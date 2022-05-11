/**
 * @name XPath query built from user-controlled sources
 * @description Building a XPath query from user-controlled sources is vulnerable to insertion of
 *              malicious Xpath code by the user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id py/xpath-injection
 * @tags security
 *       external/cwe/cwe-643
 */

import python
import semmle.python.security.dataflow.XpathInjectionQuery
import DataFlow::PathGraph

from Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink, source, sink, "This Xpath query depends on $@.", source, "a user-provided value"
