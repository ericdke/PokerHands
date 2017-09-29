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
            let p1c1RankTitle = p1c1Rank.titleOfSelectedItem,
            let p1c2SuitTitle = p1c2Suit.titleOfSelectedItem,
            let p1c2RankTitle = p1c2Rank.titleOfSelectedItem,
            let p2c1SuitTitle = p2c1Suit.titleOfSelectedItem,
            let p2c1RankTitle = p2c1Rank.titleOfSelectedItem,
            let p2c2SuitTitle = p2c2Suit.titleOfSelectedItem,
            let p2c2RankTitle = p2c2Rank.titleOfSelectedItem else {
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
        settings.player1Random = p1Random.state == .on
        settings.player2Random = p2Random.state == .on
        self.orderOut(nil)
    }
    
    @IBAction func p1RandomButton(_ sender: NSButton) {
        let boo = sender.state == .off
        p1c1Suit.isEnabled = boo
        p1c1Rank.isEnabled = boo
        p1c2Suit.isEnabled = boo
        p1c2Rank.isEnabled = boo
    }
    
    @IBAction func p2RandomButton(_ sender: NSButton) {
        let boo = sender.state == .off
        p2c1Suit.isEnabled = boo
        p2c1Rank.isEnabled = boo
        p2c2Suit.isEnabled = boo
        p2c2Rank.isEnabled = boo
    }
    
}



