//
//  Copyright © 2012 Yuri Kotov
//

#import "SearchEngine.h"

@interface CachingWrapper : NSObject <SearchEngine, SearchEngineDelegate>

- (id) initWithEngine:(id <SearchEngine>)engine;

@end
