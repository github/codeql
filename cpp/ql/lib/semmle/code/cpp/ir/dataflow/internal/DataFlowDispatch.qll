private import cpp
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.dataflow.DataFlow
private import DataFlowPrivate as DataFlowPrivate
private import DataFlowUtil
private import DataFlowImplCommon as DataFlowImplCommon
private import codeql.typetracking.TypeTracking
private import SsaImpl as SsaImpl

/**
 * Holds if `f` has name `qualifiedName` and `nparams` parameter count. This is
 * an approximation of its signature for the purpose of matching functions that
 * might be the same across link targets.
 */
private predicate functionSignature(Function f, string qualifiedName, int nparams) {
  qualifiedName = f.getQualifiedName() and
  nparams = f.getNumberOfParameters() and
  not f.isStatic()
}

/**
 * Holds if `f` is a function with a body that has name `qualifiedName` and
 * `nparams` parameter count. See `functionSignature`.
 */
private predicate functionSignatureWithBody(string qualifiedName, int nparams, Function f) {
  functionSignature(f, qualifiedName, nparams) and
  exists(f.getBlock())
}

/**
 * Holds if the target of `call` is a function _with no definition_ that has
 * name `qualifiedName` and `nparams` parameter count. See `functionSignature`.
 */
pragma[noinline]
private predicate callSignatureWithoutBody(string qualifiedName, int nparams, CallInstruction call) {
  exists(Function target |
    target = call.getStaticCallTarget() and
    not exists(target.getBlock()) and
    functionSignature(target, qualifiedName, nparams)
  )
}

/**
 * Gets a function that might be called by `call`.
 *
 * This predicate does not take additional call targets
 * from `AdditionalCallTarget` into account.
 */
cached
DataFlowPrivate::DataFlowCallable defaultViableCallable(DataFlowPrivate::DataFlowCall call) {
  result = defaultViableCallableWithoutLambda(call)
  or
  result = DataFlowImplCommon::viableCallableLambda(call, _)
}

private DataFlowPrivate::DataFlowCallable defaultViableCallableWithoutLambda(
  DataFlowPrivate::DataFlowCall call
) {
  DataFlowImplCommon::forceCachingInSameStage() and
  result = call.getStaticCallTarget()
  or
  // If the target of the call does not have a body in the snapshot, it might
  // be because the target is just a header declaration, and the real target
  // will be determined at run time when the caller and callee are linked
  // together by the operating system's dynamic linker. In case a _unique_
  // function with the right signature is present in the database, we return
  // that as a potential callee.
  exists(string qualifiedName, int nparams |
    callSignatureWithoutBody(qualifiedName, nparams, call.asCallInstruction()) and
    functionSignatureWithBody(qualifiedName, nparams, result.getUnderlyingCallable()) and
    strictcount(Function other | functionSignatureWithBody(qualifiedName, nparams, other)) = 1
  )
}

/**
 * Gets a function that might be called by `call`.
 */
private DataFlowPrivate::DataFlowCallable nonVirtualDispatch(DataFlowPrivate::DataFlowCall call) {
  result = defaultViableCallableWithoutLambda(call)
  or
  // Additional call targets
  result.getUnderlyingCallable() =
    any(AdditionalCallTarget additional)
        .viableTarget(call.asCallInstruction().getUnconvertedResultExpression())
}

private class RelevantNode extends Node {
  RelevantNode() { this.getType().stripType() instanceof Class }
}

private signature DataFlowPrivate::DataFlowCallable methodDispatchSig(
  DataFlowPrivate::DataFlowCall c
);

private predicate ignoreConstructor(Expr e) {
  e instanceof ConstructorDirectInit or
  e instanceof ConstructorVirtualInit or
  e instanceof ConstructorDelegationInit or
  exists(ConstructorFieldInit init | init.getExpr() = e)
}

/**
 * Holds if `n` is either:
 * - the post-update node of a qualifier after a call to a constructor which
 * constructs an object containing at least one virtual function.
 * - a node which represents a derived-to-base instruction that converts from `c`.
 */
private predicate qualifierSourceImpl(RelevantNode n, Class c) {
  // Object construction
  exists(CallInstruction call, ThisArgumentOperand qualifier, Call e |
    qualifier = call.getThisArgumentOperand() and
    n.(PostUpdateNode).getPreUpdateNode().asOperand() = qualifier and
    call.getStaticCallTarget() instanceof Constructor and
    qualifier.getType().stripType() = c and
    c.getABaseClass*().getAMemberFunction().isVirtual() and
    e = call.getUnconvertedResultExpression() and
    not ignoreConstructor(e)
  |
    exists(c.getABaseClass())
    or
    exists(c.getADerivedClass())
  )
  or
  // Conversion to a base class
  exists(ConvertToBaseInstruction convert |
    // Only keep the most specific cast
    not convert.getUnary() instanceof ConvertToBaseInstruction and
    n.asInstruction() = convert and
    convert.getDerivedClass() = c and
    c.getABaseClass*().getAMemberFunction().isVirtual()
  )
}

