from flask import Flask, session
from secrets import token_hex

app = Flask(__name__)

SECRET_KEY = token_hex(16)


@app.route('/')
def index():
    if 'logged_in' not in session:
        session['logged_in'] = False

    if session['logged_in']:
        return '<h1>You are logged in!</h1>'
    else:
        return '<h1>Access Denied</h1>', 403


if __name__ == '__main__':
    app.run()
