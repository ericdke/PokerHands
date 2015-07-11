//
//  ModelDealer.swift
//  testPok
//
//  Created by ERIC DEJONCKHEERE on 27/06/2015.
//  Copyright (c) 2015 Eric Dejonckheere. All rights reserved.
//

import Cocoa

struct Dealer {

    var evaluator: Evaluator

    var currentDeck: Deck

    var table: Table

    var verbose = false

    init() {
        currentDeck = Deck()
        table = Table()
        evaluator = Evaluator()
    }
    
    init(deck: Deck) {
        currentDeck = deck
        table = Table()
        evaluator = Evaluator()
    }
    
    init(deck: Deck, evaluator: Evaluator) {
        currentDeck = deck
        table = Table()
        self.evaluator = evaluator
    }

    var currentGame: String { get { return "Game: \(table.currentGame)\n" } }

    var flop: String { get { return "Flop: \(table.flop)" } }

    var turn: String { get { return "Turn: \(table.turn)" } }

    var river: String { get { return "River: \(table.river)" } }

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
        if verbose { print("\nChanged deck of cards for a new one.\n") }
    }

    mutating func shuffleDeck() {
        currentDeck.shuffle()
        if verbose { print("\nCards in the deck have been shuffled.\n") }
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
    
    mutating func dealHoldemCards(cards: [String]) -> [Card] {
        let up = cards.map({$0.uppercaseString})
        var cards = [Card]()
        var toRemove: Int?
        for card in up {
            let components = card.characters.map({String($0)})
            let cardObj = Card(suit: components[1], rank: components[0])
            for (index, deckCard) in currentDeck.cards.enumerate() {
                if deckCard == cardObj {
                    toRemove = index
                    break
                }
            }
            if let rm = toRemove {
                currentDeck.cards.removeAtIndex(rm)
                cards.append(cardObj)
            } else {
                NSLog("%@", "ERROR: \(cardObj) is not in the deck")
            }
        }
        return cards
    }
    
    mutating func dealHoldemCardsTo(inout player: Player, cards: [String]) {
        player.cards = dealHoldemCards(cards)
    }
    
    mutating func dealHoldemCardsTo(inout player: Player, cards: [Card]) {
        var toRemove: Int?
        var error = false
        for card in cards {
            for (index, deckCard) in currentDeck.cards.enumerate() {
                if deckCard == card {
                    toRemove = index
                    break
                }
            }
            if let rm = toRemove {
                currentDeck.cards.removeAtIndex(rm)
            } else {
                error = true
                NSLog("%@", "ERROR: \(card) is not in the deck")
            }
        }
        if error {
            player.cards = []
        } else {
            player.cards = cards
        }
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
        // all 5 cards combinations from the 7 cards
        let perms = cardsReps.permutation(5)
        // TODO: do the permutations with rank/else instead of literal cards descriptions
        let uniqs = Array(NSSet(array: perms.map({ $0.sort(<) }))).map({ $0 as! [String] })
        var handsResult = [(HandRank, [String])]()
        for hand in uniqs {
            let h = evaluator.evaluate(hand)
            handsResult.append((h, hand)) }
        handsResult.sortInPlace({ $0.0 < $1.0 })
        let bestHand = handsResult.first
        return bestHand!
    }

    mutating func updateHeadsUpWinner(player1 player1: Player, player2: Player) {
        currentHandWinner = findHeadsUpWinner(player1: player1, player2: player2)
    }

    func findHeadsUpWinner(player1 player1: Player, player2: Player) -> Player {
        if player1.holdemHand!.0 < player2.holdemHand!.0 {
            return player1 }
        else if player1.holdemHand!.0 == player2.holdemHand!.0 {
            return Player(name: "SPLIT") }
        else {
            return player2
        }
    }
}
