swiftc -o ../dmg-staging/MailtoHandler.app/Contents/MacOS/MailtoHandler main.swift -framework AppKit
hdiutil create -volname "MailtoHandler" -srcfolder ../dmg-staging -ov -format UDZO ../MailtoHandler.dmg
