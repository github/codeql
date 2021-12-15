from django.urls import path
from django.http import HttpResponse
from trender import TRender

def trender(request):
    template = request.GET['template']
    compiled = TRender(template)
    return HttpResponse(compiled)
    
urlpatterns = [
    path('', trender)
]
