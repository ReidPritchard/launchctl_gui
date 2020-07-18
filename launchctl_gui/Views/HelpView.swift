//
//  HelpView.swift
//  launchctl_gui
//
//  Created by Reid Pritchard on 7/17/20.
//  Copyright © 2020 Reid Pritchard. All rights reserved.
//

import SwiftUI

struct HelpView: View {
    let help: String
    
    var body: some View {
        ScrollView {
            Text(self.help)
                .padding()
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView(help: "This is the help string bby")
    }
}
