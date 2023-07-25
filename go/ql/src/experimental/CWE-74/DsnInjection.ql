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
import DataFlow::PathGraph
import DsnInjectionCustomizations

/** An untrusted flow source taken as a source for the `DsnInjection` taint-flow configuration. */
private class UntrustedFlowAsSource extends Source instanceof UntrustedFlowSource { }

from DsnInjection cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Data-Source Name is built using $@.", source.getNode(),
  "untrusted user input"
