//
//  wrapper.swift
//  launchctl_gui
//
//  Created by Reid Pritchard on 7/14/20.
//  Copyright © 2020 Reid Pritchard. All rights reserved.
//

import Foundation


extension String {
    func matchingStrings(regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map {
                result.range(at: $0).location != NSNotFound
                        ? nsString.substring(with: result.range(at: $0))
                        : ""
            }
        }
    }
}

class Wrapper {
    var manager_id: String!
    var help:String!
    var parser: pListParser!
    
    init() {
        self.setup_manager_id()
        self.setup_help()
        self.parser = pListParser()
    }
    
    func shell(cmd : String, args : String...) -> (output: [String], error: [String], exitCode: Int32) {
        var output : [String] = []
        var error : [String] = []

        let task = Process()
        task.executableURL = URL(fileURLWithPath: cmd)
//        print(task.executableURL ?? "")
        task.arguments = args
        print(task.arguments ?? "")

        let outpipe = Pipe()
        task.standardOutput = outpipe
        let errpipe = Pipe()
        task.standardError = errpipe

        do {
            try task.run()
        } catch {
            print("ERROR running task")
        }

        let outdata = outpipe.fileHandleForReading.readDataToEndOfFile()
//        print(outpipe.fileHandleForReading, outdata)
        if var string = String(data: outdata, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            output = string.components(separatedBy: "\n")
        }

        let errdata = errpipe.fileHandleForReading.readDataToEndOfFile()
//        print(errpipe.fileHandleForReading, errdata)
        if var string = String(data: errdata, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            error = string.components(separatedBy: "\n")
        }
        
//        task.waitUntilExit()

        let status = task.terminationStatus

        return (output, error, status)
    }
    
    func refresh_service(service: Service) {
        let result = self.shell(cmd: "/bin/launchctl", args: "print", "gui/"+manager_id+"/"+service.name)
        
        if result.exitCode != 0 {
            print("ERROR: ", result.exitCode, result.error)
        }
        
        var data: [String: [[String: String]]] = [:]

        data = parse_launchctl_print(output: Array(result.output))

        if data.count > 0 {
            service.update_dump(data: data)
        }
    }
    
    func kickstart_service(service: Service) -> Bool {
        let result = self.shell(cmd: "/bin/launchctl", args: "kickstart", "gui/"+manager_id+"/"+service.name)
        
        if (result.exitCode != 0) {
            print("ERROR: ", result.exitCode, result.error)
            return false
        }
        return true
    }
    
    func setup_help() {
        let result = self.shell(cmd: "/bin/launchctl", args: "help")
        
        if (result.exitCode != 0) {
            print("ERROR: ", result.exitCode, result.error)
        }
        self.help = result.output.joined(separator: "\n")
    }
    
    func setup_manager_id() {
        self.manager_id = self.shell(cmd: "/bin/launchctl", args: "manageruid").output.joined(separator: " ")
    }
    
    func get_help() -> String {
        return self.help
    }
    
    func get_user_list() -> [Service] {
        let new_res = self.shell(cmd: "/bin/launchctl", args: "print", "gui/"+self.manager_id)
        var all_services: [Service] = []
        
        if (new_res.exitCode != 0) {
            print("Aw man this isn't good...", new_res.error.joined(separator: " "))
        } else {
            for item in new_res.output {
                let range = item.range(of: "^\\s*(\\d*)\\s*(\\S*)\\s*(\\S*)$", options: .regularExpression)

                if range != nil {
                    let possible_service = item[range!]
                                .trimmingCharacters(in: .whitespacesAndNewlines)
                                .split(separator: " ")
                                .map { String($0) }
                
                    if (possible_service.count == 3) {
                        all_services.append(Service(given_string: possible_service))
                    }
                }
            }
        }
        
        return all_services.sorted(by: {  $0.name > $1.name  })
    }
    
    func load_plist(filepath: String) -> Void {
        let load_cmd = self.shell(cmd: "/bin/launchctl", args: "load", filepath)
        
        if load_cmd.exitCode != 0 {
            print("Aw man this isn't good...", load_cmd.error.joined(separator: " "))
        } else {
            print("I think it worked?")
            for item in load_cmd.output {
                print(item)
            }
        }
    }
    
    func unload_plist(filepath: String) -> Void {
        let unload_cmd = self.shell(cmd: "bin/launchctl", args: "unload", filepath)
        
        if unload_cmd.exitCode != 0 {
            print("Aw man this isn't good...", unload_cmd.error.joined(separator: " "))
        } else {
            print("I think it worked?")
            for item in unload_cmd.output {
                print(item)
            }
        }
    }
    
    func parse_plist(filepath: String) -> Void {
        self.parser.load_plist(filename: filepath);
        self.parser.printPlist();
    }
    
}



func parse_launchctl_print(output: [String]) -> [String: [[String: String]]] {
    
    // This is also such a gross way to do this. I will want to update this at some point
    var parsedValues: [String: [[String: String]]] = [:]
    var currKeyStack: [String] = []
    
    for line in output {
        let trimmedline = line.trimmingCharacters(in: .whitespacesAndNewlines)
//        print(trimmedline)

        // FIXME: Really need to work on this regex, we are not getting the values we actually need example (last exit code)
        // We may want to hardcode them. I'm not really sure what other wrappers do
        var regex_result = trimmedline.matchingStrings(regex: #"^\s{0,}(\S.{1,}) =(?:\s|> )(\{|\S{1,}|.){1,}$"#).first

        if regex_result != nil {
            regex_result = regex_result?.dropFirst()
                    .map { String($0) }

            
            // Check if new category is opening
            let l_string: String = regex_result?.last ?? ""
            if l_string.contains("{") {
//                print("New category!", (regex_result?.first)!)
                
                // Simply push to stack then use like normal
                currKeyStack.append((regex_result?.first)!)

            // Check if old category is closing
            } else if trimmedline.contains("}") {
//                print("REMOVING THIS KEY", currKeyStack.last ?? "")
                currKeyStack.removeLast()
            } else {
                // All values (NOT '{')
                add_to_dictionary(dict: &parsedValues, parentKey: currKeyStack.last ?? (regex_result?.first)!, childKey: (regex_result?.first)!, val: (regex_result?.last)!)
            }
        } else {
            // If our regex fails! (fallback)
            
            if trimmedline != "" {
                
                // Check if new category is opening
                if trimmedline.contains("{") {
//                    print("New category!", (regex_result?.first)!)
                    currKeyStack.append((regex_result?.first)!)

                // Check if end of group
                } else if trimmedline.contains("}") {
//                    print("REMOVING THIS KEY", currKeyStack.last ?? "")
                    currKeyStack.removeLast()
                } else {
                    add_to_dictionary(dict: &parsedValues, parentKey: (currKeyStack.last)!, childKey: (currKeyStack.first)!, val: trimmedline)
                }
                
            }
        }
    }
    
    return parsedValues
}

func add_to_dictionary(dict: inout [String : [[String : String]]], parentKey: String, childKey: String, val: String){
    var existingItems = dict[parentKey] ?? [[String: String]]()
    // Append to existing
    existingItems.append([childKey: val])
    // Update value at current category
    dict[parentKey] = existingItems
}
