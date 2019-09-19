/**
 * Provides classes and predicates implementing the UnsignedGEZero query.
 * This library is also used by the PointlessComparison query,
 * so that we can avoid reporting the same result twice. (PointlessComparison
 * is a newer and more general query which also finds instances of
 * the UnsignedGEZero pattern.)
 */

import cpp

class ConstantZero extends Expr {
  ConstantZero() {
    this.isConstant() and
    this.getValue() = "0"
  }
}

class UnsignedGEZero extends GEExpr {
  UnsignedGEZero() {
    this.getRightOperand() instanceof ConstantZero and
    // left operand was a signed or unsigned IntegralType before conversions
    // (not a pointer, checking a pointer >= 0 is an entirely different mistake)
    // (not an enum, as the fully converted type of an enum is compiler dependent
    //  so checking an enum >= 0 is always reasonable)
    getLeftOperand().getUnderlyingType() instanceof IntegralType and
    exists(Expr ue |
      // ue is some conversion of the left operand
      ue = getLeftOperand().getConversion*() and
      // ue is unsigned
      ue.getUnderlyingType().(IntegralType).isUnsigned() and
      // ue may be converted to zero or more strictly larger possibly signed types
      // before it is fully converted
      forall(Expr following | following = ue.getConversion+() |
        following.getType().getSize() > ue.getType().getSize()
      )
    )
  }
}

predicate unsignedGEZero(UnsignedGEZero ugez, string msg) {
  not exists(MacroInvocation mi |
    // ugez is in mi
    mi.getAnExpandedElement() = ugez and
    // and ugez was apparently not passed in as a macro parameter
    ugez.getLocation().getStartLine() = mi.getLocation().getStartLine() and
    ugez.getLocation().getStartColumn() = mi.getLocation().getStartColumn()
  ) and
  not ugez.isFromTemplateInstantiation(_) and
  msg = "Pointless comparison of unsigned value to zero."
}
