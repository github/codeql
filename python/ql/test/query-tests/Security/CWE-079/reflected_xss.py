from flask import Flask, request, make_response, escape

app = Flask(__name__)

@app.route('/unsafe')
def unsafe():
    first_name = request.args.get('name', '')
    return make_response("Your name is " + first_name)

@app.route('/safe')
def safe():
    first_name = request.args.get('name', '')
    return make_response("Your name is " + escape(first_name))

urlpatterns = [
    url(r'^r1$', response_unsafe, name='response-unsafe'),
    url(r'^r2$', response_safe, name='response-safe')
]
