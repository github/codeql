from django.db import models


class MyModel(models.Model):
  pass

def cheap_handler():
  pass

def expensive_handler_save():
  MyModel().save()

def expensive_handler_delete():
  MyModel().delete()

def expensive_handler_update():
  MyModel().update()

def expensive_handler_create():
  MyModel.objects.create()

def expensive_handler_create_indirect():
  helper()

def helper():
  MyModel.objects.create()

