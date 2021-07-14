from chameleon import PageTemplate
from django.urls import path
from django.http import HttpResponse


def chameleon(request):
    template = request.GET['template']
    tmpl = PageTemplate(template)
    return HttpResponse(tmpl)

