/**
 * @name NoSQL Injection
 * @description Building a NoSQL query from user-controlled sources is vulnerable to insertion of
 *              malicious NoSQL code by the user.
 * @kind path-problem
 * @problem.severity error
 * @id python/nosql-injection
 * @tags experimental
 *       security
 *       external/cwe/cwe-943
 */

import python
import experimental.semmle.python.security.injection.NoSQLInjection

// https://github.com/github/codeql/blob/e266cedc84cf73d01c9b2d4b0e4313e5d96755ba/python/ql/src/semmle/python/security/dataflow/PathInjection.qll#L103
from CustomPathNode source, CustomPathNode sink
where noSQLInjectionFlow(source, sink)
select source, sink
