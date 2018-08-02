/**
* @name Database query built from user-controlled sources
* @description Building a database query from user-controlled sources is vulnerable to insertion of
*              malicious code by the user.
* @kind problem
* @problem.severity error
* @precision high
* @id js/sql-injection
* @tags security
*       external/cwe/cwe-089
*/

import javascript
import semmle.javascript.security.dataflow.SqlInjection
import semmle.javascript.security.dataflow.NosqlInjection

predicate sqlInjection(DataFlow::Node source, DataFlow::Node sink) {
  any(SqlInjection::Configuration cfg).hasFlow(source, sink)
}

predicate nosqlInjection(DataFlow::Node source, DataFlow::Node sink) {
  any(NosqlInjection::Configuration cfg).hasFlow(source, sink)
}

from DataFlow::Node source, DataFlow::Node sink
where sqlInjection(source, sink) or
      nosqlInjection(source, sink)
select sink, "This query depends on $@.", source, "a user-provided value"
