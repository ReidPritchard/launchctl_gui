//
//  plist_parser.swift
//  launchctl_gui
//
//  Created by Reid Pritchard on 3/25/21.
//  Copyright © 2021 Reid Pritchard. All rights reserved.
//

import Foundation

class pListParser {
    var filepath: String!;
    var plist: [[String : String]]!; // Is there a better way to init this? it seems so ugly but idk
    // This class will mainly focus on parsing already written plist files. Hopefully I can find some good docs on
    // the rules of plists for launchctl. So in theory this woudl "debug" your plist file.
    
    // I also want to create a pList generator as well. I would expect these two class would work closely together
    // or be part of one.
    
    
    
    init() {
        // Unsure if there is much we really need to do here
    }

    func load_plist(filename: String) {
        // FIXME: This doesn't work!! I need to create another struct or class and then use PropertyListDecoder()
        // This solution will also have a nice side effect of kinda "checking" your plist for the right variable names
        // but yea fix this (todo)
        
        guard let path = Bundle.main.path(forResource: filepath, ofType: "plist") else {return}
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        guard let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [[String:String]] else {return}
        
        self.plist = plist;
    }
    
    func get_attribute(key: String) -> String {
//        let i = self.plist.firstIndex( key );
//        return self.plist[i][key];
        return "";
    }
    
    func printPlist() {
        print(self.plist);
    }
}
