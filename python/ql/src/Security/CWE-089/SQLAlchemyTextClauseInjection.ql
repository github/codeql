/**
 * @name SQLAlchemy TextClause built from user-controlled sources
 * @description Building a TextClause query from user-controlled sources is vulnerable to insertion of
 *              malicious SQL code by the user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id py/sqlalchemy-textclause-injection
 * @tags security
 *       external/cwe/cwe-089
 *       external/owasp/owasp-a1
 */

import python
import semmle.python.security.dataflow.SQLAlchemyTextClause
import DataFlow::PathGraph

from SQLAlchemyTextClause::Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "This SQLAlchemy TextClause depends on $@, which could lead to SQL injection.", source.getNode(),
  "a user-provided value"
