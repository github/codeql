import java
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineFlowTest
import DefaultFlowTest

query predicate valueOf(MethodAccess ma) {
  ma.getMethod().hasQualifiedName("java.lang", "String", "valueOf")
}
