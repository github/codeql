from django.db import models

# Create your models here.


class Foo(models.Model):
    title = models.CharField(max_length=100)
    field_not_displayed = models.IntegerField()


class Bar(models.Model):
    n = models.IntegerField()
    foo = models.ForeignKey(Foo, on_delete=models.PROTECT)
