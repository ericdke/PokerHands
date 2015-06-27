//
//  ModelTable.swift
//  testPok
//
//  Created by ERIC DEJONCKHEERE on 27/06/2015.
//  Copyright (c) 2015 Eric Dejonckheere. All rights reserved.
//

//import Foundation

struct Table {

    var dealtCards = [Card]()

    var burnt = [Card]()

    var burntCards: String { get {
        if burnt.count > 0 {
            let b = join(" ", cardsDescriptions(burnt))
            return "\nBurnt cards: \(b)" }
        return "NO CARD BURNT YET"
        }
    }

    var currentGame: String { get {
        if dealtCards.count > 0 {
            return join(" ", cardsDescriptions(dealtCards)) }
        return "GAME CLOSED"
        }
    }

    var flop: String { get {
        if dealtCards.count > 2 {
            return join(" ", cardsDescriptions(dealtCards)[0...2]) }
        return "NO FLOP"
        }
    }

    var turn: String { get {
        if dealtCards.count > 3 {
            return dealtCards[3].description }
        return "NO TURN"
        }
    }

    var river: String { get {
        if dealtCards.count > 4 {
            return dealtCards[4].description }
        return "NO RIVER"
        }
    }

    mutating func addCards(cards: [Card]) {
        dealtCards += cards
    }

    mutating func addToBurntCards(card: Card) {
        burnt.append(card)
    }

    private func cardsDescriptions(cards: [Card]) -> [String] {
        return cards.map({ $0.description })
    }
}

