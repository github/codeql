from django.db.models.expressions import RawSQL

def raw1(arg):
    return RawSQL("select foo from bar where baz = %s" % arg, "")


from django.db import models

class MyModel(models.Model):
    pass

def raw2(arg):
    MyModel.objects.raw("select foo from bar where baz = %s" % arg)

def raw3(arg):
    m = MyModel.objects.filter('foo')
    m = m.filter('bar')
    m.raw("select foo from bar where baz = %s" % arg)

def raw4(arg):
    m = MyModel.objects.filter('foo')
    m.extra("select foo from bar where baz = %s" % arg)