private module TrackVirtualDispatch<methodDispatchSig/1 virtualDispatch0> {
  /**
   * Gets a possible runtime target of `c` using both static call-target
   * information, and call-target resolution from `virtualDispatch0`.
   */
  private DataFlowPrivate::DataFlowCallable dispatch(DataFlowPrivate::DataFlowCall c) {
    result = nonVirtualDispatch(c) or
    result = virtualDispatch0(c)
  }

  private module TtInput implements TypeTrackingInput<Location> {
    final class Node = RelevantNode;

    class LocalSourceNode extends Node {
      LocalSourceNode() {
        this instanceof ParameterNode
        or
        this instanceof DataFlowPrivate::OutNode
        or
        DataFlowPrivate::readStep(_, _, this)
        or
        DataFlowPrivate::storeStep(_, _, this)
        or
        DataFlowPrivate::jumpStep(_, this)
        or
        qualifierSourceImpl(this, _)
      }
    }

    final private class ContentSetFinal = ContentSet;

    class Content extends ContentSetFinal {
      Content() {
        exists(DataFlow::Content c |
          this.isSingleton(c) and
          c.getIndirectionIndex() = 1
        )
      }
    }

    class ContentFilter extends Content {
      Content getAMatchingContent() { result = this }
    }

    predicate compatibleContents(Content storeContents, Content loadContents) {
      storeContents = loadContents
    }

    predicate simpleLocalSmallStep(Node nodeFrom, Node nodeTo) {
      nodeFrom.getFunction() instanceof Function and
      simpleLocalFlowStep(nodeFrom, nodeTo, _)
    }

    predicate levelStepNoCall(Node n1, LocalSourceNode n2) { none() }

    predicate levelStepCall(Node n1, LocalSourceNode n2) { none() }

    predicate storeStep(Node n1, Node n2, Content f) { DataFlowPrivate::storeStep(n1, f, n2) }

    predicate callStep(Node n1, LocalSourceNode n2) {
      exists(DataFlowPrivate::DataFlowCall call, DataFlowPrivate::Position pos |
        n1.(DataFlowPrivate::ArgumentNode).argumentOf(call, pos) and
        n2.(ParameterNode).isParameterOf(dispatch(call), pos)
      )
    }

    predicate returnStep(Node n1, LocalSourceNode n2) {
      exists(DataFlowPrivate::DataFlowCallable callable, DataFlowPrivate::DataFlowCall call |
        n1.(DataFlowPrivate::ReturnNode).getEnclosingCallable() = callable and
        callable = dispatch(call) and
        n2 = DataFlowPrivate::getAnOutNode(call, n1.(DataFlowPrivate::ReturnNode).getKind())
      )
    }

    predicate loadStep(Node n1, LocalSourceNode n2, Content f) {
      DataFlowPrivate::readStep(n1, f, n2)
    }

    predicate loadStoreStep(Node nodeFrom, Node nodeTo, Content f1, Content f2) { none() }

    predicate withContentStep(Node nodeFrom, LocalSourceNode nodeTo, ContentFilter f) { none() }

    predicate withoutContentStep(Node nodeFrom, LocalSourceNode nodeTo, ContentFilter f) { none() }

    predicate jumpStep(Node n1, LocalSourceNode n2) { DataFlowPrivate::jumpStep(n1, n2) }

    predicate hasFeatureBacktrackStoreTarget() { none() }
  }

  private predicate qualifierSource(RelevantNode n) { qualifierSourceImpl(n, _) }

  /**
   * Holds if `n` is the qualifier of `call` which targets the virtual member
   * function `mf`.
   */
  private predicate qualifierOfVirtualCallImpl(
    RelevantNode n, CallInstruction call, MemberFunction mf
  ) {
    n.asOperand() = call.getThisArgumentOperand() and
    call.getStaticCallTarget() = mf and
    mf.isVirtual()
  }

  private predicate qualifierOfVirtualCall(RelevantNode n) { qualifierOfVirtualCallImpl(n, _, _) }

  private import TypeTracking<Location, TtInput>::TypeTrack<qualifierSource/1>::Graph<qualifierOfVirtualCall/1>

  private predicate edgePlus(PathNode n1, PathNode n2) = fastTC(edges/2)(n1, n2)

  /**
   * Gets the most specific implementation of `mf` that may be called when the
   * qualifier has runtime type `c`.
   */
  private MemberFunction mostSpecific(MemberFunction mf, Class c) {
    qualifierOfVirtualCallImpl(_, _, mf) and
    mf.getAnOverridingFunction*() = result and
    (
      result.getDeclaringType() = c
      or
      not c.getAMemberFunction().getAnOverriddenFunction*() = mf and
      result = mostSpecific(mf, c.getABaseClass())
    )
  }

