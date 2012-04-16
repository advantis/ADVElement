//
//  Copyright © 2012 Yuri Kotov
//

typedef enum
{
    FirstSearchEngine = 0,
    SearchEngineGoogle = FirstSearchEngine,
    SearchEngineBing,
    SearchEngineYahoo,
    NUM_SEARCH_ENGINES
}
SearchEngineType;

extern Class GetClassForSearchEngineType(SearchEngineType type);