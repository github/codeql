/**
 * @name Upcast array used in pointer arithmetic
 * @description An array with elements of a derived struct type is cast to a
 *              pointer to the base type of the struct. If pointer arithmetic or
 *              an array dereference is done on the resulting pointer, it will
 *              use the width of the base type, leading to misaligned reads.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 9.3
 * @precision high
 * @id cpp/upcast-array-pointer-arithmetic
 * @tags correctness
 *       reliability
 *       security
 *       external/cwe/cwe-119
 *       external/cwe/cwe-843
 */

import cpp
import semmle.code.cpp.dataflow.DataFlow
import DataFlow::PathGraph

Type getFullyConvertedType(DataFlow::Node node) {
  result = node.asExpr().getFullyConverted().getUnspecifiedType()
}

class CastToPointerArithFlow extends DataFlow::Configuration {
  CastToPointerArithFlow() { this = "CastToPointerArithFlow" }

  override predicate isSource(DataFlow::Node node, DataFlow::FlowState state) {
    not node.asExpr() instanceof Conversion and
    exists(Type baseType1, Type baseType2 |
      hasBaseType(node.asExpr(), baseType1) and
      hasBaseType(node.asExpr().getConversion*(), baseType2) and
      introducesNewField(baseType1, baseType2)
    ) and
    getFullyConvertedType(node).getName() = state
  }

  override predicate isSink(DataFlow::Node node, DataFlow::FlowState state) {
    (
      exists(PointerAddExpr pae | pae.getAnOperand() = node.asExpr()) or
      exists(ArrayExpr ae | ae.getArrayBase() = node.asExpr())
    ) and
    getFullyConvertedType(node).getName() = state
  }
}

/**
 * Holds if the type of `e` is a `DerivedType` with `base` as its base type.
 *
 * This predicate ensures that joins go from `e` to `base` instead
 * of the other way around.
 */
pragma[inline]
predicate hasBaseType(Expr e, Type base) {
  pragma[only_bind_into](base) = e.getType().(DerivedType).getBaseType()
}

/**
 * `derived` has a (possibly indirect) base class of `base`, and at least one new
 * field has been introduced in the inheritance chain after `base`.
 */
predicate introducesNewField(Class derived, Class base) {
  (
    exists(Field f |
      f.getDeclaringType() = derived and
      derived.getABaseClass+() = base
    )
    or
    introducesNewField(derived.getABaseClass(), base)
  )
}

pragma[nomagic]
predicate hasFullyConvertedType(DataFlow::PathNode node, Type t) {
  getFullyConvertedType(node.getNode()) = t
}

from DataFlow::PathNode source, DataFlow::PathNode sink, CastToPointerArithFlow cfg, Type t
where
  cfg.hasFlowPath(pragma[only_bind_into](source), pragma[only_bind_into](sink)) and
  hasFullyConvertedType(source, t) and
  hasFullyConvertedType(sink, t)
select sink, source, sink, "This pointer arithmetic may be done with the wrong type because of $@.",
  source, "this cast"
