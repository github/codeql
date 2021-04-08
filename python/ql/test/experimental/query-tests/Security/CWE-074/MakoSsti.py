from django.urls import path
from django.http import HttpResponse
from mako.template import Template


def mako(request):
    # Load the template
    template = request.GET['template']
    mytemplate = Template(template)
    return HttpResponse(mytemplate)


urlpatterns = [
    path('', mako)
]
