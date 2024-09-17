//
//  ServiceAdditionalDetails.swift
//  launchctl_gui
//
//  Created by Reid Pritchard on 11/23/22.
//  Copyright © 2022 Reid Pritchard. All rights reserved.
//

import SwiftUI

struct ServiceAdditionalDetails: View {
    @State var additional_props: [String : [[String : String]]]
    
    init(additional_props: [String : [[String : String]]]?) {
        self.additional_props = additional_props ?? [:]
    }
    
    func buildNestedItems(key: String) -> some View {
        let nested_data = self.additional_props[key] ?? []
        
        return VStack(alignment: .leading) {
                ForEach(nested_data, id: \.self) {
                    sub_dict in
                    HStack {
                        Text("\(Array(sub_dict.keys)[0]): ")
                            .font(.subheadline)
                            .bold()

                        Text("\(sub_dict[Array(sub_dict.keys)[0]]!)").lineLimit(2)
                    }
                }
            }
            .padding(.leading, 45)
    }
    
    var detailedInfo: some View {
        List {
            ForEach(self.additional_props.keys.sorted(), id: \.self) { key in
                Group{
                    Text("\(key): ")
                        .font(.headline)
                        .bold()
                    
                    buildNestedItems(key: key)

                }
            }
        }.padding()
    }
    
    var body: some View {
        self.detailedInfo
    }
}

struct ServiceAdditionalDetails_Previews: PreviewProvider {
    static var previews: some View {
        ServiceAdditionalDetails(additional_props: Service(given_string: ["0", "10", "A neat name :)"]).additional_properties)
    }
}
