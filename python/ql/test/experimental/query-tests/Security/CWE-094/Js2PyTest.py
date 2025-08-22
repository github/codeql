
import flask
from js2py import eval_js, disable_pyimport

bp = flask.Blueprint("app", __name__, url_prefix="/")

@bp.route("/bad")
def bad():
    jk = flask.request.form["jk"]
    jk = eval_js(f"{jk} f()")