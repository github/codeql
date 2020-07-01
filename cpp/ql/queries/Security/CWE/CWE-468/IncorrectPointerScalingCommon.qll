/**
 * Shared utilities for the CWE-468 queries.
 */

import cpp

/**
 * Gets the type parameter of `sizeof` expression `e`.
 */
private Type sizeofParam(Expr e) {
  result = e.(SizeofExprOperator).getExprOperand().getFullyConverted().getType()
  or
  result = e.(SizeofTypeOperator).getTypeOperand()
}

/**
 * Holds if `e` is `sizeof` expression `sizeofExpr`, possibly multiplied
 * by another expression, and `sizeofParam` is `sizeofExpr`'s type
 * parameter.
 *
 * For example, if `e` is `4 * sizeof(T)` then `sizeofExpr` is
 * `sizeof(T)` and `sizeofParam` is `T`.
 */
private predicate multiplyWithSizeof(Expr e, Expr sizeofExpr, Type sizeofParam) {
  e = sizeofExpr and sizeofParam = sizeofParam(e).getUnspecifiedType()
  or
  multiplyWithSizeof(e.(MulExpr).getAnOperand(), sizeofExpr, sizeofParam)
}

/**
 * Holds if the pointer `e` is added to the `sizeof` expression
 * `sizeofExpr` (which may first be multiplied by another expression),
 * and `sizeofParam` is `sizeofExpr`'s type parameter.
 *
 * For example, if the program contains the expression
 * `p - (i * sizeof(T))` then `e` would be `p`, `sizeofExpr` would be
 * `sizeof(T)`, and `sizeofParam` would be `T`.
 */
predicate addWithSizeof(Expr e, Expr sizeofExpr, Type sizeofParam) {
  exists(PointerAddExpr addExpr |
    e = addExpr.getLeftOperand() and
    multiplyWithSizeof(addExpr.getRightOperand(), sizeofExpr, sizeofParam)
  )
  or
  exists(PointerSubExpr subExpr |
    e = subExpr.getLeftOperand() and
    multiplyWithSizeof(subExpr.getRightOperand(), sizeofExpr, sizeofParam)
  )
}

/**
 * Holds if `t` is a pointer or array type.
 */
predicate isPointerType(Type t) {
  t instanceof PointerType or
  t instanceof ArrayType
}

/**
 * Gets the base type of a pointer or array type.  In the case of an array of
 * arrays, the inner base type is returned.
 */
Type baseType(Type t) {
  (
    exists(PointerType dt |
      dt = t.getUnspecifiedType() and
      result = dt.getBaseType().getUnspecifiedType()
    )
    or
    exists(ArrayType at |
      at = t.getUnspecifiedType() and
      not at.getBaseType().getUnspecifiedType() instanceof ArrayType and
      result = at.getBaseType().getUnspecifiedType()
    )
    or
    exists(ArrayType at, ArrayType at2 |
      at = t.getUnspecifiedType() and
      at2 = at.getBaseType().getUnspecifiedType() and
      result = baseType(at2)
    )
  ) and
  // Make sure that the type has a size and that it isn't ambiguous.
  strictcount(result.getSize()) = 1
}

/**
 * Holds if there is a pointer expression with type `sourceType` at
 * location `sourceLoc` which might be the source expression for `use`.
 *
 * For example, with
 * ```
 * int intArray[5] = { 1, 2, 3, 4, 5 };
 * char *charPointer = (char *)intArray;
 * return *(charPointer + i);
 * ```
 * the array initializer on the first line is a source expression
 * for the use of `charPointer` on the third line.
 *
 * The source will either be an `Expr` or a `Parameter`.
 */
predicate exprSourceType(Expr use, Type sourceType, Location sourceLoc) {
  // Reaching definitions.
  if exists(SsaDefinition def, StackVariable v | use = def.getAUse(v))
  then
    exists(SsaDefinition def, StackVariable v | use = def.getAUse(v) |
      defSourceType(def, v, sourceType, sourceLoc)
    )
  else
    // Pointer arithmetic
    if use instanceof PointerAddExpr
    then exprSourceType(use.(PointerAddExpr).getLeftOperand(), sourceType, sourceLoc)
    else
      if use instanceof PointerSubExpr
      then exprSourceType(use.(PointerSubExpr).getLeftOperand(), sourceType, sourceLoc)
      else
        if use instanceof AddExpr
        then exprSourceType(use.(AddExpr).getAnOperand(), sourceType, sourceLoc)
        else
          if use instanceof SubExpr
          then exprSourceType(use.(SubExpr).getAnOperand(), sourceType, sourceLoc)
          else
            if use instanceof CrementOperation
            then exprSourceType(use.(CrementOperation).getOperand(), sourceType, sourceLoc)
            else
              // Conversions are not in the AST, so ignore them.
              if use instanceof Conversion
              then none()
              else (
                // Source expressions
                sourceType = use.getUnspecifiedType() and
                isPointerType(sourceType) and
                sourceLoc = use.getLocation()
              )
}

/**
 * Holds if there is a pointer expression with type `sourceType` at
 * location `sourceLoc` which might define the value of `v` at `def`.
 */
predicate defSourceType(SsaDefinition def, StackVariable v, Type sourceType, Location sourceLoc) {
  exprSourceType(def.getDefiningValue(v), sourceType, sourceLoc)
  or
  defSourceType(def.getAPhiInput(v), v, sourceType, sourceLoc)
  or
  exists(Parameter p |
    p = v and
    def.definedByParameter(p) and
    sourceType = p.getUnspecifiedType() and
    strictcount(p.getType()) = 1 and
    isPointerType(sourceType) and
    sourceLoc = p.getLocation()
  )
}

/**
 * Gets the pointer arithmetic expression that `e` is (directly) used
 * in, if any.
 *
 * For example, in `(char*)(p + 1)`, for `p`, ths result is `p + 1`.
 */
Expr pointerArithmeticParent(Expr e) {
  e = result.(PointerAddExpr).getLeftOperand() or
  e = result.(PointerSubExpr).getLeftOperand() or
  e = result.(PointerDiffExpr).getAnOperand()
}
