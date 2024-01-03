//
//  NoUnusedUsers.swift
//  Pareto Security
//
//  Created by Janez Troha on 15/07/2021.
//

import Foundation

class NoUnusedUsers: ParetoCheck {
    static let sharedInstance = NoUnusedUsers()
    override var UUID: String {
        "018cca4b-bedc-7794-a45d-118b60424017"
    }

    override var TitleON: String {
        "No unrequired user accounts are present"
    }

    override var TitleOFF: String {
        "Unrequired user accounts are present(" + accounts.joined(separator: ",") + ")"
    }

    var accounts: [String] {
        let output = runCMD(app: "/usr/bin/dscl", args: [".", "-list", "/Users"]).components(separatedBy: "\n")
        let local = output.filter { u in
            !u.hasPrefix("_") && u.count > 1 && u != "root" && u != "nobody" && u != "daemon"
        }
        return local
    }

    func lastLoginRecent(user: String) -> Bool {
        let output = runCMD(app: "/usr/bin/last", args: ["-w", "-y", user]).components(separatedBy: "\n")
        let log = output.filter { u in
            u.contains(user)
        }

        let entry = log.first?.components(separatedBy: "   ").filter { i in
            i.count > 1
        }
        if (log.first?.contains("still logged in")) != nil {
            return true
        }
        // parse string to date
        if entry?.count ?? 0 > 1 {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Use a POSIX locale
            dateFormatter.dateFormat = "EEE MMM d yyyy HH:mm"

            if let date = dateFormatter.date(from: entry![2]) {
                let currentDate = Date()
                let calendar = Calendar.current

                let components = calendar.dateComponents([.month], from: date, to: currentDate)

                if let monthDifference = components.month, monthDifference <= 1 {
                    return true
                } else {
                    return false
                }
            }
        }

        return false
    }

    override func checkPasses() -> Bool {
        return accounts.allSatisfy { u in
            lastLoginRecent(user: u)
        }
    }
}
