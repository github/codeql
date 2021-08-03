/**
 * @name Query built from user-controlled sources
 * @description Building a SQL in mybatis mapper.xml file from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id java/mybatis-xml-sql-injection
 * @tags security
 *       external/cwe/cwe-089
 *       external/cwe/cwe-564
 */

import java
import experimental.semmle.code.java.MybatisSqlTaintedLib
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, MybatisQueryInjectionFlowConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Sql query might include code from $@ this user input through mapper function param $@", source, source.toString(),sink, sink.toString()