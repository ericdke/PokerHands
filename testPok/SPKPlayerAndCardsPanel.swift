//
//  SPKPlayerAndCardsPanel.swift
//  SwiftyPokerHands
//
//  Created by ERIC DEJONCKHEERE on 11/07/2015.
//  Copyright © 2015 Eric Dejonckheere. All rights reserved.
//

import Cocoa

class SPKPlayerAndCardsPanel: NSPanel {

    @IBOutlet weak var p1c1Suit: NSPopUpButton!
    @IBOutlet weak var p1c1Rank: NSPopUpButton!
    @IBOutlet weak var p1c2Suit: NSPopUpButton!
    @IBOutlet weak var p1c2Rank: NSPopUpButton!
    @IBOutlet weak var p1Random: NSButton!
    @IBOutlet weak var p2c1Suit: NSPopUpButton!
    @IBOutlet weak var p2c1Rank: NSPopUpButton!
    @IBOutlet weak var p2c2Suit: NSPopUpButton!
    @IBOutlet weak var p2c2Rank: NSPopUpButton!
    @IBOutlet weak var p2Random: NSButton!
    
    let settings = SPKSettings.sharedInstance
    
    @IBAction func buttonOK(sender: NSButton) {
        settings.player1Card1Suit = p1c1Suit.titleOfSelectedItem!
        settings.player1Card1Rank = p1c1Rank.titleOfSelectedItem!
        settings.player1Card2Suit = p1c2Suit.titleOfSelectedItem!
        settings.player1Card2Rank = p1c2Rank.titleOfSelectedItem!
        settings.player2Card1Suit = p2c1Suit.titleOfSelectedItem!
        settings.player2Card1Rank = p2c1Rank.titleOfSelectedItem!
        settings.player2Card2Suit = p2c2Suit.titleOfSelectedItem!
        settings.player2Card2Rank = p2c2Rank.titleOfSelectedItem!
        settings.player1Random = Bool(p1Random.state)
        settings.player2Random = Bool(p2Random.state)
        NSNotificationCenter.defaultCenter().postNotificationName("playerAndCardsPanelButtonOK", object: nil)
    }
    
}
