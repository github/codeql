/**
* @name Database query built from user-controlled sources
* @description Building a database query from user-controlled sources is vulnerable to insertion of
*              malicious code by the user.
* @kind path-problem
* @problem.severity error
* @precision high
* @id js/sql-injection
* @tags security
*       external/cwe/cwe-089
*/

import javascript
import semmle.javascript.security.dataflow.SqlInjection
import semmle.javascript.security.dataflow.NosqlInjection
import DataFlow::PathGraph

from DataFlow::Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where (cfg instanceof SqlInjection::Configuration or
       cfg instanceof NosqlInjection::Configuration) and
      cfg.hasPathFlow(source, sink)
select sink.getNode(), "This query depends on $@.", source, "a user-provided value"
