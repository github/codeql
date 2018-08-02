import javascript

from HTTP::HeaderDefinition hd, Restify::RouteHandler rh
where rh = hd.getRouteHandler()
select hd, rh
