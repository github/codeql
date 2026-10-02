# MaD Generation Report

## Included (2)

| Package | Class | Method | Type | Kind | Certainty | Reason |
|---------|-------|--------|------|------|-----------|--------|
| org.apache.axis2.transport.mail | MailTransportListener | poll | sink | CWE-918 | 3 | Argument 0 (PollTableEntry) specifies the mail server configuration (host, protocol, credentials) used to establish a network connection to a mail server. If attacker-controlled, this enables SSRF by directing the server to connect to an arbitrary mail host. |
| org.apache.axis2.transport.mail | MailTransportSender | sendMessage | sink | CWE-918 | 3 | Argument 1 (targetAddress) is parsed via InternetAddress.parse() and used to set the target addresses for sending mail via SMTP. This allows the server to be directed to send email (a server-side request) to a user-controlled destination, which is a form of server-side request forgery. |

## Ignored (low certainty) (0)

None.

