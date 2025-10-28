# MailtoHandler

[**Download MailtoHandler.dmg**](https://github.com/VoiceNGO/MailtoHandler/raw/main/MailtoHandler.dmg)

A simple macOS app that opens mailto: links in a web-based email service instead of Mail.app

## Setup

1.  Open `MailtoHandler.app`
2.  A configuration window will appear
3.  Enter the "compose URL" for your webmail provider. This URL should contain placeholders for the email fields. Gmail's URL is pre-populated
4.  Click "Register mailto: Handler"

### Placeholders

Your compose URL can contain the following placeholders, which will be replaced with the corresponding data from the `mailto:` link:

- `{recipient}`
- `{subject}`
- `{cc}`
- `{bcc}`
- `{body}`

### Example URLs

<table>
  <tr>
    <th>Provider</th>
    <th>Compose URL</th>
  </tr>
  <tr>
    <td>Gmail</td>
    <td><code>https://mail.google.com/mail/?view=cm&to={recipient}&cc={cc}&bcc={bcc}&su={subject}&body={body}</code></td>
  </tr>
  <tr>
    <td colspan="2">
      <br>
      <em><strong>The following are AI generated and un-tested</strong></em>
      <br>&nbsp;
    </td>
  </tr>
  <tr>
    <td>Outlook.com</td>
    <td><code>https://outlook.live.com/mail/0/deeplink/compose?to={recipient}&subject={subject}&cc={cc}&body={body}</code></td>
  </tr>
  <tr>
    <td>Yahoo Mail</td>
    <td><code>https://compose.mail.yahoo.com/?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}</code></td>
  </tr>
  <tr>
    <td>ProtonMail</td>
    <td><code>https://mail.proton.me/u/0/compose?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}</code></td>
  </tr>
  <tr>
    <td>iCloud Mail</td>
    <td><code>https://www.icloud.com/mail?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}</code></td>
  </tr>
  <tr>
    <td>Zoho Mail</td>
    <td><code>https://mail.zoho.com/zm/#compose/to={recipient}/cc/{cc}/bcc/{bcc}/subject/{subject}/content/{body}</code></td>
  </tr>
  <tr>
    <td>AOL Mail</td>
    <td><code>https://mail.aol.com/webmail-std/en-us/compose?to={recipient}&cc={cc}&bcc={bcc}&subject={subject}&body={body}</code></td>
  </tr>
  <tr>
    <td>GMX Mail</td>
    <td><code>https://www.gmx.com/mail/compose?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}</code></td>
  </tr>
  <tr>
    <td>Tutanota</td>
    <td><code>https://mail.tutanota.com/compose?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}</code></td>
  </tr>
  <tr>
    <td>Mail.com</td>
    <td><code>https://www.mail.com/mail/compose?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}</code></td>
  </tr>
  <tr>
    <td>Fastmail</td>
    <td><code>https://www.fastmail.com/action/compose/?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}</code></td>
  </tr>
  <tr>
    <td>Hushmail</td>
    <td><code>https://www.hushmail.com/msg/compose?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}</code></td>
  </tr>
  <tr>
    <td>Mailfence</td>
    <td><code>https://mailfence.com/compose?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}</code></td>
  </tr>
  <tr>
    <td>Runbox</td>
    <td><code>https://runbox.com/mail/compose?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}</code></td>
  </tr>
  <tr>
    <td>Neo</td>
    <td><code>https://app.neo.space/mail/compose?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}</code></td>
  </tr>
  <tr>
    <td>Titan</td>
    <td><code>https://app.titan.email/compose?to={recipient}&subject={subject}&cc={cc}&bcc={bcc}&body={body}</code></td>
  </tr>
  <tr>
    <td>10 Minute Mail</td>
    <td><code>https://10minutemail.com/compose?to={recipient}&subject={subject}&body={body}</code></td>
  </tr>
</table>


### Your provider isn't listed?

Search for "**[your provider name] compose URL parameters**" to find the compose URL format for your email provider. Look for documentation on how to pre-fill compose fields via URL parameters.
