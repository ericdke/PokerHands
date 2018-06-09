//  Created by ERIC DEJONCKHEERE on 27/06/2015.
//  Copyright (c) 2015 Eric Dejonckheere. All rights reserved.
//
//  SWIFT 3
//

import Cocoa

enum GameMode {
    case random, custom
}

enum PersonType {
    case player1, player2, dealer
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
    @IBOutlet weak var progressBar: NSProgressIndicator!
    
    
    @IBAction func radioButtonsAction(_ sender: NSButton) {
        if sender.tag == 0 {
            settings.gameMode = .random
        } else {
            settings.gameMode = .custom
            window.beginSheet(playerAndCardsPanel, completionHandler: { _ in })
        }
    }
    
    let settings = SPKSettings.sharedInstance
    let byteRanks = ByteRanks.sharedInstance
    
    typealias DealerAndPlayers = (dealer: Dealer, player1: Player, player2: Player)
    
    var results = [DealerAndPlayers]()
    var cardsImages = [String:NSImage]()
    
    // TODO: put the tableView in its own view + controller
    func numberOfRows(in tableView: NSTableView) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        guard let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "roundsColumn"), owner: self) as? SPKHandTableCellView
            else { return nil }
        
        let result = results[row]
        
        guard let name1 = result.player1.name,
            let name2 = result.player2.name,
            let winnerName = result.dealer.currentHandWinner?.name,
            let player1CardsImages = getImages(for: result.player1.cards),
            let player2CardsImages = getImages(for: result.player2.cards),
            let tableCardsImages = getImages(for: result.dealer.table.dealtCards)
            else {
                return nil
        }
        
        cellView.textField?.stringValue = "\(name1): \(result.player1.holeCards)"
        cellView.label1.stringValue = "\(name2): \(result.player2.holeCards)"
        cellView.label2.stringValue = "Cards: \(result.dealer.table.currentGame)"
        if winnerName == "SPLIT" {
            cellView.label3.stringValue = "Split! This hand is canceled."
        } else {
            guard let winningHand = result.dealer.currentHandWinner?.handDescription,
                let winningHandName = result.dealer.currentHandWinner?.handNameDescription
                else {
                    return nil
            }
            cellView.label3.stringValue = "\(winnerName.uppercased()) wins with \(winningHandName) (\(winningHand))"
        }
        
        cellView.card1Player1.image = player1CardsImages[0]
        cellView.card2Player1.image = player1CardsImages[1]
        
        cellView.card1Player2.image = player2CardsImages[0]
        cellView.card2Player2.image = player2CardsImages[1]
        
        cellView.card1Flop.image = tableCardsImages[0]
        cellView.card2Flop.image = tableCardsImages[1]
        cellView.card3Flop.image = tableCardsImages[2]
        cellView.card4Turn.image = tableCardsImages[3]
        cellView.card5River.image = tableCardsImages[4]
        
        return cellView
    }
    
    func getImages(for cards: [Card]) -> [NSImage]? {
        var imgs = [NSImage]()
        for card in cards {
            let name = card.fileName
            if let img = cardsImages[name] {
                imgs.append(img)
            } else {
                guard let img = NSImage(named: NSImage.Name(rawValue: name)) else {
                    return nil
                }
                cardsImages[name] = img
                imgs.append(img)
            }
        }
        return imgs
    }
    
    @IBAction func goButtonClicked(_ sender: NSButton) {
        if !roundsTextField.stringValue.isEmpty && roundsTextField.integerValue != 0 {
            playGCD(times: roundsTextField.integerValue)
        } else {
            playGCD(times: 100)
        }
    }
    
    func playGCD(times: Int) {
        progressBar.isHidden = false
        progressBar.doubleValue = 1.0
        progressBar.maxValue = Double(times)
        gobutton.isEnabled = false
        results = []
        handsTableView.reloadData()
        roundsCountLabel.integerValue = 0
        player1ScoreLabel.integerValue = 0
        player2ScoreLabel.integerValue = 0
        let (name1, name2) = self.playerNames
        player1ScoreNameLabel.stringValue = name1
        player2ScoreNameLabel.stringValue = name2
        let deck = Dealer().currentDeck
        var customPlayer1Cards = [Card]()
        var customPlayer2Cards = [Card]()
        if settings.gameMode == .custom {
            customPlayer1Cards = settings.player1Cards
            customPlayer2Cards = settings.player2Cards
        }
        let eval = Evaluator()
        // go in background
        DispatchQueue.global(qos: .background).async {
            // run a loop of background tasks
            DispatchQueue.concurrentPerform(iterations: times, execute: { (index) -> Void in
                // TODO: in this example we create new players and dealer each time, but we should refactor to use a safe-thread version of one single instance of each object so we can have player statistics, dealer and table stats, etc (will probably have to implement read-write barrier in our structs)
                var dealer = Dealer(deck: deck, evaluator: eval)
                var (player1, player2) = (Player(name: name1), Player(name: name2))
                
                if self.settings.gameMode == .random {
                    dealer.dealHand(to: &player1)
                    dealer.dealHand(to: &player2)
                } else {
                    // custom cards first! otherwise the random func could deal one of the custom cards
                    if !customPlayer1Cards.isEmpty {
                        dealer.deal(cards: customPlayer1Cards, to: &player1)
                    }
                    if !customPlayer2Cards.isEmpty {
                        dealer.deal(cards: customPlayer2Cards, to: &player2)
                    }
                    if customPlayer1Cards.isEmpty {
                        dealer.dealHand(to: &player1)
                    }
                    if customPlayer2Cards.isEmpty {
                        dealer.dealHand(to: &player2)
                    }
                }
                
                dealer.dealFlop()
                dealer.dealTurn()
                dealer.dealRiver()
                
                dealer.evaluateHandAtRiver(for: &player1)
                dealer.evaluateHandAtRiver(for: &player2)
                
                dealer.updateHeadsUpWinner(player1: player1, player2: player2)
                
                DispatchQueue.main.async {
                    let p = (dealer, player1, player2)
                    self.results.append(p)
                    self.endOfHand(people: p)
                }
            })
            // this executes _after_ the loop
            DispatchQueue.main.async {
                self.progressBar.isHidden = true
                self.gobutton.isEnabled = true
            }
        }
    }
    
    func endOfHand(people: DealerAndPlayers) {
        guard let name1 = people.player1.name else {
                print("ERROR with player names")
                return
        }
        for (name, value) in people.dealer.scores {
            if name == name1 {
                player1ScoreLabel.integerValue += value
            } else {
                player2ScoreLabel.integerValue += value
            }
        }
        roundsCountLabel.integerValue += 1
        progressBar.doubleValue += 1
        let c = self.results.count - 1
        handsTableView.insertRows(at: IndexSet(integer: c), withAnimation: [])
        handsTableView.scrollRowToVisible(c)
    }
    
    var playerNames: (String, String) {
        let name1 = player1TextField.stringValue.isEmpty ? "Johnny" : player1TextField.stringValue
        let name2 = player2TextField.stringValue.isEmpty ? "Annette" : player2TextField.stringValue
        return (name1, name2)
    }
    
}
