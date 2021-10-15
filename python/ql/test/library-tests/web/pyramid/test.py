from pyramid.view import view_config
from pyramid.response import Response

@view_config(
    route_name='home'
)
def home(request):
    return Response('Welcome!')


@view_config(
    route_name='greet',
    request_method='POST'
)
def greet(request):
    name = request.POST['arg']
    return Response('Welcome %s!' % name)


@view_config(
    route_name='stuff',
    renderer='json'
)
def stuff(request):
    return {"err": 0, "body": request.body}
