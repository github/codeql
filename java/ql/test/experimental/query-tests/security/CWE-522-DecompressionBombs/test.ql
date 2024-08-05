import java
import experimental.semmle.code.java.security.DecompressionBombQuery
import TestUtilities.InlineFlowTest
import TaintFlowTestArgString<DecompressionBombsConfig, getArgString/2>

string getArgString(DataFlow::Node src, DataFlow::Node sink) {
  exists(src) and
  result = "\"" + sink.toString() + "\""
}
