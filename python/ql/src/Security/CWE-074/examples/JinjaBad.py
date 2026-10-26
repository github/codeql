from django.urls import path
from django.http import HttpResponse
from jinja2 import Template, escape


def a(request):
    template = request.GET['template']

    # BAD: Template is constructed from user input. 
    t = Template(template)

    name = request.GET['name']
    html = t.render(name=escape(name))
    return HttpResponse(html)


urlpatterns = [
    path('a', a),
]