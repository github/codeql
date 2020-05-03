from django.urls import path
from django.http import HttpResponse
from trender import TRender

urlpatterns = [
    path('', trender)
]


def trender(request):
    template = request.GET['template']
    compiled = TRender(template)
    return HttpResponse(compiled])
