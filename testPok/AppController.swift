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
    @IBOutlet weak var roundsCountLabel: NSTextField!

    typealias resultForTable = (dealer: Dealer, player1: Player, player2: Player)

    var results = [resultForTable]()

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return results.count
    }

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeViewWithIdentifier("roundsColumn", owner: self) as! SPKHandTableCellView
        let result = results[row]
        let p1 = "\(result.player1.name!):\t\(result.player1.holeCards)"
        let p2 = "\(result.player2.name!):\t\(result.player2.holeCards)"
        let g = "Cards:\t\(result.dealer.table.currentGame)"
        let wname = result.dealer.currentHandWinner!.name
        let w: String
        if let name = wname where name == "SPLIT" {
            w = "Hand is split! Nothing to see."
        } else {
            w = "Winner:\t\(result.dealer.currentHandWinner!.name!.uppercaseString) with \(result.dealer.currentHandWinner!.holdemHand!.0.name.rawValue.lowercaseString) \(result.dealer.currentHandWinner!.holdemHand!.1)"
        }
        cell.textField!.stringValue = p1
        cell.label1.stringValue = p2
        cell.label2.stringValue = g
        cell.label3.stringValue = w
        return cell
    }

    @IBAction func player1TFActivated(sender: NSTextField) {
    }

    @IBAction func player2TFActivated(sender: NSTextField) {
    }

    @IBAction func roundsTFActivated(sender: NSTextField) {
    }

    @IBAction func goButtonClicked(sender: NSButton) {
        if !roundsTextField.stringValue.isEmpty && roundsTextField.integerValue != 0 {
            playP(roundsTextField.integerValue)
        } else {
            playP(10)
        }
    }

    func playP(numberOfHands: Int) {
        self.results = []
        self.roundsCountLabel.integerValue = 0
        var name1: String
        var name2: String
        if !self.player1TextField.stringValue.isEmpty {
            name1 = self.player1TextField.stringValue
        } else {
            name1 = "Johnny"
        }
        if !self.player2TextField.stringValue.isEmpty {
            name2 = self.player2TextField.stringValue
        } else {
            name2 = "Johnny"
        }
        // TODO: creer groupes de 10 operations simultanees max
        for i in 1...numberOfHands {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                var dealer = Dealer()
                var player1 = Player(name: name1)
                var player2 = Player(name: name2)
                dealer.dealHoldemHandTo(&player1)
                dealer.dealHoldemHandTo(&player2)
                dealer.dealFlop()
                dealer.dealTurn()
                dealer.dealRiver()
                dealer.evaluateHoldemHandAtRiverFor(&player1)
                dealer.evaluateHoldemHandAtRiverFor(&player2)
                dealer.updateHeadsUpWinner(player1: player1, player2: player2)
                dealer.changeDeck()
                self.results.append((dealer, player1, player2))
                dispatch_async(dispatch_get_main_queue()) {
                    self.roundsCountLabel.integerValue++
                    self.handsTableView.reloadData()
                    self.handsTableView.scrollRowToVisible(self.results.count - 1)
                }
            }
        }
        // TODO: create a way to sum up scores in dealers then call endOfGame
    }

    func endOfGame(dealer: Dealer, numberOfHands: Int) {
        let total: Int
        if let handsSplit = dealer.scores["SPLIT"] {
            total = numberOfHands - handsSplit
            if handsSplit > 0 {
                dispatch_async(dispatch_get_main_queue()) {
                    println("\(handsSplit) hands split")
                }
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
                dispatch_async(dispatch_get_main_queue()) {
                    println("\(k) won \(v) hands (\(formatted)%)")
                }
            }
        }
    }

}
