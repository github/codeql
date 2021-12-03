from bottle import Bottle, route, request, redirect, response, SimpleTemplate
import chevron


app = Bottle()


@route('/other')
def a():
    return chevron.render("sink", {"key": "value"})


@route('/other2')
def b():
    sink = {
        'template': "template",

        'data': {
            'key': 'value'
        }
    }
    return chevron.render(**sink)
