import javascript

from HTTP::ResponseBody rb, Express::RouteHandler rh
where rb.getRouteHandler() = rh
select rb, rh
