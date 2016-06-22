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
    
    @IBAction func buttonCLOSE(_ sender: NSButton) {
        guard let p1c1SuitTitle = p1c1Suit.titleOfSelectedItem,
            p1c1RankTitle = p1c1Rank.titleOfSelectedItem,
            p1c2SuitTitle = p1c2Suit.titleOfSelectedItem,
            p1c2RankTitle = p1c2Rank.titleOfSelectedItem,
            p2c1SuitTitle = p2c1Suit.titleOfSelectedItem,
            p2c1RankTitle = p2c1Rank.titleOfSelectedItem,
            p2c2SuitTitle = p2c2Suit.titleOfSelectedItem,
            p2c2RankTitle = p2c2Rank.titleOfSelectedItem else {
                return
        }
        
        settings.player1Card1Suit = p1c1SuitTitle
        settings.player1Card1Rank = p1c1RankTitle
        settings.player1Card2Suit = p1c2SuitTitle
        settings.player1Card2Rank = p1c2RankTitle
        settings.player2Card1Suit = p2c1SuitTitle
        settings.player2Card1Rank = p2c1RankTitle
        settings.player2Card2Suit = p2c2SuitTitle
        settings.player2Card2Rank = p2c2RankTitle
        settings.player1Random = Bool(p1Random.state)
        settings.player2Random = Bool(p2Random.state)
        self.orderOut(nil)
    }
    
    @IBAction func p1RandomButton(_ sender: NSButton) {
        let boo = !Bool(sender.state)
        p1c1Suit.isEnabled = boo
        p1c1Rank.isEnabled = boo
        p1c2Suit.isEnabled = boo
        p1c2Rank.isEnabled = boo
    }
    
    @IBAction func p2RandomButton(_ sender: NSButton) {
        let boo = !Bool(sender.state)
        p2c1Suit.isEnabled = boo
        p2c1Rank.isEnabled = boo
        p2c2Suit.isEnabled = boo
        p2c2Rank.isEnabled = boo
    }
    
}
