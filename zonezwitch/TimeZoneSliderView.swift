//
//  TimeZoneSliderView.swift
//  ZoneZwitch
//

import SwiftUI

struct TimeZoneSliderView: View {
    @StateObject private var timeZoneManager = TimeZoneManager()
    
    var body: some View {
        VStack(spacing: 16) {
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
    
    private let totalMinutes = 24.0 * 60.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 8)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(color.opacity(0.3))
                    .frame(width: CGFloat(value / totalMinutes) * geometry.size.width, height: 8)
                
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
                                let snappedValue = round(newValue / 5.0) * 5.0
                                
                                if abs(snappedValue - value) >= 5.0 {
                                    value = snappedValue
                                    onValueChanged()
                                }
                            }
                            .onEnded { _ in
                                isDragging = false
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

