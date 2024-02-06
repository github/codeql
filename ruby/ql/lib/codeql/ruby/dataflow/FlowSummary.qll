/** Provides classes and predicates for defining flow summaries. */

import codeql.ruby.AST
private import codeql.ruby.CFG
private import codeql.ruby.typetracking.TypeTracking
import codeql.ruby.DataFlow
private import internal.FlowSummaryImpl as Impl
private import internal.DataFlowDispatch
private import internal.DataFlowImplCommon as DataFlowImplCommon
private import internal.DataFlowPrivate

// import all instances below
private module Summaries {
  private import codeql.ruby.Frameworks
  private import codeql.ruby.frameworks.data.ModelsAsData
}

deprecated class SummaryComponent = Impl::Private::SummaryComponent;

deprecated module SummaryComponent = Impl::Private::SummaryComponent;

deprecated class SummaryComponentStack = Impl::Private::SummaryComponentStack;

deprecated module SummaryComponentStack = Impl::Private::SummaryComponentStack;

/** A callable with a flow summary, identified by a unique string. */
abstract class SummarizedCallable extends LibraryCallable, Impl::Public::SummarizedCallable {
  bindingset[this]
  SummarizedCallable() { any() }

  /**
   * DEPRECATED: Use `propagatesFlow` instead.
   */
  deprecated predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
    this.propagatesFlow(input, output, preservesValue, _)
  }

  override predicate propagatesFlow(
    string input, string output, boolean preservesValue, string model
  ) {
    this.propagatesFlow(input, output, preservesValue) and model = ""
  }

  /**
   * Holds if data may flow from `input` to `output` through this callable.
   *
   * `preservesValue` indicates whether this is a value-preserving step or a taint-step.
   */
  predicate propagatesFlow(string input, string output, boolean preservesValue) { none() }

  /**
   * Gets the synthesized parameter that results from an input specification
   * that starts with `Argument[s]` for this library callable.
   */
  DataFlow::ParameterNode getParameter(string s) {
    exists(ParameterPosition pos |
      DataFlowImplCommon::parameterNode(result, TLibraryCallable(this), pos) and
      s = Impl::Input::encodeParameterPosition(pos)
    )
  }
}

/**
 * A callable with a flow summary, identified by a unique string, where all
 * calls to a method with the same name are considered relevant.
 */
abstract class SimpleSummarizedCallable extends SummarizedCallable {
  MethodCall mc;

  bindingset[this]
  SimpleSummarizedCallable() { mc.getMethodName() = this }

  final override MethodCall getACallSimple() { result = mc }
}

deprecated class RequiredSummaryComponentStack = Impl::Private::RequiredSummaryComponentStack;

/**
 * Provides a set of special flow summaries to ensure that callbacks passed into
 * library methods will be passed as `lambda-self` arguments into themselves. That is,
 * we are assuming that callbacks passed into library methods will be called, which is
 * needed for flow through captured variables.
 */
private module LibraryCallbackSummaries {
  private predicate libraryCall(CfgNodes::ExprNodes::CallCfgNode call) {
    not exists(getTarget(TNormalCall(call)))
  }

  private DataFlow::LocalSourceNode trackLambdaCreation(TypeTracker t) {
    t.start() and
    lambdaCreation(result, TLambdaCallKind(), _)
    or
    exists(TypeTracker t2 | result = trackLambdaCreation(t2).track(t2, t)) and
    not result instanceof DataFlow::SelfParameterNode
  }

  private predicate libraryCallHasLambdaArg(CfgNodes::ExprNodes::CallCfgNode call, int i) {
    exists(CfgNodes::ExprCfgNode arg |
      arg = call.getArgument(i) and
      arg = trackLambdaCreation(TypeTracker::end()).getALocalUse().asExpr() and
      libraryCall(call) and
      not arg instanceof CfgNodes::ExprNodes::BlockArgumentCfgNode
    )
  }

  private class LibraryLambdaMethod extends SummarizedCallable {
    LibraryLambdaMethod() { this = "<library method accepting a callback>" }

    final override MethodCall getACall() {
      libraryCall(result.getAControlFlowNode()) and
      result.hasBlock()
      or
      libraryCallHasLambdaArg(result.getAControlFlowNode(), _)
    }

    override predicate propagatesFlow(
      string input, string output, boolean preservesValue, string model
    ) {
      (
        input = "Argument[block]" and
        output = "Argument[block].Parameter[lambda-self]"
        or
        exists(int i |
          i in [0 .. 10] and
          input = "Argument[" + i + "]" and
          output = "Argument[" + i + "].Parameter[lambda-self]"
        )
      ) and
      preservesValue = true and
      model = "heuristic-callback"
    }
  }
}
