deprecated module;

import java
import semmle.code.java.dataflow.FlowSources

/**
 * Holds if `fromNode` to `toNode` is a dataflow step that returns data from
 * a bean by calling one of its getters.
 */
predicate hasGetterFlow(DataFlow::Node fromNode, DataFlow::Node toNode) {
  exists(MethodCall ma, Method m | ma.getMethod() = m |
    m instanceof GetterMethod and
    ma.getQualifier() = fromNode.asExpr() and
    ma = toNode.asExpr()
  )
}
