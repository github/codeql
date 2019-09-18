
from django.conf.urls import patterns, url
from django.db import connection, models
from django.db.models.expressions import RawSQL
from django.http.response import HttpResponse
import base64

class Name(models.Model):
    pass

def save_name(request):

    if request.method == 'POST':
        name = request.POST.get('name')
        curs = connection.cursor()
        #GOOD -- Using parameters
        curs.execute(
            "insert into names_file ('name') values ('%s')", name)
        #BAD -- Using string formatting
        curs.execute(
            "insert into names_file ('name') values ('%s')" % name)

        #BAD -- other ways of executing raw SQL code with string interpolation
        Name.objects.annotate(RawSQL("insert into names_file ('name') values ('%s')" % name))
        Name.objects.raw("insert into names_file ('name') values ('%s')" % name)
        Name.objects.extra("insert into names_file ('name') values ('%s')" % name)

urlpatterns1 = patterns(url(r'^save_name/$',
                           save_name, name='save_name'))

def maybe_xss(request):
    first_name = request.POST.get('first_name', '')
    resp = HttpResponse()
    resp.write("first name is " + first_name)
    return resp

urlpatterns2 = [
    # Route to code_execution
    url(r'^maybe_xss$', maybe_xss, name='maybe_xss')
]
