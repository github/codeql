# https://pythonhosted.org/Flask-Mail/
# https://github.com/mattupstate/flask-mail/blob/1709c70d839a7cc7b1f7eeb97333b71cd420fe32/flask_mail.py#L239

from flask import request, Flask
from flask_mail import Mail, Message

app = Flask(__name__)
mail = Mail(app)

@app.route("/send")
def send():
  msg = Message(subject="Subject",
                sender="from@example.com",
                recipients=["to@example.com"],
                body="body",
                html=request.args["html"])

  # The message can contain a body and/or HTML:
  msg.body = "body"
  msg.html = request.args["html"]

  mail.send(msg)

@app.route("/connect")
def connect():
  """
  Minimal example to test mail.connect() usage
  """
  with mail.connect() as conn:
    msg = Message(subject="Subject",
                  sender="from@example.com",
                  recipients=["to@example.com"],
                  html=request.args["html"])
    conn.send(msg)
