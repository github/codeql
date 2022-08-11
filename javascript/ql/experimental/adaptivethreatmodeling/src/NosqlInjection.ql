/**
 * NosqlInjection.ql
 *
 * For internal use only.
 *
 * Version of the standard NoSQL injection query with an output relation ready to plug into the
 * evaluation pipeline.
 *
 * @name NoSQL database query built from user-controlled sources
 * @description Building a database query from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind path-problem
 */

import javascript
import semmle.javascript.security.dataflow.NosqlInjection
import DataFlow::PathGraph

from DataFlow::Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where
  cfg instanceof NosqlInjection::Configuration and
  cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "NosqlInjection vulnerability due to $@.", source.getNode(),
  "a user-provided value"
