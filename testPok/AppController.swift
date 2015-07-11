//
//  AppController.swift
//  testPok
//
//  Created by ERIC DEJONCKHEERE on 27/06/2015.
//  Copyright (c) 2015 Eric Dejonckheere. All rights reserved.
//
//  SWIFT 2
//

import Cocoa

enum GameMode {
    case Random, Custom
}

final class AppController: NSObject, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var playerAndCardsPanel: NSPanel!
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
    @IBOutlet weak var spinner: NSProgressIndicator!
    @IBOutlet weak var pleaseWaitLabel: NSTextField!
    
    @IBAction func radioButtonsAction(sender: NSButton) {
        if sender.tag == 0 {
            settings.gameMode = .Random
        } else {
            settings.gameMode = .Custom
            window.beginSheet(playerAndCardsPanel, completionHandler: { _ in })
        }
    }
    
    let settings = SPKSettings.sharedInstance
    let byteRanks = ByteRanks()

    typealias DealerAndPlayers = (dealer: Dealer, player1: Player, player2: Player)

    var results = [DealerAndPlayers]()
    var cardsImages = [String:NSImage]()

    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerAndCardsPanelCLOSE:", name: "playerAndCardsPanelButtonCLOSE", object: nil)
    }
    
    func playerAndCardsPanelCLOSE(notification: NSNotification) {
        window.endSheet(playerAndCardsPanel)
    }

    
    // TODO: put the tableView in its own view + controller
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return results.count
    }

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {

        let cell = tableView.makeViewWithIdentifier("roundsColumn", owner: self) as! SPKHandTableCellView

        let result = results[row]
        
        let p1 = "\(result.player1.name!): \(result.player1.holeCards)"
        let p2 = "\(result.player2.name!): \(result.player2.holeCards)"
        let g = "Cards: \(result.dealer.table.currentGame)"
        let wname = result.dealer.currentHandWinner!.name
        let w: String
        if let name = wname where name == "SPLIT" {
            w = "Split! This hand is canceled."
        } else {
            w = "\(result.dealer.currentHandWinner!.name!.uppercaseString) wins with \(result.dealer.currentHandWinner!.holdemHand!.0.name.rawValue.lowercaseString) \(result.dealer.currentHandWinner!.holdemHand!.1)"
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

    @IBAction func goButtonClicked(sender: NSButton) {
        if !roundsTextField.stringValue.isEmpty && roundsTextField.integerValue != 0 {
            playGCD(roundsTextField.integerValue)
        } else {
            playGCD(10)
        }
    }
    
    func playGCD(numberOfHands: Int) {
//        pleaseWaitLabel.hidden = false
        spinner.startAnimation(nil)
        gobutton.enabled = false
        results = []
        roundsCountLabel.integerValue = 0
        player1ScoreLabel.integerValue = 0
        player2ScoreLabel.integerValue = 0
        let (name1, name2) = playerNames()
        player1ScoreNameLabel.stringValue = name1
        player2ScoreNameLabel.stringValue = name2
        let deck = Dealer().currentDeck
        var customPlayer1Cards = [Card]()
        var customPlayer2Cards = [Card]()
        if settings.gameMode == .Custom {
            customPlayer1Cards = settings.getPlayer1Cards()
            customPlayer2Cards = settings.getPlayer2Cards()
        }
        let eval = Evaluator(byteRanksInstance: self.byteRanks)
        // go in background
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            // run a loop of background tasks
            dispatch_apply(numberOfHands, dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { (index) -> Void in
                // TODO: in this example we create new players and dealer each time, but we should refactor to use a safe-thread version of one single instance of each object so we can have player statistics, dealer and table stats, etc (will probably have to implement read-write barrier in our structs)
                var dealer = Dealer(deck: deck, evaluator: eval)
                var (player1, player2) = (Player(name: name1), Player(name: name2))
                
                if self.settings.gameMode == .Random {
                    dealer.dealHoldemHandTo(&player1)
                    dealer.dealHoldemHandTo(&player2)
                } else {
                    // custom cards first
                    if !customPlayer1Cards.isEmpty {
                        dealer.dealHoldemCardsTo(&player1, cards: customPlayer1Cards)
                    }
                    if !customPlayer2Cards.isEmpty {
                        dealer.dealHoldemCardsTo(&player2, cards: customPlayer2Cards)
                    }
                    if customPlayer1Cards.isEmpty {
                        dealer.dealHoldemHandTo(&player1)
                    }
                    if customPlayer2Cards.isEmpty {
                        dealer.dealHoldemHandTo(&player2)
                    }
                }
                
                dealer.dealFlop()
                dealer.dealTurn()
                dealer.dealRiver()
                dealer.evaluateHoldemHandAtRiverFor(&player1)
                dealer.evaluateHoldemHandAtRiverFor(&player2)
                dealer.updateHeadsUpWinner(player1: player1, player2: player2)
                dispatch_async(dispatch_get_main_queue()) {
                    self.results.append((dealer, player1, player2))
                    self.endOfHand((dealer, player1, player2))
                }
            })
            // this executes _after_ the loop
            dispatch_async(dispatch_get_main_queue()) {
                self.gobutton.enabled = true
//                self.pleaseWaitLabel.hidden = true
                self.spinner.stopAnimation(nil)
            }
        }
    }
    
    func endOfHand(people: DealerAndPlayers) {
        let (p1, p2) = (people.1.name!, people.2.name!)
        for (k, v) in people.0.scores {
            if k == p1 {
                player1ScoreLabel.integerValue += v
            } else if k == p2 {
                player2ScoreLabel.integerValue += v
            }
        }
        roundsCountLabel.integerValue++
        handsTableView.reloadData()
        handsTableView.scrollRowToVisible(self.results.count - 1)
    }
    
    func playerNames() -> (String, String) {
        let (name1, name2): (String,String)
        if player1TextField.stringValue.isEmpty {
            name1 = "Johnny"
        } else {
            name1 = player1TextField.stringValue
        }
        if player2TextField.stringValue.isEmpty {
            name2 = "Annette"
        } else {
            name2 = player2TextField.stringValue
        }
        return (name1, name2)
    }

}
