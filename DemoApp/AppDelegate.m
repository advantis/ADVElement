//
//  Copyright © 2012 Yuri Kotov
//

#import "AppDelegate.h"
#import "SuggestionsViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.rootViewController = [SuggestionsViewController new];
    [_window makeKeyAndVisible];
    return YES;
}

@end
