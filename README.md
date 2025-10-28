# MailtoHandler

[**Download MailtoHandler.dmg**](https://github.com/VoiceNGO/MailtoHandler/raw/main/MailtoHandler.dmg)

A simple macOS app that opens mailto: links in a web-based email service instead of Mail.app

## Setup

1.  Open `MailtoHandler.app`
2.  A configuration window will appear
3.  Enter the "compose URL" for your webmail provider. This URL should contain placeholders for the email fields.  Gmail's URL is pre-populated
4.  Click "Register mailto: Handler"

### Placeholders

Your compose URL can contain the following placeholders, which will be replaced with the corresponding data from the `mailto:` link:

-   `{recipient}`
-   `{subject}`
-   `{cc}`
-   `{bcc}`
-   `{body}`

### Example URLs

Here are some example compose URLs:

**Gmail:**
`https://mail.google.com/mail/?view=cm&to={recipient}&cc={cc}&bcc={bcc}&su={subject}&body={body}`

(The following are AI generated and un-tested as I don't have accounts with any of them):

**Outlook.com:**
`https://outlook.live.com/mail/0/deeplink/compose?to={recipient}&subject={subject}&cc={cc}&body={body}`

**Yahoo Mail:**
`https://compose.mail.yahoo.com/?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}`

**ProtonMail:**
`https://mail.proton.me/u/0/compose?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}`
