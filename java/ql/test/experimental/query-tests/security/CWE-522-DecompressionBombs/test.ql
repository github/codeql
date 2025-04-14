import java
deprecated import experimental.semmle.code.java.security.DecompressionBombQuery
import utils.test.InlineFlowTest
deprecated import TaintFlowTestArgString<DecompressionBombsConfig, getArgString/2>

string getArgString(DataFlow::Node src, DataFlow::Node sink) {
  exists(src) and
  result = "\"" + sink.toString() + "\""
}
