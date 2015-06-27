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
        var dealer = Dealer()
        var john = Player(name: "John")
        var jack = Player(name: "Jack")
        var scores = [String:Int]()
        scores[jack.name!] = 0
        scores[john.name!] = 0
        for i in 1...30 {
            println("\nGame \(i):\n")
            dealer.dealHoldemHandTo(&john)
            dealer.dealHoldemHandTo(&jack)
            dealer.dealFlop()
            println(dealer.flop)
            dealer.dealTurn()
            println(dealer.turn)
            dealer.dealRiver()
            println(dealer.river)
            println(dealer.currentGame)
            println("\(john.currentGame) (\(john.cardsNames))")
            println("\(jack.currentGame) (\(jack.cardsNames))")

            let johnBest = evaluateHoldemHandAtRiver(john.cards + dealer.table.dealtCards, handEvaluator: evaluator, player: john)
            let jackBest = evaluateHoldemHandAtRiver(jack.cards + dealer.table.dealtCards, handEvaluator: evaluator, player: jack)

            var winner = ""
            if johnBest.0.rank < jackBest.0.rank {
                winner = john.name!
                println("\nWinner: \(winner) with \(johnBest.0.name.rawValue) (\(johnBest.1))\n")
                scores[winner]!++
            } else if johnBest.0.rank == jackBest.0.rank {
                winner = "SPLIT"
            } else {
                winner = jack.name!
                println("\nWinner: \(winner) with \(jackBest.0.name.rawValue) (\(jackBest.1))\n")
                scores[winner]!++
            }

            dealer.changeDeck()
        }

        for (k, v) in scores {
            println("\(k): \(v)")
        }

    }

    func evaluateHoldemHandAtRiver(sevenCards: [Card], handEvaluator: Evaluator, player: Player) -> (HandRank, [String]) {
        let cardsReps = sevenCards.map({ $0.description })

        let perms = cardsReps.permutation(5)

        //        println(perms)
        //        println(perms.count)

        let uniqs = Array(NSSet(array: perms.map({ ($0 as [String]).sorted(<) }))).map({ $0 as! [String] })

        //        println(uniqs)
        //        println(uniqs.count)

        var handsResult = [(HandRank, [String])]()

        for hand in uniqs {
            //            println(hand)
            let h = handEvaluator.evaluate(hand)
            //            println(h.name.rawValue)
            handsResult.append((h, hand))
        }

        handsResult.sort({ $0.0.rank < $1.0.rank })

        let bestHand = handsResult.first

//        let handName = " ".join(bestHand!.1)
//        println("\(player.name!):\t\(bestHand!.0.name.rawValue) => \(handName)")

        return bestHand!
    }









    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

