import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.ExternalFlow

class Step extends SummaryModelCsv {
  override predicate row(string row) {
    row = ";Uri;false;getQueryParameter;;;Argument[-1];ReturnValue;taint;manual"
  }
}

class Conf extends TaintTracking::Configuration {
  Conf() { this = "qltest:notNullExprFlow" }

  override predicate isSource(DataFlow::Node n) {
    n.asExpr().(MethodAccess).getMethod().hasName("taint")
  }

  override predicate isSink(DataFlow::Node n) {
    n.asExpr().(Argument).getCall().getCallee().hasName("sink")
  }
}

from DataFlow::Node src, DataFlow::Node sink, Conf conf
where conf.hasFlow(src, sink)
select src, sink
