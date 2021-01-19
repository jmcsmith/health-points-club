//
//  PointsTotal.swift
//  PointsTotal
//
//  Created by Joseph Smith on 10/1/20.
//  Copyright © 2020 Joseph Smith. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {

    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        print(configuration.attribute)
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        
            let entryDate = Calendar.current.date(byAdding: .minute, value: 10, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct PointsTotalEntryView : View {
    var entry: Provider.Entry
    @AppStorage("today", store: UserDefaults(suiteName: "group.HealthPointsClub"))
    var weekly: Int = 0
    var backgroundColor: Color {
        get {
            if entry.configuration.defaultBackground == 1 {
                return Color(UIColor.systemBackground)
            }
            
            switch entry.configuration.attribute?.identifier {
            case "0":               
                return Color(UIColor(red:0.91, green:0.36, blue:0.28, alpha:1.00))
            case "1":
                return Color(UIColor(red:0.91, green:0.36, blue:0.28, alpha:1.00))
            case "2":
                return Color(UIColor(red:0.38, green:0.75, blue:0.98, alpha:1.00))
            case "3":
                return Color(UIColor(red:0.49, green:0.36, blue:0.92, alpha:1.00))
            case "4":
                return Color(UIColor(red:0.33, green:0.73, blue:0.82, alpha:1.00))
            case "5":
                return Color(UIColor(red:0.38, green:0.87, blue:0.84, alpha:1.00))
            case "6":
                return Color(UIColor(red:0.66, green:0.95, blue:0.29, alpha:1.00))
            case "7":
                return Color(UIColor(red:0.89, green:0.24, blue:0.37, alpha:1.00))
            case "8":
                return Color(UIColor.lightGray)
            case "9":
                return Color(UIColor(red:0.32, green:0.71, blue:0.30, alpha:1.00))
            case "10":
                return Color(UIColor.systemBackground)
            default:
               return Color(UIColor.systemBackground)
            }
        }
    }
    var body: some View {
        ZStack {
            Image("heart")
                .resizable().aspectRatio(contentMode: .fit)
            Text("\(weekly)")
                .font(.system(size: 50))
                .foregroundColor(.white)
                .offset(y: -5)
        }
        .background(backgroundColor)
    }
}

@main
struct PointsTotal: Widget {
    let kind: String = "PointsTotal"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            PointsTotalEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Today's Health Points")
        .description("Shows Health Points earned today. Edit to pick an Attribute")
    }
}

struct PointsTotal_Previews: PreviewProvider {
    static var previews: some View {
        PointsTotalEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
