import javascript

from HTTP::RedirectInvocation red, Express::RouteHandler rh
where rh = red.getRouteHandler()
select red, rh
