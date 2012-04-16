//
//  Copyright © 2011 Yuri Kotov
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at http://github.com/advantis/ADVElement
//

#import <Foundation/Foundation.h>

typedef void(^ADVElementStartHandler)(NSDictionary *attributes);
typedef void(^ADVElementEndHandler)(NSString *body);

@interface ADVElement : NSObject <NSXMLParserDelegate>

@property (nonatomic, copy) ADVElementStartHandler startHandler;
@property (nonatomic, copy) ADVElementEndHandler endHandler;

- (id) initWithParent:(id<NSXMLParserDelegate>)parent;
- (ADVElement *) childElementWithName:(NSString *)elementName;

@end
