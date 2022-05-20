from django.db import models
import django.db.models.fields.files

def custom_path_function_1(instance, filename):
    ensure_tainted(filename) # $ tainted

def custom_path_function_2(instance, filename):
    ensure_tainted(filename) # $ tainted

def custom_path_function_3(instance, filename):
    ensure_tainted(filename) # $ tainted

def custom_path_function_4(instance, filename):
    ensure_tainted(filename) # $ tainted


class CustomFileFieldSubclass(models.FileField):
    pass


class MyModel(models.Model):
    upload_1 = models.FileField(None, None, custom_path_function_1)
    upload_2 = django.db.models.fields.files.FileField(upload_to=custom_path_function_2)

    upload_3 = models.ImageField(upload_to=custom_path_function_3)

    upload_4 = CustomFileFieldSubclass(upload_to=custom_path_function_4)
