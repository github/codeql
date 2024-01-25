from flask import Flask, session

app = Flask(__name__)
aConstant = 'CHANGEME1'
app.config['SECRET_KEY'] = aConstant
app.secret_key = aConstant
app.config.update(SECRET_KEY=aConstant)
app.config.from_mapping(SECRET_KEY=aConstant)
app.config.from_pyfile("config.py")
app.config.from_object('config.Config')


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
