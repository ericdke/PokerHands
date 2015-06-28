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
    @IBOutlet weak var player1ScoreNameLabel: NSTextField!
    @IBOutlet weak var player2ScoreNameLabel: NSTextField!
    @IBOutlet weak var player1ScoreLabel: NSTextField!
    @IBOutlet weak var player2ScoreLabel: NSTextField!

    typealias ResultForTable = (dealer: Dealer, player1: Player, player2: Player)

    var results = [ResultForTable]()

    override init() {
        super.init()
    }

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
        self.player1ScoreLabel.integerValue = 0
        self.player2ScoreLabel.integerValue = 0
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
            name2 = "Annette"
        }
        self.player1ScoreNameLabel.stringValue = name1
        self.player2ScoreNameLabel.stringValue = name2
        // TODO: create some sort of dispatch groups to avoid choke if numberOfHands is big
        for _ in 1...numberOfHands {
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
                    for (k, v) in dealer.scores {
                        if k == player1.name! {
                            self.player1ScoreLabel.integerValue += v
                        } else if k == player2.name! {
                            self.player2ScoreLabel.integerValue += v
                        }
                    }
                    self.roundsCountLabel.integerValue++
                    self.handsTableView.reloadData()
                    self.handsTableView.scrollRowToVisible(self.results.count - 1)
                }
            }
        }
    }

}
