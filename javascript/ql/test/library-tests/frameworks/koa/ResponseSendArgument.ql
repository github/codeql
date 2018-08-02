import javascript

from HTTP::ResponseSendArgument send, Koa::RouteHandler rh
where rh = send.getRouteHandler()
select send, rh
