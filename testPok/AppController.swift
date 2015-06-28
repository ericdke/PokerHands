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

    typealias resultForTable = (dealer: Dealer, player1: Player, player2: Player)

    var test = [resultForTable]()

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return test.count
    }

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeViewWithIdentifier("roundsColumn", owner: self) as! SPKHandTableCellView
        let result = test[row]
        let p1 = "\(result.player1.name!):\t\(result.player1.holeCards)"
        let p2 = "\(result.player2.name!):\t\(result.player2.holeCards)"
        let g = "Cards:\t\(result.dealer.table.currentGame)"
        let wname = result.dealer.currentHandWinner!.name
        let w: String
        if let name = wname where name == "SPLIT" {
            w = "Hand is split! Nothing to see."
        } else {
            w = "Winner:\t\(result.dealer.currentHandWinner!.name!.uppercaseString) with \(result.dealer.currentHandWinner!.holeCards) => \(result.dealer.currentHandWinner!.holdemHand!.1) - \(result.dealer.currentHandWinner!.holdemHand!.0.name.rawValue)"
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

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {

            self.test = []
            for i in 1...numberOfHands {
                // println("\nRound \(i):\n")
                dealer.dealHoldemHandTo(&player1)
                dealer.dealHoldemHandTo(&player2)
                dealer.dealFlop()
                dealer.dealTurn()
                dealer.dealRiver()
                // println(dealer.currentGame)
                // println("\(player1.currentGame) (\(player1.cardsNames))")
                // println("\(player2.currentGame) (\(player2.cardsNames))")
                dealer.evaluateHoldemHandAtRiverFor(&player1)
                dealer.evaluateHoldemHandAtRiverFor(&player2)
                dealer.updateHeadsUpWinner(player1: player1, player2: player2)
                dealer.changeDeck()
                self.test.append((dealer, player1, player2))
//                if dealer.currentHandWinner!.name! != "SPLIT" {
//                    self.test.append("\nWinner: \(dealer.currentHandWinner!.name!) with \(dealer.currentHandWinner!.holdemHand!.0.name.rawValue) \(dealer.currentHandWinner!.holdemHand!.1)")
//                } else {
//                    self.test.append("\nNo winner: split")
//                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.handsTableView.reloadData()
                    self.handsTableView.scrollRowToVisible(self.test.count - 1)
                    self.handsTableView.display()
                }
            }

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

}
