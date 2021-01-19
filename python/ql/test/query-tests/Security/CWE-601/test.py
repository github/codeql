from flask import Flask, request, redirect

app = Flask(__name__)

@app.route('/')
def hello():
    target = request.args.get('target', '')
    return redirect(target, code=302)


# Check for safe prefixes

@app.route('/ok')
def ok():
    untrusted = request.args.get('target', '')
    safe = "https://safe.com/"
    safe += untrusted
    return redirect(safe, code=302)


@app.route('/ok2')
def ok2():
    untrusted = request.args.get('target', '')
    safe = "https://safe.com/" + untrusted
    return redirect(safe, code=302)


@app.route('/ok3')
def ok3():
    untrusted = request.args.get('target', '')
    safe = "https://safe.com/{}".format(untrusted)
    return redirect(safe, code=302) # FP


@app.route('/ok4')
def ok4():
    untrusted = request.args.get('target', '')
    safe = f"https://safe.com/{untrusted}"
    return redirect(safe, code=302) # FP


@app.route('/ok5')
def ok5():
    untrusted = request.args.get('target', '')
    safe = "https://safe.com/%s" % untrusted
    return redirect(safe, code=302) # FP


@app.route('/const-str-compare')
def const_str_compare():
    target = request.args.get('target', '')
    if target == "example.com/":
        return redirect(target, code=302)


# Check that our sanitizer is not too broad

@app.route('/not_ok1')
def not_ok1():
    untrusted = request.args.get('target', '')
    unsafe = untrusted + "?login=success"
    return redirect(unsafe, code=302)


@app.route('/not_ok2')
def not_ok2():
    untrusted = request.args.get('target', '')
    unsafe = "{}?login=success".format(untrusted)
    return redirect(unsafe, code=302)


@app.route('/not_ok3')
def not_ok3():
    untrusted = request.args.get('target', '')
    unsafe = f"{untrusted}?login=success"
    return redirect(unsafe, code=302)


@app.route('/not_ok4')
def not_ok4():
    untrusted = request.args.get('target', '')
    unsafe = "%s?login=success" % untrusted
    return redirect(unsafe, code=302)
