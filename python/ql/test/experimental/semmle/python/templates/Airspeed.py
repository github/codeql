from bottle import Bottle, route, request, redirect, response
import airspeed


app = Bottle()


@route('/other')
def a():
    return airspeed.Template("sink")
