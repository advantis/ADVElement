//
//  Copyright © 2012 Yuri Kotov
//

#import "GoogleSearch.h"
#import "ADVElement.h"

@implementation GoogleSearch

#pragma mark - BaseSearch
- (NSString *)searchUrl
{
    return @"http://www.google.com/search?q=";
}

- (NSString *)suggestionsUrl
{
    return @"http://google.com/complete/search?output=toolbar&q=";
}

- (NSArray *)suggestionsFromData:(NSData *)data
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    NSMutableArray *suggestions = [NSMutableArray arrayWithCapacity:10];

    ADVElement *root = [ADVElement new];
    [[root childElementWithName:@"suggestion"] setStartHandler:^(NSDictionary *attributes) {
        NSString *term = [attributes objectForKey:@"data"];
        if (term)
        {
            [suggestions addObject:term];
        }
    }];
    parser.delegate = root;
    [parser parse];
    
    return suggestions;
}

#pragma mark - SearchEngine
+ (NSString *) name
{
    return @"Google";
}

@end
