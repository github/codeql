/**
 * @name SQLI Vulnerability
 * @description Using untrusted strings in a sql query allows sql injection attacks.
 * @kind path-problem
 * @id cpp/SQLIVulnerable
 * @problem.severity warning
 */

import java
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph

class SqliFlowConfig extends TaintTracking::Configuration {
    SqliFlowConfig() { this = "SqliFlow" }

    override predicate isSource(DataFlow::Node source) {
        // System.console().readLine();
        exists(Call read |
            read.getCallee().getName() = "readLine" and
            read = source.asExpr()
        )
    }

    override predicate isSanitizer(DataFlow::Node sanitizer) { none() }

    override predicate isAdditionalTaintStep(DataFlow::Node into, DataFlow::Node out) {
        // Extra taint step
        //     String.format("INSERT INTO users VALUES (%d, '%s')", id, info);
        // Not needed here, but may be needed for larger libraries.
        none()
    }

    override predicate isSink(DataFlow::Node sink) {
        // conn.createStatement().executeUpdate(query);
        exists(Call exec |
            exec.getCallee().getName() = "executeUpdate" and
            exec.getArgument(0) = sink.asExpr()
        )
    }
}

from SqliFlowConfig conf, DataFlow::PathNode source, DataFlow::PathNode sink
where conf.hasFlowPath(source, sink)
select sink, source, sink, "Possible SQL injection"
