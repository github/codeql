import go

from WebSocketReader r, DataFlow::Node nd
where nd = r.getAnOutput().getNode(r.getACall())
select nd
