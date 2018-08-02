import javascript

from HTTP::HeaderDefinition hd, Hapi::RouteHandler rh
where rh = hd.getRouteHandler()
select hd, rh
