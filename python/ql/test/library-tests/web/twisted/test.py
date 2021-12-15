from twisted.web import resource

class MyRequestHandler1(resource.Resource):
    def render(self, request):
        foo(request.uri)
        response = do_stuff_with(request)
        return response

    def render_GET(self, request):
        x = request
        bar(x.uri)
        do_stuff_with(request)
        response = do_stuff_with(request)
        return response

    def render_POST(self, request):
        baz(request.args)
        foo = request.args.get("baz")
        quux = foo[5]
        response = do_stuff_with(quux)
        return response

class MyRequestHandler2(resource.Resource):
    def myrender(self, request):
        do_stuff_with(request)

class MyRequestHandler3(resource.Resource):
    def render(self, myrequest):
        do_stuff_with(myrequest)

    def render_POST(self, postrequest):
        x = postrequest.getHeader("someheader")
        y = postrequest.getCookie("somecookie")
        z = postrequest.getUser()
        w = postrequest.getPassword()
        return do_stuff_with(x,y,z,w)

class MyRequestHandler4(resource.Resource):
    def render(self, request):
        request.write("Foobar")

class MyRequestHandler5(resource.Resource):
    def render(self, request):
        request.setHeader("foo", "bar")
        request.addCookie("key", "value")
        return "This is my response."

class NotATwistedRequestHandler(object):
    def render(self, request):
        return do_stuff_with(request)

