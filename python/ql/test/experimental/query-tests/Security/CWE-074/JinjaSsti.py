from django.urls import path
from django.http import HttpResponse
from jinja2 import Template as Jinja2_Template
from jinja2 import Environment, DictLoader, escape


def a(request):
    # Load the template
    template = request.GET['template']
    t = Jinja2_Template(template)
    name = request.GET['name']
    # Render the template with the context data
    html = t.render(name=escape(name))
    return HttpResponse(html)

def b(request):
    import jinja2
    # Load the template
    template = request.GET['template']
    t = jinja2.from_string(template)
    name = request.GET['name']
    # Render the template with the context data
    html = t.render(name=escape(name))
    return HttpResponse(html)


urlpatterns = [
    path('a', a),
    path('b', b)
]
