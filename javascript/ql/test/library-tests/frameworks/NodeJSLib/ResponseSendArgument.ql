import javascript

from HTTP::ResponseSendArgument send, NodeJSLib::RouteHandler rh
where rh = send.getRouteHandler()
select send, rh
