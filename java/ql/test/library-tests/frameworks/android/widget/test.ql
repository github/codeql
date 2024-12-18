import java
import semmle.code.java.dataflow.FlowSources
import utils.test.InlineFlowTest
import DefaultFlowTest
import TaintFlow::PathGraph

query predicate valueOf(MethodCall ma) {
  ma.getMethod().hasQualifiedName("java.lang", "String", "valueOf")
}
