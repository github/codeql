import javascript

from HTTP::RequestInputAccess ria, Connect::RouteHandler rh
where ria.getRouteHandler() = rh
select ria, ria.getKind(), rh
