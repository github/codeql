/**
 * @name XML external entity expansion
 * @description Parsing user input as an XML document with external
 *              entity expansion is vulnerable to XXE attacks.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id js/xxe
 * @tags security
 *       external/cwe/cwe-611
 *       external/cwe/cwe-827
 */

import javascript
import semmle.javascript.security.dataflow.Xxe::Xxe

from Configuration c, DataFlow::Node source, DataFlow::Node sink
where c.hasFlow(source, sink)
select sink, "A $@ is parsed as XML without guarding against external entity expansion.",
       source, "user-provided value"
