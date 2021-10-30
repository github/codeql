# This test checks that the developer doesn't pass a MIMEText instance to a MIMEMultipart message.
from flask import Flask, request
import json
import smtplib, ssl
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

app = Flask(__name__)

@app.route("/")
def email_person():
    sender_email = "sender@gmail.com"
    receiver_email = "receiver@example.com"

    message = MIMEMultipart("alternative")
    message["Subject"] = "multipart test"
    message["From"] = sender_email
    message["To"] = receiver_email

    name = request.args['name']
    # Create the plain-text and HTML version of your message
    text = "hello there"
    html = f"hello {name}"  

    # Turn these into plain/html MIMEText objects
    part1 = MIMEText(text, "plain")
    part2 = MIMEText(html, "html")

    # Add HTML/plain-text parts to MIMEMultipart message
    # The email client will try to render the last part first
    message.attach(part1)
    message.attach(part2)

    # Create secure connection with server and send email
    context = ssl.create_default_context()
    server = smtplib.SMTP_SSL("smtp.gmail.com", 465, context=context)

    server.login(sender_email, "SERVER_PASSWORD")
    server.sendmail(
        sender_email, receiver_email, message.as_string()
    )


# if __name__ == "__main__":
#     app.run(debug=True)
