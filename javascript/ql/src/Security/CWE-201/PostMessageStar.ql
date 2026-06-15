/**
 * @name Cross-window communication with unrestricted target origin
 * @description When sending sensitive information to another window using `postMessage`,
 *              the origin of the target window should be restricted to avoid unintentional
 *              information leaks.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 4.3
 * @precision high
 * @id js/cross-window-information-leak
 * @tags security
 *       external/cwe/cwe-201
 *       external/cwe/cwe-359
 */

import javascript
import semmle.javascript.security.dataflow.PostMessageStarQuery
import PostMessageStarFlow::PathGraph

from PostMessageStarFlow::PathNode source, PostMessageStarFlow::PathNode sink
where PostMessageStarFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "$@ is sent to another window without origin restriction.",
  source.getNode(), "Sensitive data"
