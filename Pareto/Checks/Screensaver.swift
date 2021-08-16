//
//  Screensaver.swift
//  Pareto Security
//
//  Created by Janez Troha on 19/07/2021.
//

import Foundation
import os.log

class ScreensaverCheck: ParetoCheck {
    final var ID = "13e4dbf1-f87f-4bd9-8a82-f62044f002f4"
    final var TITLE = "Screen saver shows in under 5 minutes"

    required init(id _: String! = "", title _: String! = "") {
        super.init(id: ID, title: TITLE)
    }

    override func checkPasses() -> Bool {
        let script = "tell application \"System Events\" to tell screen saver preferences to get delay interval"
        let out = runOSA(appleScript: script) ?? "0"
        return Int(out) ?? 0 <= 300
    }
}
