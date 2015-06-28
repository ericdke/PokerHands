//
//  SPKHandTableCellView.swift
//  testPok
//
//  Created by ERIC DEJONCKHEERE on 27/06/2015.
//  Copyright (c) 2015 Eric Dejonckheere. All rights reserved.
//

import Cocoa

class SPKHandTableCellView: NSTableCellView {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }

    @IBOutlet weak var label1: NSTextField!
    @IBOutlet weak var label2: NSTextField!
    @IBOutlet weak var label3: NSTextField!

}
