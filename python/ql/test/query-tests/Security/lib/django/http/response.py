class HttpResponseBase(object):
    status_code = 200

    def __init__(self, content_type=None, status=None, reason=None, charset=None):
        pass


class HttpResponse(HttpResponseBase):
    def __init__(self, content=b"", *args, **kwargs):
        super().__init__(*args, **kwargs)
        # Content is a bytestring. See the `content` property methods.
        self.content = content


class HttpResponseRedirectBase(HttpResponse):
    def __init__(self, redirect_to, *args, **kwargs):
        super().__init__(*args, **kwargs)
        ...


class HttpResponsePermanentRedirect(HttpResponseRedirectBase):
    status_code = 301


class HttpResponseRedirect(HttpResponseRedirectBase):
    status_code = 302


class HttpResponseNotFound(HttpResponse):
    status_code = 404


class JsonResponse(HttpResponse):

    def __init__(
        self,
        data,
        encoder=...,
        safe=True,
        json_dumps_params=None,
        **kwargs
    ):
        # fake code to represent what is going on :)
        kwargs.setdefault("content_type", "application/json")
        data = str(data)
        super().__init__(content=data, **kwargs)
