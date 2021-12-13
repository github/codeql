/**
 * @name SQLI Vulnerability
 * @description Using untrusted strings in a sql query allows sql injection attacks.
 * @kind 
 * @id python/SQLIVulnerable
 * @problem.severity warning
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.TaintTracking


predicate isSource1(DataFlow::Node source) {
    API::moduleImport("builtins").getMember("input").getACall() = source
}

predicate isSink(Call call, DataFlow::Node dfsink) {
    call.getFunc().(Attribute).getName() = "executescript" and
    dfsink.asExpr() = call.getArg(0)
}

class SqliFlowConfig extends TaintTracking::Configuration {
    SqliFlowConfig() { this = "SqliFlow" }

    override predicate isSource(DataFlow::Node source) { isSource1(source) }

    override predicate isSanitizer(DataFlow::Node sanitizer) { none() }

    override predicate isAdditionalTaintStep(DataFlow::Node into, DataFlow::Node out) { none() }

    override predicate isSink(DataFlow::Node sink) {isSink(_, sink) }
}

from SqliFlowConfig conf, DataFlow::PathNode source, DataFlow::PathNode sink
where conf.hasFlowPath(source, sink)
select sink, source, sink, "Possible SQL injection"
