import python
import semmle.python.dataflow.new.DataFlow

/*
 *    Find the taint sink: first argument to conn.executescript:
 *    conn.executescript(arg1)
 */

from Call call, Attribute att, Expr sink, DataFlow::Node dfsink
where
    call.getFunc() = att and
    att.getName() = "executescript" and
    //
    call.getArg(0) = sink and
    //
    dfsink.asExpr() = sink
select call, att, sink, dfsink

// Shortened version:
predicate isSink(Call call, DataFlow::Node dfsink) {
    call.getFunc().(Attribute).getName() = "executescript" and
    dfsink.asExpr() = call.getArg(0)
}
