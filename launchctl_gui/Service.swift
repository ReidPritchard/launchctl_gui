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
    
    init(given_string: String) {
        let data = given_string.split(separator: " ")
        
        self.status = String(data[0])
        self.pid = ""
        self.name = ""

        print("data", data)
    }
}
