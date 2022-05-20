"""tests for Django 2.x and 3.x"""
from django.urls import path
from django.shortcuts import redirect, render


def with_template(request, path='default'):
    env = {'path': path}
    # We would need to understand django templates to know if this is safe or not
    return render(request, 'possibly-vulnerable-template.html', env)


def vuln_redirect(request, path):
    return redirect(path)


urlpatterns = [
    path('/<path>', with_template),
    path('/redirect/<path>', vuln_redirect),
]
