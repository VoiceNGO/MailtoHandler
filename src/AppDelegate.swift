import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var configWindow: ConfigWindow?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.mainMenu = MenuBuilder.buildMainMenu()
        showConfigWindow()
    }
    
    func application(_ application: NSApplication, open urls: [URL]) {
        let config = Config.load()
        
        guard let template = config.composeURLTemplate else {
            showConfigWindow()
            return
        }
        
        urls.compactMap(MailtoComponents.parse)
            .compactMap { $0.buildURL(template: template) }
            .forEach { URLOpener.open($0, withBrowser: config.browserChoice) }
        
        NSApp.terminate(nil)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
    
    func showConfigWindow() {
        let config = Config.load()
        let window = ConfigWindow(config: config)
        
        window.onRegister = { _ in
            NSApp.terminate(nil)
        }
        
        window.show()
        configWindow = window
    }
}

