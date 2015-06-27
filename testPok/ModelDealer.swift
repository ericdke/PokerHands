//
//  ModelDealer.swift
//  testPok
//
//  Created by ERIC DEJONCKHEERE on 27/06/2015.
//  Copyright (c) 2015 Eric Dejonckheere. All rights reserved.
//

import Cocoa

struct Dealer {

    let evaluator = Evaluator()

    var currentDeck: Deck

    var table: Table

    var verbose = false

    init() {
        currentDeck = Deck()
        table = Table()
    }

    var currentGame: String { get { return "Game:\t\(table.currentGame)\n" } }

    var flop: String { get { return "Flop:\t\(table.flop)" } }

    var turn: String { get { return "Turn:\t\(table.turn)" } }

    var river: String { get { return "River:\t\(table.river)" } }

    var currentHandWinner: Player? {
        didSet {
            if currentHandWinner != nil {
                if scores[currentHandWinner!.name!] == nil {
                    scores[currentHandWinner!.name!] = 1
                } else {
                    scores[currentHandWinner!.name!]!++
                }
            } else {
                scores = [:]
            }
        }
    }

    var scores = [String:Int]()

    mutating func changeDeck() {
        currentDeck = Deck()
        if verbose { println("\nChanged deck of cards for a new one.\n") }
    }

    mutating func shuffleDeck() {
        currentDeck.shuffle()
        if verbose { println("\nCards in the deck have been shuffled.\n") }
    }

    mutating func deal(numberOfCards: Int) -> [Card] {
        if currentDeck.count >= numberOfCards {
            var cards = [Card]()
            for _ in 1...numberOfCards {
                cards.append(currentDeck.takeOneCard()!)
            }
            return cards
        }
        errorNotEnoughCards()
        return []
    }

    mutating func dealHoldemHand() -> [Card] {
        return deal(2)
    }

    mutating func dealHoldemHandTo(inout player: Player) {
        player.cards = dealHoldemHand()
    }

    mutating func dealFlop() -> [Card] {
        table.dealtCards = []
        table.burnt = []
        let dealt = dealWithBurning(3)
        table.addCards(dealt)
        return dealt
    }

    mutating func dealTurn() -> [Card] {
        let dealt = dealWithBurning(1)
        table.addCards(dealt)
        return dealt
    }

    mutating func dealRiver() -> [Card] {
        return dealTurn()
    }

    private mutating func burn() -> Card? {
        if currentDeck.count > 0 {
            return currentDeck.takeOneCard() }
        return nil
    }

    private mutating func dealWithBurning(numberOfCardsToDeal: Int) -> [Card] {
        if let burned = burn() {
            table.addToBurntCards(burned)
            return deal(numberOfCardsToDeal) }
        errorNotEnoughCards()
        return []
    }

    private func error(message: String) {
        NSLog("ERROR: %@", message)
    }

    private func errorNotEnoughCards() {
        error("not enough cards")
    }

    mutating func evaluateHoldemHandAtRiverFor(inout player: Player) {
        player.holdemHand = evaluateHoldemHandAtRiver(player)
    }

    func evaluateHoldemHandAtRiver(player: Player) -> (HandRank, [String]) {
        let sevenCards = table.dealtCards + player.cards
        let cardsReps = sevenCards.map({ $0.description })
        let perms = cardsReps.permutation(5) // all 5 cards combinations from the 7 cards
        let uniqs = Array(NSSet(array: perms.map({ ($0 as [String]).sorted(<) }))).map({ $0 as! [String] })
        var handsResult = [(HandRank, [String])]()
        for hand in uniqs {
            let h = evaluator.evaluate(hand)
            handsResult.append((h, hand)) }
        handsResult.sort({ $0.0.rank < $1.0.rank })
        let bestHand = handsResult.first
        return bestHand!
    }

    mutating func updateHeadsUpWinner(#player1: Player, player2: Player) {
        currentHandWinner = findHeadsUpWinner(player1: player1, player2: player2)
    }

    func findHeadsUpWinner(#player1: Player, player2: Player) -> Player {
        if player1.holdemHand!.0.rank < player2.holdemHand!.0.rank {
            println("\nWinner: \(player1.name!) with \(player1.holdemHand!.0.name.rawValue) \(player1.holdemHand!.1)\n")
            return player1 }
        else if player1.holdemHand!.0.rank == player2.holdemHand!.0.rank {
            return Player(name: "SPLIT") }
        else {
            println("\nWinner: \(player2.name!) with \(player2.holdemHand!.0.name.rawValue) \(player2.holdemHand!.1)\n")
            return player2
        }
    }
}
