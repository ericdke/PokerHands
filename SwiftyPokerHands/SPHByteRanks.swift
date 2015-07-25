//  Created by Ivan Sanchez on 06/10/2014.
//  Copyright (c) 2014 Gourame Limited. All rights reserved.
//
//  Modified for SwiftyPokerHands to take values from JSON files instead of huge array literals.

import Foundation

final class ByteRanks {
    
    enum SPHError: String, ErrorType {
        case CouldNotFindJSONFile = "FATAL ERROR: Could not find init files in app bundle"
        case CouldNotLoadJSONFile = "FATAL ERROR: Could not load init files from app bundle"
        case CouldNotConvertJSONFile = "FATAL ERROR: Could not read init files from app bundle"
    }
    
    static let sharedInstance = ByteRanks()
    
    let flushes: [Int]
    let uniqueToRanks: [Int]
    let primeProductToCombination: [Int]
    let combinationToRank: [Int]
    
    init() {
        do {
            let bundle = NSBundle.mainBundle()
            guard let fpath = bundle.pathForResource("flushes_bytes", ofType: "json"), let upath = bundle.pathForResource("uniqueToRanks_bytes", ofType: "json"), let ppath = bundle.pathForResource("primeProductToCombination_bytes", ofType: "json"), let cpath = bundle.pathForResource("combinationToRank_bytes", ofType: "json") else {
                throw SPHError.CouldNotFindJSONFile
            }
            guard let fdata = NSData(contentsOfFile: fpath), let udata = NSData(contentsOfFile: upath), let pdata = NSData(contentsOfFile: ppath), let cdata = NSData(contentsOfFile: cpath) else {
                throw SPHError.CouldNotLoadJSONFile
            }
            guard let ujson = try NSJSONSerialization.JSONObjectWithData(udata, options: []) as? [Int], let fjson = try NSJSONSerialization.JSONObjectWithData(fdata, options: []) as? [Int], let pjson = try NSJSONSerialization.JSONObjectWithData(pdata, options: []) as? [Int], let cjson = try NSJSONSerialization.JSONObjectWithData(cdata, options: []) as? [Int] else {
                throw SPHError.CouldNotConvertJSONFile
            }
            self.flushes = fjson
            self.uniqueToRanks = ujson
            self.primeProductToCombination = pjson
            self.combinationToRank = cjson
        } catch let error as SPHError {
            print(error.rawValue)
            fatalError()
        } catch {
            print(error)
            fatalError()
        }
    }
    
    
}