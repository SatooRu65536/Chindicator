import SwiftUI

@main
struct ChindicatorApp: App {
#if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
#endif
    var body: some Scene {
        WindowGroup {
        }
    }
}

#if os(macOS)
class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var popover: NSPopover?
    
    @objc func terminate() {
        NSApp.terminate(self)
    }
    
    @objc func openPreferencesWindow() {
    }
    
    @objc func showPopover(_ sender: NSStatusBarButton) {
        if popover == nil {
            let popover = NSPopover()
            
            popover.contentViewController = NSHostingController(rootView: ContentView())
            popover.behavior = .transient
            popover.animates = false
            
            self.popover = popover
        }
        
        popover?.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxY)
        popover?.contentViewController?.view.window?.makeKey()
        
        guard let event = NSApp.currentEvent else { return }
        if event.type == NSEvent.EventType.rightMouseUp {
            let menu = NSMenu()
            
            menu.addItem(
                withTitle: NSLocalizedString("Quit", comment: "Quit app"),
                action: #selector(terminate),
                keyEquivalent: ""
            )
            
            statusItem?.menu = menu
            return
        }
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.windows.forEach{ $0.close() }
        NSApp.setActivationPolicy(.accessory)
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        let button = statusItem.button!
        //        button.image = NSImage(systemSymbolName: "leaf", accessibilityDescription: nil)
        button.image = NSImage(named:NSImage.Name("Chin5"))
        
        button.action = #selector(showPopover)
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
    }
}
#endif
