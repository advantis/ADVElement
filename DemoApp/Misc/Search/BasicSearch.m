//
//  Copyright © 2012 Yuri Kotov
//

#import "BasicSearch.h"
#import "ADVNetworkActivityIndicator.h"

@implementation BasicSearch

@synthesize delegate = _delegate;

@dynamic searchUrl;
@dynamic suggestionsUrl;

#pragma mark - BaseSearch
- (NSArray *) suggestionsFromData:(NSData *)data
{
    return nil;
}

#pragma mark - SearchEngine
+ (NSString *) name
{
    return nil;
}

- (NSURL *) searchURLForString:(NSString *)string
{
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    string = [self.searchUrl stringByAppendingString:string];
    return [NSURL URLWithString:string];
}

- (void) asyncSearchForString:(NSString *)string
{
    if (0 == [string length]) return;

    // Never ever do this in real app! Obviously, there are 100500 reasons, why synchronous network requests are bad
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *query = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:[self.suggestionsUrl stringByAppendingString:query]];

        ADVNetworkActivityIndicator *networkIndicator = [ADVNetworkActivityIndicator sharedIndicator];
        [networkIndicator start];
        NSData *responseData = [NSData dataWithContentsOfURL:url];
        [networkIndicator stop];

        NSArray *suggestions = [self suggestionsFromData:responseData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate searchEngine:self didLoadSuggestions:suggestions forString:string];
        });
    });
}

@end