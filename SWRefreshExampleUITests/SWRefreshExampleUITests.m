//
//  SWRefreshExampleUITests.m
//  SWRefreshExampleUITests
//
//  Created by SolaWing on 16/4/1.
//  Copyright © 2016年 SW. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface SWRefreshExampleUITests : XCTestCase

@end

@implementation SWRefreshExampleUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    XCUIApplication* app = [XCUIApplication new];
    XCUIElementQuery *tablesQuery = app.tables;
    [tablesQuery.staticTexts[@"TableView"] tap];

    // new page
    XCTAssert(tablesQuery.staticTexts[@"this is inset top placeholder!"].exists);

    XCTAssertEqual(tablesQuery.count, 1);
    XCUIElement *table = [tablesQuery elementBoundByIndex:0];
    NSUInteger count = [table cells].count;

    XCUICoordinate* start = [table coordinateWithNormalizedOffset:CGVectorMake(0.5, 0.5)];
    [start pressForDuration:0.2 thenDragToCoordinate:[start coordinateWithOffset:CGVectorMake(0, 200)]];
    [self expectationForPredicate:[NSPredicate predicateWithFormat:@"count > %d", count] evaluatedWithObject:table.cells handler:nil];
    [self waitForExpectationsWithTimeout:3 handler:nil];

    count = [table cells].count;
    [table swipeDown];
    [self expectationForPredicate:[NSPredicate predicateWithFormat:@"count > %d", count] evaluatedWithObject:table.cells handler:nil];
    [self waitForExpectationsWithTimeout:3 handler:nil];

    count = [table cells].count;
    [table swipeUp];
    [self expectationForPredicate:[NSPredicate predicateWithFormat:@"count > %d", count] evaluatedWithObject:table.cells handler:nil];
    [self waitForExpectationsWithTimeout:3 handler:nil];

    [[app.navigationBars.buttons elementBoundByIndex:0] tap];
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

@end
