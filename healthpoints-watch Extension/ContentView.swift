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
    @State var attributes = HealthDay.shared.attributes
    var body: some View {
        List {
            ForEach(attributes, id: \.type) { item  in
                HStack {
                    Text(item.type.rawValue)
                    Spacer()
                    Text(item.getPoints(withWeight: 1.0, withBodyMass: HealthDay.shared.bodyMass).description)
                }
            }
        }.onAppear {
            let hkHelper = HealthKitHelper()
            hkHelper.loadHealthDay()
            self.attributes = HealthDay.shared.attributes
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

