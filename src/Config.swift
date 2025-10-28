import Foundation

struct Config {
    let composeURLTemplate: String?
    let browserChoice: BrowserChoice
    
    static func load() -> Config {
        let template = UserDefaults.standard.string(forKey: "ComposeURLTemplate")
        let browserName = UserDefaults.standard.string(forKey: "BrowserChoice")
        let browserPath = UserDefaults.standard.string(forKey: "BrowserPath")
        
        let browser: BrowserChoice
        if let name = browserName {
            browser = BrowserChoice(name: name, path: browserPath)
        } else {
            browser = .defaultBrowser
        }
        
        return Config(composeURLTemplate: template, browserChoice: browser)
    }
    
    func save() {
        UserDefaults.standard.set(composeURLTemplate, forKey: "ComposeURLTemplate")
        UserDefaults.standard.set(browserChoice.name, forKey: "BrowserChoice")
        
        if let path = browserChoice.path {
            UserDefaults.standard.set(path, forKey: "BrowserPath")
        } else {
            UserDefaults.standard.removeObject(forKey: "BrowserPath")
        }
    }
}

