//
//  ActionBar.swift
//  launchctl_gui
//
//  Created by Reid Pritchard on 8/7/20.
//  Copyright © 2020 Reid Pritchard. All rights reserved.
//

import SwiftUI

struct ActionBar: View {
    let wrapper: Wrapper
    
    var body: some View {
            
        HStack {

            Button("Load PList"){
                let dialog = NSOpenPanel();
                    dialog.title                   = "Choose plist file";
                    dialog.showsResizeIndicator    = true;
                    dialog.showsHiddenFiles        = false;
                    dialog.allowsMultipleSelection = false;
                    dialog.canChooseDirectories = false;
                    dialog.allowedFileTypes = ["plist"]
                
                    dialog.begin { (result) -> Void in
                    if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                        let selectedPath = dialog.url!.path
                        print(selectedPath)
                        
                        self.wrapper.load_plist(filepath: selectedPath)
                    } else {
                        // User clicked on "Cancel"
                        return
                    }
                }
            }
                        
            Button("Parse PList") {
                let dialog = NSOpenPanel();
                    dialog.title                   = "Choose plist file";
                    dialog.showsResizeIndicator    = true;
                    dialog.showsHiddenFiles        = false;
                    dialog.allowsMultipleSelection = false;
                    dialog.canChooseDirectories = false;
                    dialog.allowedFileTypes = ["plist"]
                
                    dialog.begin { (result) -> Void in
                    if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                        let selectedPath = dialog.url!.path
                        print(selectedPath)

                        // TODO: Implement parser function
                    } else {
                        // User clicked on "Cancel"
                        return
                    }
                }
            }
        }
    }
}

struct ActionBar_Previews: PreviewProvider {
    static var previews: some View {
        ActionBar(wrapper: Wrapper())
    }
}
