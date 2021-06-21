# This tests that the user can't send multiple vulnerable emails.
# source: https://pythonhosted.org/Flask-Mail/

from flask_mail import Message

@app.route("/")
def index():
  with mail.connect() as conn:
      for user in users:
          message = '...'
          subject = "hello, %s" % user.name
          msg = Message(recipients=[user.email],
                        html=message,
                        subject=subject)

          conn.send(msg)
