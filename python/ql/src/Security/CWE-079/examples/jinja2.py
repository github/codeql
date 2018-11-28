from flask import Flask, request, make_response, escape
from jinja2 import Environment, select_autoescape, FileSystemLoader

app = Flask(__name__)
loader = FileSystemLoader( searchpath="templates/" )

unsafe_env = Environment(loader=loader)
safe1_env = Environment(loader=loader, autoescape=True)
safe2_env = Environment(loader=loader, autoescape=select_autoescape())

def render_response_from_env(env):
    name = request.args.get('name', '')
    template = env.get_template('template.html')
    return make_response(template.render(name=name))

@app.route('/unsafe')
def unsafe():
    return render_response_from_env(unsafe_env)

@app.route('/safe1')
def safe1():
    return render_response_from_env(safe1_env)

@app.route('/safe2')
def safe2():
    return render_response_from_env(safe2_env)

