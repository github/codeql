from flask import Flask, request, make_response
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

#BAD
@app.route('/bad/with-flow')
def server_bad_flow():
    try:
        do_computation()
    except Exception as e:
        err = traceback.format_exc()
        return format_error(err)

def format_error(msg):
    return "[ERROR] " + msg

#Unrelated error
@app.route('/maybe_xss')
def maybe_xss():
    return make_response(request.args.get('name', ''))
