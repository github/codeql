from flask import Flask, session
from secrets import token_hex

app = Flask(__name__)
app.secret_key = token_hex(16)
app.config.from_pyfile("config3.py")


@app.route('/')
def CheckForSecretKeyValue():
    # debugging whether secret_key is secure or not
    return app.secret_key, session.get('logged_in')


if __name__ == '__main__':
    app.run()
