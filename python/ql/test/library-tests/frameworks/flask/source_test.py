from flask import Flask, request
app = Flask(__name__)


@app.route("/example") # $ routeSetup="/example"
def test_sources(): # $ requestHandler
    # we've had problems with multiple paths being shown with flask sources, when the
    # request is used multiple time. So this test goes together with `SourceTest.ql`
    if "foo" in request.args:
        user_controlled = request.args["foo"]
        SINK(user_controlled)


@app.route("/example2") # $ routeSetup="/example2"
def test_sources(): # $ requestHandler
    if cond:
        user_controlled = request.args["foo"]
    else:
        user_controlled = request.args["bar"]
    SINK(user_controlled)


if __name__ == "__main__":
    app.run(debug=True)
