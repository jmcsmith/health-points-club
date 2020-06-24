//
//  ComplicationController.swift
//  healthpoints-watch Extension
//
//  Created by Joseph Smith on 4/29/20.
//  Copyright © 2020 Joseph Smith. All rights reserved.
//

import ClockKit
import RSSHealthKitHelper_Watch


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        let predictionDate = Date()
        let predictionTemplate = template(for: complication.family, date: predictionDate)
        
        let entry = CLKComplicationTimelineEntry(date: predictionDate, complicationTemplate: predictionTemplate)
        handler(entry)
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        switch complication.family { case .modularLarge:
            let template = CLKComplicationTemplateModularLargeStandardBody()
            template.headerTextProvider = CLKSimpleTextProvider(text: "Magic 8-Ball", shortText: "8-Ball")
            template.body1TextProvider = CLKSimpleTextProvider(text: "Your Prediction", shortText: "Prediction")
            handler(template) case .modularSmall:
                let template = CLKComplicationTemplateModularSmallSimpleText()
                template.textProvider = CLKSimpleTextProvider(text: "8")
                handler(template)
        default:
            handler(nil)
        }
    }
    func template(for family: CLKComplicationFamily, date: Date) -> CLKComplicationTemplate {
        
        
        let total = HealthDay.shared.getPoints()
        
        switch family {
        case .modularLarge:
            let template = CLKComplicationTemplateModularLargeStandardBody()
            template.headerTextProvider = CLKSimpleTextProvider(text: "Today: "+total.description)
            template.body1TextProvider = CLKSimpleTextProvider(text: "Weekly Total: \(HealthDay.shared.weeklyTotal.description)")
            template.body2TextProvider = CLKSimpleTextProvider(text: "Lifetime Total: \(HealthDay.shared.lifetimeTotal.description)")
            return template
        case .modularSmall:
            let template = CLKComplicationTemplateModularSmallSimpleText()
            template.textProvider = CLKSimpleTextProvider(text: total.description)
            return template
        case .graphicRectangular:
            let template = CLKComplicationTemplateGraphicRectangularStandardBody()
            template.headerTextProvider = CLKSimpleTextProvider(text: "Today: "+total.description)
            template.body1TextProvider = CLKSimpleTextProvider(text: "Weekly Total: \(HealthDay.shared.weeklyTotal.description)")
            template.body2TextProvider = CLKSimpleTextProvider(text: "Lifetime Total: \(HealthDay.shared.lifetimeTotal.description)")
            return template
        case .circularSmall:
            let template = CLKComplicationTemplateModularSmallSimpleText()
            template.textProvider = CLKSimpleTextProvider(text: total.description)
            return template
        case .graphicCircular:
            let template = CLKComplicationTemplateGraphicCircularStackText()
            let line1 = CLKSimpleTextProvider(text: "HPC")
            line1.tintColor = UIColor.red
            
            template.line1TextProvider = line1
            template.line2TextProvider = CLKSimpleTextProvider(text: "\(total)")
            
            return template
        default:
            let template = CLKComplicationTemplateModularSmallSimpleText()
            template.textProvider = CLKSimpleTextProvider(text: total.description)
            return template
        }
    }
    
}
