# This tests that the developer doesn't pass tainted user data into the mail.send.post() method in the SendGrid library.
# source :https://github.com/sendgrid/sendgrid-python
import sendgrid
import os


sg = sendgrid.SendGridAPIClient(os.environ.get('SENDGRID_API_KEY'))

data = {
    "asm": {
        "group_id": 1,
        "groups_to_display": [
            1,
            2,
            3
        ]
    },
    "attachments": [
        {
            "content": "[BASE64 encoded content block here]",
            "content_id": "ii_139db99fdb5c3704",
            "disposition": "inline",
            "filename": "file1.jpg",
            "name": "file1",
            "type": "jpg"
        }
    ],
    "batch_id": "[YOUR BATCH ID GOES HERE]",
    "categories": [
        "category1",
        "category2"
    ],
    "content": [
        {
            "type": "text/html",
            "value": "<html><p>Hello, world!</p><img src=[CID GOES HERE]></img></html>"
        }
    ],
    "custom_args": {
        "New Argument 1": "New Value 1",
        "activationAttempt": "1",
        "customerAccountNumber": "[CUSTOMER ACCOUNT NUMBER GOES HERE]"
    },
    "from": {
        "email": "sam.smith@example.com",
        "name": "Sam Smith"
    },
    "headers": {},
    "ip_pool_name": "[YOUR POOL NAME GOES HERE]",
    "mail_settings": {
        "bcc": {
            "email": "ben.doe@example.com",
            "enable": True
        },
        "bypass_list_management": {
            "enable": True
        },
        "footer": {
            "enable": True,
            "html": "<p>Thanks</br>The SendGrid Team</p>",
            "text": "Thanks,/n The SendGrid Team"
        },
        "sandbox_mode": {
            "enable": False
        },
        "spam_check": {
            "enable": True,
            "post_to_url": "http://example.com/compliance",
            "threshold": 3
        }
    },
    "personalizations": [
        {
            "bcc": [
                {
                    "email": "sam.doe@example.com",
                    "name": "Sam Doe"
                }
            ],
            "cc": [
                {
                    "email": "jane.doe@example.com",
                    "name": "Jane Doe"
                }
            ],
            "custom_args": {
                "New Argument 1": "New Value 1",
                "activationAttempt": "1",
                "customerAccountNumber": "[CUSTOMER ACCOUNT NUMBER GOES HERE]"
            },
            "headers": {
                "X-Accept-Language": "en",
                "X-Mailer": "MyApp"
            },
            "send_at": 1409348513,
            "subject": "Hello, World!",
            "substitutions": {
                "id": "substitutions",
                "type": "object"
            },
            "to": [
                {
                    "email": "john.doe@example.com",
                    "name": "John Doe"
                }
            ]
        }
    ],
    "reply_to": {
        "email": "sam.smith@example.com",
        "name": "Sam Smith"
    },
    "sections": {
        "section": {
            ":sectionName1": "section 1 text",
            ":sectionName2": "section 2 text"
        }
    },
    "send_at": 1409348513,
    "subject": "Hello, World!",
    "template_id": "[YOUR TEMPLATE ID GOES HERE]",
    "tracking_settings": {
        "click_tracking": {
            "enable": True,
            "enable_text": True
        },
        "ganalytics": {
            "enable": True,
            "utm_campaign": "[NAME OF YOUR REFERRER SOURCE]",
            "utm_content": "[USE THIS SPACE TO DIFFERENTIATE YOUR EMAIL FROM ADS]",
            "utm_medium": "[NAME OF YOUR MARKETING MEDIUM e.g. email]",
            "utm_name": "[NAME OF YOUR CAMPAIGN]",
            "utm_term": "[IDENTIFY PAID KEYWORDS HERE]"
        },
        "open_tracking": {
            "enable": True,
            "substitution_tag": "%opentrack"
        },
        "subscription_tracking": {
            "enable": True,
            "html": "If you would like to unsubscribe and stop receiving these emails <% clickhere %>.",
            "substitution_tag": "<%click here%>",
            "text": "If you would like to unsubscribe and stop receiving these emails <% click here %>."
        }
    }
}

response = sg.client.mail.send.post(request_body=data)
