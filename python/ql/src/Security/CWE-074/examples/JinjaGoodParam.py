from django.urls import path
from django.http import HttpResponse
from jinja2 import Template, escape


def a(request):
    # GOOD: Template is a constant, not constructed from user input
    t = Template("Hello, {{name}}!")

    name = request.GET['name']
    html = t.render(name=escape(name))
    return HttpResponse(html)


urlpatterns = [
    path('a', a),
]