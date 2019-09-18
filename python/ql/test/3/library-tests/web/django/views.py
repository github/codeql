
from django.http import HttpResponse
from django.shortcuts import redirect, render
from django.views.generic import View

def view_func1(request):
    # Whether this is safe depends on template.html -- annoyingly
    return HttpResponse(request.GET.get("untrusted"))


def view_func2(request, path='default'):
    env = {'path': path}
    return render(request, 'vulnerable-path.html', env)


class ClassView(View):

    def get(self, request):
        pass
