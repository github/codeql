from flask import Flask, redirect
from flask.views import MethodView
import flask_admin

ensure_tainted = ensure_not_tainted = print


app = Flask(__name__)

# unknown at least for our current analysis
foo = "'/foo'"
UNKNOWN_ROUTE = eval(foo) # $ getCode=foo


class ExampleClass(flask_admin.BaseView):
    @flask_admin.expose('/')
    def foo(self): # $ MISSING: requestHandler
        return "foo"

    @flask_admin.expose(url='/bar/<arg>')
    def bar(self, arg): # $ MISSING: requestHandler
        ensure_tainted(arg) # $ MISSING: tainted
        return "bar: " + arg

    @flask_admin.expose_plugview("/flask-class")
    @flask_admin.expose_plugview(url="/flask-class/<arg>")
    class Nested(MethodView):
        def get(self, cls, arg="default"): # $ requestHandler routedParameter=arg SPURIOUS: routedParameter=cls
            assert isinstance(cls, ExampleClass)
            ensure_tainted(arg) # $ tainted
            ensure_not_tainted(cls) # $ SPURIOUS: tainted
            return "GET: " + arg

        def post(self, cls, arg): # $ requestHandler routedParameter=arg SPURIOUS: routedParameter=cls
            assert isinstance(cls, ExampleClass)
            ensure_tainted(arg) # $ tainted
            ensure_not_tainted(cls) # $ SPURIOUS: tainted
            return "POST: " + arg

    @flask_admin.expose_plugview(UNKNOWN_ROUTE)
    class WithUnknownRoute(MethodView):
        def get(self, cls, maybeRouted): # $ requestHandler routedParameter=maybeRouted SPURIOUS: routedParameter=cls
            ensure_tainted(maybeRouted) # $ tainted
            ensure_not_tainted(cls) # $ SPURIOUS: tainted
            return "ok"


@app.route('/') # $ routeSetup="/"
def index(): # $ requestHandler
    return redirect('/admin') # $ HttpRedirectResponse HttpResponse redirectLocation='/admin'


if __name__ == "__main__":
    admin = flask_admin.Admin(app, name="Some Admin Interface")
    admin.add_view(ExampleClass())

    print(app.url_map)
    app.run(debug=True)
