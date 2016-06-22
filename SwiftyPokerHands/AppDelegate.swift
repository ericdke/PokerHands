//  Created by ERIC DEJONCKHEERE on 27/06/2015.
//  Copyright (c) 2015 Eric Dejonckheere. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window.title = "Swifty Poker Hands"
        window.backgroundColor = NSColor.white()
    }

    func applicationWillTerminate(_ aNotification: Notification) {

    }


}

