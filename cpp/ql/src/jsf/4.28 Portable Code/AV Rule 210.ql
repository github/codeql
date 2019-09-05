/**
 * @name AV Rule 210
 * @description Algorithms shall not make assumptions concerning how
 *              data is represented in memory.
 * @kind problem
 * @id cpp/jsf/av-rule-210
 * @problem.severity error
 * @precision low
 * @tags correctness
 *       portability
 *       external/jsf
 */

import cpp

/*
 * The standard lists three things that are disallowed in particular:
 *    - relying on big vs. little endian representation
 *    - relying on base class subobject ordering in derived classes
 *    - relying on nonstatic data member ordering across access specifiers
 *
 * We currently only check for violations of the first one, in a similar way
 * to AV Rule 147: No casts from pointers to/arrays of integrals to pointers to
 * integrals of a different size, no unions that both contain an integral and
 * an array of smaller integrals.
 */

class PointerOrArrayType extends DerivedType {
  PointerOrArrayType() { this instanceof PointerType or this instanceof ArrayType }
}

// cast from pointer to integral type to pointer to a different integral type
class ExposingIntegralCastExpr extends Expr {
  ExposingIntegralCastExpr() {
    exists(
      PointerOrArrayType src, PointerOrArrayType dst, IntegralType srcbase, IntegralType dstbase
    |
      src = this.getUnderlyingType() and
      srcbase = src.getBaseType().getUnderlyingType() and
      dst = this.getActualType() and
      dstbase = dst.getBaseType().getUnderlyingType() and
      srcbase != dstbase
    )
  }
}

class ExposingIntegralUnion extends Union {
  ExposingIntegralUnion() {
    exists(MemberVariable mv1, MemberVariable mv2, IntegralType mv1tp, IntegralType mv2tp |
      mv1 = this.getAMemberVariable() and
      mv2 = this.getAMemberVariable() and
      mv1tp = mv1.getUnderlyingType().(IntegralType) and
      (
        mv2tp = mv2.getUnderlyingType().(IntegralType)
        or
        mv2tp = mv2.getUnderlyingType().(ArrayType).getBaseType().getUnderlyingType().(IntegralType)
      ) and
      mv1tp.getSize() > mv2tp.getSize()
    )
  }
}

from Element e, string message
where
  e instanceof ExposingIntegralCastExpr and
  message = "AV Rule 210: This cast makes assumptions concerning data representation in memory."
  or
  e instanceof ExposingIntegralUnion and
  message = "AV Rule 210: This union may make assumptions concerning data representation in memory."
select e, message
