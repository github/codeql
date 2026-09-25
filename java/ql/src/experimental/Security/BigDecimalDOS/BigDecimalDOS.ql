/**
 * @id java/BigDecimalDOS
 * @name Java-BigDecimal-DOS-Vulnerability
 * @description When user-controllable data is passed to the relevant methods in BigDecimal, it may cause DOS issues when computing resources are limited. This issue is common in business scenarios such as e-commerce platforms.
 * @kind path-problem
 * @problem.severity error
 */

import java
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

class BigDecimalDOSConfig extends TaintTracking::Configuration {
  BigDecimalDOSConfig() { this = "Java-BigDecimal-DOS-Vulnerability-Config" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(Method method, MethodAccess call |
      method.getDeclaringType().hasQualifiedName("java.math", "BigDecimal") and
      method.hasName(["add", "subtract"]) and
      call.getMethod() = method and
      sink.asExpr() = call.getArgument(0)
    )
  }
}

from BigDecimalDOSConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select source.getNode(), source, sink, "Potential Java BigDecimal DOS issue due to $@.",
  source.getNode(), "a user-provided value"
