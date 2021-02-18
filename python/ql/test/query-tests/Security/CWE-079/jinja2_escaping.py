
Environment(loader=templateLoader, autoescape=fake_func())
from flask import Flask, request, make_response, escape
from jinja2 import Environment, select_autoescape, FileSystemLoader, Template

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

# Explicit autoescape

e = Environment(
    loader=loader,
    autoescape=select_autoescape(['html', 'htm', 'xml'])
) # GOOD

# Additional checks with flow.
auto = select_autoescape
e = Environment(autoescape=auto) # GOOD
z = 0
e = Environment(autoescape=z) # BAD
E = Environment
E() # BAD
E(autoescape=z) # BAD
E(autoescape=auto) # GOOD
E(autoescape=0+1) # GOOD

def checked(cond=False):
    if cond:
        e = Environment(autoescape=cond) # GOOD


unsafe_tmpl = Template('Hello {{ name }}!')
safe1_tmpl = Template('Hello {{ name }}!', autoescape=True)
safe2_tmpl = Template('Hello {{ name }}!', autoescape=select_autoescape())
