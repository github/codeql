from flask import Flask, session

app = Flask(__name__)
aConstant = 'CHANGEME1'
app.config['SECRET_KEY'] = aConstant
app.secret_key = aConstant
app.config.update(SECRET_KEY=aConstant)
app.config.from_mapping(SECRET_KEY=aConstant)
app.config.from_pyfile("config.py")
app.config.from_pyfile("config2.py")
app.config.from_object('config.Config')
app.config.from_object('config2.Config')
app.config.from_object('settings')


@app.route('/')
def CheckForSecretKeyValue():
    # debugging whether secret_key is secure or not
    return app.secret_key, session.get('logged_in')


if __name__ == '__main__':
    app.run()
