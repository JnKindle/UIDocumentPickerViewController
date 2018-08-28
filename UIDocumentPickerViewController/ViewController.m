//
//  ViewController.m
//  UIDocumentPickerViewController
//
//  Created by Jn_Kindle on 2018/8/28.
//  Copyright © 2018年 JnKindle. All rights reserved.
//

#import "ViewController.h"

#import "AFNetworking.h"

@interface ViewController ()<UIDocumentPickerDelegate,UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic, strong) UIDocumentPickerViewController *documentPickerVC;
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionC;


@end

@implementation ViewController

-(AFHTTPSessionManager *)sessionManager
{
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        //设置请求超时时间
        _sessionManager.requestSerializer.timeoutInterval = 45.f;
        //设置服务器返回结果的类型:JSON(AFJSONResponseSerializer,AFHTTPResponseSerializer)
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    }
    return _sessionManager;
}

- (UIDocumentPickerViewController *)documentPickerVC {
    if (!_documentPickerVC) {
        self.documentPickerVC = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.content"] inMode:UIDocumentPickerModeOpen];
        _documentPickerVC.delegate = self;
        _documentPickerVC.modalPresentationStyle = UIModalPresentationFormSheet; //设置模态弹出方式
    }
    return _documentPickerVC;
}

- (UIDocumentInteractionController *)documentInteractionC {
    if (!_documentInteractionC) {
        self.documentInteractionC = [[UIDocumentInteractionController alloc] init];
        _documentInteractionC.delegate = self;
    }
    return _documentInteractionC;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(100, 100, 100, 40);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"点击" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    
}


- (void)click:(UIButton *)sender
{
    //文件选取，浏览
    [self presentViewController:self.documentPickerVC animated:YES completion:nil];
    
    //文件预览
    /*
    NSURL *url = [NSURL URLWithString:@"https://sbb.hd-os.com/sbbyd_upload/shop/201712281548087721587.png"];
    [self previewFileWithURL:url];
     */
}


#pragma mark - UIDocumentPickerDelegate
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    //获取授权
    BOOL fileUrlAuthozied = [urls.firstObject startAccessingSecurityScopedResource];
    if (fileUrlAuthozied) {
        //通过文件协调工具来得到新的文件地址，以此得到文件保护功能
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
        NSError *error;
        
        [fileCoordinator coordinateReadingItemAtURL:urls.firstObject options:0 error:&error byAccessor:^(NSURL *newURL) {
            //读取文件
            NSString *fileName = [newURL lastPathComponent];
            NSError *error = nil;
            NSData *fileData = [NSData dataWithContentsOfURL:newURL options:NSDataReadingMappedIfSafe error:&error];
            if (error) {
                //读取出错
            } else {
                //文件 上传或者其它操作
                //[self uploadingWithFileData:fileData fileName:fileName fileURL:newURL];
                NSLog(@"------------->文件 上传或者其它操作");
                
            }
            [self dismissViewControllerAnimated:YES completion:NULL];
        }];
        [urls.firstObject stopAccessingSecurityScopedResource];
    } else {
        //授权失败
    }
}


/**
 预览文件

 @param URL 文件路径
 */
- (void)previewFileWithURL:(NSURL *)URL
{
    if ([URL isFileURL]) {
        if ([[[NSFileManager alloc] init] fileExistsAtPath:URL.path]) {
            //指定预览文件的URL
            self.documentInteractionC.URL = URL;
            //弹出预览文件窗口
            [self.documentInteractionC presentPreviewAnimated:YES];
        } else {
            //[SVProgressHUD showErrorWithStatus:@"该文件不存在!"];
        }
    } else {
        if ([URL.scheme containsString:@"http"]) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"不存在本地文件，需要下载，是否下载？" preferredStyle:UIAlertControllerStyleAlert];
            [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //文件存储路径
                NSString *filePathString = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:URL.absoluteString.lastPathComponent];
                
                NSURLSessionDownloadTask *downloadTask = [self.sessionManager downloadTaskWithRequest:[NSURLRequest requestWithURL:URL] progress:^(NSProgress * _Nonnull downloadProgress) {
                    
                } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                    //返回文件存储路径
                    return [NSURL fileURLWithPath:filePathString];
                } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                    
                    //下载完成后，替换原来的URL，下次不用再下载，直接打开
                    //[newURL replaceObjectAtIndex:indexPath.row withObject:filePath];
                    //指定预览文件的URL
                    self.documentInteractionC.URL = filePath;
                    //弹出预览文件窗口
                    [self.documentInteractionC presentPreviewAnimated:YES];
                    
                }];
                //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                //MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                //hud.label.text = @"正在下载文件";
                //启动下载文件任务
                [downloadTask resume];
            }]];
            [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alertC animated:YES completion:^{
                
            }];
        } else {
            //[SVProgressHUD showErrorWithStatus:@"该文件链接不存在!"];
        }
    }
}

#pragma mark - UIDocumentInteractionControllerDelegate
//返回一个视图控制器，代表在此视图控制器弹出
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}
//返回一个视图，将此视图作为父视图
- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller {
    return self.view;
}
//返回一个CGRect，做为预览文件窗口的坐标和大小
- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller {
    return self.view.frame;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
