//
//  TimeZoneSliderView.swift
//  ZoneZwitch
//
//  Main view with two synchronized time zone sliders
//

import SwiftUI

struct TimeZoneSliderView: View {
    @StateObject private var timeZoneManager = TimeZoneManager()
    
    var body: some View {
        VStack(spacing: 16) {
            // EST Slider
            VStack(spacing: 8) {
                Text(timeZoneManager.estTimeString)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
                
                TimeZoneSlider(
                    value: $timeZoneManager.estMinutes,
                    timeZoneName: "EST",
                    color: .blue,
                    onValueChanged: {
                        timeZoneManager.updateISTFromEST()
                    }
                )
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            
            // IST Slider
            VStack(spacing: 8) {
                Text(timeZoneManager.istTimeString)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
                
                TimeZoneSlider(
                    value: $timeZoneManager.istMinutes,
                    timeZoneName: "IST",
                    color: .orange,
                    onValueChanged: {
                        timeZoneManager.updateESTFromIST()
                    }
                )
            }
            .padding(.horizontal, 20)
            
            // Now button
            Button(action: {
                timeZoneManager.updateToCurrentTime()
            }) {
                Text("Now")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .cornerRadius(6)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom, 16)
        }
        .frame(width: 350, height: 220)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

struct TimeZoneSlider: View {
    @Binding var value: Double
    let timeZoneName: String
    let color: Color
    let onValueChanged: () -> Void
    
    @State private var isDragging = false
    @State private var lastValue: Double = 0
    
    private let totalMinutes = 24.0 * 60.0 // 1440 minutes in a day
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 8)
                
                // Active track
                RoundedRectangle(cornerRadius: 4)
                    .fill(color.opacity(0.3))
                    .frame(width: CGFloat(value / totalMinutes) * geometry.size.width, height: 8)
                
                // Tick marks
                HStack(spacing: 0) {
                    ForEach(0..<25) { hour in
                        Rectangle()
                            .fill(Color.gray.opacity(0.4))
                            .frame(width: 1, height: hour % 6 == 0 ? 12 : 6)
                            .offset(y: -2)
                        if hour < 24 {
                            Spacer()
                        }
                    }
                }
                
                // Slider handle
                Circle()
                    .fill(color)
                    .frame(width: 20, height: 20)
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                    .offset(x: CGFloat(value / totalMinutes) * geometry.size.width - 10)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                if !isDragging {
                                    isDragging = true
                                    lastValue = value
                                }
                                
                                let newValue = max(0, min(totalMinutes, Double(gesture.location.x / geometry.size.width) * totalMinutes))
                                // Snap to 5-minute increments
                                let snappedValue = round(newValue / 5.0) * 5.0
                                
                                // Only update if value changed (to avoid excessive updates)
                                if abs(snappedValue - value) >= 5.0 {
                                    value = snappedValue
                                    onValueChanged()
                                }
                            }
                            .onEnded { _ in
                                isDragging = false
                                // Final update if needed
                                if abs(value - lastValue) >= 5.0 {
                                    onValueChanged()
                                }
                            }
                    )
            }
        }
        .frame(height: 20)
    }
}

