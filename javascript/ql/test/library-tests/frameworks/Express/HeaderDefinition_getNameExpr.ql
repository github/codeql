import javascript

from HTTP::ExplicitHeaderDefinition hd
where hd.getRouteHandler() instanceof Express::RouteHandler
select hd, hd.getNameExpr()
