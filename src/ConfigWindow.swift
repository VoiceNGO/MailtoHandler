import AppKit

final class ConfigWindow: NSWindowController {
    var onRegister: ((Config) -> Void)?
    
    private let providerPopup: NSPopUpButton
    private let browserPopup: NSPopUpButton
    private let customURLTextView: NSTextView
    private let customStack: NSStackView
    
    init(config: Config) {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 362, height: 120),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.title = "Mailto Handler Configuration"
        
        providerPopup = ConfigWindow.buildProviderPopup()
        browserPopup = ConfigWindow.buildBrowserPopup()
        
        let (customURLTextView, customStack) = ConfigWindow.buildCustomURLEditor()
        self.customURLTextView = customURLTextView
        self.customStack = customStack
        
        super.init(window: window)
        
        providerPopup.target = self
        providerPopup.action = #selector(providerChanged)
        
        browserPopup.target = self
        browserPopup.action = #selector(browserChanged)
        
        let registerButton = ConfigWindow.buildRegisterButton(target: self, action: #selector(register))
        
        let contentView = ConfigWindow.buildContentView(
            providerPopup: providerPopup,
            customStack: customStack,
            browserPopup: browserPopup,
            registerButton: registerButton
        )
        
        window.contentView = contentView
        
        loadConfig(config)
        resizeToFit()
        window.center()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    func show() {
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}

extension ConfigWindow {
    static func buildProviderPopup() -> NSPopUpButton {
        let popup = NSPopUpButton()
        popup.translatesAutoresizingMaskIntoConstraints = false
        
        EmailProvider.providers.forEach { provider in
            popup.addItem(withTitle: provider.name)
        }
        popup.addItem(withTitle: "Custom")
        
        return popup
    }
    
    static func buildBrowserPopup() -> NSPopUpButton {
        let popup = NSPopUpButton()
        popup.translatesAutoresizingMaskIntoConstraints = false
        
        popup.addItem(withTitle: "Default Browser")
        
        Browser.known.filter(\.exists).forEach { browser in
            popup.addItem(withTitle: browser.name)
        }
        
        popup.addItem(withTitle: "Other...")
        
        return popup
    }
    
    static func buildCustomURLEditor() -> (NSTextView, NSStackView) {
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
        
        let instructionsLabel = NSTextField(wrappingLabelWithString: "Use placeholders: {recipient}, {subject}, {cc}, {bcc}, {body}")
        instructionsLabel.font = NSFont.systemFont(ofSize: NSFont.smallSystemFontSize)
        instructionsLabel.textColor = NSColor.labelColor
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let exampleLabel = NSTextField(wrappingLabelWithString: "Example: https://mail.google.com/mail/?view=cm&to={recipient}&cc={cc}&bcc={bcc}&su={subject}&body={body}")
        exampleLabel.font = NSFont.systemFont(ofSize: NSFont.smallSystemFontSize)
        exampleLabel.textColor = NSColor.secondaryLabelColor
        exampleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = NSStackView(views: [scrollView, instructionsLabel, exampleLabel])
        stack.orientation = .vertical
        stack.spacing = 4
        stack.isHidden = true
        
        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalToConstant: 322),
            scrollView.heightAnchor.constraint(equalToConstant: 54),
            instructionsLabel.widthAnchor.constraint(equalToConstant: 322),
            exampleLabel.widthAnchor.constraint(equalToConstant: 322)
        ])
        
        return (textView, stack)
    }
    
    static func buildRegisterButton(target: AnyObject, action: Selector) -> NSView {
        let button = NSButton()
        button.title = "Register"
        button.bezelStyle = .rounded
        button.target = target
        button.action = action
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let container = NSView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(button)
        
        NSLayoutConstraint.activate([
            container.widthAnchor.constraint(equalToConstant: 322),
            container.heightAnchor.constraint(equalToConstant: 32),
            button.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            button.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        return container
    }
    
    static func buildContentView(
        providerPopup: NSPopUpButton,
        customStack: NSStackView,
        browserPopup: NSPopUpButton,
        registerButton: NSView
    ) -> NSView {
        let mainStack = NSStackView(views: [providerPopup, customStack, browserPopup, registerButton])
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
            providerPopup.widthAnchor.constraint(equalToConstant: 322),
            browserPopup.widthAnchor.constraint(equalToConstant: 322)
        ])
        
        return contentView
    }
}

