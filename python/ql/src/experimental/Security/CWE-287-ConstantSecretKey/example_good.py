from flask import Flask, session
from secrets import token_hex

app = Flask(__name__)
app.config['SECRET_KEY'] = token_hex(64)


@app.route('/')
def DEB_EX():
    if 'logged_in' not in session:
        session['logged_in'] = False
    if session['logged_in']:
        return app.secret_key
    else:
        return app.secret_key, 403


if __name__ == '__main__':
    app.run()
