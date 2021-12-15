import flask

from flask import Flask, request, make_response
app = Flask(__name__)

@app.route("/")
def hello_world():
    return "Hello World!"

from flask.views import MethodView

class MyView(MethodView):

    def get(self, user_id):
        if user_id is None:
            # return a list of users
            pass
        else:
            # expose a single user
            pass

the_view = MyView.as_view('my_view')

app.add_url_rule('/the/', defaults={'user_id': None},
                 view_func=the_view, methods=['GET',])

@app.route("/dangerous")
def dangerous():
    return request.args.get('payload')

@app.route("/dangerous-with-cfg-split")
def dangerous2():
    x = request.form['param0']
    if request.method == "POST":
        return request.form['param1']
    return None

@app.route('/unsafe')
def unsafe():
    first_name = request.args.get('name', '')
    return make_response("Your name is " + first_name)

@app.route('/safe')
def safe():
    first_name = request.args.get('name', '')
    return make_response("Your name is " + escape(first_name))

@app.route('/hello/<name>')
def hello(name):
    return make_response("Your name is " + name)

@app.route('/foo/<path:subpath>')
def foo(subpath):
    return make_response("The subpath is " + subpath)

@app.route('/multiple/') # TODO: not recognized as route
@app.route('/multiple/foo/<foo>') # TODO: not recognized as route
@app.route('/multiple/bar/<bar>')
def multiple(foo=None, bar=None):
    return make_response("foo={!r} bar={!r}".format(foo, bar))

@app.route('/complex/<string(length=2):lang_code>')
def complex(lang_code):
    return make_response("lang_code {}".format(lang_code))

if __name__ == "__main__":
    app.run(debug=True)
