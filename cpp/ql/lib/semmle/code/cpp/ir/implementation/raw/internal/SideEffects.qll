/**
 * Predicates to compute the modeled side effects of calls during IR construction.
 *
 * These are used in `TranslatedElement.qll` to generate the `TTranslatedSideEffect` instances, and
 * also in `TranslatedCall.qll` to inject the actual side effect instructions.
 */

private import cpp
private import semmle.code.cpp.ir.implementation.Opcode
private import semmle.code.cpp.models.interfaces.PointerWrapper
private import semmle.code.cpp.models.interfaces.SideEffect

private predicate isDeeplyConst(Type t) {
  t.isConst() and
  isDeeplyConstBelow(t)
  or
  isDeeplyConst(t.(Decltype).getBaseType())
  or
  isDeeplyConst(t.(ReferenceType).getBaseType())
  or
  exists(SpecifiedType specType | specType = t |
    specType.getASpecifier().getName() = "const" and
    isDeeplyConstBelow(specType.getBaseType())
  )
  or
  isDeeplyConst(t.(ArrayType).getBaseType())
}

private predicate isDeeplyConstBelow(Type t) {
  t instanceof BuiltInType
  or
  not t instanceof PointerWrapper and
  t instanceof Class
  or
  t instanceof Enum
  or
  isDeeplyConstBelow(t.(Decltype).getBaseType())
  or
  isDeeplyConst(t.(PointerType).getBaseType())
  or
  isDeeplyConst(t.(ReferenceType).getBaseType())
  or
  isDeeplyConstBelow(t.(SpecifiedType).getBaseType())
  or
  isDeeplyConst(t.(ArrayType).getBaseType())
  or
  isDeeplyConst(t.(GNUVectorType).getBaseType())
  or
  isDeeplyConst(t.(FunctionPointerIshType).getBaseType())
  or
  isDeeplyConst(t.(PointerWrapper).getTemplateArgument(0))
  or
  isDeeplyConst(t.(PointerToMemberType).getBaseType())
  or
  isDeeplyConstBelow(t.(TypedefType).getBaseType())
}

private predicate isConstPointerLike(Type t) {
  (
    t instanceof PointerWrapper
    or
    t instanceof PointerType
    or
    t instanceof ArrayType
    or
    t instanceof ReferenceType
  ) and
  isDeeplyConstBelow(t)
}

/**
 * Holds if the specified call has a side effect that does not come from a `SideEffectFunction`
 * model.
 */
private predicate hasDefaultSideEffect(Call call, ParameterIndex i, boolean buffer, boolean isWrite) {
  not call.getTarget() instanceof SideEffectFunction and
  (
    exists(MemberFunction mfunc |
      // A non-static member function, including a constructor or destructor, may write to `*this`,
      // and may also read from `*this` if it is not a constructor.
      i = -1 and
      mfunc = call.getTarget() and
      not mfunc.isStatic() and
      buffer = false and
      (
        isWrite = false and not mfunc instanceof Constructor
        or
        isWrite = true and not mfunc instanceof ConstMemberFunction
      )
    )
    or
    exists(Expr expr |
      // A pointer-like argument is assumed to read from the pointed-to buffer, and may write to the
      // buffer as well unless the pointer points to a `const` value.
      i >= 0 and
      buffer = true and
      expr = call.getArgument(i).getFullyConverted() and
      exists(Type t | t = expr.getUnspecifiedType() |
        t instanceof ArrayType or
        t instanceof PointerType or
        t instanceof ReferenceType or
        t instanceof PointerWrapper
      ) and
      (
        isWrite = true and
        not isConstPointerLike(call.getTarget().getParameter(i).getUnderlyingType())
        or
        isWrite = false
      )
    )
  )
}

/**
 * A `Call` or `NewOrNewArrayExpr`.
 *
 * Both kinds of expression invoke a function as part of their evaluation. This class provides a
 * way to treat both kinds of function similarly, and to get the invoked `Function`.
 */
class CallOrAllocationExpr extends Expr {
  CallOrAllocationExpr() {
    this instanceof Call
    or
    this instanceof NewOrNewArrayExpr
  }

  /** Gets the `Function` invoked by this expression, if known. */
  final Function getTarget() {
    result = this.(Call).getTarget()
    or
    result = this.(NewOrNewArrayExpr).getAllocator()
  }
}

/**
 * Returns the side effect opcode, if any, that represents any side effects not specifically modeled
 * by an argument side effect.
 */
Opcode getCallSideEffectOpcode(CallOrAllocationExpr expr) {
  not exists(expr.getTarget().(SideEffectFunction)) and result instanceof Opcode::CallSideEffect
  or
  exists(SideEffectFunction sideEffectFunction |
    sideEffectFunction = expr.getTarget() and
    if not sideEffectFunction.hasOnlySpecificWriteSideEffects()
    then result instanceof Opcode::CallSideEffect
    else (
      not sideEffectFunction.hasOnlySpecificReadSideEffects() and
      result instanceof Opcode::CallReadSideEffect
    )
  )
}

/**
 * Returns a side effect opcode for parameter index `i` of the specified call.
 *
 * This predicate will return at most two results: one read side effect, and one write side effect.
 */
Opcode getASideEffectOpcode(Call call, ParameterIndex i) {
  exists(boolean buffer |
    (
      call.getTarget().(SideEffectFunction).hasSpecificReadSideEffect(i, buffer)
      or
      not call.getTarget() instanceof SideEffectFunction and
      hasDefaultSideEffect(call, i, buffer, false)
    ) and
    if exists(call.getTarget().(SideEffectFunction).getParameterSizeIndex(i))
    then (
      buffer = true and
      result instanceof Opcode::SizedBufferReadSideEffect
    ) else (
      buffer = false and result instanceof Opcode::IndirectReadSideEffect
      or
      buffer = true and result instanceof Opcode::BufferReadSideEffect
    )
  )
  or
  exists(boolean buffer, boolean mustWrite |
    (
      call.getTarget().(SideEffectFunction).hasSpecificWriteSideEffect(i, buffer, mustWrite)
      or
      not call.getTarget() instanceof SideEffectFunction and
      hasDefaultSideEffect(call, i, buffer, true) and
      mustWrite = false
    ) and
    if exists(call.getTarget().(SideEffectFunction).getParameterSizeIndex(i))
    then (
      buffer = true and
      mustWrite = false and
      result instanceof Opcode::SizedBufferMayWriteSideEffect
      or
      buffer = true and
      mustWrite = true and
      result instanceof Opcode::SizedBufferMustWriteSideEffect
    ) else (
      buffer = false and
      mustWrite = false and
      result instanceof Opcode::IndirectMayWriteSideEffect
      or
      buffer = false and
      mustWrite = true and
      result instanceof Opcode::IndirectMustWriteSideEffect
      or
      buffer = true and mustWrite = false and result instanceof Opcode::BufferMayWriteSideEffect
      or
      buffer = true and mustWrite = true and result instanceof Opcode::BufferMustWriteSideEffect
    )
  )
}
