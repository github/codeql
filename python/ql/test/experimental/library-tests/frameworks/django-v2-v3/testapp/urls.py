from django.urls import path, re_path

from . import views

urlpatterns = [
    path("foo/", views.foo),  # $routeSetup="foo/"
    # TODO: Doesn't include standard `$` to mark end of string, due to problems with
    # inline expectation tests (which thinks the `$` would mark the beginning of a new
    # line)
    re_path(r"^ba[rz]/", views.bar_baz),  # $routeSetup="^ba[rz]/"
]
