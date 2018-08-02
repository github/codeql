import javascript

from HTTP::ResponseSendArgument send, Express::RouteHandler rh
where rh = send.getRouteHandler()
select send, rh
