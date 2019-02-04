

from bottle import Bottle, route, request

app = Bottle()

@app.route('/hello/<name>')
def hello(name = "World!"):
    return "Hello " + name

@route('/bye/<name>')
def bye(name = "World!"):
    return "Bye " + name


@route('/other')
def other():
    name = request.cookies.username
    return "User name is " + name
