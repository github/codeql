# This tests that the developer doesn't pass content via the Content class initializer.
# source:https://github.com/sendgrid/sendgrid-python

import sendgrid
import os
from sendgrid.helpers.mail import *

sg = sendgrid.SendGridAPIClient(api_key=os.environ.get('SENDGRID_API_KEY'))
from_email = Email("test@example.com")
to_email = To("test@example.com")
subject = "Sending with SendGrid is Fun"
content = Content("text/html", "and <b>easy</b> to do anywhere, even with Python") # Content can also take the MimeType.html as the first arg here. Need to create a separate example for this.

mail = Mail(from_email, to_email, subject, content)

response = sg.client.mail.send.post(request_body=mail.get())
