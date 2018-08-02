import javascript

from HTTP::HeaderDefinition hd, NodeJSLib::RouteHandler rh
where rh = hd.getRouteHandler()
select hd, rh
