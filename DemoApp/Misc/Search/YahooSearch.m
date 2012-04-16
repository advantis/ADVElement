//
//  Copyright © 2012 Yuri Kotov
//

#import "YahooSearch.h"
#import "ADVElement.h"

#define kYahooSuggestURL		@"http://search.yahooapis.com/WebSearchService/V1/relatedSuggestion?appid=YahooDemo&query=%@"

@implementation YahooSearch

#pragma mark - BaseSearch
- (NSString *)searchUrl
{
    return @"http://search.yahoo.com/search?p=";
}

- (NSString *)suggestionsUrl
{
    return @"http://search.yahooapis.com/WebSearchService/V1/relatedSuggestion?appid=YahooDemo&query=";
}

- (NSArray *)suggestionsFromData:(NSData *)data
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    NSMutableArray *suggestions = [NSMutableArray arrayWithCapacity:10];
    
    ADVElement *root = [ADVElement new];
    [[root childElementWithName:@"Result"] setEndHandler:^(NSString *body) {
        if (body)
        {
            [suggestions addObject:body];
        }
    }];
    parser.delegate = root;
    [parser parse];
    
    return suggestions;
}

#pragma mark - SearchEngine
+ (NSString *) name
{
    return @"Yahoo";
}

@end
