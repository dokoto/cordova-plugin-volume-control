#import <Cordova/CDV.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VolumeControl : CDVPlugin {
    // Member variables go here.
}

- (void)toggleMute:(CDVInvokedUrlCommand*)command;
- (void)isMuted:(CDVInvokedUrlCommand*)command;
- (void)setVolume:(CDVInvokedUrlCommand*)command;
- (void)getVolume:(CDVInvokedUrlCommand*)command;
- (void)getCategory:(CDVInvokedUrlCommand*)command;
- (void)hideVolume:(CDVInvokedUrlCommand*)command;
- (void)showVolume:(CDVInvokedUrlCommand*)command;
- (void)hideShowVolume:(BOOL)show;
@end

@implementation VolumeControl

- (void)toggleMute:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    DLog(@"toggleMute");

    Class avSystemControllerClass = NSClassFromString(@"AVSystemController");
    id avSystemControllerInstance = [avSystemControllerClass performSelector:@selector(sharedAVSystemController)];

    NSInvocation *privateInvocation = [NSInvocation invocationWithMethodSignature:
                                       [avSystemControllerClass instanceMethodSignatureForSelector:
                                        @selector(toggleActiveCategoryMuted)]];
    [privateInvocation setTarget:avSystemControllerInstance];
    [privateInvocation setSelector:@selector(toggleActiveCategoryMuted)];
    [privateInvocation invoke];
    BOOL result;
    [privateInvocation getReturnValue:&result];

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:result];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)isMuted:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    DLog(@"isMuted");

    Class avSystemControllerClass = NSClassFromString(@"AVSystemController");
    id avSystemControllerInstance = [avSystemControllerClass performSelector:@selector(sharedAVSystemController)];

    BOOL result;
    NSInvocation *privateInvocation = [NSInvocation invocationWithMethodSignature:
                                       [avSystemControllerClass instanceMethodSignatureForSelector:
                                        @selector(getActiveCategoryMuted:)]];
    [privateInvocation setTarget:avSystemControllerInstance];
    [privateInvocation setSelector:@selector(getActiveCategoryMuted:)];
    [privateInvocation setArgument:&result atIndex:2];
    [privateInvocation invoke];

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:result];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setVolume:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    float volume = [[command argumentAtIndex:0] floatValue];
    DLog(@"setVolume: [%f]", volume);

    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-2000., -2000., 0.1f, 0.1f)];
    NSArray *windows = [UIApplication sharedApplication].windows;


    //find the volumeSlider
    UISlider* volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }

    [volumeViewSlider setValue:volume animated:YES];
    [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:true];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getVolume:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    DLog(@"getVolume");

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDouble:audioSession.outputVolume];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getCategory:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    DLog(@"getCategory");

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:audioSession.category];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)hideShowVolume:(BOOL)show
{
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame: self.webView.bounds];
    [volumeView sizeToFit];
    if(!show){
        volumeView.alpha = 0.01;
    }
    volumeView.showsVolumeSlider=NO;
    [self.webView.superview addSubview: volumeView];
    [self.webView setNeedsDisplay];
}

- (void)hideVolume:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    DLog(@"hideVolume");

    [self hideShowVolume: NO];

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)showVolume:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    DLog(@"hideVolume");

    [self hideShowVolume: YES];

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
