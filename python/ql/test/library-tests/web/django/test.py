
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

urlpatterns = [
    # Route to code_execution
    url(r'^maybe_xss$', maybe_xss, name='maybe_xss')
]


# Non capturing group (we correctly identify page_number as a request parameter)

def show_articles(request, page_number=1):
    return HttpResponse('articles page: {}'.format(page_number))

urlpatterns = [
    # one pattern to support `articles/page-<n>` and ensuring that articles/ goes to page-1
    url(r'articles/^(?:page-(?P<page_number>\d+)/)?$', show_articles),
]


# Positional arguments

def xxs_positional_arg1(request, arg0):
    return HttpResponse('xxs_positional_arg1: {}'.format(arg0))

def xxs_positional_arg2(request, arg0, arg1, arg2):
    return HttpResponse('xxs_positional_arg2: {} {} {}'.format(arg0, arg1, arg2))

def xxs_positional_arg3(request, arg0, arg1):
    return HttpResponse('xxs_positional_arg3: {} {}'.format(arg0, arg1))

urlpatterns = [
    # passing as positional argument is not the recommended way of doing things,
    # but it is certainly possible
    url(r'^(.+)$', xxs_positional_arg1, name='xxs_positional_arg1'),
    url(r'^([^/]+)/([^/]+)/([^/]+)$', xxs_positional_arg2, name='xxs_positional_arg2'),
    url(r'^([^/]+)/(?:foo|bar)/([^/]+)$', xxs_positional_arg3, name='xxs_positional_arg3'),
]
