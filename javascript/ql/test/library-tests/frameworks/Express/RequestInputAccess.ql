import javascript

from HTTP::RequestInputAccess ria, Express::RouteHandler rh
where ria.getRouteHandler() = rh
select ria, ria.getKind(), rh
