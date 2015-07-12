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
    
    @IBAction func buttonCLOSE(sender: NSButton) {
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
        NSNotificationCenter.defaultCenter().postNotificationName("playerAndCardsPanelButtonCLOSE", object: nil)
    }
    
    @IBAction func p1RandomButton(sender: NSButton) {
        if sender.state == NSOnState {
            p1c1Suit.enabled = false
            p1c1Rank.enabled = false
            p1c2Suit.enabled = false
            p1c2Rank.enabled = false
        } else {
            p1c1Suit.enabled = true
            p1c1Rank.enabled = true
            p1c2Suit.enabled = true
            p1c2Rank.enabled = true
        }
    }
    
    @IBAction func p2RandomButton(sender: NSButton) {
        if sender.state == NSOnState {
            p2c1Suit.enabled = false
            p2c1Rank.enabled = false
            p2c2Suit.enabled = false
            p2c2Rank.enabled = false
        } else {
            p2c1Suit.enabled = true
            p2c1Rank.enabled = true
            p2c2Suit.enabled = true
            p2c2Rank.enabled = true
        }
    }
    
}
