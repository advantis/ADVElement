//
//  Copyright © 2012 Yuri Kotov
//

#import "SearchEngineType.h"

#import "GoogleSearch.h"
#import "BingSearch.h"
#import "YahooSearch.h"

Class GetClassForSearchEngineType(SearchEngineType type)
{
    switch (type)
    {
        case SearchEngineGoogle:
            return [GoogleSearch class];

        case SearchEngineBing:
            return [BingSearch class];

        case SearchEngineYahoo:
            return [YahooSearch class];

        default:
            return Nil;
    }
}