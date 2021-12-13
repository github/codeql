import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs

/*
 *    Find the taint source, and notice the three distinct CodeQL classes involved.
 */
from DataFlow::CallCfgNode call, DataFlow::Node source, API::Node target
where
    target = API::moduleImport("builtins").getMember("input") and
    call = target.getACall() and
    source = call
select target, call, source

// Shorter and as predicate
predicate isSource(DataFlow::Node source) {
    API::moduleImport("builtins").getMember("input").getACall() = source
}
