# ZoneZwitch - macOS Menu Bar Time Zone Slider App

A lightweight macOS menu bar application that allows you to visually compare time between EST (Eastern Standard Time) and IST (India Standard Time) using two interactive sliders.

## Features

- **Menu Bar Integration**: Lives in the macOS menu bar with a clock icon
- **Interactive Sliders**: Two horizontal timeline bars with draggable handles
- **Real-time Synchronization**: When you drag one slider, the other automatically updates to show the corresponding time
- **Time Zone Conversion**: Properly handles EST ↔ IST conversions with day wrap-around
- **Clean UI**: Minimal, modern interface with smooth animations

## Requirements

- macOS 11.0 (Big Sur) or later
- Xcode 12.0 or later
- Swift 5.5 or later

## Building the App

### Using Xcode

1. **Create a new Xcode project:**
   - Open Xcode
   - Choose "File" → "New" → "Project"
   - Select "macOS" → "App"
   - Product Name: `ZoneZwitch`
   - Interface: `SwiftUI`
   - Language: `Swift`
   - Click "Next" and choose a location

2. **Add the source files:**
   - Delete the default `App.swift` file
   - Drag all `.swift` files from this directory into the Xcode project:
     - `ZoneZwitchApp.swift`
     - `StatusBarController.swift`
     - `TimeZoneSliderView.swift`
     - `TimeZoneManager.swift`
   - Make sure "Copy items if needed" is checked
   - Add to target: `ZoneZwitch`

3. **Replace Info.plist:**
   - In Xcode, find `Info.plist` in the project navigator
   - Right-click and select "Open As" → "Source Code"
   - Replace its contents with the `Info.plist` file from this directory
   - OR manually add this key-value pair:
     ```xml
     <key>LSUIElement</key>
     <true/>
     ```
     This hides the dock icon so the app only appears in the menu bar.

4. **Configure project settings:**
   - Select the project in the navigator
   - Under "Signing & Capabilities", you can enable "App Sandbox" if needed
   - Set "Application Category" to "Utility" (optional)

5. **Build and run:**
   - Press ⌘R or click the Run button
   - The app will appear in your menu bar with a clock icon
   - Click the icon to open the popover with the time zone sliders

## Project Structure

```
zonezwitch/
├── ZoneZwitchApp.swift      # Main app entry point
├── StatusBarController.swift # Menu bar icon and popover management
├── TimeZoneSliderView.swift  # SwiftUI view with sliders
├── TimeZoneManager.swift     # Time zone conversion logic
└── README.md                 # This file
```

## Usage

1. Launch the app
2. Click the clock icon in the menu bar
3. Drag either the EST or IST slider to select a time
4. The other slider automatically updates to show the corresponding time
5. Time labels above each slider show the current selection

## Technical Details

- **Time Resolution**: Sliders snap to 5-minute increments
- **Time Zones**: 
  - EST: `America/New_York` (handles EDT automatically)
  - IST: `Asia/Kolkata` (UTC+5:30)
- **Architecture**: SwiftUI with AppKit integration for menu bar

## Future Enhancements

- "Now" button to jump to current time
- Additional time zones
- AM/PM or 24-hour format toggle
- Meeting scheduler mode

## License

Created for personal use.


