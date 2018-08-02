import javascript

from HTTP::CookieDefinition cookiedef, Express::RouteHandler rh
where rh = cookiedef.getRouteHandler()
select cookiedef, rh
