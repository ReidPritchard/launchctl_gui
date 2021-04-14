//
//  PulldownList.swift
//  launchctl_gui
//
//  Created by Reid Pritchard on 4/1/21.
//  Copyright © 2021 Reid Pritchard. All rights reserved.
//

import SwiftUI

struct PulldownList: View {
    let coordinateSpace: CoordinateSpace = .named("Pulldown List")
    var onRefresh: ()->Void
    @State var refresh: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            if (geo.frame(in: coordinateSpace).midY > 50) {
                Spacer()
                    .onAppear {
                        if refresh == false {
                            onRefresh() // call refresh once if pulled more than 50px
                        }
                        refresh = true
                    }
            } else if (geo.frame(in: coordinateSpace).maxY < 1) {
                Spacer()
                    .onAppear {
                        refresh = false
                        // reset  refresh if view shrink back
                    }
            }
            ScrollView {
                if refresh { ///show loading if refresh called
                    if #available(OSX 11.0, *) {
                        ProgressView()
                    } else {
                        // Fallback on earlier versions
                        // TODO: Implement fallback for ProgressView
                    }
                } else {
                    // mimic static progress bar with filled bar to the drag percentage
                    ForEach(0..<8) { tick in
                          VStack {
                              Rectangle()
                                .opacity((Int((geo.frame(in: coordinateSpace).midY)/7) < tick) ? 0 : 1)
                                  .frame(width: 3, height: 7)
                                .cornerRadius(3)
                              Spacer()
                      }.rotationEffect(Angle.degrees(Double(tick)/(8) * 360))
                   }.frame(width: 20, height: 20, alignment: .center)
                }
            }.frame(width: geo.size.width)
        }.padding(.top, -60)
    }
}

struct PullToRefreshDemo: View {
    var body: some View {
        ScrollView {
            PulldownList() {
                //refresh view here
                print("refreshing")
            }
            ForEach (0..<20, content: { item in
                Text("Some view...")
            })
        }
    }
}

struct PulldownList_Previews: PreviewProvider {
    static var previews: some View {
        PullToRefreshDemo()
    }
}
