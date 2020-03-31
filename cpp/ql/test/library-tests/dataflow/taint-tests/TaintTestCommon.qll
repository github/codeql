import cpp
import semmle.code.cpp.dataflow.TaintTracking
import semmle.code.cpp.models.interfaces.Taint

/** Common data flow configuration to be used by tests. */
class TestAllocationConfig extends TaintTracking::Configuration {
  TestAllocationConfig() { this = "TestAllocationConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().(FunctionCall).getTarget().getName() = "source"
    or
    source.asParameter().getName().matches("source%")
    or
    // Track uninitialized variables
    exists(source.asUninitialized())
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall call |
      call.getTarget().getName() = "sink" and
      sink.asExpr() = call.getAnArgument()
    )
  }

  override predicate isSanitizer(DataFlow::Node barrier) {
    barrier.asExpr().(VariableAccess).getTarget().hasName("sanitizer")
  }
}

class SetMemberFunction extends TaintFunction {
  SetMemberFunction() { this.hasName("setMember") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameter(0) and
    output.isQualifierObject()
  }
}

class GetMemberFunction extends TaintFunction {
  GetMemberFunction() { this.hasName("getMember") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValue()
  }
}

class SetStringFunction extends TaintFunction {
  SetStringFunction() { this.hasName("setString") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(0) and
    output.isQualifierObject()
  }
}

class GetStringFunction extends TaintFunction {
  GetStringFunction() { this.hasName("getString") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValueDeref()
  }
}
