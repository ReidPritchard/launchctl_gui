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
        Button("Load PList"){
            let dialog = NSOpenPanel();

            dialog.title                   = "Choose plist file";
            dialog.showsResizeIndicator    = true;
            dialog.showsHiddenFiles        = false;
            dialog.allowsMultipleSelection = false;
            dialog.canChooseDirectories = false;
            dialog.allowedFileTypes = ["plist"]

            if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
                let result = dialog.url // Pathname of the file

                if (result != nil) {
                    let path: String = result!.path
                    self.wrapper.load_plist(filepath: path)
                }
                
            } else {
                // User clicked on "Cancel"
                return
            }
        }
    }
}

struct ActionBar_Previews: PreviewProvider {
    static var previews: some View {
        ActionBar(wrapper: Wrapper())
    }
}
