
from django.conf.urls import patterns, url
from django.db import connection, models
from django.db.models.expressions import RawSQL
from django.http.response import HttpResponse
import base64

class User(models.Model):
    pass

def show_user(request, username):
    with connection.cursor() as cursor:
        # GOOD -- Using parameters
        cursor.execute("SELECT * FROM users WHERE username = %s", username)
        User.objects.raw("SELECT * FROM users WHERE username = %s", (username,))

        # BAD -- Using string formatting
        cursor.execute("SELECT * FROM users WHERE username = '%s'" % username)

        # BAD -- other ways of executing raw SQL code with string interpolation
        User.objects.annotate(RawSQL("insert into names_file ('name') values ('%s')" % username))
        User.objects.raw("insert into names_file ('name') values ('%s')" % username)
        User.objects.extra("insert into names_file ('name') values ('%s')" % username)

        # BAD (but currently no custom query to find this)
        #
        # It is exposed to SQL injection (https://docs.djangoproject.com/en/2.2/ref/models/querysets/#extra)
        # For example, using name = "; DROP ALL TABLES -- "
        # will result in SQL: SELECT * FROM name WHERE name = ''; DROP ALL TABLES -- ''
        #
        # This shouldn't be very widespread, since using a normal string will result in invalid SQL
        # Using name = "example", will result in SQL: SELECT * FROM name WHERE name = ''example''
        # which in MySQL will give a syntax error
        #
        # When testing this out locally, none of the queries worked against SQLite3, but I could use
        # the SQL injection against MySQL.
        User.objects.raw("SELECT * FROM users WHERE username = '%s'", (username,))

urlpatterns = patterns(url(r'^users/(?P<username>[^/]+)$', show_user))

def maybe_xss(request):
    first_name = request.POST.get('first_name', '')
    resp = HttpResponse()
    resp.write("first name is " + first_name)
    return resp

def xss_kwargs(request, foo, bar, baz=None):
    return HttpResponse('xss_kwargs: {} {}'.format(foo, bar))

urlpatterns = [
    url(r'^maybe_xss$', maybe_xss, name='maybe_xss'),
    url(r'^bar/(?P<bar>[^/]+)/foo/(?P<foo>[^/]+)', xss_kwargs, name='xss_kwargs'),
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
