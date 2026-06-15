/**
 * Provides predicates for detecting whether an expression dereferences a pointer.
 */

import cpp
import Nullness
import semmle.code.cpp.models.interfaces.ArrayFunction

/**
 * Holds if the call `fc` will dereference argument `i`.
 */
predicate callDereferences(FunctionCall fc, int i) {
  exists(ArrayFunction af |
    fc.getTarget() = af and
    (
      af.hasArrayInput(i) or
      af.hasArrayOutput(i)
    )
  )
  or
  exists(FormattingFunction ff |
    fc.getTarget() = ff and
    i >= ff.getFirstFormatArgumentIndex() and
    fc.getArgument(i).getType() instanceof PointerType
  )
}

/**
 * Holds if evaluation of `op` dereferences `e` directly.
 *
 * This predicate does not recurse through function calls or arithmetic operations. To find
 * such cases, use `dereferencedByOperation`.
 */
predicate directDereferencedByOperation(Expr op, Expr e) {
  exists(PointerDereferenceExpr deref |
    deref.getAChild() = e and
    deref = op and
    not deref.getParent*() instanceof SizeofOperator
  )
  or
  exists(ArrayExpr ae |
    (
      not ae.getParent() instanceof AddressOfExpr and
      not ae.getParent*() instanceof SizeofOperator
    ) and
    ae = op and
    (
      e = ae.getArrayBase() and e.getType() instanceof PointerType
      or
      e = ae.getArrayOffset() and e.getType() instanceof PointerType
    )
  )
  or
  // ptr->Field
  e = op.(FieldAccess).getQualifier() and isClassPointerType(e.getType())
  or
  // ptr->method()
  e = op.(Call).getQualifier() and isClassPointerType(e.getType())
}

/**
 * Holds if evaluation of `op` dereferences `e`.
 *
 * This includes the set of operations identified via `directDereferencedByOperation`, as well
 * as calls to function that are known to dereference an argument.
 */
predicate dereferencedByOperation(Expr op, Expr e) {
  directDereferencedByOperation(op, e)
  or
  exists(CrementOperation crement | dereferencedByOperation(e, op) and crement.getOperand() = e)
  or
  exists(AddressOfExpr addof, ArrayExpr ae |
    dereferencedByOperation(addof, op) and
    addof.getOperand() = ae and
    (e = ae.getArrayBase() or e = ae.getArrayOffset()) and
    e.getType() instanceof PointerType
  )
  or
  exists(UnaryArithmeticOperation arithop |
    dereferencedByOperation(arithop, op) and
    e = arithop.getAnOperand() and
    e.getType() instanceof PointerType
  )
  or
  exists(BinaryArithmeticOperation arithop |
    dereferencedByOperation(arithop, op) and
    e = arithop.getAnOperand() and
    e.getType() instanceof PointerType
  )
  or
  exists(FunctionCall fc, int i |
    (callDereferences(fc, i) or functionCallDereferences(fc, i)) and
    e = fc.getArgument(i) and
    op = fc
  )
}

private predicate isClassPointerType(Type t) {
  t.getUnderlyingType().(PointerType).getBaseType().getUnderlyingType() instanceof Class
}

/**
 * Holds if `e` will be dereferenced after being evaluated.
 */
predicate dereferenced(Expr e) { dereferencedByOperation(_, e) }

pragma[noinline]
private predicate functionCallDereferences(FunctionCall fc, int i) {
  functionDereferences(fc.getTarget(), i)
}

/**
 * Holds if the body of a function `f` is likely to dereference its `i`th
 * parameter unconditionally. This analysis does not account for reassignment.
 */
predicate functionDereferences(Function f, int i) {
  exists(VariableAccess access, Parameter p |
    p = f.getParameter(i) and
    dereferenced(access) and
    access = p.getAnAccess() and
    not checkedValid(p, access)
  )
}
