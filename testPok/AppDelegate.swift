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
        let evaluator = Evaluator()
//
//
//        println(hand1.name.rawValue)
//        println(hand1.rank)

//        var dealer = Dealer()
//
//        var john = Player(name: "John")
//        var jack = Player(name: "Jack")
//
//        for i in 1...3 {
//            println("\nGame \(i):\n")
//            dealer.dealHoldemHandTo(&john)
//            dealer.dealHoldemHandTo(&jack)
//            dealer.dealFlop()
//            println(dealer.flop)
//            dealer.dealTurn()
//            println(dealer.turn)
//            dealer.dealRiver()
//            println(dealer.river)
//            println(dealer.currentGame)
//            println("\(john.currentGame) (\(john.cardsNames))")
//            println("\(jack.currentGame) (\(jack.cardsNames))")
//
//            let johnsHand = evaluator.evaluate(john.cards.map({ $0.description }) + dealer.table.dealtCards.map({ $0.description }))
//            let jacksHand = evaluator.evaluate(jack.cards.map({ $0.description }) + dealer.table.dealtCards.map({ $0.description }))
//            println("\(john.name!) hand: \(johnsHand)")
//            println("\(jack.name!) hand: \(jacksHand)")
//
//            dealer.changeDeck()
//        }
        let flop = ["8♠", "8♣", "8♥", "Q♣", "A♠"]
        let player = ["T♣", "T♠"]
        let all = flop + player
        let perms = all.permutation(5)
        println(perms)
        println(perms.count)
//        println(evaluator.evaluate(["9♣", "Q♣", "A♠︎", "A♣", "J♣"]).name.rawValue)

        let uniqs = Array(NSSet(array: perms.map({ ($0 as [String]).sorted(<) }))).map({ $0 as! [String] })
        println(uniqs)
        println(uniqs.count)
        
//        let def = uniqs.map({ ($0 as! [String]).sorted(<) })
//        let final = Array(NSSet(array: def))
//        println(final.count)
//        
//        for obj in final {
//            println(obj)
//        }
        
        var handsResult = [(HandRank, String)]()
        
        for hand in uniqs {
            println(hand)
            let h = evaluator.evaluate(hand)
            println(h.name.rawValue)
            handsResult.append((h, hand.description))
        }
        
        handsResult.sort({ $0.0.rank < $1.0.rank })
        
        let bestHand = handsResult.first
        
        println("\(bestHand!.0.name.rawValue) => \(bestHand!.1)")
        
//        let h = evaluator.evaluate(uniqs[0] as [String])
//        println(h.name)
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

