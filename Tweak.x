#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#include <dispatch/dispatch.h>
#include <mach-o/dyld.h>
#include <dlfcn.h>

#ifdef __cplusplus
extern "C" {
#endif
void MSHookMemory(void *target, const void *data, size_t size);
#ifdef __cplusplus
}
#endif

static bool isSuspiciousPath(NSString *path) {
    return ([path containsString:@"Library/"] && ![path hasPrefix:@"/var/mobile/Containers/Data/Application"]
          && ![path hasPrefix:@"/private/var/mobile/Containers/Data/Application"]);
}

%hook NSFileManager
- (NSArray<NSString *> *)contentsOfDirectoryAtPath:(NSString *)path error:(NSError **)error {
    if (isSuspiciousPath(path)) {
        return %orig(@"/Fuck/You/Pixelcyber", error);
    }
    return %orig;
}
%end

static uint8_t RET[] = {
    0xC0, 0x03, 0x5F, 0xD6
};

%ctor {
    %init;
    if ([NSProcessInfo.processInfo.processName isEqualToString:@"Shu"]) {
        intptr_t aslr = _dyld_get_image_vmaddr_slide(0);
        if ([[NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleVersion"] isEqualToString:@"1.2.4.728"]) {
            // For Shu Version (1.2.4.728)
            MSHookMemory((void *)(aslr + 0x10006E3B8), (void *)RET, sizeof(RET));
            MSHookMemory((void *)(aslr + 0x100ADD658), (void *)RET, sizeof(RET));
        }
        else if ([[NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleVersion"] isEqualToString:@"1.3.0.731"]) {
            // For Shu TestFlight Version (1.3.0.731)
            MSHookMemory((void *)(aslr + 0x10006F170), (void *)RET, sizeof(RET));
            MSHookMemory((void *)(aslr + 0x100ADD380), (void *)RET, sizeof(RET));
        }
        else if ([[NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleVersion"] isEqualToString:@"1.3.0.732"]) {
            // For Shu TestFlight Version (1.3.0.732)
            MSHookMemory((void *)(aslr + 0x100AE1300), (void *)RET, sizeof(RET));
            MSHookMemory((void *)(aslr + 0x100071338), (void *)RET, sizeof(RET));
        }
        else if ([[NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleVersion"] isEqualToString:@"1.3.0.733"]) {
            // For Shu TestFlight Version (1.3.0.733)
            MSHookMemory((void *)(aslr + 0x100AE12BC), (void *)RET, sizeof(RET));
            MSHookMemory((void *)(aslr + 0x100070E80), (void *)RET, sizeof(RET));
        }
        else if ([[NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleVersion"] isEqualToString:@"1.3.0.734"]) {
            // For Shu TestFlight Version (1.3.0.734)
            MSHookMemory((void *)(aslr + 0x100AE12BC), (void *)RET, sizeof(RET));
            MSHookMemory((void *)(aslr + 0x100070E98), (void *)RET, sizeof(RET));
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(3.0 * NSEC_PER_SEC)),dispatch_get_main_queue(),^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PixelcyberBypassJailbreak" message:@"屏蔽成功" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [UIApplication.sharedApplication.keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
        }]];
        [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    });
}
