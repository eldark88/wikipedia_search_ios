//
//  ViewController.m
//  Wikipedia
//
//  Created by eldark88 on 8/29/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import "SearchViewController.h"
#import "AppDelegate.h"
#import "SearchBar.h"
#import "SearchResult.h"
#import "UITableView+InfiniteScrolling.h"
#import "SearchViewModel.h"
#import "TableViewCell.h"
#import "DetailViewController.h"

static NSString * const cellId = @"cellId";
static NSString * const detailSegue = @"detailSegue";

@interface SearchViewController () <UISearchBarDelegate, NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) SearchBar *searchBar;
@property (nonatomic, strong) SearchViewModel *viewModel;
@end

@implementation SearchViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	id persistenceController = ((AppDelegate *)[UIApplication sharedApplication].delegate).persistenceController;

	self.viewModel = [[SearchViewModel alloc] initWithPersistenceController:persistenceController];
	self.viewModel.fetchedResultsController.delegate = self;

	self.tableView.estimatedRowHeight = 60.0;
	self.tableView.rowHeight = UITableViewAutomaticDimension;

	//-- setup searchbar
	self.searchBar = [[SearchBar alloc] initWithFrame:self.navigationController.navigationBar.bounds];
	self.searchBar.delegate = self;
	self.searchBar.placeholder = @"Search ";
	self.navigationItem.titleView = self.searchBar;

	//----
	__weak typeof(self) weakSelf = self;
    [self.tableView addInfiniteScrollingHandler:^{
        __weak typeof(self) strongSelf = weakSelf;
        [strongSelf.viewModel fetchSubsequentResultsWithCompletionBlock:^(BOOL completed){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completed) {
                    strongSelf.tableView.enableInfiniteScrolling = NO;
                }
                else {
                    [strongSelf.tableView stopInfiniteScrollingAnimation];
                }
            });
        }];
	 }];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - UIBarPositioningDelegate
- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar {
	return UIBarPositionTopAttached;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id sectionInfo = [[self.viewModel.fetchedResultsController sections] objectAtIndex:section];

	return [sectionInfo numberOfObjects];
}

- (void)configureCell:(TableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	SearchResult *searchResult = [self.viewModel.fetchedResultsController objectAtIndexPath:indexPath];

	cell.titleLabel.text = searchResult.title;

	cell.dateLabel.text = [self.viewModel formattedDate:searchResult.lastEditedDate];

	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];

	[self configureCell:cell atIndexPath:indexPath];

	return cell;
}

#pragma mark -
- (void)searchBarSearchButtonClicked:(SearchBar *)searchBar {

	[searchBar showActivityIndicator];
    
    //--
    [self.viewModel searchWithKeyword:searchBar.text completionBlock:^(BOOL completed){
        dispatch_async(dispatch_get_main_queue(), ^{
            [searchBar dismissAcitivityIndicator];
        });
    }];
    
	[self.tableView reloadData];
    
    [searchBar resignFirstResponder];
}

#pragma mark -
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([[segue identifier] isEqualToString:detailSegue]) {
		UITableViewCell *cell = sender;

		NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

		SearchResult *searchResult = [self.viewModel.fetchedResultsController objectAtIndexPath:indexPath];

		DetailViewController *detailViewController = segue.destinationViewController;

		detailViewController.viewModel = [self.viewModel detailViewModelWithWithTitle:searchResult.title];
	}
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 5.0f;
}

#pragma mark - fetchedResultsController
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {

	switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            self.tableView.enableInfiniteScrolling = YES;
            break;

        case NSFetchedResultsChangeUpdate:
            [self configureCell:(id)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;

        case NSFetchedResultsChangeDelete:
        case NSFetchedResultsChangeMove:
            break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView endUpdates];
}

@end
