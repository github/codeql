# this test is similar to source_test.py, but does not have a global import of flask.request

import flask

from flask import Flask
app = Flask(__name__)


@app.route("/import_inside_function") # $ routeSetup="/import_inside_function"
def test_sources(): # $ requestHandler
    # but imports inside the function should also be allowed
    from flask import request

    # we've had problems with multiple paths being shown with flask sources, when the
    # request is used multiple time. So this test goes together with `SourceTest.ql`
    if "foo" in request.args:
        user_controlled = request.args["foo"]
        SINK(user_controlled)


@app.route("/ref_flask.request") # $ routeSetup="/ref_flask.request"
def test_ref(): # $ requestHandler
    if "foo" in flask.request.args:
        user_controlled = flask.request.args["foo"]
        SINK(user_controlled)


if __name__ == "__main__":
    app.run(debug=True)
