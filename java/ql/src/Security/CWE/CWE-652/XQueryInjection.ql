/**
 * @name XQuery query built from user-controlled sources
 * @description Building an XQuery query from user-controlled sources is vulnerable to insertion of
 *              malicious XQuery code by the user.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/XQuery-injection
 * @tags security
 *       external/cwe/cwe-652
 */

import java
import semmle.code.java.dataflow.FlowSources
import XQueryInjectionLib
import DataFlow::PathGraph

class XQueryInjectionConfig extends DataFlow::Configuration {
  XQueryInjectionConfig() { this = "XQueryInjectionConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof XQueryInjectionSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof XQueryInjectionSink }

  override predicate isBarrier(DataFlow::Node node) {
    exists(MethodAccess ma, Method m, BindParameterRemoteFlowConf conf, DataFlow::Node node1 |
      m = ma.getMethod()
    |
      node.asExpr() = ma and
      m.hasName("bindString") and
      m.getDeclaringType()
          .getASourceSupertype*()
          .hasQualifiedName("javax.xml.xquery", "XQDynamicContext") and
      ma.getArgument(1) = node1.asExpr() and
      conf.hasFlowTo(node1)
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, XQueryInjectionConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "XQuery query might include code from $@.", source.getNode(),
  "this user input"
