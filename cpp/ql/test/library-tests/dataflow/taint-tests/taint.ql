import TestUtilities.dataflow.FlowTestCommon

module TaintModels {
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
}

module AstTest {
  private import semmle.code.cpp.dataflow.TaintTracking
  private import semmle.code.cpp.models.interfaces.Taint

  /** Common data flow configuration to be used by tests. */
  class AstTestAllocationConfig extends TaintTracking::Configuration {
    AstTestAllocationConfig() { this = "ASTTestAllocationConfig" }

    override predicate isSource(DataFlow::Node source) {
      source.asExpr().(FunctionCall).getTarget().getName() = "source"
      or
      source.asParameter().getName().matches("source%")
      or
      // Track uninitialized variables
      exists(source.asUninitialized())
      or
      exists(FunctionCall fc |
        fc.getAnArgument() = source.asDefiningArgument() and
        fc.getTarget().hasName("argument_source")
      )
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
}

module IRTest {
  private import semmle.code.cpp.ir.IR
  private import semmle.code.cpp.ir.dataflow.TaintTracking

  /** Common data flow configuration to be used by tests. */
  class TestAllocationConfig extends TaintTracking::Configuration {
    TestAllocationConfig() { this = "TestAllocationConfig" }

    override predicate isSource(DataFlow::Node source) {
      source.asConvertedExpr().(FunctionCall).getTarget().getName() = "source"
      or
      source.asParameter().getName().matches("source%")
      or
      exists(FunctionCall fc |
        fc.getAnArgument() = source.asDefiningArgument() and
        fc.getTarget().hasName("argument_source")
      )
    }

    override predicate isSink(DataFlow::Node sink) {
      exists(FunctionCall call |
        call.getTarget().getName() = "sink" and
        sink.asConvertedExpr() = call.getAnArgument()
        or
        call.getTarget().getName() = "sink" and
        sink.asExpr() = call.getAnArgument() and
        sink.asConvertedExpr() instanceof ReferenceDereferenceExpr
      )
      or
      exists(ReadSideEffectInstruction read |
        read.getSideEffectOperand() = sink.asOperand() and
        read.getPrimaryInstruction().(CallInstruction).getStaticCallTarget().hasName("sink")
      )
    }

    override predicate isSanitizer(DataFlow::Node barrier) {
      barrier.asExpr().(VariableAccess).getTarget().hasName("sanitizer")
    }
  }
}
