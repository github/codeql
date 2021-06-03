/**
 * Provides C# specific classes and predicates for defining flow summaries.
 */

private import csharp
private import semmle.code.csharp.frameworks.system.linq.Expressions
private import DataFlowDispatch
private import DataFlowPrivate
private import DataFlowPublic
private import FlowSummaryImpl::Private
private import FlowSummaryImpl::Public
private import semmle.code.csharp.Unification

/** Holds is `i` is a valid parameter position. */
predicate parameterPosition(int i) { i in [-1 .. any(Parameter p).getPosition()] }

/** Gets the synthesized summary data-flow node for the given values. */
Node summaryNode(SummarizedCallable c, SummaryNodeState state) { result = TSummaryNode(c, state) }

/** Gets the synthesized data-flow call for `receiver`. */
SummaryCall summaryDataFlowCall(Node receiver) { receiver = result.getReceiver() }

/** Gets the type of content `c`. */
DataFlowType getContentType(Content c) {
  exists(Type t | result = Gvn::getGlobalValueNumber(t) |
    t = c.(FieldContent).getField().getType()
    or
    t = c.(PropertyContent).getProperty().getType()
    or
    c instanceof ElementContent and
    t instanceof ObjectType // we don't know what the actual element type is
  )
}

private DataFlowType getReturnTypeBase(DataFlowCallable c, ReturnKind rk) {
  exists(Type t | result = Gvn::getGlobalValueNumber(t) |
    rk instanceof NormalReturnKind and
    (
      t = c.(Constructor).getDeclaringType()
      or
      not c instanceof Constructor and
      t = c.getReturnType()
    )
    or
    t = c.getParameter(rk.(OutRefReturnKind).getPosition()).getType()
  )
}

/** Gets the return type of kind `rk` for callable `c`. */
bindingset[c]
DataFlowType getReturnType(SummarizedCallable c, ReturnKind rk) {
  result = getReturnTypeBase(c, rk)
  or
  rk =
    any(JumpReturnKind jrk | result = getReturnTypeBase(jrk.getTarget(), jrk.getTargetReturnKind()))
}

/**
 * Gets the type of the `i`th parameter in a synthesized call that targets a
 * callback of type `t`.
 */
DataFlowType getCallbackParameterType(DataFlowType t, int i) {
  exists(SystemLinqExpressions::DelegateExtType dt |
    t = Gvn::getGlobalValueNumber(dt) and
    result = Gvn::getGlobalValueNumber(dt.getDelegateType().getParameter(i).getType())
  )
}

/**
 * Gets the return type of kind `rk` in a synthesized call that targets a
 * callback of type `t`.
 */
DataFlowType getCallbackReturnType(DataFlowType t, ReturnKind rk) {
  rk instanceof NormalReturnKind and
  exists(SystemLinqExpressions::DelegateExtType dt |
    t = Gvn::getGlobalValueNumber(dt) and
    result = Gvn::getGlobalValueNumber(dt.getDelegateType().getReturnType())
  )
}

/** Holds if `spec` is a relevant external specification. */
predicate relevantSpec(string spec) { none() }

/**
 * Holds if an external flow summary exists for `c` with input specification
 * `input`, output specification `output`, and kind `kind`.
 */
predicate externalSummary(DataFlowCallable c, string input, string output, string kind) { none() }

/** Gets the summary component for specification component `c`, if any. */
bindingset[c]
SummaryComponent interpretComponentSpecific(string c) {
  c = "ReturnValue" and result = SummaryComponent::return(any(NormalReturnKind nrk))
  or
  c = "Element" and result = SummaryComponent::content(any(ElementContent ec))
  or
  exists(Field f |
    c.regexpCapture("Field\\[(.+)\\]", 1) = f.getQualifiedName() and
    result = SummaryComponent::content(any(FieldContent fc | fc.getField() = f))
  )
  or
  exists(Property p |
    c.regexpCapture("Property\\[(.+)\\]", 1) = p.getQualifiedName() and
    result = SummaryComponent::content(any(PropertyContent pc | pc.getProperty() = p))
  )
}
