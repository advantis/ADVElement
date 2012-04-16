//
//  Copyright © 2012 Yuri Kotov
//

#import "BingSearch.h"
#import "ADVElement.h"

@implementation BingSearch

#pragma mark - BaseSearch
- (NSString *)searchUrl
{
    return @"http://www.bing.com/search?a=results&q=";
}

- (NSString *)suggestionsUrl
{
    return @"http://api.bing.net/xml.aspx?AppId=6127D6A66CEA926DEF0246749A4214E912C36043&Sources=RelatedSearch&Version=2.0&Market=en-us&Query=";
}

- (NSArray *)suggestionsFromData:(NSData *)data
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    NSMutableArray *suggestions = [NSMutableArray arrayWithCapacity:10];

    ADVElement *root = [ADVElement new];
    [[root childElementWithName:@"rs:Title"] setEndHandler:^(NSString *body) {
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
    return @"Bing";
}

@end