/**
 * @name Unvalidated dynamic method call
 * @description Calling a method with a user-controlled name may dispatch to
 *              an unexpected target, which could cause an exception.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id js/unvalidated-dynamic-method-call
 * @tags security
 *       external/cwe/cwe-754
 */

import javascript
import semmle.javascript.security.dataflow.UnvalidatedDynamicMethodCall::UnvalidatedDynamicMethodCall
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "Invocation of method with $@ name may dispatch to unexpected target and cause an exception.",
  source.getNode(), "user-controlled"
