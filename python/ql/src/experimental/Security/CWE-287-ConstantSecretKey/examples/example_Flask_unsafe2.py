from flask import Flask, session

app = Flask(__name__)
aConstant = 'CHANGEME1'
SECRET_KEY = aConstant
app.config.from_object(__name__)


@app.route('/')
def DEB_EX():
    if 'logged_in' not in session:
        session['logged_in'] = 'value'
    # debugging whether secret_key is secure or not
    return app.secret_key, session.__str__()


if __name__ == '__main__':
    app.run()
