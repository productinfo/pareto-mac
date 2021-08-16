//
//  ScreensaverPassword.swift
//  Pareto Security
//
//  Created by Janez Troha on 19/07/2021.
//

class ScreensaverPasswordCheck: ParetoCheck {
    override var UUID: String {
        "37dee029-605b-4aab-96b9-5438e5aa44d8"
    }

    override var Title: String {
        "Password after sleep or screen saver"
    }

    override func checkPasses() -> Bool {
        let script = "tell application \"System Events\" to tell security preferences to get require password to wake"
        let out = runOSA(appleScript: script) ?? "false"
        return out.contains("true")
    }
}
