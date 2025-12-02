//
//  TimeZoneManager.swift
//  ZoneZwitch
//
//  Handles time zone conversions between EST and IST
//

import Foundation
import SwiftUI
import Combine

class TimeZoneManager: ObservableObject {
    @Published var estMinutes: Double = 0
    @Published var istMinutes: Double = 0
    
    private let estTimeZone = TimeZone(abbreviation: "EST") ?? TimeZone(identifier: "America/New_York")!
    private let istTimeZone = TimeZone(identifier: "Asia/Kolkata")!
    
    private var isUpdating = false
    
    init() {
        // Initialize with current time
        updateToCurrentTime()
    }
    
    var estTimeString: String {
        formatTime(minutes: estMinutes, timeZone: estTimeZone, abbreviation: "EST")
    }
    
    var istTimeString: String {
        formatTime(minutes: istMinutes, timeZone: istTimeZone, abbreviation: "IST")
    }
    
    func updateISTFromEST() {
        guard !isUpdating else { return }
        isUpdating = true
        
        // Create a date representing the EST time today
        let estDate = minutesToDate(minutes: estMinutes, in: estTimeZone)
        
        // Convert to IST - this represents the same moment in time
        let istDate = convertToTimeZone(estDate, from: estTimeZone, to: istTimeZone)
        istMinutes = dateToMinutes(date: istDate, in: istTimeZone)
        
        isUpdating = false
    }
    
    func updateESTFromIST() {
        guard !isUpdating else { return }
        isUpdating = true
        
        // Create a date representing the IST time today
        let istDate = minutesToDate(minutes: istMinutes, in: istTimeZone)
        
        // Convert to EST - this represents the same moment in time
        let estDate = convertToTimeZone(istDate, from: istTimeZone, to: estTimeZone)
        estMinutes = dateToMinutes(date: estDate, in: estTimeZone)
        
        isUpdating = false
    }
    
    func updateToCurrentTime() {
        let now = Date()
        estMinutes = dateToMinutes(date: now, in: estTimeZone)
        istMinutes = dateToMinutes(date: now, in: istTimeZone)
    }
    
    // MARK: - Helper Methods
    
    private func minutesToDate(minutes: Double, in timeZone: TimeZone) -> Date {
        let calendar = Calendar.current
        let today = Date()
        
        // Get today's date components
        var components = calendar.dateComponents(in: timeZone, from: today)
        
        // Set the time components from minutes
        components.hour = Int(minutes) / 60
        components.minute = Int(minutes) % 60
        components.second = 0
        components.nanosecond = 0
        
        // Create date in the specified timezone
        return calendar.date(from: components) ?? today
    }
    
    private func dateToMinutes(date: Date, in timeZone: TimeZone) -> Double {
        let calendar = Calendar.current
        let components = calendar.dateComponents(in: timeZone, from: date)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        return Double(hour * 60 + minute)
    }
    
    private func convertToTimeZone(_ date: Date, from sourceTimeZone: TimeZone, to targetTimeZone: TimeZone) -> Date {
        // The date represents a moment in time
        // We just return it - the dateToMinutes function will extract the time
        // components in whatever timezone we specify
        return date
    }
    
    private func formatTime(minutes: Double, timeZone: TimeZone, abbreviation: String) -> String {
        let hour = Int(minutes) / 60
        let minute = Int(minutes) % 60
        
        let calendar = Calendar.current
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        components.timeZone = timeZone
        
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = "h:mm a"
        
        if let date = calendar.date(from: components) {
            return "\(formatter.string(from: date)) \(abbreviation)"
        }
        
        // Fallback formatting
        let period = hour >= 12 ? "PM" : "AM"
        let displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour)
        return String(format: "%d:%02d %@ %@", displayHour, minute, period, abbreviation)
    }
}


