from flask import Flask
app = Flask(__name__)


import traceback

def do_computation():
    raise Exception("Secret info")

# BAD
@app.route('/bad')
def server_bad():
    try:
        do_computation()
    except Exception as e:
        return traceback.format_exc()

# GOOD
@app.route('/good')
def server_good():
    try:
        do_computation()
    except Exception as e:
        log(traceback.format_exc())
        return "An internal error has occurred!"
