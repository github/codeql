from django.http.response import HttpResponse, HttpResponseRedirect, JsonResponse, HttpResponseNotFound

# Not an XSS sink, since the Content-Type is not "text/html"
# FP reported in https://github.com/github/codeql-python-team/issues/38
def safe__json_response(request):
    # implicitly sets Content-Type to "application/json"
    return JsonResponse({"foo": request.GET.get("foo")})  # $HttpResponse mimetype=application/json responseBody=Dict

# Not an XSS sink, since the Content-Type is not "text/html"
def safe__manual_json_response(request):
    json_data = '{"json": "{}"}'.format(request.GET.get("foo"))
    return HttpResponse(json_data, content_type="application/json")  # $HttpResponse mimetype=application/json responseBody=json_data

# Not an XSS sink, since the Content-Type is not "text/html"
def safe__manual_content_type(request):
    return HttpResponse('<img src="0" onerror="alert(1)">', content_type="text/plain")  # $HttpResponse mimetype=text/plain responseBody='<img src="0" onerror="alert(1)">'

# XSS FP reported in https://github.com/github/codeql/issues/3466
# Note: This should be an open-redirect sink, but not an XSS sink.
def or__redirect(request):
    return HttpResponseRedirect(request.GET.get("next"))  # $HttpResponse mimetype=text/html

def information_exposure_through_redirect(request, as_kw=False):
    # This is a contrived example, but possible
    private = "private"
    if as_kw:
        return HttpResponseRedirect(request.GET.get("next"), content=private)  # $HttpResponse mimetype=text/html responseBody=private
    else:
        return HttpResponseRedirect(request.GET.get("next"), private)  # $HttpResponse mimetype=text/html responseBody=private

# Ensure that simple subclasses are still vuln to XSS
def xss__not_found(request):
    return HttpResponseNotFound(request.GET.get("name"))  # $HttpResponse mimetype=text/html responseBody=Attribute()

# Ensure we still have an XSS sink when manually setting the content_type to HTML
def xss__manual_response_type(request):
    return HttpResponse(request.GET.get("name"), content_type="text/html; charset=utf-8")  # $HttpResponse mimetype=text/html responseBody=Attribute()

def xss__write(request):
    response = HttpResponse()  # $HttpResponse mimetype=text/html
    response.write(request.GET.get("name"))  # $HttpResponse mimetype=text/html responseBody=Attribute()

# This is safe but probably a bug if the argument to `write` is not a result of `json.dumps` or similar.
def safe__write_json(request):
    response = JsonResponse()  # $HttpResponse mimetype=application/json
    response.write(request.GET.get("name"))  # $HttpResponse mimetype=application/json responseBody=Attribute()

# Ensure manual subclasses are vulnerable
class CustomResponse(HttpResponse):
    def __init__(self, banner, content, *args, **kwargs):
        super().__init__(content, *args, content_type="text/html", **kwargs)

def xss__custom_response(request):
    return CustomResponse("ACME Responses", request.GET("name"))  # $HttpResponse MISSING: mimetype=text/html responseBody=Attribute() SPURIOUS: responseBody="ACME Responses"

class CustomJsonResponse(JsonResponse):
    def __init__(self, banner, content, *args, **kwargs):
        super().__init__(content, *args, content_type="text/html", **kwargs)

def safe__custom_json_response(request):
    return CustomJsonResponse("ACME Responses", {"foo": request.GET.get("foo")})  # $HttpResponse mimetype=application/json MISSING: responseBody=Dict SPURIOUS: responseBody="ACME Responses"
