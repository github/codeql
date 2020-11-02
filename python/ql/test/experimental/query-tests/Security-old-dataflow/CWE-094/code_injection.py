from django.conf.urls import url
import base64

def code_execution(request):
    if request.method == 'POST':
        first_name = request.POST.get('first_name', '')
        exec(base64.decodestring(first_name))

urlpatterns = [
    # Route to code_execution
    url(r'^code-ex$', code_execution, name='code-execution')
]
