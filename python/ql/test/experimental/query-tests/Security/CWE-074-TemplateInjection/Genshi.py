from django.urls import path
from django.http import HttpResponse
from genshi.template import TextTemplate,MarkupTemplate

def genshi1():    
    template = request.GET['template']
    tmpl = MarkupTemplate(template)
    return HttpResponse(tmpl)

def genshi2():
    template = request.GET['template']
    tmpl = TextTemplate(template)
    return HttpResponse(tmpl)

urlpatterns = [
    path('', genshi1),
    path('', genshi2)
]
