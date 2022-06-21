from flask import request, Flask
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail, Email, To, Content, MimeType, HtmlContent

app = Flask(__name__)


@app.route("/send")
def send():
    message = Mail(
        from_email='from_email@example.com',
        to_emails='to@example.com',
        subject='Sending with Twilio SendGrid is Fun',
        html_content=request.args["html_content"])

    sg = SendGridAPIClient('SENDGRID_API_KEY')
    sg.send(message)


@app.route("/send-HtmlContent")
def send():
    message = Mail(
        from_email='from_email@example.com',
        to_emails='to@example.com',
        subject='Sending with Twilio SendGrid is Fun',
        html_content=HtmlContent(request.args["html_content"]))

    sg = SendGridAPIClient('SENDGRID_API_KEY')
    sg.send(message)


@app.route("/send_post")
def send_post():
    from_email = Email("test@example.com")
    to_email = To("test@example.com")
    subject = "Sending with SendGrid is Fun"
    html_content = Content("text/html", request.args["html_content"])
    plain_content = Content("text/plain", request.args["plain_content"])

    mail = Mail(from_email, to_email, subject, plain_content, html_content)

    sg = SendGridAPIClient(api_key='SENDGRID_API_KEY')
    response = sg.client.mail.send.post(request_body=mail.get())


@app.route("/send_post2")
def send_post2():
    from_email = Email("test@example.com")
    to_email = To("test@example.com")
    subject = "Sending with SendGrid is Fun"
    html_content = Content(MimeType.html, request.args["html_content"])
    plain_content = Content(MimeType.text, request.args["plain_content"])

    mail = Mail(from_email, to_email, subject, plain_content, html_content)

    sg = SendGridAPIClient(api_key='SENDGRID_API_KEY')
    response = sg.client.mail.send.post(request_body=mail.get())
