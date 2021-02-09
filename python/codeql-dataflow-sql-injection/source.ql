import python
import semmle.python.dataflow.new.DataFlow

/*
 *    Find the taint source, and notice the three distinct CodeQL classes involved.
 */
from Value target, CallNode call, DataFlow::Node source
where
    target = Value::named("input") and
    call = target.getACall() and
    source.asCfgNode() = call
select target, call, source

// Shorter and as predicate
predicate isSource(DataFlow::Node source) {
    Value::named("input").getACall() = source.asCfgNode()
}