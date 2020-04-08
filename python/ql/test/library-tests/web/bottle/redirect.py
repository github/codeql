from bottle import Bottle, route, request, redirect, response

app = Bottle()

@route('/wrong/<where>')
def unsafe(where="/right/url"):
    redirect(where)
