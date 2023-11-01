/**
 * @name SQL Data-source URI built from local user-controlled sources
 * @description Building an SQL data-source URI from untrusted sources can allow attacker to compromise security
 * @kind path-problem
 * @problem.severity error
 * @id go/dsn-injection-local
 * @tags security
 *       experimental
 *       external/cwe/cwe-74
 */

import go
import DsnInjectionCustomizations
import DsnInjectionFlow::PathGraph

/** An argument passed via the command line taken as a source for the `DsnInjectionFlow` taint-flow. */
private class OsArgsSource extends Source {
  OsArgsSource() { this = any(Variable c | c.hasQualifiedName("os", "Args")).getARead() }
}

from DsnInjectionFlow::PathNode source, DsnInjectionFlow::PathNode sink
where DsnInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This query depends on a $@.", source.getNode(),
  "user-provided value"
