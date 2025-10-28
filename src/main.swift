import AppKit
import Foundation

class AppDelegate: NSObject, NSApplicationDelegate {
    private var window: NSWindow?
    private var textField: NSTextField?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenu()
        showUI()
    }
    
    func application(_ application: NSApplication, open urls: [URL]) {
        guard let composeURLTemplate = UserDefaults.standard.string(forKey: "ComposeURLTemplate") else {
            showUI()
            return
        }
        
        for url in urls {
            guard url.scheme == "mailto", let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { continue }
            
            var replacements: [String: String] = [:]
            
            if !components.path.isEmpty {
                replacements["recipient"] = components.path
            }
            
            components.queryItems?.forEach { item in
                let key = item.name.lowercased()
                if ["subject", "cc", "bcc", "body"].contains(key), let value = item.value, !value.isEmpty {
                    replacements[key] = value
                }
            }
            
            var finalURLString = composeURLTemplate
            let allowedCharacters = CharacterSet.urlQueryAllowed.subtracting(CharacterSet(charactersIn: "&=?"))
            
            for (key, value) in replacements {
                let placeholder = "{\(key)}"
                if let encodedValue = value.addingPercentEncoding(withAllowedCharacters: allowedCharacters) {
                    finalURLString = finalURLString.replacingOccurrences(of: placeholder, with: encodedValue)
                }
            }
            
            for key in ["recipient", "subject", "cc", "bcc", "body"] {
                if replacements[key] == nil {
                    let placeholder = "{\(key)}"
                    finalURLString = finalURLString.replacingOccurrences(of: placeholder, with: "")
                }
            }
            
            if var urlComponents = URLComponents(string: finalURLString) {
                urlComponents.queryItems = urlComponents.queryItems?.filter { item in
                    guard let value = item.value else { return false }
                    return !value.isEmpty
                }
                
                if let finalURL = urlComponents.url {
                    NSWorkspace.shared.open(finalURL)
                }
            }
        }
        
        NSApp.terminate(nil)
    }
    
    func showUI() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 150),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.center()
        window.title = "Mailto Handler Configuration"
        
        let contentView = NSView(frame: window.contentRect(forFrameRect: window.frame))
        
        let label = NSTextField(labelWithString: "Compose URL Template:")
        label.frame = NSRect(x: 20, y: 90, width: 460, height: 20)
        contentView.addSubview(label)
        
        let textField = NSTextField(frame: NSRect(x: 20, y: 60, width: 460, height: 24))
        let defaultURL = "https://mail.google.com/mail/?view=cm&to={recipient}&cc={cc}&bcc={bcc}&su={subject}&body={body}"
        textField.stringValue = UserDefaults.standard.string(forKey: "ComposeURLTemplate") ?? defaultURL
        textField.placeholderString = defaultURL
        contentView.addSubview(textField)
        self.textField = textField
        
        let button = NSButton(frame: NSRect(x: 20, y: 20, width: 200, height: 32))
        button.title = "Register mailto: Handler"
        button.bezelStyle = .rounded
        button.target = self
        button.action = #selector(registerHandler)
        contentView.addSubview(button)
        
        window.contentView = contentView
        window.makeKeyAndOrderFront(nil)
        self.window = window
        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func registerHandler() {
        guard let url = textField?.stringValue, !url.isEmpty else { return }
        
        UserDefaults.standard.set(url, forKey: "ComposeURLTemplate")
        
        let bundleID = Bundle.main.bundleIdentifier ?? "com.voicenpo.mailtohandler"
        LSSetDefaultHandlerForURLScheme("mailto" as CFString, bundleID as CFString)
        
        let alert = NSAlert()
        alert.messageText = "Success"
        alert.informativeText = "Mailto handler registered successfully!"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
        
        NSApp.terminate(nil)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    private func setupMenu() {
        let mainMenu = NSMenu()
        NSApp.mainMenu = mainMenu

        // App Menu
        let appMenuItem = NSMenuItem()
        mainMenu.addItem(appMenuItem)

        let appMenu = NSMenu()
        appMenuItem.submenu = appMenu

        let appName = ProcessInfo.processInfo.processName
        let quitMenuItem = NSMenuItem(
            title: "Quit \(appName)",
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "q"
        )
        appMenu.addItem(quitMenuItem)

        // Edit Menu
        let editMenuItem = NSMenuItem()
        mainMenu.addItem(editMenuItem)

        let editMenu = NSMenu(title: "Edit")
        editMenuItem.submenu = editMenu

        editMenu.addItem(withTitle: "Undo", action: Selector(("undo:")), keyEquivalent: "z")
        editMenu.addItem(withTitle: "Redo", action: Selector(("redo:")), keyEquivalent: "Z")
        editMenu.addItem(NSMenuItem.separator())
        editMenu.addItem(withTitle: "Cut", action: #selector(NSText.cut(_:)), keyEquivalent: "x")
        editMenu.addItem(withTitle: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c")
        editMenu.addItem(withTitle: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v")
        editMenu.addItem(NSMenuItem.separator())
        editMenu.addItem(withTitle: "Select All", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a")
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
