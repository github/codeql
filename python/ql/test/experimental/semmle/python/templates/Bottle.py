from bottle import Bottle, route, request, redirect, response, SimpleTemplate
from bottle import template as temp


app = Bottle()


@route('/other')
def a():
    template = "test"
    tpl = SimpleTemplate(template)


@route('/other2')
def b():
    template = "test"
    return temp(template, name='World')
