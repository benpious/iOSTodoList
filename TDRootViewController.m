//
//  TDRootViewController.m
//  #Do
//
//  Created by Benjamin Pious on 3/19/16.
//  Copyright © 2016 benpious. All rights reserved.
//

#import "TDRootViewController.h"
#import "TDRootView.h"
#import "TDPersistentStore.h"
#import "TDMutableModelCollection.h"
#import "TDTheme.h"
#import "TDTodoItemEditingResponder.h"
#import <objc/runtime.h>

@interface TDRootViewController () <TDRootViewDelegate, TDThemeable, TDTodoItemEditingResponder>

@property (nonatomic, readonly) TDRootView *rootView;
@property (nonatomic) TDPersistentStore *model;
@property (nonatomic) id<TDTodoSectionList, TDDisplayDataSource, TDMutableModelCollection> sections;
@property (nonatomic) id<TDTodoSection, TDDisplayDataSource, TDMutableModelCollection> currentSection;
@property (nonatomic) id<TDDisplayDataSource, TDMutableModelCollection> collectionToDisplay;
@property (nonatomic, readonly) BOOL isShowingASection;

@end

@implementation TDRootViewController
@synthesize theme = _theme;

- (void)loadView {
  self.view = [[TDRootView alloc] initWithDelegate:self];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.model = [[TDPersistentStore alloc] initWithBuiltinStore];
  self.sections = self.model.lists;
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
    self.currentSection = (id)self.sections.list[index];
    self.collectionToDisplay = self.currentSection;
  }
}

- (void)markItemAtIndex:(NSUInteger)index
              withState:(TDItemMarkState)state {
  [self.collectionToDisplay markItemAtIndex:index
                                  withState:state];
}

- (void)userSelectedPullDownOption:(TDPullDownSelection)selection {
  switch (selection) {
    case TDPullDownSelectionAddNew:
      [self.collectionToDisplay pushNewItem];
      break;
    case TDPullDownSelectionGoBack:
      if (![self.collectionToDisplay isEqual:self.sections]) {
        self.currentSection = nil;
        self.collectionToDisplay = self.sections;
      }
      break;
    default:
      break;
  }
}

#pragma mark - responding to user editing

- (BOOL)canPerformAction:(SEL)action
              withSender:(id)sender {
  if (sel_isEqual(@selector(userFinishedEditingTodoItemTitle:forItemAtIndexPath:), action)) {
    return YES;
  }
  else {
    return [super canPerformAction:action
                        withSender:sender];
  }
}

- (void)userFinishedEditingTodoItemTitle:(NSString *)title
                      forItemAtIndexPath:(NSIndexPath *)indexPath {
  [self.collectionToDisplay[indexPath.item] setTitle:title];
}

@end
