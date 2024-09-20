from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.exceptions import APIException

@api_view()
def normal_response(request): # $ requestHandler
    # has no pre-defined content type, since that will be negotiated
    # see https://www.django-rest-framework.org/api-guide/responses/
    data = "data"
    resp = Response(data) # $ HttpResponse responseBody=data
    return resp

@api_view()
def plain_text_response(request): # $ requestHandler
    # this response is not the standard way to use the Djagno REST framework, but it
    # certainly is possible -- notice that the response contains double quotes
    data = 'this response will contain double quotes since it was a string'
    resp = Response(data, None, None, None, None, "text/plain") # $ HttpResponse responseBody=data mimetype=text/plain
    resp = Response(data=data, content_type="text/plain") # $ HttpResponse responseBody=data mimetype=text/plain
    return resp

################################################################################
# Cookies
################################################################################

@api_view
def setting_cookie(request):
    resp = Response() # $ HttpResponse
    resp.set_cookie("key", "value") # $ CookieWrite CookieName="key" CookieValue="value" CookieSecure=false CookieHttpOnly=false CookieSameSite=Lax
    resp.set_cookie(key="key4", value="value") # $ CookieWrite CookieName="key4" CookieValue="value" CookieSecure=false CookieHttpOnly=false CookieSameSite=Lax
    resp.headers["Set-Cookie"] = "key2=value2" # $ headerWriteName="Set-Cookie" headerWriteValue="key2=value2" CookieWrite CookieRawHeader="key2=value2" CookieSecure=false CookieHttpOnly=false CookieSameSite=Lax
    resp.cookies["key3"] = "value3" # $ CookieWrite CookieName="key3" CookieValue="value3"
    resp.delete_cookie("key4") # $ CookieWrite CookieName="key4"
    resp.delete_cookie(key="key4") # $ CookieWrite CookieName="key4"
    return resp

################################################################################
# Exceptions
################################################################################

# see https://www.django-rest-framework.org/api-guide/exceptions/

@api_view(["GET", "POST"])
def exception_test(request): # $ requestHandler
    data = "exception details"
    # note: `code details` not exposed by default
    code = "code details"
    e1 = APIException(data, code) # $ HttpResponse responseBody=data
    e2 = APIException(detail=data, code=code) # $ HttpResponse responseBody=data
    raise e2
