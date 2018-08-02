import javascript

from HTTP::RequestInputAccess ria, Koa::RouteHandler rh
where ria.getRouteHandler() = rh
select ria, ria.getKind(), rh