  /**
   * Gets a possible pair of end-points `(p1, p2)` where:
   * - `p1` is a derived-to-base conversion that converts from some
   * class `derived`, and
   * - `p2` is the qualifier of a call to a virtual function that may
   * target `callable`, and
   * - `callable` is the most specific implementation that may be called when
   * the qualifier has type `derived`.
   */
  private predicate pairCand(
    PathNode p1, PathNode p2, DataFlowPrivate::DataFlowCallable callable,
    DataFlowPrivate::DataFlowCall call
  ) {
    exists(Class derived, MemberFunction mf |
      qualifierSourceImpl(p1.getNode(), derived) and
      qualifierOfVirtualCallImpl(p2.getNode(), call.asCallInstruction(), mf) and
      p1.isSource() and
      p2.isSink() and
      callable.asSourceCallable() = mostSpecific(mf, derived)
    )
  }

  /** Gets a possible run-time target of `call`. */
  DataFlowPrivate::DataFlowCallable virtualDispatch(DataFlowPrivate::DataFlowCall call) {
    exists(PathNode p1, PathNode p2 | p1 = p2 or edgePlus(p1, p2) | pairCand(p1, p2, result, call))
  }
}

private DataFlowPrivate::DataFlowCallable noDisp(DataFlowPrivate::DataFlowCall call) { none() }

pragma[nomagic]
private DataFlowPrivate::DataFlowCallable d1(DataFlowPrivate::DataFlowCall call) {
  result = TrackVirtualDispatch<noDisp/1>::virtualDispatch(call)
}

pragma[nomagic]
private DataFlowPrivate::DataFlowCallable d2(DataFlowPrivate::DataFlowCall call) {
  result = TrackVirtualDispatch<d1/1>::virtualDispatch(call)
}

pragma[nomagic]
private DataFlowPrivate::DataFlowCallable d3(DataFlowPrivate::DataFlowCall call) {
  result = TrackVirtualDispatch<d2/1>::virtualDispatch(call)
}

pragma[nomagic]
private DataFlowPrivate::DataFlowCallable d4(DataFlowPrivate::DataFlowCall call) {
  result = TrackVirtualDispatch<d3/1>::virtualDispatch(call)
}

pragma[nomagic]
private DataFlowPrivate::DataFlowCallable d5(DataFlowPrivate::DataFlowCall call) {
  result = TrackVirtualDispatch<d4/1>::virtualDispatch(call)
}

pragma[nomagic]
private DataFlowPrivate::DataFlowCallable d6(DataFlowPrivate::DataFlowCall call) {
  result = TrackVirtualDispatch<d5/1>::virtualDispatch(call)
}

/** Gets a function that might be called by `call`. */
cached
DataFlowPrivate::DataFlowCallable viableCallable(DataFlowPrivate::DataFlowCall call) {
  not exists(d6(call)) and
  result = nonVirtualDispatch(call)
  or
  result = d6(call)
}

/**
 * Holds if the set of viable implementations that can be called by `call`
 * might be improved by knowing the call context.
 */
predicate mayBenefitFromCallContext(DataFlowPrivate::DataFlowCall call) {
  mayBenefitFromCallContext(call, _, _)
}

private predicate localLambdaFlowStep(Node nodeFrom, Node nodeTo) {
  localFlowStep(nodeFrom, nodeTo)
  or
  DataFlowPrivate::additionalLambdaFlowStep(nodeFrom, nodeTo, _)
}

/**
 * Holds if `call` is a call through a function pointer, and the pointer
 * value is given as the `arg`'th argument to `f`.
 */
private predicate mayBenefitFromCallContext(
  DataFlowPrivate::DataFlowCall call, DataFlowPrivate::DataFlowCallable f, int arg
) {
  f = pragma[only_bind_out](call).getEnclosingCallable() and
  exists(InitializeParameterInstruction init |
    not exists(call.getStaticCallTarget())
    or
    exists(call.getStaticCallSourceTarget().(VirtualFunction).getAnOverridingFunction())
  |
    init.getEnclosingFunction() = f.getUnderlyingCallable() and
    localLambdaFlowStep+(instructionNode(init),
      operandNode(call.asCallInstruction().getCallTargetOperand())) and
    init.getParameter().getIndex() = arg
  )
}

/**
 * Gets a viable dispatch target of `call` in the context `ctx`. This is
 * restricted to those `call`s for which a context might make a difference.
 */
DataFlowPrivate::DataFlowCallable viableImplInCallContext(
  DataFlowPrivate::DataFlowCall call, DataFlowPrivate::DataFlowCall ctx
) {
  result = viableCallable(call) and
  exists(int i, DataFlowPrivate::DataFlowCallable f |
    mayBenefitFromCallContext(pragma[only_bind_into](call), f, i) and
    f = ctx.getStaticCallTarget() and
    result.asSourceCallable() =
      ctx.getArgument(i).getUnconvertedResultExpression().(FunctionAccess).getTarget()
  )
}

/** Holds if arguments at position `apos` match parameters at position `ppos`. */
pragma[inline]
predicate parameterMatch(
  DataFlowPrivate::ParameterPosition ppos, DataFlowPrivate::ArgumentPosition apos
) {
  ppos = apos
}
