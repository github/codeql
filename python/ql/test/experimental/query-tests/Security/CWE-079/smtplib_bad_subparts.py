# This test checks that the developer doesn't pass a MIMEText instance to a MIMEMultipart initializer via the subparts parameter.
from flask import Flask, request
import json
import smtplib
import ssl
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

app = Flask(__name__)


@app.route("/")
def email_person():
    sender_email = "sender@gmail.com"
    receiver_email = "receiver@example.com"

    name = request.args['search']
    # Create the plain-text and HTML version of your message
    text = "hello there"
    html = f"hello {name}"

    # Turn these into plain/html MIMEText objects
    part1 = MIMEText(text, "plain")
    part2 = MIMEText(html, "html")

    message = MIMEMultipart(_subparts=(part1, part2))
    message["Subject"] = "multipart test"
    message["From"] = sender_email
    message["To"] = receiver_email

    # Create secure connection with server and send email
    context = ssl.create_default_context()
    server = smtplib.SMTP_SSL("smtp.gmail.com", 465, context=context)

    server.login(sender_email, "SERVER_PASSWORD")
    server.sendmail(
        sender_email, receiver_email, message.as_string()
    )


# if __name__ == "__main__":
#     app.run(debug=True)
