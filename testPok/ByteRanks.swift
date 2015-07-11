//  Created by Ivan Sanchez on 06/10/2014.
//  Copyright (c) 2014 Gourame Limited. All rights reserved.
//
//  Modified for SwiftyPokerHands to take values from JSON files instead of huge array literals.

import Foundation

final class ByteRanks {
    let flushes: [Int]
    let uniqueToRanks:[Int]
    let primeProductToCombination:[Int]
    let combinationToRank:[Int]
    init() {
        do {
            let path = NSBundle.mainBundle().pathForResource("flushes_bytes", ofType: "json")
            let d = NSData(contentsOfFile: path!)
            let j = try NSJSONSerialization.JSONObjectWithData(d!, options: []) as! [Int]
            self.flushes = j
        } catch {
            print(error)
            self.flushes = []
        }
        do {
            let path = NSBundle.mainBundle().pathForResource("uniqueToRanks_bytes", ofType: "json")
            let d = NSData(contentsOfFile: path!)
            let j = try NSJSONSerialization.JSONObjectWithData(d!, options: []) as! [Int]
            self.uniqueToRanks = j
        } catch {
            print(error)
            self.uniqueToRanks = []
        }
        do {
            let path = NSBundle.mainBundle().pathForResource("primeProductToCombination_bytes", ofType: "json")
            let d = NSData(contentsOfFile: path!)
            let j = try NSJSONSerialization.JSONObjectWithData(d!, options: []) as! [Int]
            self.primeProductToCombination = j
        } catch {
            print(error)
            self.primeProductToCombination = []
        }
        do {
            let path = NSBundle.mainBundle().pathForResource("combinationToRank_bytes", ofType: "json")
            let d = NSData(contentsOfFile: path!)
            let j = try NSJSONSerialization.JSONObjectWithData(d!, options: []) as! [Int]
            self.combinationToRank = j
        } catch {
            print(error)
            self.combinationToRank = []
        }
    }
}