extension ConfigWindow {
    func loadConfig(_ config: Config) {
        if let template = config.composeURLTemplate,
           let provider = EmailProvider.find(byTemplate: template) {
            providerPopup.selectItem(withTitle: provider.name)
        } else if let template = config.composeURLTemplate {
            providerPopup.selectItem(withTitle: "Custom")
            customURLTextView.string = template
            customStack.isHidden = false
        }
        
        let browserName = config.browserChoice.name
        let isKnownBrowser = Browser.find(byName: browserName) != nil
        
        if !isKnownBrowser && !config.browserChoice.isDefault {
            browserPopup.removeItem(withTitle: "Other...")
            browserPopup.addItem(withTitle: browserName)
            browserPopup.addItem(withTitle: "Other...")
        }
        
        browserPopup.selectItem(withTitle: browserName)
    }
    
    func buildConfig() -> Config? {
        let template: String?
        if providerPopup.selectedItem?.title == "Custom" {
            guard !customURLTextView.string.isEmpty else { return nil }
            template = customURLTextView.string
        } else if let providerName = providerPopup.selectedItem?.title,
                  let provider = EmailProvider.find(byName: providerName) {
            template = provider.template
        } else {
            return nil
        }
        
        let browserChoice: BrowserChoice
        if let browserName = browserPopup.selectedItem?.title {
            if browserName == "Default Browser" {
                browserChoice = .defaultBrowser
            } else if let browser = Browser.find(byName: browserName) {
                browserChoice = BrowserChoice(name: browserName, path: browser.path)
            } else if let path = UserDefaults.standard.string(forKey: "BrowserPath") {
                browserChoice = BrowserChoice(name: browserName, path: path)
            } else {
                browserChoice = .defaultBrowser
            }
        } else {
            browserChoice = .defaultBrowser
        }
        
        return Config(composeURLTemplate: template, browserChoice: browserChoice)
    }
}

extension ConfigWindow {
    @objc func providerChanged() {
        guard let window = window else { return }
        
        let isCustom = (providerPopup.selectedItem?.title == "Custom")
        customStack.isHidden = !isCustom
        
        window.layoutIfNeeded()
        resizeToFit(animated: true)
    }
    
    @objc func browserChanged() {
        guard let selectedTitle = browserPopup.selectedItem?.title else { return }
        
        if selectedTitle != "Other..." {
            return
        }
        
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowedContentTypes = [.application]
        openPanel.directoryURL = URL(fileURLWithPath: "/Applications")
        
        guard openPanel.runModal() == .OK, let url = openPanel.url else {
            browserPopup.selectItem(at: 0)
            return
        }
        
        let appName = url.deletingPathExtension().lastPathComponent
        
        browserPopup.removeItem(withTitle: "Other...")
        browserPopup.addItem(withTitle: appName)
        browserPopup.addItem(withTitle: "Other...")
        browserPopup.selectItem(withTitle: appName)
        
        UserDefaults.standard.set(url.path, forKey: "BrowserPath")
    }
    
    @objc func register() {
        guard let config = buildConfig() else { return }
        
        config.save()
        URLOpener.registerAsMailtoHandler()
        
        let alert = NSAlert()
        alert.messageText = "Success"
        alert.informativeText = "Mailto handler registered successfully!"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
        
        onRegister?(config)
    }
    
    func resizeToFit(animated: Bool = false) {
        guard let window = window, let contentView = window.contentView else { return }
        
        contentView.layoutSubtreeIfNeeded()
        let contentHeight = contentView.fittingSize.height
        let frameHeight = window.frameRect(forContentRect: NSRect(x: 0, y: 0, width: 362, height: contentHeight)).height
        
        var newFrame = window.frame
        newFrame.origin.y += (newFrame.height - frameHeight)
        newFrame.size.height = frameHeight
        
        window.setFrame(newFrame, display: true, animate: animated)
    }
}

