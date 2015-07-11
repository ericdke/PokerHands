//
//  testPokTests.swift
//  testPokTests
//
//  Created by ERIC DEJONCKHEERE on 27/06/2015.
//  Copyright (c) 2015 Eric Dejonckheere. All rights reserved.
//

import Cocoa
import XCTest

class testPokTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDeal2Cards() {
        var dealer = Dealer()
        let cards = dealer.deal(2)
        XCTAssert(cards.count == 2, "2 cards from dealer")
        XCTAssert(dealer.currentDeck.count == 50, "deck: 52 - 2 = 50")
    }
    
    func testDealHoldemHand() {
        var dealer = Dealer()
        let cards = dealer.dealHoldemHand()
        XCTAssert(cards.count == 2, "2 cards from dealer")
        XCTAssert(dealer.currentDeck.count == 50, "deck: 52 - 2 = 50")
    }
    
    func testDealHoldemHandFor2Players() {
        var dealer = Dealer()
        var p1 = Player()
        var p2 = Player()
        p1.cards = dealer.dealHoldemHand()
        p2.cards = dealer.dealHoldemHand()
        XCTAssert(p1.count == 2, "2 cards from dealer")
        XCTAssert(p2.count == 2, "2 cards from dealer")
        XCTAssert(dealer.currentDeck.count == 48, "deck: 52 - 2 - 2 = 48")
    }
    
    func testDealHoldemHandTo2Players() {
        var dealer = Dealer()
        var p1 = Player()
        var p2 = Player()
        dealer.dealHoldemHandTo(&p1)
        dealer.dealHoldemHandTo(&p2)
        XCTAssert(p1.count == 2, "2 cards from dealer")
        XCTAssert(p2.count == 2, "2 cards from dealer")
        XCTAssert(dealer.currentDeck.count == 48, "deck: 52 - 2 - 2 = 48")
    }
    
    func testDealFlop() {
        var dealer = Dealer()
        dealer.dealFlop()
        XCTAssert(dealer.table.dealtCards.count == 3, "flop: 3 cards")
        XCTAssert(dealer.table.burnt.count == 1)
        XCTAssert(dealer.currentDeck.count == 48, "deck: 52 - 1 - 3 = 48")
    }
    
    func testDealTurn() {
        var dealer = Dealer()
        dealer.dealFlop()
        dealer.dealTurn()
        XCTAssert(dealer.table.dealtCards.count == 4, "flop + turn: 4 cards")
        XCTAssert(dealer.table.burnt.count == 2)
        XCTAssert(dealer.currentDeck.count == 46, "deck: 52 - 1 - 3 - 1 - 1 = 46")
    }
    
    func testDealRiver() {
        var dealer = Dealer()
        dealer.dealFlop()
        dealer.dealTurn()
        dealer.dealRiver()
        XCTAssert(dealer.table.dealtCards.count == 5, "flop + turn + river: 5 cards")
        XCTAssert(dealer.table.burnt.count == 3)
        XCTAssert(dealer.currentDeck.count == 44, "deck: 52 - 1 - 3 - 1 - 1 - 1 -1 = 44")
    }
    
    func testDealTable() {
        var dealer = Dealer()
        var p1 = Player()
        var p2 = Player()
        dealer.dealHoldemHandTo(&p1)
        dealer.dealHoldemHandTo(&p2)
        dealer.dealFlop()
        dealer.dealTurn()
        dealer.dealRiver()
        XCTAssert(dealer.table.dealtCards.count == 5, "flop + turn + river: 5 cards")
        XCTAssert(dealer.table.burnt.count == 3)
        XCTAssert(dealer.currentDeck.count == 40, "deck: 52 - 2 - 2 - 1 - 3 - 1 - 1 - 1 -1 = 40")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
