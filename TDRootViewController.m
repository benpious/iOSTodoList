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

@interface TDRootViewController () <TDRootViewDelegate>

@property (nonatomic, readonly) TDRootView *rootView;
@property (nonatomic) TDTodoSectionList *sections;
@property (nonatomic) TDTodoSection *currentSection;
@property (nonatomic) id<TDDisplayDataSource> collectionToDisplay;
@property (nonatomic, readonly) BOOL isShowingASection;

@end

@implementation TDRootViewController

- (void)loadView {
  self.view = [[TDRootView alloc] initWithDelegate:self];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.sections = [[TDTodoSectionList alloc] initWithList:@[[[TDTodoSection alloc] initWithTitle:@"Todo"
                                                                                           items:@[[[TDTodoItem alloc] initWithTitle:@"Test"]]]]];
  self.collectionToDisplay = self.sections;
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
