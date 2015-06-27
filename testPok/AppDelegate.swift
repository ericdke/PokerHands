//
//  AppDelegate.swift
//  testPok
//
//  Created by ERIC DEJONCKHEERE on 27/06/2015.
//  Copyright (c) 2015 Eric Dejonckheere. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification) {

        var dealer = Dealer()
        var player1 = Player(name: "John")
        var player2 = Player(name: "Jack")
        let numberOfHands = 10

        for i in 1...numberOfHands {
            println("\nRound \(i):\n")
            dealer.dealHoldemHandTo(&player1)
            dealer.dealHoldemHandTo(&player2)
            dealer.dealFlop()
            dealer.dealTurn()
            dealer.dealRiver()
            println(dealer.currentGame)
            println("\(player1.currentGame) (\(player1.cardsNames))")
            println("\(player2.currentGame) (\(player2.cardsNames))")
            dealer.evaluateHoldemHandAtRiverFor(&player1)
            dealer.evaluateHoldemHandAtRiverFor(&player2)
            dealer.updateHeadsUpWinner(player1: player1, player2: player2)
            dealer.changeDeck()
        }

        let total: Int
        if let handsSplitted = dealer.scores["SPLIT"] {
            total = numberOfHands - handsSplitted
            if handsSplitted > 0 {
                println("\(handsSplitted) hands splitted")
            }
        } else {
            total = numberOfHands
        }

        for (k, v) in dealer.scores {
            if k == "SPLIT" {
                continue
            } else {
                let percent = Double(v) / Double(total) * Double(100)
                let formatted = String(format: "%.2f", percent)
                println("\(k) won \(v) hands (\(formatted)%)")
            }
        }

        // -- end of game

        dealer = Dealer()
    }











    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

