/**
 * @name SQL query built from user-controlled sources
 * @description Building a SQL query from user-controlled sources is vulnerable to insertion of
 *              malicious SQL code by the user.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id py/sql-injection
 * @tags security
 *       external/cwe/cwe-089
 *       external/owasp/owasp-a1
 */

import python

/* Sources */
import semmle.python.web.HttpRequest

/* Sinks */
import semmle.python.security.injection.Sql
import semmle.python.web.django.Db
import semmle.python.web.django.Model


from TaintSource src, TaintSink sink
where src.flowsToSink(sink)

select sink, "This SQL query depends on $@.", src, "a user-provided value"
