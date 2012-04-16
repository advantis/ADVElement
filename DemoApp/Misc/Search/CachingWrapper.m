//
//  Copyright © 2012 Yuri Kotov
//

#import "CachingWrapper.h"

const NSTimeInterval SuggestionsLoadDelay = 0.5;

@implementation CachingWrapper
{
    id <SearchEngine> _engine;
    NSCache *_cache;
}

@synthesize delegate = _delegate;

#pragma mark - CachingWrapper
- (id) initWithEngine:(id <SearchEngine>)engine
{
    self = [super init];
    if (self)
    {
        _cache = [NSCache new];

        _engine = engine;
        _engine.delegate = self;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidReceiveMemoryWarning:)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    return self;
}

- (void) applicationDidReceiveMemoryWarning:(NSNotification *)notification
{
    [_cache removeAllObjects];
}

- (void) performSearch:(NSString *)string
{
    [_engine asyncSearchForString:string];
}

#pragma mark - NSObject
- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - SearchEngine
+ (NSString *) name
{
    return nil;
}

- (NSURL *) searchURLForString:(NSString *)string
{
    return [_engine searchURLForString:string];
}

- (void) asyncSearchForString:(NSString *)string
{
    NSArray *suggestions = [_cache objectForKey:string];
    if (suggestions)
    {
        [_delegate searchEngine:self didLoadSuggestions:suggestions forString:string];
    }
    else
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(performSearch:)
                   withObject:string
                   afterDelay:SuggestionsLoadDelay];
    }
}

#pragma mark - SearchEngineDelegate
- (void) searchEngine:(id <SearchEngine>)engine
   didLoadSuggestions:(NSArray *)suggestions
            forString:(NSString *)string
{
    [_cache setObject:suggestions forKey:string cost:[suggestions count]];
    [_delegate searchEngine:self didLoadSuggestions:suggestions forString:string];
}

@end
