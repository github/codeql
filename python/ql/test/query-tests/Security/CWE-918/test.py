import sys
import re

from django.conf.urls import url
from django.http import HttpResponse
import requests


PY2 = sys.version_info[0] == 2
PY3 = sys.version_info[0] == 3

if PY2:
    from httplib import HTTPConnection
    from urlparse import urlsplit, urlunsplit
if PY3:
    from http.client import HTTPConnection
    from urllib.parse import urlsplit, urlunsplit


def vuln_1(request):
    url = request.GET["url"]
    r = requests.get(url)  # vuln
    return HttpResponse("ok")


def vuln_2(request):
    host = request.GET["host"]
    path = request.GET["path"]
    conn = HTTPConnection(host)  # vuln
    conn.request("GET", path)  # vuln
    return HttpResponse("ok")


# with urlsplit
def vuln_3(request):
    url = request.GET["url"]
    _scheme, host, path, _query, _fragment = urlsplit(url)
    conn = HTTPConnection(host)  # vuln
    conn.request("GET", path)  # vuln
    return HttpResponse("ok")


# with urlunsplit
def vuln_4(request):
    host = request.GET["host"]
    path = request.GET["path"]
    parts = SplitResult(scheme="http", netloc=host, path=path, query="", fragment="")
    url = urlunsplit(parts)  # TODO: taint tracking doesn't handle urlunsplit
    rsp = requests.get(url)  # vuln TODO: FN
    return HttpResponse("ok")


def bad_sanitizer1(request):
    host = request.GET["host"]
    path = request.GET["path"]

    # this check is vulnerable, for example "example.com.evil.com"
    if not host.startswith("example.com"):
        return HttpResponse("not ok")

    url = "https://{}{}".format(host, path)
    rsp = requests.get(url)  # vuln
    return HttpResponse("ok")


def bad_sanitizer2(request):
    host = request.GET["host"]
    path = request.GET["path"]

    # this check is vulnerable, for example "127.1", or any DNS returning "127.0.0.1"
    # see https://portswigger.net/web-security/ssrf#ssrf-with-blacklist-based-input-filters
    if host in ["127.0.0.1", "localhost"]:
        return HttpResponse("not ok")

    url = "https://{}{}".format(host, path)
    rsp = requests.get(url)  # vuln
    return HttpResponse("ok")


def bad_sanitizer3(request):
    url = request.GET["url"]
    split_res = urlsplit(url)

    host = split_res.netloc

    # unsafe since dot is not escaped. See rule 'py/incomplete-hostname-regexp'
    if not re.match(r"^(www|beta).example.com$", host):
        return HttpResponse("not ok")

    path = split_res.path
    if not path.startswith("/my-app/"):
        return HttpResponse("not ok")

    conn = HTTPConnection(host)  # vuln TODO: FN
    conn.request("GET", path)  # safe
    return HttpResponse("ok")


def bad_sanitizer4(request):
    url = request.GET["url"]

    # this check is vulnerable, for example "http://example.com.evil.com"
    if not (url.startswith("http://example.com") or url.startswith("https://example.com")):
        return HttpResponse("not ok")

    rsp = requests.get(url)  # vuln TODO: FN
    return HttpResponse("ok")


def safe_1(request):
    URL_REGEXP = re.compile(r"^https?://(www|beta)\.example\.com(/|$)")
    url = request.GET["url"]

    if not URL_REGEXP.match(url): # TODO: Currently we don't recognize this as a sanitizer
        return HttpResponse("not ok")

    r = requests.get(url)  # safe TODO: FP
    return HttpResponse("ok")


def safe_2(request):
    url = request.GET["url"]
    split_res = urlsplit(url)

    host = split_res.netloc
    if host != "example.com":
        return HttpResponse("not ok")

    path = split_res.path
    if not path.startswith("/my-app/"):
        return HttpResponse("not ok")

    conn = HTTPConnection(host)  # safe
    conn.request("GET", path)  # safe
    return HttpResponse("ok")


def safe_3(request):
    HOST_REGEXP_PATTERN = r"^(www|beta)\.example\.com$"

    url = request.GET["url"]
    split_res = urlsplit(url)

    host = split_res.netloc
    if not re.match(HOST_REGEXP_PATTERN, host):
        return HttpResponse("not ok")

    path = split_res.path
    if not path.startswith("/my-app/"):
        return HttpResponse("not ok")

    conn = HTTPConnection(host)  # safe
    conn.request("GET", path)  # safe
    return HttpResponse("ok")


def safe_4(request):
    url = request.GET["url"]
    split_res = urlsplit(url)

    if split_res.netloc != "example.com":
        return HttpResponse("not ok")

    if not split_res.path.startswith("/my-app/"):
        return HttpResponse("not ok")

    requests.get(url)  # safe TODO: FP
    return HttpResponse("ok")


# django v 1.x setup of request handlers -- it's a bit annoying to do it this way, but
# since we're using .qlref, we can't use a fake source :|
urlpatterns = [
    url(r"^vuln_1$", vuln_1),
    url(r"^vuln_2$", vuln_2),
    url(r"^vuln_3$", vuln_3),
    url(r"^vuln_4$", vuln_4),
    url(r"^bad_sanitizer1$", bad_sanitizer1),
    url(r"^bad_sanitizer2$", bad_sanitizer2),
    url(r"^bad_sanitizer3$", bad_sanitizer3),
    url(r"^safe_1$", safe_1),
    url(r"^safe_2$", safe_2),
    url(r"^safe_3$", safe_3),
    url(r"^safe_4$", safe_4),
]
