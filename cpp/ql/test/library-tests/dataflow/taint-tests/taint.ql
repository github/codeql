import utils.test.dataflow.FlowTestCommon

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
  module AstTestAllocationConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
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

    predicate isSink(DataFlow::Node sink) {
      exists(FunctionCall call |
        call.getTarget().getName() = "sink" and
        sink.asExpr() = call.getAnArgument()
      )
    }

    predicate isBarrier(DataFlow::Node barrier) {
      barrier.asExpr().(VariableAccess).getTarget().hasName("sanitizer")
    }
  }

  module AstFlow = TaintTracking::Global<AstTestAllocationConfig>;
}

module IRTest {
  private import semmle.code.cpp.ir.IR
  private import semmle.code.cpp.ir.dataflow.TaintTracking
  private import semmle.code.cpp.ir.dataflow.FlowSteps

  /**
   * Object->field flow when the object is of type
   * TaintInheritingContentObject and the field is named
   * flowFromObject
   */
  class TaintInheritingContentTest extends TaintInheritingContent, DataFlow::FieldContent {
    TaintInheritingContentTest() {
      exists(Struct o, Field f |
        this.getField() = f and
        f = o.getAField() and
        o.hasGlobalName("TaintInheritingContentObject") and
        f.hasName("flowFromObject") and
        this.getIndirectionIndex() = 1
      )
    }
  }

  /** Common data flow configuration to be used by tests. */
  module TestAllocationConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      source.asExpr().(FunctionCall).getTarget().getName() = "source"
      or
      source.asIndirectExpr().(FunctionCall).getTarget().getName() = "source"
      or
      source.asIndirectExpr().(FunctionCall).getTarget().getName() = "indirect_source"
      or
      source.asParameter().getName().matches("source%")
      or
      exists(FunctionCall fc |
        fc.getAnArgument() = source.asDefiningArgument() and
        fc.getTarget().hasName("argument_source")
      )
    }

    predicate isSink(DataFlow::Node sink) {
      exists(FunctionCall call |
        call.getTarget().getName() = "sink" and
        [sink.asExpr(), sink.asIndirectExpr()] = call.getAnArgument()
      )
    }

    predicate isBarrier(DataFlow::Node barrier) {
      barrier.asExpr().(VariableAccess).getTarget().hasName("sanitizer")
    }

    predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c) {
      // allow arbitrary reads at sinks
      isSink(node) and
      c.(DataFlow::FieldContent).getField().getDeclaringType() = node.getType().getUnspecifiedType()
    }
  }

  module IRFlow = TaintTracking::Global<TestAllocationConfig>;
}

import MakeTest<MergeTests<AstFlowTest<AstTest::AstFlow>, IRFlowTest<IRTest::IRFlow>>>
