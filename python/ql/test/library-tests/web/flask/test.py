import flask

from flask import Flask, request, make_response
app = Flask(__name__)

@app.route("/")
def hello():
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
