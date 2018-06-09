//  Created by ERIC DEJONCKHEERE on 27/06/2015.
//  Copyright (c) 2015 Eric Dejonckheere. All rights reserved.
//

import Cocoa

extension Bool {
    public init(_ value: Int) {
        self.init(value > 0)
    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window.title = "Poker Hands"
    }

    func applicationWillTerminate(_ aNotification: Notification) {

    }


}

