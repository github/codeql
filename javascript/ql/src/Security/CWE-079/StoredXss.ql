/**
 * @name Stored cross-site scripting
 * @description Using uncontrolled stored values in HTML allows for
 *              a stored cross-site scripting vulnerability.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id js/stored-xss
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import javascript
import semmle.javascript.security.dataflow.StoredXssQuery
import StoredXssFlow::PathGraph

from StoredXssFlow::PathNode source, StoredXssFlow::PathNode sink
where StoredXssFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Stored cross-site scripting vulnerability due to $@.",
  source.getNode(), "stored value"
