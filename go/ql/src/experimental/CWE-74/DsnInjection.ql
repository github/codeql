/**
 * @name SQL Data-source URI built from user-controlled sources
 * @description Building an SQL data-source URI from untrusted sources can allow attacker to compromise security
 * @kind path-problem
 * @problem.severity error
 * @id go/dsn-injection
 * @tags security
 *       experimental
 *       external/cwe/cwe-74
 */

import go
import DsnInjectionCustomizations
import DsnInjectionFlow::PathGraph

/** A remote flow source taken as a source for the `DsnInjection` taint-flow configuration. */
private class ThreatModelFlowAsSource extends Source instanceof ActiveThreatModelSource { }

from DsnInjectionFlow::PathNode source, DsnInjectionFlow::PathNode sink
where DsnInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Data-Source Name is built using $@.", source.getNode(),
  "untrusted user input"
