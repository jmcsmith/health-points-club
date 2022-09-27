//
//  ContentView.swift
//  healthpoints-watch Extension
//
//  Created by Joseph Smith on 4/29/20.
//  Copyright © 2020 Joseph Smith. All rights reserved.
//

import SwiftUI
import RSSHealthKitHelper_Watch

struct ContentView: View {


    @AppStorage("today", store: UserDefaults(suiteName: "group.HealthPointsClub.test")) var total = 0
    @ObservedObject private var attributesLoader = AttributesLoader()
    
    init() {
        self.attributesLoader.load()
    }
    
    var body: some View {
        List {
            ForEach(attributesLoader.attributes ?? [] , id: \.type) { item  in
                HStack {
                    Text(item.type.rawValue)
                    Spacer()
                    Text(item.getPoints(withWeight: 1.0, withBodyMass: HealthDay.shared.bodyMass).description)
                        .background(Color(item.type.getBackgroundColor()))
                }
                .listRowBackground(Color(item.type.getBackgroundColor())
                .clipped()
                .cornerRadius(15))
                
            }
            
        }.onAppear {
            self.attributesLoader.load()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

