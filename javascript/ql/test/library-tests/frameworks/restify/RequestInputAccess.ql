import javascript

from HTTP::RequestInputAccess ria, Restify::RouteHandler rh
where ria.getRouteHandler() = rh
select ria, ria.getKind(), rh
