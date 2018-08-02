/**
 * @name Reflected cross-site scripting
 * @description Writing user input directly to an HTTP response allows for
 *              a cross-site scripting vulnerability.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id js/reflected-xss-path
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import javascript
import semmle.javascript.security.dataflow.ReflectedXss
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, ReflectedXss::Configuration cfg
where cfg.hasPathFlow(source, sink)
select sink, source, sink, "Cross-site scripting vulnerability due to $@.",
       source, "user-provided value"
