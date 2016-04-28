#import <Cordova/CDV.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_OS_9_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

@interface VolumeControl : CDVPlugin {
    // Member variables go here.
    @private MPVolumeView *volumeView;
}

// Public Plugin Interface
- (void)setVolumeAfterHideHUD:(CDVInvokedUrlCommand*)command;
- (void)setVolumeBeforeShowHUD:(CDVInvokedUrlCommand*)command;
@end

@implementation VolumeControl

/*
 * PUBLIC METHODS
 */

- (void)setVolumeAfterHideHUD:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    
    [self _hideVolomeHUDView];
    [self performSelector:@selector(_setVolume:) withObject:[NSNumber numberWithFloat: [[command argumentAtIndex:0] floatValue] ] afterDelay:1];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setVolumeBeforeShowHUD:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    
    [self _setVolume: [NSNumber numberWithFloat: [[command argumentAtIndex:0] floatValue] ] ];
    [self performSelector:@selector(_showVolumeHUDView) withObject:nil afterDelay:2];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}



/*
 * PRIVATE METHODS
 */

- (void)_hideVolomeHUDView {
    if (volumeView != nil) {
        [volumeView removeFromSuperview];
        volumeView = nil;
    }
    
    volumeView = [[MPVolumeView alloc] initWithFrame: CGRectMake(-100,-100,16,16)];
    volumeView.showsRouteButton = NO;
    volumeView.userInteractionEnabled = NO;
    
    [self.webView.superview addSubview:volumeView];
    [self.webView.superview setNeedsDisplay];
}

- (void)_showVolumeHUDView {
    if (volumeView != nil) {
        [volumeView removeFromSuperview];
        volumeView = nil;
    }
    
    volumeView = [[MPVolumeView alloc] initWithFrame: CGRectMake(100,100,16,16)];
    volumeView.showsVolumeSlider = NO;
    
    [self.webView.superview addSubview:volumeView];
    [self.webView.superview setNeedsDisplay];
}

- (void)_setVolume:(NSNumber*)volume {
    MPVolumeView *VolumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-2000., -2000., 0.1f, 0.1f)];
    
    //find the volumeSlider
    UISlider* volumeViewSlider = nil;
    for (UIView *view in [VolumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    
    [volumeViewSlider setValue:[volume floatValue] animated:YES];
    [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
