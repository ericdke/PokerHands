//
//  AppController.swift
//  testPok
//
//  Created by ERIC DEJONCKHEERE on 27/06/2015.
//  Copyright (c) 2015 Eric Dejonckheere. All rights reserved.
//

import Cocoa

class AppController: NSObject, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var handsTableView: NSTableView!
    @IBOutlet weak var player1TextField: NSTextField!
    @IBOutlet weak var player2TextField: NSTextField!
    @IBOutlet weak var roundsTextField: NSTextField!

    var test = [String]()

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return test.count
    }

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeViewWithIdentifier("roundsColumn", owner: self) as! SPKHandTableCellView
        cell.textField!.stringValue = test[row]
        return cell
    }

    @IBAction func player1TFActivated(sender: NSTextField) {
    }

    @IBAction func player2TFActivated(sender: NSTextField) {
    }

    @IBAction func roundsTFActivated(sender: NSTextField) {
    }

    @IBAction func goButtonClicked(sender: NSButton) {
        if !player1TextField.stringValue.isEmpty && !player2TextField.stringValue.isEmpty && !roundsTextField.stringValue.isEmpty {
            if roundsTextField.integerValue != 0 {
                play(roundsTextField.integerValue)
            }
        }
    }

    func play(numberOfHands: Int) {
        var dealer = Dealer()
        var player1 = Player(name: player1TextField.stringValue)
        var player2 = Player(name: player2TextField.stringValue)

        for i in 1...numberOfHands {
//            println("\nRound \(i):\n")
            dealer.dealHoldemHandTo(&player1)
            dealer.dealHoldemHandTo(&player2)
            dealer.dealFlop()
            dealer.dealTurn()
            dealer.dealRiver()
//            println(dealer.currentGame)

            test.append(dealer.currentGame)

//            println("\(player1.currentGame) (\(player1.cardsNames))")
//            println("\(player2.currentGame) (\(player2.cardsNames))")
            dealer.evaluateHoldemHandAtRiverFor(&player1)
            dealer.evaluateHoldemHandAtRiverFor(&player2)
            dealer.updateHeadsUpWinner(player1: player1, player2: player2)
            dealer.changeDeck()

            handsTableView.reloadData()
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

}
