import shared.FlowSummaries
private import semmle.code.csharp.dataflow.internal.ExternalFlow

/** Holds if `c` is a base callable or prototype. */
private predicate isBaseCallableOrPrototype(UnboundCallable c) {
  c.getDeclaringType() instanceof Interface
  or
  exists(Modifiable m | m = [c.(Modifiable), c.(Accessor).getDeclaration()] |
    m.isAbstract()
    or
    c.getDeclaringType().(Modifiable).isAbstract() and m.(Virtualizable).isVirtual()
  )
}

class IncludeFilteredSummarizedCallable extends IncludeSummarizedCallable {
  /**
   * Holds if flow is propagated between `input` and `output` and
   * if there is no summary for a callable in a `base` class or interface
   * that propagates the same flow between `input` and `output`.
   */
  override predicate relevantSummary(
    SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
  ) {
    this.propagatesFlow(input, output, preservesValue, _) and
    not exists(IncludeSummarizedCallable rsc |
      isBaseCallableOrPrototype(rsc) and
      rsc.propagatesFlow(input, output, preservesValue, _) and
      this.(UnboundCallable).overridesOrImplementsUnbound(rsc)
    )
  }
}

import TestSummaryOutput<IncludeFilteredSummarizedCallable>
