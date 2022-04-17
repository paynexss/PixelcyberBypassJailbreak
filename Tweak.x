#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#include <dispatch/dispatch.h>
#include <mach-o/dyld.h>

#include "substrate.h" // void MSHookMemory(void *target, const void *data, size_t size);

%hook NSFileManager
- (NSArray<NSString *> *)contentsOfDirectoryAtPath:(NSString *)path error:(NSError **)error {
    if ([path containsString:@"Library/"] && ![path hasPrefix:@"/var/mobile/Containers/Data/Application"]
     && ![path hasPrefix:@"/private/var/mobile/Containers/Data/Application"]) {
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
    if ([NSProcessInfo.processInfo.processName isEqualToString:@"Shu"]
     && [[NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleVersion"] isEqualToString:@"1.2.4.728"]) {
        // For Shu TestFlight Version (1.2.4.728)
        MSHookMemory((void *)(_dyld_get_image_vmaddr_slide(0) + 0x10006E3B8), (void *)RET, sizeof(RET));
        MSHookMemory((void *)(_dyld_get_image_vmaddr_slide(0) + 0x100ADD658), (void *)RET, sizeof(RET));
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(3.0 * NSEC_PER_SEC)),dispatch_get_main_queue(),^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PixelcyberBypassJailbreak" message:@"Bypass Success" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [UIApplication.sharedApplication.keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
        }]];
        [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    });
}
