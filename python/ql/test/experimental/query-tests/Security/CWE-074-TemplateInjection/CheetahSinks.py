from flask import Flask, request
from Cheetah.Template import Template


app = Flask(__name__)


@app.route('/other')
def a():
    template = request.args.get('template')
    return Template(template)


class Template3(Template):
    title = 'Hello World Example!'
    contents = 'Hello World!'


@app.route('/other2')
def b():
    template = request.args.get('template')
    t3 = Template3(template)
