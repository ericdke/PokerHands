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
    @IBOutlet weak var gobutton: NSButton!

    typealias TypeForTable = (dealer: Dealer, player1: Player, player2: Player)

    var results = [TypeForTable]()
    var cardsImages = [String:NSImage]()

    override init() {
        super.init()
    }

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return results.count
    }

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeViewWithIdentifier("roundsColumn", owner: self) as! SPKHandTableCellView
        
        let result = results[row]
        
        let p1hc = result.player1.holeCards
        let p2hc = result.player2.holeCards
        let p1 = "\(result.player1.name!):\t\(p1hc)"
        let p2 = "\(result.player2.name!):\t\(p2hc)"
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
        
        let player1CardsImages = getImageForCards(result.player1.cards)
        cell.card1Player1.image = player1CardsImages[0]
        cell.card2Player1.image = player1CardsImages[1]
        
        let player2CardsImages = getImageForCards(result.player2.cards)
        cell.card1Player2.image = player2CardsImages[0]
        cell.card2Player2.image = player2CardsImages[1]
        
        let tableCardsImages = getImageForCards(result.dealer.table.dealtCards)
        cell.card1Flop.image = tableCardsImages[0]
        cell.card2Flop.image = tableCardsImages[1]
        cell.card3Flop.image = tableCardsImages[2]
        cell.card4Turn.image = tableCardsImages[3]
        cell.card5River.image = tableCardsImages[4]
        
        return cell
    }
    
    func getImageForCards(cards: [Card]) -> [NSImage] {
        var imgs = [NSImage]()
        for card in cards {
            let name = card.fileName
            if let img = cardsImages[name] {
                imgs.append(img)
            } else {
                let img = NSImage(named: name)!
                cardsImages[name] = img
                imgs.append(img)
            }
        }
        return imgs
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
        gobutton.enabled = false
        results = []
        roundsCountLabel.integerValue = 0
        player1ScoreLabel.integerValue = 0
        player2ScoreLabel.integerValue = 0
        let (name1, name2) = playerNames()
        player1ScoreNameLabel.stringValue = name1
        player2ScoreNameLabel.stringValue = name2
        let dgen = Dealer()
        let deck = dgen.currentDeck
        // TODO: create some sort of dispatch groups to avoid choke if numberOfHands is big
        for i in 1...numberOfHands {
            // TODO: in this example we create new players and dealer each time because of race conditions otherwise, but we should refactor to use a safe-thread version of one single instance of each object so we can have player statistics, dealer and table stats, etc (will probably have to implement read-write barrier in our structs)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                var dealer = Dealer(deck: deck)
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
                    if i == numberOfHands {
                        self.gobutton.enabled = true
                    }
                }
            }
        }
    }
    
    func playerNames() -> (String, String) {
        let name1: String
        let name2: String
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
        return (name1, name2)
    }

}
