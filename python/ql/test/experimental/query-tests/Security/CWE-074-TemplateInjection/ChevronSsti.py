from flask import Flask, request
import chevron


app = Flask(__name__)


@app.route('/other')
def a():
    template = request.args.get('template')
    return chevron.render(template, {"key": "value"})


@app.route('/other2')
def b():
    template = request.args.get('template')
    args = {
        'template': template,

        'data': {
            'key': 'value'
        }
    }
    return chevron.render(**args)
