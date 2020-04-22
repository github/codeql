import go
import semmle.go.frameworks.Websocket

from WebSocketReader r, DataFlow::Node nd
where nd = r.getAnOutput().getNode(r.getACall())
select nd
