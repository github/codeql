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
import experimental.semmle.code.java.MybatisSqlTaintedInParamLib
import DataFlow::PathGraph


from DataFlow::PathNode source, DataFlow::PathNode sink, MybatisQueryInjectionFlowConfig conf, SqlStatement sql
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
"source $@ as the param $@ of sql mapper method and will join together with $@ which result in SqlInjection",
 source, source.toString(),sink, sink.toString(), conf.getSql(sink.getNode(), sql), "mybatis mapper SQL"
