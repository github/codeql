"""tests for Django 1.x"""
from django.conf.urls import url
from django.shortcuts import redirect, render


def with_template(request, path='default'):
    env = {'path': path}
    # We would need to understand django templates to know if this is safe or not
    return render(request, 'possibly-vulnerable-template.html', env)


def vuln_redirect(request, path):
    return redirect(path)


urlpatterns = [
    url(r'^(?P<path>.*)$', with_template),
    url(r'^redirect/(?P<path>.*)$', vuln_redirect),
]
