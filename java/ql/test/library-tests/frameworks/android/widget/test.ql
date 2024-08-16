import java
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineFlowTest
import DefaultFlowTest
import TaintFlow::PathGraph

query predicate valueOf(MethodCall ma) {
  ma.getMethod().hasQualifiedName("java.lang", "String", "valueOf")
}
