from lxml import etree
from io import StringIO

from django.urls import path
from django.http import HttpResponse
from django.template import Template, Context, Engine, engines


def a(request):
    value = request.GET['xpath']
    f = StringIO('<foo><bar></bar></foo>')
    tree = etree.parse(f)
    r = tree.xpath("/tag[@id=$tagid]", tagid=value)


urlpatterns = [
    path('a', a)
]
