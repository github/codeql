from flask import Flask

app = Flask(__name__)

@app.route('/crash')
def main():
    raise Exception()

app.run(debug=True)
