from aiohttp import web

async def test_taint(request: web.Request): # $ requestHandler

    ensure_tainted(
        # see https://docs.aiohttp.org/en/stable/web_reference.html#request-and-base-request
        request, # $ tainted

        # yarl.URL (see `yarl` framework tests)
        request.url, # $ tainted
        request.url.human_repr(), # $ tainted
        request.rel_url, # $ tainted
        request.rel_url.human_repr(), # $ tainted

        request.forwarded, # $ tainted

        request.host, # $ tainted
        request.remote, # $ tainted
        request.path, # $ tainted
        request.path_qs, # $ tainted
        request.raw_path, # $ tainted

        # dict-like for captured parts of the URL
        request.match_info, # $ tainted
        request.match_info["key"], # $ tainted
        request.match_info.get("key"), # $ tainted

        # multidict.MultiDictProxy[str] (see `multidict` framework tests)
        request.query, # $ tainted
        request.query.getone("key"), # $ tainted

        # multidict.CIMultiDictProxy[str] (see `multidict` framework tests)
        request.headers, # $ tainted
        request.headers.getone("key"), # $ tainted



        # dict-like (readonly)
        request.cookies, # $ tainted
        request.cookies["key"], # $ tainted
        request.cookies.get("key"), # $ tainted
        request.cookies.keys(), # $ MISSING: tainted
        request.cookies.values(), # $ tainted
        request.cookies.items(), # $ tainted
        list(request.cookies), # $ tainted
        iter(request.cookies), # $ tainted


        # aiohttp.StreamReader
        # see https://docs.aiohttp.org/en/stable/streams.html#aiohttp.StreamReader
        request.content, # $ tainted
        await request.content.read(), # $ tainted
        await request.content.readany(), # $ tainted
        await request.content.readexactly(42), # $ tainted
        await request.content.readline(), # $ tainted
        await request.content.readchunk(), # $ tainted
        (await request.content.readchunk())[0], # $ tainted
        [line async for line in request.content], # $ tainted
        [data async for data in request.content.iter_chunked(1024)], # $ tainted
        [data async for data in request.content.iter_any()], # $ tainted
        [data async for data, _ in request.content.iter_chunks()], # $ tainted
        request.content.read_nowait(), # $ tainted

        # aiohttp.StreamReader
        request._payload, # $ tainted
        await request._payload.readany(), # $ tainted

        request.content_type, # $ tainted
        request.charset, # $ tainted

        request.http_range, # $ tainted

        # Optional[datetime]
        request.if_modified_since, # $ tainted
        request.if_unmodified_since, # $ tainted
        request.if_range, # $ tainted

        request.clone(scheme="https"), # $ tainted

        # asyncio.Transport
        # https://docs.python.org/3/library/asyncio-protocol.html#asyncio-transport
        # example given in https://docs.aiohttp.org/en/stable/web_reference.html#aiohttp.web.BaseRequest.transport
        # uses `peername` to get IP address of client
        request.transport, # $ tainted
        request.transport.get_extra_info("key"), # $ MISSING: tainted

        # Like request.transport.get_extra_info
        request.get_extra_info("key"), # $ tainted

        # Like request.transport.get_extra_info
        request.protocol.transport.get_extra_info("key"), # $ MISSING: tainted

        # bytes
        await request.read(), # $ tainted

        # str
        await request.text(), # $ tainted

        # obj
        await request.json(), # $ tainted

        # aiohttp.multipart.MultipartReader
        await request.multipart(), # $ tainted

        # multidict.MultiDictProxy[str] (see `multidict` framework tests)
        await request.post(), # $ tainted
        (await request.post()).getone("key"), # $ tainted
    )

    import yarl
    assert isinstance(request.url, yarl.URL)
    assert isinstance(request.rel_url, yarl.URL)


    # things that are technically controlled by sender of request,
    # but doesn't seem that likely for exploitation.
    ensure_not_tainted(
        request.method,
        request.version,
        request.scheme,
        request.secure,
        request.keep_alive,

        request.content_length,
        request.body_exists,
        request.has_body,
        request.can_read_body,
    )

    ensure_not_tainted(
        request.loop,

        request.app,
        request.config_dict,
    )


class TaintTestClass(web.View):
    def get(self): # $ requestHandler
        ensure_tainted(
            self.request, # $ tainted
            self.request.url # $ tainted
        )


app = web.Application()
app.router.add_get(r"/test_taint/{name}/{number:\d+}", test_taint)  # $ routeSetup="/test_taint/{name}/{number:\d+}"
app.router.add_view(r"/test_taint_class", TaintTestClass)  # $ routeSetup="/test_taint_class"


if __name__ == "__main__":
    web.run_app(app)
