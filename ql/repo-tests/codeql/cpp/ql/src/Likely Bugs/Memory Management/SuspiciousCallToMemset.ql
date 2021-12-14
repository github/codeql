/**
 * @name Suspicious call to memset
 * @description Use of memset where the size argument is computed as the size of
 *              some non-struct type. When initializing a buffer, you should specify
 *              its size as <number of elements> * <size of one element> to ensure
 *              portability.
 * @kind problem
 * @id cpp/suspicious-call-to-memset
 * @problem.severity recommendation
 * @security-severity 10.0
 * @precision medium
 * @tags reliability
 *       correctness
 *       security
 *       external/cwe/cwe-676
 */

import cpp

/**
 * Holds if `e` is a `sizeof` expression on type `t`, with
 * optional multiplication by a constant.
 */
predicate sizeOfExpr(Expr e, Type t) {
  t = e.(SizeofTypeOperator).getTypeOperand()
  or
  t = e.(SizeofExprOperator).getExprOperand().getType()
  or
  sizeOfExpr(e.(MulExpr).getAnOperand(), t) and
  e.(MulExpr).getAnOperand() instanceof Literal
}

/**
 * Gets the type `t` with typedefs, array types and references removed.
 *
 * This is similar to `Type.stripType` except that it doesn't remove
 * a `PointerType`.
 */
Type stripType(Type t) {
  result = stripType(t.(TypedefType).getBaseType())
  or
  result = stripType(t.(ArrayType).getBaseType())
  or
  result = stripType(t.(ReferenceType).getBaseType())
  or
  result = stripType(t.(SpecifiedType).getBaseType())
  or
  result = stripType(t.(Decltype).getBaseType())
  or
  not t instanceof TypedefType and
  not t instanceof ArrayType and
  not t instanceof ReferenceType and
  not t instanceof SpecifiedType and
  not t instanceof Decltype and
  result = t
}

/**
 * Holds if `t` points to `base` via a specified number of levels of pointer
 * indirection.  Intermediate typedefs and array types are allowed. Note that
 * `base` is a stripped type (via `stripType`).
 */
predicate pointerIndirection(Type t, int indirection, Type base) {
  base = stripType(t) and
  not base instanceof PointerType and
  indirection = 0
  or
  pointerIndirection(stripType(t).(PointerType).getBaseType(), indirection - 1, base)
}

/**
 * Holds if `t` points to a non-pointer, non-array type via a specified number
 * of levels of pointer indirection.  Intermediate typedefs and array types are
 * allowed.
 */
predicate pointerIndirection2(Type t, int indirection) {
  not stripType(t) instanceof PointerType and
  indirection = 0
  or
  pointerIndirection2(stripType(t).(PointerType).getBaseType(), indirection - 1)
}

/**
 * Holds if `memset(dataArg, _, sizeArg)`, where `sizeArg` has the form
 * `sizeof(type)`, could be reasonable.
 */
predicate reasonableMemset(FunctionCall fc) {
  exists(Expr dataArg, Expr sizeArg |
    dataArg = fc.getArgument(0) and
    sizeArg = fc.getArgument(2) and
    exists(Type dataType, Type sizeOfType |
      dataType = dataArg.getType() and
      sizeOfExpr(sizeArg, sizeOfType) and
      exists(int i |
        exists(Type base |
          // memset(&t, _, sizeof(t))
          pointerIndirection(dataType, i + 1, base) and
          pointerIndirection(sizeOfType, i, base)
        )
        or
        exists(Type base |
          // memset(t[n], _, sizeof(t))
          pointerIndirection(dataType.getUnspecifiedType().(ArrayType), i, base) and
          pointerIndirection(sizeOfType, i, base)
        )
        or
        exists(VoidType vt |
          // memset(void *, _, sizeof(t))
          pointerIndirection(dataType, i + 1, vt) and
          pointerIndirection2(sizeOfType, i)
        )
        or
        exists(Type ct |
          // memset(char *, _, sizeof(t)) and similar
          ct.getSize() = 1 and
          pointerIndirection(dataType, i + 1, ct) and
          pointerIndirection2(sizeOfType, i)
        )
        or
        exists(Type ct |
          // memset(char [], _, sizeof(t)) and similar
          ct.getSize() = 1 and
          pointerIndirection(dataType.getUnspecifiedType().(ArrayType), i, ct) and
          pointerIndirection2(sizeOfType, i)
        )
      )
    )
  )
}

from FunctionCall fc, Type t
where
  fc.getTarget().hasName("memset") and
  sizeOfExpr(fc.getArgument(2), t) and
  not reasonableMemset(fc)
select fc,
  "The size of the memory area set by memset should not be the size of the type " + t.getName() +
    "."
