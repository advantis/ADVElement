//
//  Copyright © 2011 Yuri Kotov
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at http://github.com/advantis/ADVElement
//

#import "ADVElement.h"

#if __has_feature(objc_arc_weak)
    #define __desirable_weak    __weak
#else
    #define __desirable_weak    __unsafe_unretained
#endif

@interface ADVElement ()

@property (nonatomic, strong) NSMutableDictionary *subelements;

@end

@implementation ADVElement
{
    NSInteger _level;
    __desirable_weak id _parent;
    NSMutableString *_body;
}

@synthesize startHandler = _startHandler;
@synthesize endHandler = _endHandler;
@synthesize subelements = _subelements;

#pragma mark - Element
- (id) initWithParent:(id<NSXMLParserDelegate>)parent
{
    self = [super init];
    if (self)
    {
        _parent = parent;
    }
    return self;
}

- (NSMutableDictionary *) subelements
{
    if (!_subelements)
    {
        _subelements = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    return _subelements;
}

- (ADVElement *) childElementWithName:(NSString *)elementName
{
    NSParameterAssert(elementName);
    ADVElement *node = [[ADVElement alloc] initWithParent:self];
    [self.subelements setObject:node forKey:elementName];
    #if !__has_feature(objc_arc)
    [node release];
    #endif
    return node;
}

#pragma mark - NSObject
#if !__has_feature(objc_arc)
- (void) dealloc
{
    [_body release];
    [_subelements release];
    [_startHandler release];
    [_endHandler release];
    [super dealloc];
}
#endif

#pragma mark - NSXMLParserDelegate
- (void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qualifiedName
     attributes:(NSDictionary *)attributeDict
{
    ADVElement *node = [_subelements objectForKey:elementName];
    if (node)
    {
        if (node.startHandler)
        {
            node.startHandler(attributeDict);
        }
        parser.delegate = node;
    }
    else
    {
        ++_level;
    }
}

- (void) parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string
{
    if (0 == _level && _endHandler)
    {
        if (_body)
        {
            [_body appendString:string];
        }
        else
        {
            _body = [string mutableCopy];
        }
    }
}

- (void) parser:(NSXMLParser *)parser
  didEndElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName
{
    if (--_level < 0)
    {
        _level = 0;
        if (_endHandler)
        {
            _endHandler(_body);
        }
        #if !__has_feature(objc_arc)
        [_body release];
        #endif
        _body = nil;
        parser.delegate = _parent;
    }
}

@end
