from django.urls import path
from django.http import HttpResponse
from django.template import Template, Context, Engine, engines


def dj(request):
    # Load the template
    template = request.GET['template']
    t = Template(template)
    ctx = Context(locals())
    html = t.render(ctx)
    return HttpResponse(html)


def djEngine(request):
    # Load the template
    template = request.GET['template']

    django_engine = engines['django']
    t = django_engine.from_string(template)
    ctx = Context(locals())
    html = t.render(ctx)
    return HttpResponse(html)


def djEngineJinja(request):
    # Load the template
    template = request.GET['template']

    django_engine = engines['jinja']
    t = django_engine.from_string(template)
    ctx = Context(locals())
    html = t.render(ctx)
    return HttpResponse(html)


urlpatterns = [
    path('', dj),
    path('', djEngine),
    path('', djEngineJinja),
]
