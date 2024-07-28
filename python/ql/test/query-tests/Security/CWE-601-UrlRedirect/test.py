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

from django.utils.http import url_has_allowed_host_and_scheme
import math 

@app.route('/ok6')
def ok6():
    untrusted = request.args.get('target', '')
    # random chance. 
    if math.random() > 0.5:
        redirect(untrusted, code=302) # NOT OK
    if url_has_allowed_host_and_scheme(untrusted, allowed_hosts=None):
        return redirect(untrusted, code=302) # OK
    
    return redirect("https://example.com", code=302) # OK

import yarl

@app.route('/ok7')
def ok7():
    untrusted = request.args.get('target', '')
    untrusted = untrusted.replace("\\", "/")
    if not yarl.URL(untrusted).is_absolute():
        return redirect(untrusted, code=302) # OK
    return redirect("/", code=302)

@app.route('/not_ok5')
def not_ok5():
    untrusted = request.args.get('target', '')
    # no backslash replace
    if not yarl.URL(untrusted).is_absolute():
        return redirect(untrusted, code=302) # NOT OK
    return redirect("/", code=302)

from urllib.parse import urlparse

@app.route('/ok8')
def ok8():
    untrusted = request.args.get('target', '')
    untrusted = untrusted.replace("\\", "/")
    if not urlparse(untrusted).netloc:
        return redirect(untrusted, code=302) # OK
    return redirect("/", code=302)

@app.route('/ok9')
def ok9():
    untrusted = request.args.get('target', '')
    untrusted = untrusted.replace("\\", "/")
    if urlparse(untrusted).netloc == "":
        return redirect(untrusted, code=302) # OK
    return redirect("/", code=302)

@app.route('/not_ok6')
def not_ok6():
    untrusted = request.args.get('target', '')
    # no backslash replace
    if not urlparse(untrusted).netloc:
        return redirect(untrusted, code=302) # NOT OK
    return redirect("/", code=302)

@app.route('/not_ok7')
def not_ok7():
    untrusted = request.args.get('target', '')
    # wrong check
    if urlparse(untrusted).netloc != "":
        return redirect(untrusted, code=302) # NOT OK
    return redirect("/", code=302)

@app.route('/ok10')
def ok10():
    untrusted = request.args.get('target', '')
    untrusted = untrusted.replace("\\", "/")
    if urlparse(untrusted).netloc in ["", request.host]:
        return redirect(untrusted, code=302) # OK
    return redirect("/", code=302)

@app.route('/ok11')
def ok11():
    untrusted = request.args.get('target', '')
    untrusted = untrusted.replace("\\", "/")
    if urlparse(untrusted).netloc not in ["", request.host]:
        return redirect("/", code=302) # OK
    return redirect(untrusted, code=302)
