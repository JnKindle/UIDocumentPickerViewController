# UIDocumentPickerViewController
选取、浏览和预览本地、共享或者iCloud文件
有时候，开发中需要我们实现“将一个APP的文件拷贝到另一个APP上并实现上传等功能”，那我们怎么去实现呢？

下面介绍一种方法：

App Extension 在iOS8中实现的跨APP数据操作和分享。

首先新建一个工程，并指定属性就能实现上述的需求啦，具体如下图

![avatar](https://img-blog.csdn.net/20180828150908556?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1JhbmdpbmdXb24=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

到这里，差不多就已经实现啦

另外，在

//9.0之前
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation
{
    //实现上传等操作功能
    
    return YES;
}

//9.0后
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options
{
    //实现上传等操作功能

    return YES;
}
实现上传等操作功能，是不是很简单？

检测：

打开第三方应用，如微信





Demo：https://github.com/JnKindle/UIDocumentPickerViewController

欢迎大家访问我的GitHub

GitTub：https://github.com/JnKindle
