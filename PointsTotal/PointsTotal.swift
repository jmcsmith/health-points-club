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
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        print("Timeline")
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
    @Environment(\.widgetFamily) var family
    @AppStorage("today", store: UserDefaults(suiteName: "group.club.healthpoints.test")) var today: Int = 0
    @AppStorage("weekTotal", store: UserDefaults(suiteName: "group.club.healthpoints.test")) var week: Int = 0
    @AppStorage("allTimeHigh", store: UserDefaults(suiteName: "group.club.healthpoints.test")) var high: Int = 0
    @AppStorage("lifetimeTotal", store: UserDefaults(suiteName: "group.club.healthpoints.test")) var life: Int = 0
    @AppStorage("widgetValues", store: UserDefaults(suiteName: "group.club.healthpoints.test")) var data: Data = Data()
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
    @ViewBuilder
    var body: some View {
        
        switch family {
        case .accessoryCircular:
            ZStack {
                Image("heart")
                    .resizable().aspectRatio(contentMode: .fit)
                Text("\(getPointValue(attribute: entry.configuration.attribute))")
                    .font(.system(size: 30))
                    .bold()
                    .foregroundColor(.white)
                    .offset(y: -5)
            }
        case .systemSmall:
            ZStack {
                Image("heart")
                    .resizable().aspectRatio(contentMode: .fit)
                Text("\(getPointValue(attribute: entry.configuration.attribute))")
                    .font(.system(size: 50))
                    .bold()
                    .foregroundColor(.white)
                    .offset(y: -5)
            }
            .background(backgroundColor)
        case .accessoryRectangular:
            HStack {
                VStack {
                    Text("Today: \(today)")
                    Text("Weekly Total: \(week)")
                        .font(.caption2)
                    Text("All Time High: \(high)")
                        .font(.caption2)
                    Text("Life Time Total: \(life)")
                        .font(.caption2)
                }
            }
        case .systemMedium:
            HStack(spacing: 0){
                ZStack {
                    Image("heart")
                        .resizable().aspectRatio(contentMode: .fit)
                    Text("\(getPointValue(attribute: entry.configuration.attribute))")
                        .font(.system(size: 50))
                        .bold()
                        .foregroundColor(.white)
                        .offset(y: -5)
                }
                VStack {
                    Text("Today: \(today)")
                        .font(.title)
                    Text("Weekly Total: \(week)")
                     
                    Text("All Time High: \(high)")
                        
                    Text("Life Time Total: \(life)")
                        
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
        default:
            Text("Some other WidgetFamily in the future.")
        }
        
    }
    private func getPointValue(attribute: Attribute?) -> Int {
        if let attribute {
            do {
       
                let values = try JSONDecoder().decode([WidgetValue].self, from: data)
                
                switch attribute.identifier {
                case "0":
                    return values.first(where: {$0.type == "Steps"})?.value ?? 0
                case "1":
                    return values.first(where: {$0.type == "Workouts"})?.value ?? 0
                case "2":
                    return values.first(where: {$0.type == "Water"})?.value ?? 0
                case "3":
                    return values.first(where: {$0.type == "Sleep"})?.value ?? 0
                case "4":
                    return values.first(where: {$0.type == "Mind Sessions"})?.value ?? 0
                case "5":
                    return values.first(where: {$0.type == "Stand Hours"})?.value ?? 0
                case "6":
                    return values.first(where: {$0.type == "Exercise"})?.value ?? 0
                case "7":
                    return values.first(where: {$0.type == "Move"})?.value ?? 0
                case "8":
                    return values.first(where: {$0.type == "⌚️ Rings"})?.value ?? 0
                case "9":
                    return values.first(where: {$0.type == "Calories"})?.value ?? 0
                case "10":
                    return today
                default:
                    return -1
                }
//                return -1
            } catch {
                print(error)
                return -1
            }
            
 
        } else {
            return -1
        }
    }
}

@main
struct PointsTotal: Widget {
    let kind: String = "PointsTotal"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            PointsTotalEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .accessoryCircular, .accessoryRectangular, .systemMedium])
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

