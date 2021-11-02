from flask import Flask, redirect
from flask.views import MethodView
import flask_admin

ensure_tainted = ensure_not_tainted = print


app = Flask(__name__)

# unknown at least for our current analysis
foo = "'/foo'"
UNKNOWN_ROUTE = eval(foo) # $ getCode=foo


class ExampleClass(flask_admin.BaseView):
    @flask_admin.expose('/') # $ routeSetup="/"
    def foo(self): # $ requestHandler
        return "foo" # $ HttpResponse

    @flask_admin.expose(url='/bar/<arg>') # $ routeSetup="/bar/<arg>"
    def bar(self, arg): # $ requestHandler routedParameter=arg
        ensure_tainted(arg) # $ tainted
        return "bar: " + arg # $ HttpResponse

    @flask_admin.expose_plugview("/flask-class") # $ routeSetup="/flask-class"
    @flask_admin.expose_plugview(url="/flask-class/<arg>") # $ routeSetup="/flask-class/<arg>"
    class Nested(MethodView):
        def get(self, cls, arg="default"): # $ requestHandler routedParameter=arg
            assert isinstance(cls, ExampleClass)
            ensure_tainted(arg) # $ tainted
            ensure_not_tainted(cls)
            return "GET: " + arg # $ HttpResponse

        def post(self, cls, arg): # $ requestHandler routedParameter=arg
            assert isinstance(cls, ExampleClass)
            ensure_tainted(arg) # $ tainted
            ensure_not_tainted(cls)
            return "POST: " + arg # $ HttpResponse

    @flask_admin.expose_plugview(UNKNOWN_ROUTE) # $ routeSetup
    class WithUnknownRoute(MethodView):
        def get(self, cls, maybeRouted): # $ requestHandler routedParameter=maybeRouted
            ensure_tainted(maybeRouted) # $ tainted
            ensure_not_tainted(cls)
            return "ok" # $ HttpResponse


@app.route('/') # $ routeSetup="/"
def index(): # $ requestHandler
    return redirect('/admin') # $ HttpRedirectResponse HttpResponse redirectLocation='/admin'


if __name__ == "__main__":
    admin = flask_admin.Admin(app, name="Some Admin Interface")
    admin.add_view(ExampleClass())

    print(app.url_map)
    app.run(debug=True)
