//
//  wrapper.swift
//  launchctl_gui
//
//  Created by Reid Pritchard on 7/14/20.
//  Copyright © 2020 Reid Pritchard. All rights reserved.
//

import Foundation

class Wrapper {
    var help:String!
    
    init() {
        self.setup_help()
    }
    
    func shell(cmd : String, args : String...) -> (output: [String], error: [String], exitCode: Int32) {
        var output : [String] = []
        var error : [String] = []

        let task = Process()
        task.executableURL = URL(fileURLWithPath: cmd)
        print(task.executableURL ?? "")
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
        
        task.waitUntilExit()

        let outdata = outpipe.fileHandleForReading.readDataToEndOfFile()
        if var string = String(data: outdata, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            output = string.components(separatedBy: "\n")
        }

        let errdata = errpipe.fileHandleForReading.readDataToEndOfFile()
        if var string = String(data: errdata, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            error = string.components(separatedBy: "\n")
        }

        let status = task.terminationStatus

        return (output, error, status)
    }
    
    func setup_help() {
        let result = self.shell(cmd: "/bin/launchctl", args: "help")
        
        if (result.exitCode != 0) {
            print("ERROR: ", result.exitCode, result.error.joined(separator: " "))
        }
        self.help = result.output.joined(separator: "\n")
    }
    
    func get_help() -> String {
        return self.help
    }
    
    func get_list() -> [String] {
        let result = self
            .shell(cmd: "/bin/launchctl", args: "list")
        
        if (result.exitCode != 0) {
            print("ERROR: ", result.exitCode, result.error.joined(separator: " "))
        }
        print("res", result.output.joined(separator: " "))
        return result.output
    }

}
