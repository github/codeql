import javascript

from HTTP::ExplicitHeaderDefinition hd
where hd.getRouteHandler() instanceof NodeJSLib::RouteHandler
select hd, hd.getNameExpr()
