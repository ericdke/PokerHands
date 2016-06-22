import Cocoa

final class SPKHandTableCellView: NSTableCellView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }

    @IBOutlet weak var label1: NSTextField!
    @IBOutlet weak var label2: NSTextField!
    @IBOutlet weak var label3: NSTextField!
    
    @IBOutlet weak var card1Player1: NSImageView!
    @IBOutlet weak var card2Player1: NSImageView!
    @IBOutlet weak var card1Player2: NSImageView!
    @IBOutlet weak var card2Player2: NSImageView!
    @IBOutlet weak var card1Flop: NSImageView!
    @IBOutlet weak var card2Flop: NSImageView!
    @IBOutlet weak var card3Flop: NSImageView!
    @IBOutlet weak var card4Turn: NSImageView!
    @IBOutlet weak var card5River: NSImageView!

}
