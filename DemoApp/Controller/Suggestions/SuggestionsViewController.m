//
//  Copyright © 2012 Yuri Kotov
//

#import "SuggestionsViewController.h"

#import "SearchEngineType.h"
#import "CachingWrapper.h"

@implementation SuggestionsViewController
{
    NSArray *_suggestions;
    id<SearchEngine> _searchEngine;
}

#pragma mark - SuggestionsViewController
- (void)setSearchEngineType:(SearchEngineType)type
{
    id<SearchEngine> engine = [GetClassForSearchEngineType(type) new];
    _searchEngine = [[CachingWrapper alloc] initWithEngine:engine];
    _searchEngine.delegate = self;
}

#pragma mark - UITableViewController
- (id) initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        [self setSearchEngineType:FirstSearchEngine];
    }
    return self;
}

#pragma mark - UIViewController
- (void) viewDidLoad
{
    [super viewDidLoad];

    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 88.f)];
    searchBar.placeholder = @"Type for suggestions";
    searchBar.delegate = self;

    NSMutableArray *titles = [[NSMutableArray alloc] initWithCapacity:NUM_SEARCH_ENGINES];
    for (SearchEngineType type = FirstSearchEngine; type < NUM_SEARCH_ENGINES; ++type)
    {
        [titles addObject:[GetClassForSearchEngineType(type) name]];
    }

    searchBar.showsScopeBar = YES;
    searchBar.scopeButtonTitles = titles;

    self.tableView.tableHeaderView = searchBar;
}

#pragma mark - UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_suggestions count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SuggestionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [_suggestions objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *suggestion = [_suggestions objectAtIndex:indexPath.row];
    NSURL *url = [_searchEngine searchURLForString:suggestion];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - UISearchBarDelegate
- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:NO];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:NO];
}

- (void) searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self setSearchEngineType:(SearchEngineType)selectedScope];
    [_searchEngine asyncSearchForString:searchBar.text];
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (0 < [searchText length])
    {
        [_searchEngine asyncSearchForString:searchText];
    }
    else
    {
        _suggestions = nil;
        [self.tableView reloadData];
    }
}

#pragma mark - SearchEngineDelegate
- (void) searchEngine:(id <SearchEngine>)engine
   didLoadSuggestions:(NSArray *)suggestions
            forString:(NSString *)string
{
    _suggestions = suggestions;
    [self.tableView reloadData];
}

@end
