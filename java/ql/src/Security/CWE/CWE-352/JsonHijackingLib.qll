import java
import DataFlow
import JsonStringLib
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.spring.SpringController

/** Json data flow */
class JsonFlowConfig extends DataFlow2::Configuration {
  JsonFlowConfig() { this = "JsonFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof JsonpStringSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(AddExpr ae |
      ae.getRightOperand().toString().regexpMatch("\"\\)\"|\"\\);\"") and
      ae.getLeftOperand()
          .(AddExpr)
          .getLeftOperand()
          .(AddExpr)
          .getRightOperand()
          .toString()
          .regexpMatch("\"\\(\"") and
      ae.getLeftOperand().(AddExpr).getRightOperand() = sink.asExpr()
    )
  }
}

/** User-controllable callback function name data flow */
class RemoteFlowConfig extends DataFlow2::Configuration {
  RemoteFlowConfig() { this = "RemoteFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(AddExpr ae |
      ae.getRightOperand().toString().regexpMatch("\"\\)\"|\"\\);\"") and
      ae.getLeftOperand()
          .(AddExpr)
          .getLeftOperand()
          .(AddExpr)
          .getRightOperand()
          .toString()
          .regexpMatch("\"\\(\"") and
      ae.getLeftOperand().(AddExpr).getLeftOperand().(AddExpr).getLeftOperand() = sink.asExpr()
    )
  }
}

/** A data flow source for unvalidated user input. */
class JsonHijackingSource extends DataFlow::Node {
  JsonHijackingSource() {
    exists(AddExpr ae |
      ae.getRightOperand().toString().regexpMatch("\"\\)\"|\"\\);\"") and
      ae.getLeftOperand()
          .(AddExpr)
          .getLeftOperand()
          .(AddExpr)
          .getRightOperand()
          .toString()
          .regexpMatch("\"\\(\"") and
      exists(JsonFlowConfig jfc |
        jfc.hasFlowTo(DataFlow::exprNode(ae.getLeftOperand().(AddExpr).getRightOperand()))
      ) and
      exists(RemoteFlowConfig rfc |
        rfc.hasFlowTo(DataFlow::exprNode(ae.getLeftOperand()
                .(AddExpr)
                .getLeftOperand()
                .(AddExpr)
                .getLeftOperand()))
      ) and
      ae = this.asExpr()
    )
  }
}

/** A data flow sink for unvalidated user input that is used to jsonp. */
abstract class JsonHijackingSink extends DataFlow::Node { }

/** Use ```print```, ```println```, ```write``` to output result. */
private class WriterPrintln extends JsonHijackingSink {
  WriterPrintln() {
    exists(MethodAccess ma |
      ma.getMethod().getName().regexpMatch("print|println|write") and
      ma.getMethod()
          .getDeclaringType()
          .getASourceSupertype*()
          .hasQualifiedName("java.io", "PrintWriter") and
      ma.getArgument(0) = this.asExpr()
    )
  }
}

/** Spring Request Method return result. */
private class SpringReturn extends JsonHijackingSink {
  SpringReturn() {
    exists(ReturnStmt rs, Method m | m = rs.getEnclosingCallable() |
      m instanceof SpringRequestMappingMethod and
      rs.getResult() = this.asExpr()
    )
  }
}
