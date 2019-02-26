/**
 * @name Cross-window communication with unrestricted target origin
 * @description When sending sensitive information to another window using `postMessage`,
 *              the origin of the target window should be restricted to avoid unintentional
 *              information leaks.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id js/cross-window-information-leak
 * @tags security
 *       external/cwe/cwe-201
 *       external/cwe/cwe-359
 */

import javascript
import semmle.javascript.security.dataflow.PostMessageStar::PostMessageStar
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "Sensitive data returned from $@ is sent to another window without origin restriction.",
  source.getNode(), "here"
