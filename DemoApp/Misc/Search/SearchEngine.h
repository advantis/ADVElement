//
//  Copyright © 2012 Yuri Kotov
//

#import <Foundation/Foundation.h>

@protocol SearchEngineDelegate;

@protocol SearchEngine <NSObject>

@property (nonatomic, weak) id<SearchEngineDelegate> delegate;

+ (NSString *) name;

- (NSURL *) searchURLForString:(NSString *)string;
- (void) asyncSearchForString:(NSString *)string;

@end


@protocol SearchEngineDelegate <NSObject>

- (void) searchEngine:(id <SearchEngine>)engine
   didLoadSuggestions:(NSArray *)suggestions
            forString:(NSString *)string;

@end