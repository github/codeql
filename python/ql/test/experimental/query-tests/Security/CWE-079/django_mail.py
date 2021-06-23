# https://data-flair.training/blogs/django-send-email/
# Using flask for RFS and django.core.mail as email library

from flask import request, Flask
from django.core.mail import send_mail, mail_admins, mail_managers

app = Flask(__name__)

@app.route("/send")
def send():
  """
  https://github.com/django/django/blob/ca9872905559026af82000e46cde6f7dedc897b6/django/core/mail/__init__.py#L38

  Apparently there's no html_message in send_mass_mail: https://github.com/django/django/blob/ca9872905559026af82000e46cde6f7dedc897b6/django/core/mail/__init__.py#L64
  """
  send_mail("Subject", "body", "from@example.com", ["to@example.com"], html_message=request.args("html"))

@app.route("/internal")
def internal():
  """
  https://github.com/django/django/blob/ca9872905559026af82000e46cde6f7dedc897b6/django/core/mail/__init__.py#L90-L121
  """
  mail_admins("Subject", "body", html_message=request.args("html"))
  mail_managers("Subject", "body", html_message=request.args("html"))
