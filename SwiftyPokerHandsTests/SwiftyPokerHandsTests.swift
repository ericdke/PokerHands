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
    
    let eval = Evaluator()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitDealerFromJSONFiles() {
        let dealer = Dealer()
        XCTAssertNotNil(dealer.evaluator)
        XCTAssertNotNil(dealer.evaluator.byteRanks.combinationToRank)
        XCTAssertNotNil(dealer.evaluator.byteRanks.flushes)
        XCTAssertNotNil(dealer.evaluator.byteRanks.primeProductToCombination)
        XCTAssertNotNil(dealer.evaluator.byteRanks.uniqueToRanks)
        XCTAssertFalse(dealer.evaluator.byteRanks.combinationToRank.isEmpty)
        XCTAssertFalse(dealer.evaluator.byteRanks.flushes.isEmpty)
        XCTAssertFalse(dealer.evaluator.byteRanks.primeProductToCombination.isEmpty)
        XCTAssertFalse(dealer.evaluator.byteRanks.uniqueToRanks.isEmpty)
        XCTAssertTrue(dealer.currentDeck.count == 52)
        XCTAssertTrue(dealer.currentDeck.cards.first! == Card(suit: "♠", rank: "A"))
    }
    
    func testInitPlayer() {
        let player = Player(name: "James")
        XCTAssertTrue(player.name == "James")
    }
    
    func testInitDeck() {
        let d = Deck()
        XCTAssertTrue(d.count == 52)
        XCTAssertTrue(d.suits == ["♠","♣","♥","♦"])
        XCTAssertTrue(d.ranks == ["A","K","Q","J","T","9","8","7","6","5","4","3","2"])
        XCTAssertTrue(d.cards.first! == Card(suit: "♠", rank: "A"))
    }
    
    func testInitCard() {
        let ace = Card(suit: "♠", rank: "A")
        XCTAssertTrue(ace.name == "Ace of Spades")
        XCTAssertTrue(ace.description == "A♠")
        XCTAssertTrue(ace.fileName == "ace_of_spades_w.png")
        let ten = Card(suit: "♥", rank: "T")
        XCTAssertTrue(ten.name == "10 of Hearts")
        XCTAssertTrue(ten.description == "T♥")
        XCTAssertTrue(ten.fileName == "10_of_hearts_w.png")
    }
    
    func testDeal2Cards() {
        var dealer = Dealer(evaluator: eval)
        let cards = dealer.deal(number: 2)
        XCTAssertTrue(cards.count == 2, "2 cards from dealer")
        XCTAssertTrue(dealer.currentDeck.count == 50, "deck: 52 - 2 = 50")
    }
    
    func testDealHoldemHand() {
        var dealer = Dealer(evaluator: eval)
        let cards = dealer.dealHand()
        XCTAssertTrue(cards.count == 2, "2 cards from dealer")
        XCTAssertTrue(dealer.currentDeck.count == 50, "deck: 52 - 2 = 50")
    }
    
    func testDealHoldemHandFor2Players() {
        var dealer = Dealer(evaluator: eval)
        var p1 = Player()
        var p2 = Player()
        p1.cards = dealer.dealHand()
        p2.cards = dealer.dealHand()
        XCTAssertTrue(p1.count == 2, "2 cards from dealer")
        XCTAssertTrue(p2.count == 2, "2 cards from dealer")
        XCTAssertTrue(dealer.currentDeck.count == 48, "deck: 52 - 2 - 2 = 48")
    }
    
    func testDealHoldemHandTo2Players() {
        var dealer = Dealer(evaluator: eval)
        var p1 = Player()
        var p2 = Player()
        dealer.dealHand(to: &p1)
        dealer.dealHand(to: &p2)
        XCTAssertTrue(p1.count == 2, "2 cards from dealer")
        XCTAssertTrue(p2.count == 2, "2 cards from dealer")
        XCTAssertTrue(dealer.currentDeck.count == 48, "deck: 52 - 2 - 2 = 48")
    }
    
    func testDealFlop() {
        var dealer = Dealer(evaluator: eval)
        _ = dealer.dealFlop()
        XCTAssertTrue(dealer.table.dealtCards.count == 3, "flop: 3 cards")
        XCTAssertTrue(dealer.table.burnt.count == 1)
        XCTAssertTrue(dealer.currentDeck.count == 48, "deck: 52 - 1 - 3 = 48")
    }
    
    func testDealTurn() {
        var dealer = Dealer(evaluator: eval)
        _ = dealer.dealFlop()
        _ = dealer.dealTurn()
        XCTAssertTrue(dealer.table.dealtCards.count == 4, "flop + turn: 4 cards")
        XCTAssertTrue(dealer.table.burnt.count == 2)
        XCTAssertTrue(dealer.currentDeck.count == 46, "deck: 52 - 1 - 3 - 1 - 1 = 46")
    }
    
    func testDealRiver() {
        var dealer = Dealer(evaluator: eval)
        _ = dealer.dealFlop()
        _ = dealer.dealTurn()
        _ = dealer.dealRiver()
        XCTAssertTrue(dealer.table.dealtCards.count == 5, "flop + turn + river: 5 cards")
        XCTAssertTrue(dealer.table.burnt.count == 3)
        XCTAssertTrue(dealer.currentDeck.count == 44, "deck: 52 - 1 - 3 - 1 - 1 - 1 -1 = 44")
    }
    
    func testDealTable() {
        var dealer = Dealer(evaluator: eval)
        var p1 = Player()
        var p2 = Player()
        dealer.dealHand(to: &p1)
        dealer.dealHand(to: &p2)
        _ = dealer.dealFlop()
        _ = dealer.dealTurn()
        _ = dealer.dealRiver()
        XCTAssertTrue(dealer.table.dealtCards.count == 5, "flop + turn + river: 5 cards")
        XCTAssertTrue(dealer.table.burnt.count == 3)
        XCTAssertTrue(dealer.currentDeck.count == 40, "deck: 52 - 2 - 2 - 1 - 3 - 1 - 1 - 1 -1 = 40")
    }
    
    func testDealForOnePlayerAndEvaluate() {
        var dealer = Dealer(evaluator: eval)
        var p1 = Player(name: "Jim")
        XCTAssertTrue(p1.holeCards.isEmpty)
        XCTAssertTrue(p1.hand == nil)
        dealer.deal(cards: ["A♠", "K♠"], to: &p1)
        XCTAssertTrue(p1.holeCards == "A♠ K♠")
        dealer.table.dealtCards = [Card(suit: "♠", rank: "Q"), Card(suit: "♠", rank: "J"), Card(suit: "♠", rank: "T"), Card(suit: "♠", rank: "2"), Card(suit: "♠", rank: "3")]
        dealer.evaluateHandAtRiver(for: &p1)
        XCTAssertTrue(p1.hand!.0.rank == 1)
        XCTAssertTrue(p1.hand!.0.name.rawValue == "A Straight Flush")
        XCTAssertTrue(p1.cardsNames == "Ace of Spades, King of Spades")
    }
    
    func testDealForTwoPlayersAndEvaluate() {
        var dealer = Dealer(evaluator: eval)
        var p1 = Player(name: "Jim")
        var p2 = Player(name: "Jane")
        dealer.deal(cards: ["A♠", "K♠"], to: &p1)
        dealer.deal(cards: ["2♥", "2♦"], to: &p2)
        dealer.table.dealtCards = [Card(suit: "♠", rank: "Q"), Card(suit: "♠", rank: "J"), Card(suit: "♠", rank: "T"), Card(suit: "♠", rank: "2"), Card(suit: "♠", rank: "3")]
        dealer.evaluateHandAtRiver(for: &p1)
        dealer.evaluateHandAtRiver(for: &p2)
        dealer.updateHeadsUpWinner(player1: p1, player2: p2)
        XCTAssertTrue(dealer.currentHandWinner!.name == "Jim")
    }
    
    func testDealForTwoPlayersAndEvaluateSplit() {
        var dealer = Dealer(evaluator: eval)
        var p1 = Player(name: "Jim")
        var p2 = Player(name: "Jane")
        dealer.deal(cards: ["A♠", "K♠"], to: &p1)
        dealer.deal(cards: ["A♥", "K♦"], to: &p2)
        dealer.table.dealtCards = [Card(suit: "♠", rank: "Q"), Card(suit: "♦", rank: "J"), Card(suit: "♦", rank: "T"), Card(suit: "♥", rank: "2"), Card(suit: "♠", rank: "3")]
        dealer.evaluateHandAtRiver(for: &p1)
        dealer.evaluateHandAtRiver(for: &p2)
        dealer.updateHeadsUpWinner(player1: p1, player2: p2)
        XCTAssertTrue(dealer.currentHandWinner!.name == "SPLIT")
    }
    
    func testDealerChangeDeck() {
        var dealer = Dealer(evaluator: eval)
        var p1 = Player(name: "Jim")
        dealer.dealHand(to: &p1)
        _ = dealer.dealFlop()
        XCTAssertTrue(dealer.currentDeck.count == 46)
        dealer.changeDeck()
        XCTAssertTrue(dealer.currentDeck.count == 52)
    }
    
    func testShuffleDeck() {
        var dealer = Dealer(evaluator: eval)
        let firstCards = dealer.currentDeck.cards[0...5].map({$0.rank})
        dealer.shuffleDeck()
        XCTAssertFalse(dealer.currentDeck.cards[0...5].map({$0.rank}) == firstCards)
    }
    
    func testPlayerCardHistory() {
        var dealer = Dealer(evaluator: eval)
        var p1 = Player(name: "Jim")
        dealer.deal(cards: [Card(suit: "♠", rank: "A"), Card(suit: "♠", rank: "K")], to: &p1)
        dealer.deal(cards: [Card(suit: "♠", rank: "Q"), Card(suit: "♠", rank: "J")], to: &p1)
        dealer.deal(cards: [Card(suit: "♠", rank: "T"), Card(suit: "♠", rank: "9")], to: &p1)
        XCTAssertTrue(p1.historyOfDealtCards[0].0 == Card(suit: "♠", rank: "A"))
        XCTAssertTrue(p1.historyOfDealtCards[0].1 == Card(suit: "♠", rank: "K"))
        XCTAssertTrue(p1.historyOfDealtCards[1].0 == Card(suit: "♠", rank: "Q"))
        XCTAssertTrue(p1.historyOfDealtCards[1].1 == Card(suit: "♠", rank: "J"))
        XCTAssertTrue(p1.historyOfDealtCards[2].0 == Card(suit: "♠", rank: "T"))
        XCTAssertTrue(p1.historyOfDealtCards[2].1 == Card(suit: "♠", rank: "9"))
        XCTAssertTrue(p1.cardsHistory == "A♠ K♠, Q♠ J♠, T♠ 9♠")
    }
    
    func testPlayerFrequentHands() {
        var dealer = Dealer(evaluator: eval)
        var p1 = Player(name: "Jim")
        dealer.deal(cards: [Card(suit: "♠", rank: "A"), Card(suit: "♠", rank: "K")], to: &p1)
        dealer.deal(cards: [Card(suit: "♠", rank: "Q"), Card(suit: "♠", rank: "J")], to: &p1)
        dealer.changeDeck()
        dealer.deal(cards: [Card(suit: "♠", rank: "A"), Card(suit: "♠", rank: "K")], to: &p1)
        dealer.deal(cards: [Card(suit: "♠", rank: "T"), Card(suit: "♠", rank: "9")], to: &p1)
        dealer.changeDeck()
        dealer.deal(cards: [Card(suit: "♠", rank: "A"), Card(suit: "♠", rank: "K")], to: &p1)
        dealer.deal(cards: [Card(suit: "♠", rank: "T"), Card(suit: "♠", rank: "9")], to: &p1)
        let fh = p1.frequentHands
        XCTAssertTrue(fh["A♠,K♠"] == 3)
        XCTAssertTrue(fh["T♠,9♠"] == 2)
    }

    
    
    
    
    
    
    
    
//    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
