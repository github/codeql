import java
import utils.test.InlineFlowTest
import semmle.code.java.security.TaintedPathQuery
import TaintFlowTestArgString<TaintedPathConfig, getArgString/2>

string getArgString(DataFlow::Node src, DataFlow::Node sink) {
  exists(src) and
  result = "\"" + sink.toString() + "\""
}
