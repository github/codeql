from bottle import Bottle, route, request, redirect, response, SimpleTemplate
from bottle import template as temp


app = Bottle()


@route('/other')
def a():
    template = request.query.template
    tpl = SimpleTemplate(template)
    tpl.render(name='World')
    return tmp


@route('/other2')
def b():
    template = request.query.template
    temp(template, name='World')
    return tmp
