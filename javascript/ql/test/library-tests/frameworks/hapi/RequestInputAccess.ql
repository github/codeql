import javascript

from HTTP::RequestInputAccess ria, Hapi::RouteHandler rh
where ria.getRouteHandler() = rh
select ria, ria.getKind(), rh
