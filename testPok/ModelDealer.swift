//
//  ModelDealer.swift
//  testPok
//
//  Created by ERIC DEJONCKHEERE on 27/06/2015.
//  Copyright (c) 2015 Eric Dejonckheere. All rights reserved.
//

import Cocoa

struct Dealer {

    var currentDeck: Deck

    var table: Table

    var verbose = false

    init() {
        currentDeck = Deck()
        table = Table()
    }

    var currentGame: String { get { return "\n\t\t\(table.currentGame)\n" } }

    var flop: String { get { return "Flop:\t\(table.flop)" } }

    var turn: String { get { return "Turn:\t\(table.turn)" } }

    var river: String { get { return "River:\t\(table.river)" } }

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
}
