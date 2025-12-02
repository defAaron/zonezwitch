//
//  ZoneZwitchApp.swift
//  ZoneZwitch
//
//  Created for macOS menu bar time zone slider app
//

import SwiftUI

@main
struct ZoneZwitchApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarController: StatusBarController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBarController = StatusBarController()
        
        // Hide dock icon
        NSApp.setActivationPolicy(.accessory)
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        statusBarController = nil
    }
}


