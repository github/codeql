from django.http.response import HttpResponse, HttpResponseRedirect, JsonResponse, HttpResponseNotFound

# Not an XSS sink, since the Content-Type is not "text/html"
# FP reported in https://github.com/github/codeql-python-team/issues/38
def fp_json_response(request):
    # implicitly sets Content-Type to "application/json"
    return JsonResponse({"foo": request.GET.get("foo")})

# Not an XSS sink, since the Content-Type is not "text/html"
def fp_manual_json_response(request):
    json_data = '{"json": "{}"}'.format(request.GET.get("foo"))
    return HttpResponse(json_data, content_type="application/json")

# Not an XSS sink, since the Content-Type is not "text/html"
def fp_manual_content_type(request):
    return HttpResponse('<img src="0" onerror="alert(1)">', content_type="text/plain")

# XSS FP reported in https://github.com/github/codeql/issues/3466
# Note: This should be a open-redirect sink, but not a XSS sink.
def fp_redirect(request):
    return HttpResponseRedirect(request.GET.get("next"))

# Ensure that simple subclasses are still vuln to XSS
def tp_not_found(request):
    return HttpResponseNotFound(request.GET.get("name"))

# Ensure we still have a XSS sink when manually setting the content_type to HTML
def tp_manual_response_type(request):
    return HttpResponse(request.GET.get("name"), content_type="text/html; charset=utf-8")
