/**
 * @name Suspicious pointer scaling
 * @description Implicit scaling of pointer arithmetic expressions
 *              can cause buffer overflow conditions.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/suspicious-pointer-scaling
 * @tags security
 *       external/cwe/cwe-468
 */
import cpp
import semmle.code.cpp.controlflow.SSA
import IncorrectPointerScalingCommon

private predicate isPointerType(Type t) {
  t instanceof PointerType or
  t instanceof ArrayType
}

private Type baseType(Type t) {
  (
    exists (PointerType dt
    | dt = t.getUnspecifiedType() and
      result = dt.getBaseType().getUnspecifiedType()) or
    exists (ArrayType at
    | at = t.getUnspecifiedType() and
      (not at.getBaseType().getUnspecifiedType() instanceof ArrayType) and
      result = at.getBaseType().getUnspecifiedType()) or
    exists (ArrayType at, ArrayType at2
    | at = t.getUnspecifiedType() and
      at2 = at.getBaseType().getUnspecifiedType() and
      result = baseType(at2))
  )
  // Make sure that the type has a size and that it isn't ambiguous.  
  and strictcount(result.getSize()) = 1
    
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
private
predicate exprSourceType(Expr use, Type sourceType, Location sourceLoc) {
  // Reaching definitions.
  if exists (SsaDefinition def, LocalScopeVariable v | use = def.getAUse(v)) then
    exists (SsaDefinition def, LocalScopeVariable v
    | use = def.getAUse(v)
    | defSourceType(def, v, sourceType, sourceLoc))

  // Pointer arithmetic
  else if use instanceof PointerAddExpr then
    exprSourceType(use.(PointerAddExpr).getLeftOperand(), sourceType, sourceLoc)
  else if use instanceof PointerSubExpr then
    exprSourceType(use.(PointerSubExpr).getLeftOperand(), sourceType, sourceLoc)
  else if use instanceof AddExpr then
    exprSourceType(use.(AddExpr).getAnOperand(), sourceType, sourceLoc)
  else if use instanceof SubExpr then
    exprSourceType(use.(SubExpr).getAnOperand(), sourceType, sourceLoc)
  else if use instanceof CrementOperation then
    exprSourceType(use.(CrementOperation).getOperand(), sourceType, sourceLoc)

  // Conversions are not in the AST, so ignore them.
  else if use instanceof Conversion then
    none()

  // Source expressions
  else
    (sourceType = use.getType().getUnspecifiedType() and
     isPointerType(sourceType) and
     sourceLoc = use.getLocation())
}

/**
 * Holds if there is a pointer expression with type `sourceType` at
 * location `sourceLoc` which might define the value of `v` at `def`.
 */
private
predicate defSourceType(SsaDefinition def, LocalScopeVariable v,
                        Type sourceType, Location sourceLoc) {
  exprSourceType(def.getDefiningValue(v), sourceType, sourceLoc)
  or
  defSourceType(def.getAPhiInput(v), v, sourceType, sourceLoc)
  or
  exists (Parameter p
  | p = v and
    def.definedByParameter(p) and
    sourceType = p.getType().getUnspecifiedType() and
    isPointerType(sourceType) and
    sourceLoc = p.getLocation())
}

/**
 * Gets the pointer arithmetic expression that `e` is (directly) used
 * in, if any.
 *
 * For example, in `(char*)(p + 1)`, for `p`, ths result is `p + 1`.
 */
private Expr pointerArithmeticParent(Expr e) {
  e = result.(PointerAddExpr).getLeftOperand() or
  e = result.(PointerSubExpr).getLeftOperand() or
  e = result.(PointerDiffExpr).getAnOperand()
}

from Expr dest, Type destType, Type sourceType, Type sourceBase,
     Type destBase, Location sourceLoc
where exists(pointerArithmeticParent(dest))
  and exprSourceType(dest, sourceType, sourceLoc)
  and sourceBase = baseType(sourceType)
  and destType = dest.getFullyConverted().getType()
  and destBase = baseType(destType)
  and destBase.getSize() != sourceBase.getSize()
  and not dest.isInMacroExpansion()

  // If the source type is a char* or void* then don't
  // produce a result, because it is likely to be a false
  // positive.
  and not (sourceBase instanceof CharType)
  and not (sourceBase instanceof VoidType)

  // Low-level pointer tricks often involve casting a struct pointer to a
  // char pointer, then accessing it at byte offsets. For example, this can
  // be necessary in order to resume an interrupted `write(2)`.
  and not (destBase instanceof CharType)
  
  // Similarly, gcc and compilers emulating it will allow void pointer
  // arithmetic as if void were a 1-byte type
  and not (destBase instanceof VoidType)

  // Don't produce an alert if the root expression computes
  // an offset, rather than a pointer. For example:
  // ```
  //     (p + 1) - q
  // ```
  and forall(Expr parent |
             parent = pointerArithmeticParent+(dest) |
             parent.getFullyConverted().getType().getUnspecifiedType() instanceof PointerType)
select
  dest,
  "This pointer might have type $@ (size " + sourceBase.getSize() +
  "), but the pointer arithmetic here is done with type " +
  destType + " (size " + destBase.getSize() + ").",
  sourceLoc, sourceBase.toString()
