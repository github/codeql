import os.path

from django.db import models

def custom_path_function(instance, filename):
    print(repr(os.path.join("rootdir", filename)))
    raise NotImplementedError()

class MyModel(models.Model):
    upload = models.FileField(upload_to=custom_path_function)
