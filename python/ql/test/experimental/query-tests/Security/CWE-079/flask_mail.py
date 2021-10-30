from flask import request, Flask
from flask_mail import Mail, Message

app = Flask(__name__)
mail = Mail(app)

@app.route("/send")
def send():
  msg = Message(subject="Subject",
                sender="from@example.com",
                recipients=["to@example.com"],
                body="plain-text body",
                html=request.args["html"])

  # The message can contain a body and/or HTML:
  msg.body = "plain-text body"
  # The email's HTML can be set via msg.html or as an initialize argument when creating a Message object.
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
