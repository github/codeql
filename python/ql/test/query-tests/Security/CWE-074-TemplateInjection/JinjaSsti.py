from django.urls import path
from django.http import HttpResponse
from jinja2 import Template 
from jinja2 import Environment, DictLoader, escape


def a(request):
    # Load the template
    template = request.GET['template']
    t = Template(template) # BAD: Template constructed from user input
    name = request.GET['name']
    # Render the template with the context data
    html = t.render(name=escape(name))
    return HttpResponse(html)

def b(request):
    import jinja2
    # Load the template
    template = request.GET['template']
    env = Environment()
    t = env.from_string(template) # BAD: Template constructed from user input
    name = request.GET['name']
    # Render the template with the context data
    html = t.render(name=escape(name))
    return HttpResponse(html)


urlpatterns = [
    path('a', a),
    path('b', b)
]
