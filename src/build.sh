swiftc -o ../dmg-staging/MailtoHandler.app/Contents/MacOS/MailtoHandler \
    main.swift \
    AppDelegate.swift \
    ConfigWindow.swift \
    MenuBuilder.swift \
    URLOpener.swift \
    MailtoParser.swift \
    Config.swift \
    Models.swift \
    -framework AppKit
hdiutil create -volname "MailtoHandler" -srcfolder ../dmg-staging -ov -format UDZO ../MailtoHandler.dmg
