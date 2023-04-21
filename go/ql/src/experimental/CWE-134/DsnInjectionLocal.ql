/**
 * @name SQL Data-source URI built from local user-controlled sources
 * @description Building an SQL data-source URI from untrusted sources can allow attacker to compromise security
 * @kind path-problem
 * @problem.severity error
 * @id go/dsn-injection
 * @tags security
 *       experimental
 *       external/cwe/cwe-134
 */

import go
import DataFlow::PathGraph
import DsnInjectionCustomizations

/** An argument passed via the command line taken as a source for the `DsnInjection` taint-flow configuration. */
private class OsArgsSource extends Source {
  OsArgsSource() { this = any(Variable c | c.hasQualifiedName("os", "Args")).getARead() }
}

from DsnInjection cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This query depends on a $@.", source.getNode(),
  "user-provided value"
