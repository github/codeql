/**
 * @name SqlAlchemy Injection
 * @description Building a SQL query from user-controlled sources is vulnerable to insertion of
 *              malicious SQL code by the user in SQLAlchemy.
 * @kind path-problem
 * @problem.severity error
 * @id python/sqlalchemy-injection
 * @tags experimental
 *       security
 *       external/cwe/cwe-089
 */

import python
import experimental.semmle.python.security.injection.SqlAlchemyInjection

from CustomPathNode source, CustomPathNode sink
where SqlAlchemyInjectionFlow(source, sink)
select sink, source, sink, "$@ SQL query contains an unsanitized $@", sink, "This", source,
  "user-provided value"
