//
//  Service.swift
//  launchctl_gui
//
//  Created by Reid Pritchard on 7/15/20.
//  Copyright © 2020 Reid Pritchard. All rights reserved.
//

import Foundation


class Service:Identifiable {
    var id = UUID()
    var status: String
    var pid: String
    var name: String
    
    init(given_string: [String]) {
        self.pid = String(given_string[0].trimmingCharacters(in: .whitespacesAndNewlines))
        self.status = String(given_string[1].trimmingCharacters(in: .whitespacesAndNewlines))
        self.name = String(given_string[2].trimmingCharacters(in: .whitespacesAndNewlines))
    }
}
