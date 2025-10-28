import Foundation

struct Browser {
    let name: String
    let appName: String
    
    var path: String {
        "/Applications/\(appName)"
    }
    
    var exists: Bool {
        FileManager.default.fileExists(atPath: path)
    }
    
    static let known: [Browser] = [
        Browser(name: "Arc", appName: "Arc.app"),
        Browser(name: "Avast Secure Browser", appName: "Avast Secure Browser.app"),
        Browser(name: "Brave", appName: "Brave Browser.app"),
        Browser(name: "Chrome", appName: "Google Chrome.app"),
        Browser(name: "DuckDuckGo", appName: "DuckDuckGo.app"),
        Browser(name: "Edge", appName: "Microsoft Edge.app"),
        Browser(name: "Epic", appName: "Epic.app"),
        Browser(name: "Firefox", appName: "Firefox.app"),
        Browser(name: "Maxthon", appName: "Maxthon.app"),
        Browser(name: "Min", appName: "Min.app"),
        Browser(name: "Opera GX", appName: "Opera GX.app"),
        Browser(name: "Opera", appName: "Opera.app"),
        Browser(name: "Orion", appName: "Orion.app"),
        Browser(name: "Safari", appName: "Safari.app"),
        Browser(name: "SeaMonkey", appName: "SeaMonkey.app"),
        Browser(name: "SigmaOS", appName: "SigmaOS.app"),
        Browser(name: "Tor Browser", appName: "Tor Browser.app"),
        Browser(name: "Vivaldi", appName: "Vivaldi.app"),
        Browser(name: "Waterfox", appName: "Waterfox.app"),
        Browser(name: "Yandex", appName: "Yandex.app"),
    ]
    
    static func find(byName name: String) -> Browser? {
        known.first { $0.name == name }
    }
}

struct EmailProvider {
    let name: String
    let template: String
    
    static let providers: [EmailProvider] = [
        EmailProvider(name: "Gmail", template: "https://mail.google.com/mail/?view=cm&to={recipient}&cc={cc}&bcc={bcc}&su={subject}&body={body}"),
        EmailProvider(name: "Outlook.com", template: "https://outlook.live.com/mail/0/deeplink/compose?to={recipient}&subject={subject}&cc={cc}&body={body}"),
        EmailProvider(name: "Yahoo Mail", template: "https://compose.mail.yahoo.com/?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}"),
        EmailProvider(name: "ProtonMail", template: "https://mail.proton.me/u/0/compose?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}"),
        EmailProvider(name: "iCloud Mail", template: "https://www.icloud.com/mail?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}"),
        EmailProvider(name: "Zoho Mail", template: "https://mail.zoho.com/zm/#compose/to={recipient}/cc/{cc}/bcc/{bcc}/subject/{subject}/content/{body}"),
        EmailProvider(name: "AOL Mail", template: "https://mail.aol.com/webmail-std/en-us/compose?to={recipient}&cc={cc}&bcc={bcc}&subject={subject}&body={body}"),
        EmailProvider(name: "GMX Mail", template: "https://www.gmx.com/mail/compose?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}"),
        EmailProvider(name: "Tutanota", template: "https://mail.tutanota.com/compose?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}"),
        EmailProvider(name: "Mail.com", template: "https://www.mail.com/mail/compose?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}"),
        EmailProvider(name: "Fastmail", template: "https://www.fastmail.com/action/compose/?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}"),
        EmailProvider(name: "Hushmail", template: "https://www.hushmail.com/msg/compose?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}"),
        EmailProvider(name: "Mailfence", template: "https://mailfence.com/compose?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}"),
        EmailProvider(name: "Runbox", template: "https://runbox.com/mail/compose?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}"),
        EmailProvider(name: "Neo", template: "https://app.neo.space/mail/compose?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}"),
        EmailProvider(name: "Titan", template: "https://app.titan.email/compose?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}"),
        EmailProvider(name: "10 Minute Mail", template: "https://10minutemail.com/compose?to={recipient}&subject={subject}&body={body}")
    ]
    
    static func find(byName name: String) -> EmailProvider? {
        providers.first { $0.name == name }
    }
    
    static func find(byTemplate template: String) -> EmailProvider? {
        providers.first { $0.template == template }
    }
}

struct BrowserChoice {
    let name: String
    let path: String?
    
    static let defaultBrowser = BrowserChoice(name: "Default Browser", path: nil)
    
    var isDefault: Bool {
        path == nil
    }
}

