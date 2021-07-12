from twisted.web.server import Site, Request
from twisted.web.resource import Resource
from twisted.internet import reactor, endpoints


root = Resource()


class Foo(Resource):
    def render(self, request: Request): # $ requestHandler
        print(f"{request.content=}")
        print(f"{request.cookies=}")
        print(f"{request.received_cookies=}")
        return b"I am Foo" # $ HttpResponse


root.putChild(b"foo", Foo())


class Child(Resource):
    def __init__(self, name):
        self.name = name.decode("utf-8")

    def render_GET(self, request): # $ requestHandler
        return f"Hi, I'm child '{self.name}'".encode("utf-8") # $ HttpResponse


class Parent(Resource):
    def getChild(self, path, request): # $ requestHandler
        print(path, type(path))
        return Child(path)

    def render_GET(self, request): # $ requestHandler
        return b"Hi, I'm parent" # $ HttpResponse


root.putChild(b"parent", Parent())


if __name__ == "__main__":
    factory = Site(root)
    endpoint = endpoints.TCP4ServerEndpoint(reactor, 8880)
    endpoint.listen(factory)

    print("Will run on http://localhost:8880")

    reactor.run()
