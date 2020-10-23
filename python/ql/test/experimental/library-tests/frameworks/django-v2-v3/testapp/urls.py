from django.urls import path, re_path

# This version 1.x way of defining urls is deprecated in Django 3.1, but still works
from django.conf.urls import url

from . import views

urlpatterns = [
    path("foo/", views.foo),  # $routeSetup="foo/"
    # TODO: Doesn't include standard `$` to mark end of string, due to problems with
    # inline expectation tests (which thinks the `$` would mark the beginning of a new
    # line)
    re_path(r"^ba[rz]/", views.bar_baz),  # $routeSetup="^ba[rz]/"
    url(r"^deprecated/", views.deprecated),  # $routeSetup="^deprecated/"
]
