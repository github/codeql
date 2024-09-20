/**
 * Provides consistency queries for checking invariants in the language-specific
 * data-flow classes and predicates.
 */

private import python
import semmle.python.dataflow.new.DataFlow::DataFlow
private import semmle.python.dataflow.new.internal.DataFlowImplSpecific
private import semmle.python.dataflow.new.internal.DataFlowDispatch
private import semmle.python.dataflow.new.internal.TaintTrackingImplSpecific
private import codeql.dataflow.internal.DataFlowImplConsistency

private module Input implements InputSig<Location, PythonDataFlow> {
  private import Private
  private import Public

  predicate postWithInFlowExclude(Node n) { n instanceof FlowSummaryNode }

  predicate uniqueNodeLocationExclude(Node n) { n instanceof FlowSummaryNode }

  predicate missingLocationExclude(Node n) { n instanceof FlowSummaryNode }

  predicate argHasPostUpdateExclude(ArgumentNode n) {
    // TODO: Implement post-updates for *args, see tests added in https://github.com/github/codeql/pull/14936
    exists(ArgumentPosition apos | n.argumentOf(_, apos) and apos.isStarArgs(_))
    or
    // TODO: Implement post-updates for **kwargs, see tests added in https://github.com/github/codeql/pull/14936
    exists(ArgumentPosition apos | n.argumentOf(_, apos) and apos.isDictSplat())
  }

  predicate reverseReadExclude(Node n) {
    // since `self`/`cls` parameters can be marked as implicit argument to `super()`,
    // they will have PostUpdateNodes. We have a read-step from the synthetic `**kwargs`
    // parameter, but dataflow-consistency queries should _not_ complain about there not
    // being a post-update node for the synthetic `**kwargs` parameter.
    n instanceof SynthDictSplatParameterNode
  }

  predicate uniqueParameterNodePositionExclude(DataFlowCallable c, ParameterPosition pos, Node p) {
    // For normal parameters that can both be passed as positional arguments or keyword
    // arguments, we currently have parameter positions for both cases..
    //
    // TODO: Figure out how bad breaking this consistency check is
    exists(Function func, Parameter param |
      c.getScope() = func and
      p = parameterNode(param) and
      c.getParameter(pos) = p and
      param = func.getArg(_) and
      param = func.getArgByName(_)
    )
  }

  predicate uniqueEnclosingCallableExclude(Node n) {
    // We only have a selection of valid callables.
    // For instance, we do not have classes as `DataFlowCallable`s.
    not n.(SynthCaptureNode).getSynthesizedCaptureNode().getEnclosingCallable() instanceof Function and
    not n.(SynthCaptureNode).getSynthesizedCaptureNode().getEnclosingCallable() instanceof Module
  }

  predicate uniqueCallEnclosingCallableExclude(DataFlowCall call) {
    not exists(call.getLocation().getFile().getRelativePath())
  }

  predicate identityLocalStepExclude(Node n) {
    not exists(n.getLocation().getFile().getRelativePath())
  }

  predicate multipleArgumentCallExclude(ArgumentNode arg, DataFlowCall call) {
    // since we can have multiple DataFlowCall for a CallNode (for example if it can
    // resolve to multiple functions), but we only make _one_ ArgumentNode for each
    // argument in the CallNode, we end up violating this consistency check in those
    // cases. (see `getCallArg` in DataFlowDispatch.qll)
    exists(DataFlowCall other, CallNode cfgCall | other != call |
      call.getNode() = cfgCall and
      other.getNode() = cfgCall and
      isArgumentNode(arg, call, _) and
      isArgumentNode(arg, other, _)
    )
    or
    // bound methods that refer to the same self argument.
    // Example: In `bm = self.foo; bm(); bm()` both bm() calls use the same `self` as
    // the (pos self) argument
    exists(AttrRead attr, DataFlowCall other | other != call |
      // for simple cases we can track the function back to the attr read but when the
      // call appears in the body of a list-comprehension, we can't do that, and simply
      // allow it instead.
      (
        call.getScope() = attr.getScope() and
        any(CfgNode n | n.asCfgNode() = call.getNode().(CallNode).getFunction()).getALocalSource() =
          attr
        or
        not exists(call.getScope().(Function).getDefinition()) and
        call.getScope().getScope+() = attr.getScope()
      ) and
      (
        other.getScope() = attr.getScope() and
        any(CfgNode n | n.asCfgNode() = other.getNode().(CallNode).getFunction()).getALocalSource() =
          attr
        or
        not exists(other.getScope().(Function).getDefinition()) and
        other.getScope().getScope+() = attr.getScope()
      ) and
      arg = attr.getObject() and
      arg = call.getArgument(any(ArgumentPosition p | p.isSelf())) and
      arg = other.getArgument(any(ArgumentPosition p | p.isSelf()))
    )
    or
    // `f = getattr(obj, "foo"); f()` where `obj` is used as (pos self) argument for
    // `f()` call
    exists(DataFlowCall getAttrCall, DataFlowCall methodCall, AttrRead attr |
      call in [getAttrCall, methodCall]
    |
      arg = getAttrCall.getArgument(any(ArgumentPosition p | p.isPositional(0))) and
      arg = methodCall.getArgument(any(ArgumentPosition p | p.isSelf())) and
      attr.getObject() = arg and
      attr.(CfgNode).getNode() = getAttrCall.getNode()
    )
    or
    // In the code `super(Base, self).foo()` we use `self` as an argument in both the
    // super() call (pos 1) and in the .foo() call (pos self).
    exists(DataFlowCall superCall, DataFlowCall methodCall | call in [superCall, methodCall] |
      exists(superCallTwoArgumentTracker(_, arg)) and
      arg = superCall.getArgument(any(ArgumentPosition p | p.isPositional(1))) and
      arg = methodCall.getArgument(any(ArgumentPosition p | p.isSelf()))
    )
    or
    // in the code `def func(self): super().foo(); super.bar()` we use `self` as the
    // (pos self) argument in both .foo() and .bar() calls.
    exists(Function f, DataFlowCall other | other != call |
      exprNode(f.getArg(0)) = arg and
      call.getNode().getScope() = f and
      arg = call.getArgument(any(ArgumentPosition p | p.isSelf())) and
      arg = other.getArgument(any(ArgumentPosition p | p.isSelf())) and
      other.getNode().getScope() = f
    )
  }
}

import MakeConsistency<Location, PythonDataFlow, PythonTaintTracking, Input>
