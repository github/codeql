class HttpResponseBase(object):
    status_code = 200


class HttpResponse(HttpResponseBase):
    pass


class HttpResponseRedirectBase(HttpResponse):
    pass


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
