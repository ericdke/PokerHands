//
//  SPKSettings.swift
//  SwiftyPokerHands
//
//  Created by ERIC DEJONCKHEERE on 11/07/2015.
//  Copyright © 2015 Eric Dejonckheere. All rights reserved.
//

import Cocoa

class SPKSettings {
    static let sharedInstance = SPKSettings()
    
    var player1Card1Suit = ""
    var player1Card1Rank = ""
    var player1Card2Suit = ""
    var player1Card2Rank = ""
    var player1Random = false
    var player2Card1Suit = ""
    var player2Card1Rank = ""
    var player2Card2Suit = ""
    var player2Card2Rank = ""
    var player2Random = false
    
    var gameMode: GameMode = .Random
    
    func getPlayer1Cards() -> [Card] {
        if player1Random {
            return []
        } else {
            let c1Suit = String(player1Card1Suit.characters.first!)
            let c2Suit = String(player1Card2Suit.characters.first!)
            let card1 = Card(suit: c1Suit, rank: getRank(player1Card1Rank))
            let card2 = Card(suit: c2Suit, rank: getRank(player1Card2Rank))
            return [card1, card2]
        }
    }
    
    func getPlayer2Cards() -> [Card] {
        if player2Random {
            return []
        } else {
            let c1Suit = String(player2Card1Suit.characters.first!)
            let c2Suit = String(player2Card2Suit.characters.first!)
            let card1 = Card(suit: c1Suit, rank: getRank(player2Card1Rank))
            let card2 = Card(suit: c2Suit, rank: getRank(player2Card2Rank))
            return [card1, card2]
        }
    }
    
    private func getRank(rank: String) -> String {
        switch rank {
            case "Ace":
            return "A"
            case "King":
            return "K"
            case "Queen":
            return "Q"
            case "Jack":
            return "J"
            case "10":
            return "T"
            default:
            return rank
        }
    }
    
}
