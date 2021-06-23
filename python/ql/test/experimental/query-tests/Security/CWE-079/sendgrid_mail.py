# https://www.twilio.com/blog/how-to-send-emails-in-python-with-sendgrid

from flask import request, Flask
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail, Email, To, Content, MimeType

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

@app.route("/send_post")
def send_post():
  from_email = Email("test@example.com")
  to_email = To("test@example.com")
  subject = "Sending with SendGrid is Fun"
  content = Content("text/html", request.args["html_content"]) 

  # https://github.com/sendgrid/sendgrid-python/blob/cf0924c35c37bbec8e5ca39e963a55f54f0eec11/sendgrid/helpers/mail/mime_type.py#L1
  content = Content(MimeType.html, request.args["html_content"]) 

  mail = Mail(from_email, to_email, subject, content)

  sg = SendGridAPIClient(api_key='SENDGRID_API_KEY')
  response = sg.client.mail.send.post(request_body=mail.get())
