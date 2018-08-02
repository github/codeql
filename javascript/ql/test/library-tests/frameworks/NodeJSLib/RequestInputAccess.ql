import javascript

from HTTP::RequestInputAccess ria, NodeJSLib::RouteHandler rh
where ria.getRouteHandler() = rh
select ria, ria.getKind(), rh
