//
//  plist_parser.swift
//  launchctl_gui
//
//  Created by Reid Pritchard on 3/25/21.
//  Copyright © 2021 Reid Pritchard. All rights reserved.
//

import Foundation

/// A class for parsing and generating plist files, specifically tailored for use with `launchctl`.
class PlistParser {
    /// The path to the plist file.
    var filepath: String?
    
    /// The contents of the plist file as a mutable dictionary.
    var plist: NSMutableDictionary?
    
    /// Initializes a new instance of `PlistParser`.
    init() {
        // No initialization required.
    }
    
    /// Loads a plist file from the given filename.
    ///
    /// - Parameter filename: The path to the plist file to load.
    /// - Throws: An error if the file cannot be loaded or parsed.
    func loadPlist(filename: String) throws {
        self.filepath = filename
        let url = URL(fileURLWithPath: filename)
        
        // Check if the file exists
        guard FileManager.default.fileExists(atPath: filename) else {
            throw NSError(domain: "PlistParser", code: 1, userInfo: [NSLocalizedDescriptionKey: "File does not exist at path: \(filename)"])
        }
        
        let data = try Data(contentsOf: url)
        var format = PropertyListSerialization.PropertyListFormat.xml // The format of the plist file
        
        // Deserialize the plist data
        guard let plist = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: &format) as? NSMutableDictionary else {
            throw NSError(domain: "PlistParser", code: 2, userInfo: [NSLocalizedDescriptionKey: "Unable to parse plist data"])
        }
        
        self.plist = plist
    }
    
    /// Retrieves the value associated with the specified key in the plist.
    ///
    /// - Parameter key: The key whose value to retrieve.
    /// - Returns: The value associated with `key` if it exists, otherwise `nil`.
    func getAttribute(forKey key: String) -> Any? {
        guard let plist = self.plist else {
            print("Plist not loaded.")
            return nil
        }
        return plist[key]
    }
    
    /// Sets the value for the specified key in the plist.
    ///
    /// - Parameters:
    ///   - value: The value to set.
    ///   - key: The key to associate the value with.
    func setAttribute(value: Any, forKey key: String) {
        if plist == nil {
            // Initialize the plist as a mutable dictionary if it's nil
            plist = NSMutableDictionary()
        }
        plist?[key] = value
    }
    
    /// Saves the plist to a file.
    ///
    /// - Parameter filename: The path to the plist file to save.
    /// - Throws: An error if the plist cannot be saved.
    func savePlist(filename: String) throws {
        guard let plist = self.plist else {
            throw NSError(domain: "PlistParser", code: 3, userInfo: [NSLocalizedDescriptionKey: "Plist not loaded or is empty."])
        }
        let url = URL(fileURLWithPath: filename)
        let data = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
        try data.write(to: url)
    }
    
    /// Prints the contents of the plist.
    func printPlist() {
        if let plist = self.plist {
            print(plist)
        } else {
            print("Plist is empty or not loaded.")
        }
    }
}
