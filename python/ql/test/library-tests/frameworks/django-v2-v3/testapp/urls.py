from django.urls import path, re_path

from . import views

urlpatterns = [
    path("foo/", views.foo),  # $routeSetup="foo/"
    # TODO: Doesn't include standard `$` to mark end of string, due to problems with
    # inline expectation tests (which thinks the `$` would mark the beginning of a new
    # line)
    re_path(r"^ba[rz]/", views.bar_baz),  # $routeSetup="^ba[rz]/"

    path("basic-view-handler/", views.MyBasicViewHandler.as_view()),  # $routeSetup="basic-view-handler/"
    path("custom-inheritance-view-handler/", views.MyViewHandlerWithCustomInheritance.as_view()),  # $routeSetup="custom-inheritance-view-handler/"

    path("CustomRedirectView/<foo>", views.CustomRedirectView.as_view()),  # $routeSetup="CustomRedirectView/<foo>"
    path("CustomRedirectView2/<foo>", views.CustomRedirectView2.as_view()),  # $routeSetup="CustomRedirectView2/<foo>"

    path("file-test/", views.file_test), # $routeSetup="file-test/"
]

from django import __version__ as django_version

if django_version[0] == "3":
    # This version 1.x way of defining urls is deprecated in Django 3.1, but still works.
    # However, it is removed in Django 4.0, so we need this guard to make our code runnable
    from django.conf.urls import url

    old_urlpatterns = urlpatterns

    # we need this assignment to get our logic working... maybe it should be more
    # sophisticated?
    urlpatterns = [
        url(r"^deprecated/", views.deprecated),  # $routeSetup="^deprecated/"
    ]

    urlpatterns += old_urlpatterns
