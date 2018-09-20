/**
 * @name Stored cross-site scripting
 * @description Using uncontrolled stored values in HTML allows for
 *              a stored cross-site scripting vulnerability.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id js/stored-xss
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import javascript
import semmle.javascript.security.dataflow.StoredXss::StoredXss

from Configuration xss, DataFlow::Node source, DataFlow::Node sink
where xss.hasFlow(source, sink)
select sink, "Stored cross-site scripting vulnerability due to $@.",
       source, "stored value"