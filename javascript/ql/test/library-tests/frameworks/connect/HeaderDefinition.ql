import javascript

from HTTP::HeaderDefinition hd, Connect::RouteHandler rh
where rh = hd.getRouteHandler()
select hd, rh
