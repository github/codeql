
from django.db import models

class MyModel(models.Model):
    title = models.CharField(max_length=500)
    summary = models.TextField(blank=True)

def update_my_model(key, title):
    item = MyModel.objects.get(pk=key)
    item.title = title
