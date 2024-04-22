from pyramid.view import view_config
from pyramid.config import Configurator

@view_config(route_name="test1")
def test1(request):
    ensure_tainted(
        request,              # $ tainted
        request.body,         # $ MISSING:tainted
        request.GET['a']      # $ MISSING:tainted
        ) 

def test2(request):
    ensure_tainted(request) # $ tainted

@view_config(route_name="test1")
def test3(context, request):
    ensure_tainted(request) # $ tainted

if __name__ == "__main__":
    with Configurator() as config:
        config.add_view(test2, route_name="test2")