# https://pythonhosted.org/Flask-Mail/
# https://github.com/mattupstate/flask-mail/blob/1709c70d839a7cc7b1f7eeb97333b71cd420fe32/flask_mail.py#L239

# tmp: this test cover RFS to any part of the message, but can be shortened to a specific part (body&html) once we decide the objective of the query.
from flask_mail import Mail, Message

app = Flask(__name__)
mail = Mail(app)

@app.route("/send")
def send():
  msg = Message(subject=request.args["subject"],
                sender=request.args["sender"],
                recipients=list(request.args["recipient"]),
                body=request.args["body"],
                html=request.args["html"])

  # The message can contain a body and/or HTML:
  msg.body = "test"
  msg.html = "<b>test</b>"

  mail.send(msg)

@app.route("/connect")
def connect():
  """
  Minimal example to test mail.connect() usage
  """
  with mail.connect() as conn:
    msg = Message(subject=request.args["subject"],
                  sender=request.args["sender"],
                  recipients=list(request.args["recipient"]),
                  body=request.args["html"])
    conn.send(msg)
