//
//  TDRootViewController.m
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "TDRootViewController.h"
#import "TDRootView.h"
#import "TDTodoSectionList.h"
#import "TDMutableModelCollection.h"
#import "TDTheme.h"

@interface TDRootViewController () <TDRootViewDelegate, TDThemeable>

@property (nonatomic, readonly) TDRootView *rootView;
@property (nonatomic) TDTodoSectionList *sections;
@property (nonatomic) TDTodoSection *currentSection;
@property (nonatomic) id<TDDisplayDataSource> collectionToDisplay;
@property (nonatomic, readonly) BOOL isShowingASection;

@end

@implementation TDRootViewController
@synthesize theme = _theme;

- (void)loadView {
  self.view = [[TDRootView alloc] initWithDelegate:self];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.sections = [[TDTodoSectionList alloc] initWithList:@[[[TDTodoSection alloc] initWithTitle:@"Todo"
                                                                                           items:@[[[TDTodoItem alloc] initWithTitle:@"Test"],
                                                                                                   [[TDTodoItem alloc] initWithTitle:@"Test2"]]]]];
  TDTheme *theme = [[TDTheme alloc] init];
  theme.backgroundColor = [UIColor yellowColor];
  theme.textColor = [UIColor whiteColor];
  theme.foregroundColor = [UIColor grayColor];
  theme.deleteColor = [UIColor redColor];
  theme.doneColor = [UIColor greenColor];
  self.collectionToDisplay = self.sections;
  self.theme = theme;
}

- (TDRootView *)rootView {
  return (id)self.view;
}

#pragma mark - setters and getters

- (BOOL)isShowingASection {
  return !!self.currentSection;
}

- (void)setCollectionToDisplay:(id<TDDisplayDataSource>)collectionToDisplay {
  _collectionToDisplay = collectionToDisplay;
  self.rootView.dataSource = collectionToDisplay;
}

- (void)setTheme:(TDTheme *)theme {
  _theme = theme;
  self.rootView.theme = _theme;
}

#pragma mark - view delegate

- (void)selectedItemAtIndex:(NSUInteger)index {
  if (!self.isShowingASection) {
    self.currentSection = self.sections.list[index];
    self.collectionToDisplay = self.currentSection;
  }
}

- (void)markItemAtIndex:(NSUInteger)index
              withState:(TDItemMarkState)state {
  [self.collectionToDisplay markItemAtIndex:index
                                  withState:state];
}

- (void)addNewItem {
  
}

@end
