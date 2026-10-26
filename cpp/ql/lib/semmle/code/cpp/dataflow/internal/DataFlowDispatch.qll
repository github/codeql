/**
 * DEPRECATED: Use `semmle.code.cpp.dataflow.new.DataFlow` instead.
 */

private import cpp
private import DataFlowPrivate
private import DataFlowUtil

/**
 * Gets a function that might be called by `call`.
 */
DataFlowCallable viableCallable(DataFlowCall call) {
  result = call.(Call).getTarget()
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
private predicate callSignatureWithoutBody(string qualifiedName, int nparams, Call call) {
  exists(Function target |
    target = call.getTarget() and
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

/** A parameter position represented by an integer. */
class ParameterPosition extends int {
  ParameterPosition() { any(ParameterNode p).isParameterOf(_, this) }
}

/** An argument position represented by an integer. */
class ArgumentPosition extends int {
  ArgumentPosition() { any(ArgumentNode a).argumentOf(_, this) }
}

/** Holds if arguments at position `apos` match parameters at position `ppos`. */
pragma[inline]
predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) { ppos = apos }
