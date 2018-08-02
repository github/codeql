import javascript

from HTTP::HeaderDefinition hd, Express::RouteHandler rh
where rh = hd.getRouteHandler()
select hd, rh
