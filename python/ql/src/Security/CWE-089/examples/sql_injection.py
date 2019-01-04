
from django.conf.urls import patterns, url
from django.db import connection


def save_name(request):

    if request.method == 'POST':
        name = request.POST.get('name')
        curs = connection.cursor()
        #BAD -- Using string formatting
        curs.execute(
            "insert into names_file ('name') values ('%s')" % name)
        #GOOD -- Using parameters
        curs.execute(
            "insert into names_file ('name') values ('%s')", name)


urlpatterns = patterns(url(r'^save_name/$',
                           upload, name='save_name'))

