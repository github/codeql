

from bottle import Bottle, route, request, redirect, response

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


@route('/wrong/url')
def safe():
    redirect("/right/url")

@route('/wrong/<where>')
def unsafe(where="/right/url"):
    redirect(where)

@route('/args')
def unsafe2():
    redirect(request.query.where, code)

@route('/xss')
def maybe_xss():
    response.body = "name is " + request.query.name
