/**
 * @name SQLI Vulnerability
 * @description Using untrusted strings in a sql query allows sql injection attacks.
 * @kind path-problem
 * @id go/SQLIVulnerable
 * @problem.severity error
 */

import go
import semmle.go.dataflow.DataFlow
import DataFlow::PathGraph

class SqliFlowConfig extends TaintTracking::Configuration {
    SqliFlowConfig() { this = "SqliFlow" }

    override predicate isSource(DataFlow::Node source) {
        // count, err := os.Stdin.Read(buf)
        exists(CallExpr read |
            read.getTarget().getName() = "Read" and
            read.getArgument(0) = source.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr()
        )
    }

    override predicate isSanitizer(DataFlow::Node sanitizer) { none() }

    override predicate isAdditionalTaintStep(DataFlow::Node into, DataFlow::Node out) { none() }

    override predicate isSink(DataFlow::Node sink) {
        // _, err = db.Exec(query)
        exists(CallExpr exec |
            exec.getTarget().getName() = "Exec" and
            exec.getArgument(0) = sink.asExpr()
        )
    }
}

from SqliFlowConfig conf, DataFlow::PathNode source, DataFlow::PathNode sink
where conf.hasFlowPath(source, sink)
select sink, source, sink, "Possible SQL injection"
