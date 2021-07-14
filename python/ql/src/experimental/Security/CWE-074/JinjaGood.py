from django.urls import path
from django.http import HttpResponse
from jinja2 import Template as Jinja2_Template
from jinja2 import Environment, DictLoader, escape


def a(request):
    # Load the template
    template = request.GET['template']
    env = SandboxedEnvironment(undefined=StrictUndefined)
    t = env.from_string(template)
    name = request.GET['name']
    # Render the template with the context data
    html = t.render(name=escape(name))
    return HttpResponse(html)


urlpatterns = [
    path('a', a),
]
