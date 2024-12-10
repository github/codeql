from django.urls import path
from django.http import HttpResponse
from jinja2 import escape
from jinja2.sandbox import SandboxedEnvironment


def a(request):
    env = SandboxedEnvironment()
    template = request.GET['template']

    # GOOD: A sandboxed environment is used to construct the template. 
    t = env.from_string(template)

    name = request.GET['name']
    html = t.render(name=escape(name))
    return HttpResponse(html)


urlpatterns = [
    path('a', a),
]