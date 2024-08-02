/**
 * @name Unsafe dynamic method access
 * @description Invoking user-controlled methods on certain objects can lead to remote code execution.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.3
 * @precision high
 * @id js/unsafe-dynamic-method-access
 * @tags security
 *       external/cwe/cwe-094
 */

import javascript
import semmle.javascript.security.dataflow.UnsafeDynamicMethodAccessQuery
import UnsafeDynamicMethodAccessFlow::PathGraph

from UnsafeDynamicMethodAccessFlow::PathNode source, UnsafeDynamicMethodAccessFlow::PathNode sink
where UnsafeDynamicMethodAccessFlow::flowPath(source, sink)
select sink, source, sink,
  "This method is invoked using a $@, which may allow remote code execution.", source.getNode(),
  "user-controlled value"
