# Uncomment the next line to define a global platform for your project
platform :ios, '8.0'

target 'ChatProject' do

 #去掉由pod引入的第三方库的警告, 需要使用更新命令才生效
  inhibit_all_warnings!

  #为滚动控件(UIScrollView,UITableView,UICollectionView)添加头部和脚部刷新UI
  pod 'MJRefresh', '3.1.12'
  #为UI控件提供网络图片加载和缓存功能,AF已经整合了此功能,一般用AF就够了,据专业人士说:SD比AF快0.02秒. 如果同时引入AF和SD, 那么AF的网络图片加载方法会被划线.
  pod 'SDWebImage'

  #对系统Sqlite的封装,使用SQL语句操作数据库
  #pod 'FMDB'

  #Github排名第一的网络操作框架,底层是用NSURLSession+NSOperation(多线程)
  pod 'AFNetworking'


  pod 'MBProgressHUD', '~> 1.0.0'


  #把json里面的数据空值置为nil
  pod 'NullSafe', '~> 1.2.2'


  #实现滚动控件中,弹出键盘时,自动移动输入框位置,防止被键盘遮盖的功能
  pod 'IQKeyboardManager'

  pod 'Bugly','~> 2.4.2'

  # U-Share SDK UI模块（分享面板，建议添加）
  pod 'UMengUShare/UI'

  # 集成微信
  pod 'UMengUShare/Social/WeChat'

  # 集成QQ
  pod 'UMengUShare/Social/QQ'
  #存储图片服务器
  pod 'AliyunOSSiOS', '~> 2.5.2'
  #图片浏览器

  #融云
  pod 'RongCloudIM/IMKit', '~> 2.9.0'
  pod 'RongCloudIM/IMLib', '~> 2.9.0'
  pod 'RongCloudRTC/RongCallLib', '2.9.0'
  pod 'RongCloudRTC/RongCallKit', '2.9.0'


  #ping++
  pod 'Pingpp/Wx', '~>2.2.15'
  pod 'Pingpp/Alipay', '~>2.2.15'
  #内购iap第三方
  pod 'IAPHelper'

  #Jpush
  pod 'JPush', '~> 2.1.9'
  
  #SMSSDK
#pod 'MOBFoundation_IDFA'
#pod 'SMSSDK'

  #ReactiveCocoa
  pod 'ReactiveCocoa', :git => 'https://github.com/zhao0/ReactiveCocoa.git', :tag => '2.5.2'

  target 'ChatProjectTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ChatProjectUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
