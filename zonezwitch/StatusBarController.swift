//
//  StatusBarController.swift
//  ZoneZwitch
//
//  Manages the menu bar icon and popover
//

import AppKit
import SwiftUI

class StatusBarController {
    private var statusBarItem: NSStatusItem?
    private var popover: NSPopover?
    
    init() {
        setupStatusBar()
    }
    
    private func setupStatusBar() {
        // Create status bar item
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        guard let statusBarItem = statusBarItem else { return }
        
        // Set icon (using SF Symbol or custom icon)
        if let button = statusBarItem.button {
            button.image = NSImage(systemSymbolName: "clock", accessibilityDescription: "ZoneZwitch")
            button.image?.isTemplate = true
            button.action = #selector(togglePopover)
            button.target = self
        }
        
        // Create popover
        popover = NSPopover()
        popover?.contentSize = NSSize(width: 350, height: 220)
        popover?.behavior = .transient
        popover?.contentViewController = NSHostingController(rootView: TimeZoneSliderView())
    }
    
    @objc private func togglePopover() {
        guard let statusBarItem = statusBarItem,
              let button = statusBarItem.button,
              let popover = popover else { return }
        
        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            popover.contentViewController?.view.window?.makeKey()
        }
    }
}

