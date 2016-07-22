//
//  ComplicationController.swift
//  noteswatch Extension
//
//  Created by Kyle Zappitell on 7/8/16.
//  Copyright © 2016 Kyle Zappitell. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.Forward, .Backward])
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        let imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "microphone.png")!)
        let now = NSDate()
        
        switch complication.family {
        case .ModularSmall:
            let smalltemp = CLKComplicationTemplateModularSmallSimpleImage()
            smalltemp.imageProvider = imageProvider
            let small = CLKComplicationTimelineEntry(date: now, complicationTemplate: smalltemp)
            handler(small)
        case .CircularSmall:
            let circsmalltemp = CLKComplicationTemplateCircularSmallSimpleImage()
            circsmalltemp.imageProvider = imageProvider
            let circsmall = CLKComplicationTimelineEntry(date: now, complicationTemplate: circsmalltemp)
            handler(circsmall)
        case .UtilitarianSmall:
            let utilsmalltemp = CLKComplicationTemplateUtilitarianSmallRingImage()
            utilsmalltemp.imageProvider = imageProvider
            let utilsmall = CLKComplicationTimelineEntry(date: now, complicationTemplate: utilsmalltemp)
            handler(utilsmall)
        default:
            handler(nil)
        }
        handler(nil)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        handler(nil);
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        //Need Images that fit size of other templates (Only works for modular small rn)
        let imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "microphone.png")!)
        
        switch complication.family {
        case .ModularSmall:
            let small = CLKComplicationTemplateModularSmallSimpleImage()
            small.imageProvider = imageProvider
            handler(small)
        case .CircularSmall:
            let circsmall = CLKComplicationTemplateCircularSmallSimpleImage()
            circsmall.imageProvider = imageProvider
            handler(circsmall)
        case .UtilitarianSmall:
            let utilsmall = CLKComplicationTemplateUtilitarianSmallRingImage()
            utilsmall.imageProvider = imageProvider
            handler(utilsmall)
        default:
            handler(nil)
        }
    }
    
}
