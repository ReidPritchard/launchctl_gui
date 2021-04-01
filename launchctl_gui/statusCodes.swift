//
//  statusCodes.swift
//  launchctl_gui
//
//  Created by Reid Pritchard on 7/18/20.
//  Copyright © 2020 Reid Pritchard. All rights reserved.
//

import Foundation

class statusCodes {
    let code: String
    let int_code: Int?
    var description: String = ""
    
    init(code: String) {
        self.code = code
        self.int_code = Int(code)
    }
    
    
    func getDescription() -> String {
        if self.int_code == nil {
            return "No Exit Code"
        }
        
        if self.description != "" {
            return self.description
        }
        
        // TODO: Figure out what all the codes mean
        if int_code == 0 {
            self.description = "Returned with 0!! YAY"
        } else if int_code == 78 {
            self.description = "Function not implemented"
        } else if int_code! < 0 {
            self.description = "Returned with negative code"
        }else if int_code! > 0 {
            self.description = "Returned with positive non-zero code"
        }
        
        return self.description
    }
}
