from django.db import models
from django.http.response import HttpResponse
from django.shortcuts import render
from django import forms

class MyModel(models.Model):
    text = models.CharField(max_length=256)

class MyModelForm(forms.ModelForm):
    # see https://docs.djangoproject.com/en/4.0/topics/forms/modelforms/#django.forms.ModelForm
    class Meta:
        model = MyModel
        fields = ["text"]

# TODO: When we actually start supporting ModelForm, we need to add test-cases for
# limiting what fields are used. See
# https://docs.djangoproject.com/en/4.0/topics/forms/modelforms/#selecting-the-fields-to-use

def add_mymodel_handler(request):
    if request.method == "POST":
        form = MyModelForm(request.POST, request.FILES)
        if form.is_valid():
            new_MyMoodel_instance = form.save()
            return HttpResponse("ok")
        else:
            print("not valid", form.errors)
    else:
        form = MyModelForm(initial=request.GET)

    return render(request, "form_example.html", {"form": form})


def show_mymodel_handler(request):
    obj = MyModel.objects.last()
    return HttpResponse("Last object (id={}) had text: {!r}".format(obj.id, obj.text))
