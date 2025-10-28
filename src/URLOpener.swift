import AppKit
import Foundation

struct URLOpener {
    static func open(_ url: URL, withBrowser browser: BrowserChoice) {
        if let path = browser.path,
           FileManager.default.fileExists(atPath: path) {
            let browserURL = URL(fileURLWithPath: path)
            NSWorkspace.shared.open([url], withApplicationAt: browserURL, configuration: NSWorkspace.OpenConfiguration())
        } else {
            NSWorkspace.shared.open(url)
        }
    }
    
    static func registerAsMailtoHandler() {
        let bundleID = Bundle.main.bundleIdentifier ?? "npo.voice.mailtohandler"
        LSSetDefaultHandlerForURLScheme("mailto" as CFString, bundleID as CFString)
    }
}

