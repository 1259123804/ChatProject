//
//  NSData+Base64.h
//  Gurpartap Singh
//
//  Created by Gurpartap Singh on 06/05/12.
//  Copyright (c) 2012 Gurpartap Singh. All rights reserved.
//

#import "NSData+Base64.h"
static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
@implementation NSData (Base64Additions)

+ (NSData *)base64DataFromString:(NSString *)string {
  unsigned long ixtext, lentext;
  unsigned char ch, inbuf[4], outbuf[3];
  short i, ixinbuf;
  Boolean flignore, flendtext = false;
  const unsigned char *tempcstring;
  NSMutableData *theData;
  
  if (string == nil) {
    return [NSData data];
  }
  
  ixtext = 0;
  
  tempcstring = (const unsigned char *)[string UTF8String];
  
  lentext = [string length];
  
  theData = [NSMutableData dataWithCapacity: lentext];
  
  ixinbuf = 0;
  
  while (true) {
    if (ixtext >= lentext) {
      break;
    }
    
    ch = tempcstring [ixtext++];
    
    flignore = false;
    
    if ((ch >= 'A') && (ch <= 'Z')) {
      ch = ch - 'A';
    }
    else if ((ch >= 'a') && (ch <= 'z')) {
      ch = ch - 'a' + 26;
    }
    else if ((ch >= '0') && (ch <= '9')) {
      ch = ch - '0' + 52;
    }
    else if (ch == '+') {
      ch = 62;
    }
    else if (ch == '=') {
      flendtext = true;
    }
    else if (ch == '/') {
      ch = 63;
    }
    else {
      flignore = true; 
    }
    
    if (!flignore) {
      short ctcharsinbuf = 3;
      Boolean flbreak = false;
      
      if (flendtext) {
        if (ixinbuf == 0) {
          break;
        }
        
        if ((ixinbuf == 1) || (ixinbuf == 2)) {
          ctcharsinbuf = 1;
        }
        else {
          ctcharsinbuf = 2;
        }
        
        ixinbuf = 3;
        
        flbreak = true;
      }
      
      inbuf [ixinbuf++] = ch;
      
      if (ixinbuf == 4) {
        ixinbuf = 0;
        
        outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
        outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
        outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
        
        for (i = 0; i < ctcharsinbuf; i++) {
          [theData appendBytes: &outbuf[i] length: 1];
        }
      }
      
      if (flbreak) {
        break;
      }
    }
  }
  
  return theData;
}

+ (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    if (string == nil)
        [NSException raise:NSInvalidArgumentException format:nil];
    if ([string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}



@end
