from django.http import HttpResponseRedirect
from django.shortcuts import redirect
from django.utils.http import url_has_allowed_host_and_scheme
from django.views import View

class RedirectView(View):
    def get(self, request, *args, **kwargs):
        target = request.GET.get('target', '')
        if url_has_allowed_host_and_scheme(target, allowed_hosts=None):
            return HttpResponseRedirect(target)
        else:
            # ignore the target and redirect to the home page
            return redirect('/')