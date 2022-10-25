import sendgrid
import os
from flask import request, Flask

app = Flask(__name__)


@app.route("/sendgrid")
def send():
    sg = sendgrid.SendGridAPIClient(os.environ.get('SENDGRID_API_KEY'))

    data = {
        "content": [
            {
                "type": "text/html",
                "value": "<html>{}</html>".format(request.args["html_content"])
            }
        ],
        "from": {
            "email": "sam.smith@example.com",
            "name": "Sam Smith"
        },
        "headers": {},
        "mail_settings": {
            "footer": {
                "enable": True,
                "html": "<html>{}</html>".format(request.args["html_footer"]),
                "text": "Thanks,/n The SendGrid Team"
            },
        },
        "reply_to": {
            "email": "sam.smith@example.com",
            "name": "Sam Smith"
        },
        "send_at": 1409348513,
        "subject": "Hello, World!",
        "template_id": "[YOUR TEMPLATE ID GOES HERE]",
        "tracking_settings": {
            "subscription_tracking": {
                "enable": True,
                "html": "<html>{}</html>".format(request.args["html_tracking"]),
                "substitution_tag": "<%click here%>",
                "text": "If you would like to unsubscribe and stop receiving these emails <% click here %>."
            }
        }
    }

    response = sg.client.mail.send.post(request_body=data)
