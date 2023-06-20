from bottle import Bottle, route, request, redirect, response, SimpleTemplate
from Cheetah.Template import Template


app = Bottle()


@route('/other')
def a():
    return Template("sink")


class Template3(Template):
    title = 'Hello World Example!'
    contents = 'Hello World!'


@route('/other2')
def b():
    t3 = Template3("sink")
