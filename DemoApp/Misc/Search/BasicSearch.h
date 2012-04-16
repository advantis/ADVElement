//
//  Copyright © 2012 Yuri Kotov
//

#import <Foundation/Foundation.h>
#import "SearchEngine.h"

@interface BasicSearch : NSObject <SearchEngine, NSURLConnectionDelegate>

@property (nonatomic, readonly) NSString *searchUrl;
@property (nonatomic, readonly) NSString *suggestionsUrl;

- (NSArray *) suggestionsFromData:(NSData *)data;

@end