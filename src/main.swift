import AppKit
import Foundation

class AppDelegate: NSObject, NSApplicationDelegate {
    private var window: NSWindow?
    private var textView: NSTextView?
    private var scrollView: NSScrollView?
    private var popupButton: NSPopUpButton?
    private var exampleLabel: NSTextField?
    private var customStack: NSStackView?
    private var browserPopupButton: NSPopUpButton?
    
    private let browsers: [(name: String, appName: String)] = [
        ("Chrome", "Google Chrome.app"),
        ("Firefox", "Firefox.app"),
        ("Safari", "Safari.app"),
        ("Edge", "Microsoft Edge.app"),
        ("Opera", "Opera.app"),
        ("Brave", "Brave Browser.app"),
        ("Arc", "Arc.app"),
        ("Vivaldi", "Vivaldi.app")
    ]
    
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
                    openURL(finalURL)
                }
            }
        }
        
        NSApp.terminate(nil)
    }
    
    func openURL(_ url: URL) {
        if let browserPath = UserDefaults.standard.string(forKey: "BrowserPath"),
           FileManager.default.fileExists(atPath: browserPath) {
            let browserURL = URL(fileURLWithPath: browserPath)
            NSWorkspace.shared.open([url], withApplicationAt: browserURL, configuration: NSWorkspace.OpenConfiguration())
        } else {
            NSWorkspace.shared.open(url)
        }
    }
    
    func showUI() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 362, height: 120),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.center()
        window.title = "Mailto Handler Configuration"
        
        let popupButton = NSPopUpButton()
        popupButton.addItem(withTitle: "Gmail")
        popupButton.addItem(withTitle: "Outlook.com")
        popupButton.addItem(withTitle: "Yahoo Mail")
        popupButton.addItem(withTitle: "ProtonMail")
        popupButton.addItem(withTitle: "iCloud Mail")
        popupButton.addItem(withTitle: "Zoho Mail")
        popupButton.addItem(withTitle: "AOL Mail")
        popupButton.addItem(withTitle: "GMX Mail")
        popupButton.addItem(withTitle: "Tutanota")
        popupButton.addItem(withTitle: "Mail.com")
        popupButton.addItem(withTitle: "Fastmail")
        popupButton.addItem(withTitle: "Hushmail")
        popupButton.addItem(withTitle: "Mailfence")
        popupButton.addItem(withTitle: "Runbox")
        popupButton.addItem(withTitle: "Neo")
        popupButton.addItem(withTitle: "Titan")
        popupButton.addItem(withTitle: "10 Minute Mail")
        popupButton.addItem(withTitle: "Custom")
        popupButton.target = self
        popupButton.action = #selector(providerChanged)
        popupButton.translatesAutoresizingMaskIntoConstraints = false
        self.popupButton = popupButton
        
        let browserPopupButton = NSPopUpButton()
        browserPopupButton.addItem(withTitle: "Default Browser")
        
        for (name, appName) in browsers {
            let appPath = "/Applications/\(appName)"
            if FileManager.default.fileExists(atPath: appPath) {
                browserPopupButton.addItem(withTitle: name)
            }
        }
        
        browserPopupButton.addItem(withTitle: "Other...")
        browserPopupButton.target = self
        browserPopupButton.action = #selector(browserChanged)
        browserPopupButton.translatesAutoresizingMaskIntoConstraints = false
        self.browserPopupButton = browserPopupButton
        
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        scrollView.borderType = .bezelBorder
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let textView = NSTextView(frame: scrollView.bounds)
        textView.minSize = NSSize(width: 0, height: 0)
        textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        textView.autoresizingMask = [.width]
        textView.textContainer?.containerSize = NSSize(width: scrollView.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        textView.textContainer?.widthTracksTextView = true
        textView.font = NSFont.systemFont(ofSize: NSFont.systemFontSize)
        textView.allowsUndo = true
        textView.isEditable = true
        textView.isSelectable = true
        textView.string = ""
        
        scrollView.documentView = textView
        self.textView = textView
        self.scrollView = scrollView
        
        let exampleLabel = NSTextField(wrappingLabelWithString: "Example: https://mail.google.com/mail/?view=cm&to={recipient}&cc={cc}&bcc={bcc}&su={subject}&body={body}")
        exampleLabel.font = NSFont.systemFont(ofSize: NSFont.smallSystemFontSize)
        exampleLabel.textColor = NSColor.secondaryLabelColor
        exampleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.exampleLabel = exampleLabel
        
        let customStack = NSStackView(views: [scrollView, exampleLabel])
        customStack.orientation = .vertical
        customStack.spacing = 4
        customStack.isHidden = true
        self.customStack = customStack
        
        let button = NSButton()
        button.title = "Register"
        button.bezelStyle = .rounded
        button.target = self
        button.action = #selector(registerHandler)
        
        let buttonContainer = NSView()
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        buttonContainer.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStack = NSStackView(views: [popupButton, customStack, browserPopupButton, buttonContainer])
        mainStack.orientation = .vertical
        mainStack.spacing = 10
        mainStack.alignment = .leading
        mainStack.edgeInsets = NSEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        let contentView = NSView()
        contentView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            popupButton.widthAnchor.constraint(equalToConstant: 322),
            
            scrollView.widthAnchor.constraint(equalToConstant: 322),
            scrollView.heightAnchor.constraint(equalToConstant: 54),
            
            exampleLabel.widthAnchor.constraint(equalToConstant: 322),
            
            browserPopupButton.widthAnchor.constraint(equalToConstant: 322),
            
            buttonContainer.widthAnchor.constraint(equalToConstant: 322),
            buttonContainer.heightAnchor.constraint(equalToConstant: 32),
            
            button.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor),
            button.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        window.contentView = contentView
        self.window = window
        
        if let savedURL = UserDefaults.standard.string(forKey: "ComposeURLTemplate"), !savedURL.isEmpty {
            var matchedProvider = false
            
            for item in popupButton.itemArray {
                let title = item.title
                if title != "Custom" {
                    let providerURL = getURLForProvider(title)
                    if providerURL == savedURL {
                        popupButton.select(item)
                        matchedProvider = true
                        break
                    }
                }
            }
            
            if !matchedProvider {
                popupButton.selectItem(withTitle: "Custom")
                textView.string = savedURL
                customStack.isHidden = false
            }
        }
        
        if let savedBrowser = UserDefaults.standard.string(forKey: "BrowserChoice") {
            let isKnownBrowser = browsers.contains(where: { $0.name == savedBrowser })
            
            if !isKnownBrowser && savedBrowser != "Default Browser" {
                browserPopupButton.removeItem(withTitle: "Other...")
                browserPopupButton.addItem(withTitle: savedBrowser)
                browserPopupButton.addItem(withTitle: "Other...")
            }
            
            browserPopupButton.selectItem(withTitle: savedBrowser)
        }
        
        contentView.layoutSubtreeIfNeeded()
        let contentHeight = contentView.fittingSize.height
        let frameHeight = window.frameRect(forContentRect: NSRect(x: 0, y: 0, width: 362, height: contentHeight)).height
        
        var frame = window.frame
        frame.size.height = frameHeight
        window.setFrame(frame, display: false)
        window.center()
        
        window.makeKeyAndOrderFront(nil)
        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func providerChanged() {
        guard let selectedTitle = popupButton?.selectedItem?.title, let window = window else { return }
        
        let isCustom = (selectedTitle == "Custom")
        customStack?.isHidden = !isCustom
        
        window.layoutIfNeeded()
        
        let contentHeight = window.contentView?.fittingSize.height ?? 200
        let frameHeight = window.frameRect(forContentRect: NSRect(x: 0, y: 0, width: 362, height: contentHeight)).height
        
        var newFrame = window.frame
        newFrame.origin.y += (newFrame.height - frameHeight)
        newFrame.size.height = frameHeight
        
        window.setFrame(newFrame, display: true, animate: true)
    }
    
    @objc func browserChanged() {
        guard let selectedTitle = browserPopupButton?.selectedItem?.title else { return }
        
        if selectedTitle == "Other..." {
            let openPanel = NSOpenPanel()
            openPanel.allowsMultipleSelection = false
            openPanel.canChooseDirectories = false
            openPanel.canChooseFiles = true
            openPanel.allowedContentTypes = [.application]
            openPanel.directoryURL = URL(fileURLWithPath: "/Applications")
            
            if openPanel.runModal() == .OK, let url = openPanel.url {
                let appName = url.deletingPathExtension().lastPathComponent
                
                browserPopupButton?.removeItem(withTitle: "Other...")
                browserPopupButton?.addItem(withTitle: appName)
                browserPopupButton?.addItem(withTitle: "Other...")
                browserPopupButton?.selectItem(withTitle: appName)
                
                UserDefaults.standard.set(appName, forKey: "BrowserChoice")
                UserDefaults.standard.set(url.path, forKey: "BrowserPath")
            } else {
                browserPopupButton?.selectItem(at: 0)
            }
        } else if selectedTitle == "Default Browser" {
            UserDefaults.standard.set(selectedTitle, forKey: "BrowserChoice")
            UserDefaults.standard.removeObject(forKey: "BrowserPath")
        } else {
            for (name, appName) in browsers {
                if name == selectedTitle {
                    let appPath = "/Applications/\(appName)"
                    UserDefaults.standard.set(selectedTitle, forKey: "BrowserChoice")
                    UserDefaults.standard.set(appPath, forKey: "BrowserPath")
                    break
                }
            }
        }
    }
    
    func getURLForProvider(_ provider: String) -> String {
        switch provider {
        case "Gmail":
            return "https://mail.google.com/mail/?view=cm&to={recipient}&cc={cc}&bcc={bcc}&su={subject}&body={body}"
        case "Outlook.com":
            return "https://outlook.live.com/mail/0/deeplink/compose?to={recipient}&subject={subject}&cc={cc}&body={body}"
        case "Yahoo Mail":
            return "https://compose.mail.yahoo.com/?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}"
        case "ProtonMail":
            return "https://mail.proton.me/u/0/compose?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}"
        case "iCloud Mail":
            return "https://www.icloud.com/mail?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}"
        case "Zoho Mail":
            return "https://mail.zoho.com/zm/#compose/to={recipient}/cc/{cc}/bcc/{bcc}/subject/{subject}/content/{body}"
        case "AOL Mail":
            return "https://mail.aol.com/webmail-std/en-us/compose?to={recipient}&cc={cc}&bcc={bcc}&subject={subject}&body={body}"
        case "GMX Mail":
            return "https://www.gmx.com/mail/compose?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}"
        case "Tutanota":
            return "https://mail.tutanota.com/compose?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}"
        case "Mail.com":
            return "https://www.mail.com/mail/compose?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}"
        case "Fastmail":
            return "https://www.fastmail.com/action/compose/?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}"
        case "Hushmail":
            return "https://www.hushmail.com/msg/compose?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}"
        case "Mailfence":
            return "https://mailfence.com/compose?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}"
        case "Runbox":
            return "https://runbox.com/mail/compose?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}"
        case "Neo":
            return "https://app.neo.space/mail/compose?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}"
        case "Titan":
            return "https://app.titan.email/compose?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}"
        case "10 Minute Mail":
            return "https://10minutemail.com/compose?to={recipient}&subject={subject}&body={body}"
        default:
            return ""
        }
    }
    
    @objc func registerHandler() {
        let url: String
        
        if popupButton?.selectedItem?.title == "Custom" {
            guard let customURL = textView?.string, !customURL.isEmpty else { return }
            url = customURL
        } else {
            guard let provider = popupButton?.selectedItem?.title else { return }
            url = getURLForProvider(provider)
        }
        
        UserDefaults.standard.set(url, forKey: "ComposeURLTemplate")
        
        if let browserChoice = browserPopupButton?.selectedItem?.title {
            UserDefaults.standard.set(browserChoice, forKey: "BrowserChoice")
        }
        
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
