private import cpp
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.dataflow.DataFlow

Function viableImpl(CallInstruction call) { result = viableCallable(call) }

/**
 * Gets a function that might be called by `call`.
 */
Function viableCallable(CallInstruction call) {
  result = call.getStaticCallTarget()
  or
  // If the target of the call does not have a body in the snapshot, it might
  // be because the target is just a header declaration, and the real target
  // will be determined at run time when the caller and callee are linked
  // together by the operating system's dynamic linker. In case a _unique_
  // function with the right signature is present in the database, we return
  // that as a potential callee.
  exists(string qualifiedName, int nparams |
    callSignatureWithoutBody(qualifiedName, nparams, call) and
    functionSignatureWithBody(qualifiedName, nparams, result) and
    strictcount(Function other | functionSignatureWithBody(qualifiedName, nparams, other)) = 1
  )
  or
  // Rudimentary virtual dispatch support. It's essentially local data flow
  // where the source is a derived-to-base conversion and the target is the
  // qualifier of a call.
  exists(Class derived, DataFlow::Node thisArgument |
    nodeMayHaveClass(derived, thisArgument) and
    overrideMayAffectCall(derived, thisArgument, _, result, call)
  )
}

/**
 * Holds if `call` is a virtual function call with qualifier `thisArgument` in
 * `enclosingFunction`, whose static target is overridden by
 * `overridingFunction` in `overridingClass`.
 */
pragma[noinline]
private predicate overrideMayAffectCall(
  Class overridingClass, DataFlow::Node thisArgument, Function enclosingFunction,
  MemberFunction overridingFunction, CallInstruction call
) {
  call.getEnclosingFunction() = enclosingFunction and
  overridingFunction.getAnOverriddenFunction+() = call.getStaticCallTarget() and
  overridingFunction.getDeclaringType() = overridingClass and
  thisArgument = DataFlow::instructionNode(call.getThisArgument())
}

/**
 * Holds if `node` may have dynamic class `derived`, where `derived` is a class
 * that may affect virtual dispatch within the enclosing function.
 *
 * For the sake of performance, this recursion is written out manually to make
 * it a relation on `Class x Node` rather than `Node x Node` or `MemberFunction
 * x Node`, both of which would be larger. It's a forward search since there
 * should usually be fewer classes than calls.
 *
 * If a value is cast several classes up in the hierarchy, that will be modeled
 * as a chain of `ConvertToBaseInstruction`s and will cause the search to start
 * from each of them and pass through subsequent ones. There might be
 * performance to gain by stopping before a second upcast and reconstructing
 * the full chain in a "big-step" recursion after this one.
 */
private predicate nodeMayHaveClass(Class derived, DataFlow::Node node) {
  exists(ConvertToBaseInstruction toBase |
    derived = toBase.getDerivedClass() and
    overrideMayAffectCall(derived, _, toBase.getEnclosingFunction(), _, _) and
    node.asInstruction() = toBase
  )
  or
  exists(DataFlow::Node prev |
    nodeMayHaveClass(derived, prev) and
    DataFlow::localFlowStep(prev, node)
  )
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
 * Holds if the call context `ctx` reduces the set of viable dispatch
 * targets of `ma` in `c`.
 */
predicate reducedViableImplInCallContext(CallInstruction call, Function f, CallInstruction ctx) {
  none()
}

/**
 * Gets a viable dispatch target of `ma` in the context `ctx`. This is
 * restricted to those `ma`s for which the context makes a difference.
 */
Function prunedViableImplInCallContext(CallInstruction call, CallInstruction ctx) { none() }

/**
 * Holds if flow returning from `m` to `ma` might return further and if
 * this path restricts the set of call sites that can be returned to.
 */
predicate reducedViableImplInReturn(Function f, CallInstruction call) { none() }

/**
 * Gets a viable dispatch target of `ma` in the context `ctx`. This is
 * restricted to those `ma`s and results for which the return flow from the
 * result to `ma` restricts the possible context `ctx`.
 */
Function prunedViableImplInCallContextReverse(CallInstruction call, CallInstruction ctx) { none() }
