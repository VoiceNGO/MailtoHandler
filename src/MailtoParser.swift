import Foundation

struct MailtoComponents {
    let recipient: String?
    let subject: String?
    let cc: String?
    let bcc: String?
    let body: String?
    
    static func parse(from url: URL) -> MailtoComponents? {
        guard url.scheme == "mailto",
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        var replacements: [String: String] = [:]
        
        if !components.path.isEmpty {
            replacements["recipient"] = components.path
        }
        
        components.queryItems?.forEach { item in
            let key = item.name.lowercased()
            if ["subject", "cc", "bcc", "body"].contains(key),
               let value = item.value,
               !value.isEmpty {
                replacements[key] = value
            }
        }
        
        return MailtoComponents(
            recipient: replacements["recipient"],
            subject: replacements["subject"],
            cc: replacements["cc"],
            bcc: replacements["bcc"],
            body: replacements["body"]
        )
    }
    
    func buildURL(template: String) -> URL? {
        let allowedCharacters = CharacterSet.urlQueryAllowed.subtracting(CharacterSet(charactersIn: "&=?"))
        
        let replacements = [
            "recipient": recipient,
            "subject": subject,
            "cc": cc,
            "bcc": bcc,
            "body": body
        ]
        
        var result = template
        for (key, value) in replacements {
            let placeholder = "{\(key)}"
            if let value = value,
               let encoded = value.addingPercentEncoding(withAllowedCharacters: allowedCharacters) {
                result = result.replacingOccurrences(of: placeholder, with: encoded)
            } else {
                result = result.replacingOccurrences(of: placeholder, with: "")
            }
        }
        
        guard var urlComponents = URLComponents(string: result) else {
            return nil
        }
        
        urlComponents.queryItems = urlComponents.queryItems?.filter { item in
            guard let value = item.value else { return false }
            return !value.isEmpty
        }
        
        return urlComponents.url
    }
}

