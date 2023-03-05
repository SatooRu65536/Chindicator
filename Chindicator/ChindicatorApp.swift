import SwiftUI
import CoreWLAN
import LaunchAtLogin

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
    
    @objc func enableLaunchAtLogin() {
        LaunchAtLogin.isEnabled = true
    }
    
    @objc func disableLaunchAtLogin() {
        LaunchAtLogin.isEnabled = false
    }
    
    @objc func showPopover(_ sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else { return }
        if event.type == NSEvent.EventType.leftMouseUp {
            let menu = NSMenu()
            
            menu.addItem(
                withTitle: NSLocalizedString("自動起動 ON", comment: "自動起動ON"),
                action: #selector(enableLaunchAtLogin),
                keyEquivalent: ""
            )
            
            menu.addItem(
                withTitle: NSLocalizedString("自動起動 OFF", comment: "自動起動OFF"),
                action: #selector(disableLaunchAtLogin),
                keyEquivalent: ""
            )
            
            menu.addItem(
                withTitle: NSLocalizedString("Quit app", comment: "Quit app"),
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
        button.image = NSImage(named:NSImage.Name("Chin0"))
        button.action = #selector(showPopover)
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        
        let client = CWWiFiClient()
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true, block: { (timer) in
            let rssi = client.interface()?.rssiValue() ?? 0
            
            if rssi == 0 {
                button.image = NSImage(named:NSImage.Name("Chin0"))
            } else if rssi <= -90 {
                button.image = NSImage(named:NSImage.Name("Chin1"))
            } else if rssi <= -81 {
                button.image = NSImage(named:NSImage.Name("Chin2"))
            } else if rssi <= -76 {
                button.image = NSImage(named:NSImage.Name("Chin3"))
            } else if rssi <= -61 {
                button.image = NSImage(named:NSImage.Name("Chin4"))
            } else {
                button.image = NSImage(named:NSImage.Name("Chin5"))
            }
        })
        print(LaunchAtLogin.isEnabled)
    }
}
#endif
