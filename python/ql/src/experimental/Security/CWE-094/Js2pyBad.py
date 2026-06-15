@bp.route("/bad")
def bad():
    jk = flask.request.form["jk"]
    jk = eval_js(f"{jk} f()")
