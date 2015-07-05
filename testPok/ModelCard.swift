//
//  Card.swift
//  testPok
//
//  Created by ERIC DEJONCKHEERE on 27/06/2015.
//  Copyright (c) 2015 Eric Dejonckheere. All rights reserved.
//

//import Foundation

struct Card {

    let suit: String

    let rank: String

    let description: String

    init(suit: String, rank: String) {
        self.suit = suit
        self.rank = rank
        self.description = "\(rank)\(suit)"
    }

    var name: String {
        get {
            var s = ""
            switch suit {
            case "♠":
                s = "Spades"
            case "♣":
                s = "Clubs"
            case "♥":
                s = "Hearts"
            case "♦":
                s = "Diamonds"
            default:
                print("Error")
            }
            var r = ""
            switch rank {
            case "A":
                r = "Ace"
            case "K":
                r = "King"
            case "Q":
                r = "Queen"
            case "J":
                r = "Jack"
            case "T":
                r = "10"
            default:
                r = rank
            }
            return "\(r) of \(s)"
        }
    }
    
    var fileName: String {
        get {
            let temp = name.stringByReplacingOccurrencesOfString(" ", withString: "_").lowercaseString
            return "\(temp)_w.png"
        }
    }
    
}
