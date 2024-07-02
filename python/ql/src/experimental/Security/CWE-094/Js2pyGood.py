@bp.route("/good")
def good():
    # disable python imports to prevent execution of malicious code 
    js2py.disable_pyimport()
    jk = flask.request.form["jk"]
    jk = eval_js(f"{jk} f()")
