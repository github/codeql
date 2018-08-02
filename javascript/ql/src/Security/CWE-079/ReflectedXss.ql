/**
 * @name Reflected cross-site scripting
 * @description Writing user input directly to an HTTP response allows for
 *              a cross-site scripting vulnerability.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id js/reflected-xss
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import javascript
import semmle.javascript.security.dataflow.ReflectedXss::ReflectedXss

from Configuration xss, DataFlow::Node source, DataFlow::Node sink
where xss.hasFlow(source, sink)
select sink, "Cross-site scripting vulnerability due to $@.",
       source, "user-provided value"