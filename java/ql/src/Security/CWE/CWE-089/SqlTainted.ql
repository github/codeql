/**
 * @name Query built from user-controlled sources
 * @description Building a SQL or Java Persistence query from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/sql-injection
 * @tags security
 *       external/cwe/cwe-089
 */

import semmle.code.java.Expr
import semmle.code.java.dataflow.FlowSources
import SqlInjectionLib


from QueryInjectionSink query, RemoteUserInput source
where queryTaintedBy(query, source)
select query, "Query might include code from $@.",
  source, "this user input"
