//
//  Service.swift
//  launchctl_gui
//
//  Created by Reid Pritchard on 7/15/20.
//  Copyright © 2020 Reid Pritchard. All rights reserved.
//

import Foundation


class Service : NSObject, Identifiable {
    let id = UUID()
    
    var status: String
    var pid: String
    let name: String
    let status_description: String

    var additional_properties: [String: [[String: String]]] = [:]
//    var active_count: Int?
//    var copy_count: Int?
//    var one_shot: Int?
//    var plist_path: String = ""
//    var state: String = ""
//
//    var program: String = ""
//    var arguments: [String] = []
//
//    var stdout_path: String = ""
//    var stderr_path: String = ""
//    // Honeslty not sure what this one means, might change
//    // type later
//    var inherited_enviroment: [String] = []
//    var default_enviroment: [String] = []
//    var enviroment: [String] = []
//
//    var domain: String = ""
//    var asid: Int?
//    var minimum_runtime: Int?
//    var exit_timeout: Int?
//    var runs: Int?
//    var successive_crashes: Int?
//    var last_exit_code // status represnets this :)
    
    var event_triggers: [String: String] = [:]

    convenience override init() {
        // No inputs
        self.init(given_string: [])
    }
    
    init(given_string: [String]) {
        if given_string.count == 0 {
            self.pid = "-999"
            self.status = "-999"
            self.name = ""
            
            self.status_description = ""
        } else {
            self.pid = String(given_string[0].trimmingCharacters(in: .whitespacesAndNewlines))
            self.status = String(given_string[1].trimmingCharacters(in: .whitespacesAndNewlines))
            self.name = String(given_string[2].trimmingCharacters(in: .whitespacesAndNewlines))
            
            self.status_description = statusCodes(code: self.status).getDescription()
        }
    }
    
    func get_attribute(names: [String]) -> String {
        
        for name in names {
            return name;
        }
        
        return "";
    }

    func update_dump(data: [String: [[String: String]]]) {
        additional_properties = data
    }
}
