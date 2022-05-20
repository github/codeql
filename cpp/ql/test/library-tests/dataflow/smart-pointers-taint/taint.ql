import TestUtilities.dataflow.FlowTestCommon

module AstTest {
  private import semmle.code.cpp.dataflow.TaintTracking

  class AstSmartPointerTaintConfig extends TaintTracking::Configuration {
    AstSmartPointerTaintConfig() { this = "ASTSmartPointerTaintConfig" }

    override predicate isSource(DataFlow::Node source) {
      source.asExpr().(FunctionCall).getTarget().getName() = "source"
    }

    override predicate isSink(DataFlow::Node sink) {
      exists(FunctionCall call |
        call.getTarget().getName() = "sink" and
        sink.asExpr() = call.getAnArgument()
      )
    }
  }
}

module IRTest {
  private import semmle.code.cpp.ir.dataflow.TaintTracking

  class IRSmartPointerTaintConfig extends TaintTracking::Configuration {
    IRSmartPointerTaintConfig() { this = "IRSmartPointerTaintConfig" }

    override predicate isSource(DataFlow::Node source) {
      source.asExpr().(FunctionCall).getTarget().getName() = "source"
    }

    override predicate isSink(DataFlow::Node sink) {
      exists(FunctionCall call |
        call.getTarget().getName() = "sink" and
        sink.asExpr() = call.getAnArgument()
      )
    }
  }
}
