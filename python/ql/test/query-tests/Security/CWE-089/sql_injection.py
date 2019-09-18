
from django.conf.urls import patterns, url
from django.db import connection, models
from django.db.models.expressions import RawSQL

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

urlpatterns = patterns(url(r'^save_name/$',
                           save_name, name='save_name'))

