# This tests that the developer doesn't pass tainted user data into the mail.send.post() method in the SendGrid library.
import sendgrid
import os


sg = sendgrid.SendGridAPIClient(os.environ.get('SENDGRID_API_KEY'))

data = {
    "content": [
        {
            "type": "text/html",
            "value": "<html><p>Hello, world!</p><img src=[CID GOES HERE]></img></html>"
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
            "html": "<p>Thanks</br>The SendGrid Team</p>",
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
            "html": "If you would like to unsubscribe and stop receiving these emails <% clickhere %>.",
            "substitution_tag": "<%click here%>",
            "text": "If you would like to unsubscribe and stop receiving these emails <% click here %>."
        }
    }
}

response = sg.client.mail.send.post(request_body=data)
