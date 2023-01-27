/**
 * @name Incomplete tostring
 * @description A toString on a IPA type does not cover all branches.
 * @kind problem
 * @problem.severity warning
 * @id ql/incomplete-tostring
 * @tags correctness
 *       maintainability
 * @precision very-high
 */

import ql

/**
 * Strategy:
 *
 * - Find toString predicates
 * - split into branches
 * - for each branch, find type restrictions of `this` (as `TypeExpr`)
 * - if a branch has no restrictions, it covers all
 * - collect new type branches covered
 * - report if any branches are not covered
 */
class ToString extends ClassPredicate {
  ToString() { this.getName() = "toString" }

  private Disjunction getADisJunction() {
    result = this.getBody()
    or
    result = this.getADisJunction().getAChild()
  }

  Formula getADisjunct() {
    result = this.getADisJunction().getAChild() and
    not result instanceof Disjunction
    or
    not exists(this.getADisJunction()) and
    result = this.getBody()
  }

  TypeExpr getRestrictions() {
    result = this.getADisjunct().getAChild+()
    // exists(Formula disjunct |
    //   disjunct = this.getADisjunct() and
    //   disjunct.getAChild()+.(TypeE)
    // )
  }
}

abstract class ThisTypeRestriction extends AstNode {
  NewTypeBranchType getRestriction;
}

class ThisEqualsBranch extends ThisTypeRestriction, ComparisonFormula {
  NewTypeBranchType restriction;

  ThisEqualsBranch() {
    this.getOperator() = "=" and
    this.getAnOperand() instanceof ThisAccess and
    result = this.getAnOperand().(PredicateCall).getType()
  }

  NewTypeBranchType getRestriction() { result = restriction }
}

// Find
//
// newtype TDef ...
//
// class C extends TDef {
//   predicate toString() {
//      ... does not cover all of TDef
//   }
// }
ToString getToStringsOnClassExtendingNewtype(NewType nt) {
  nt = result.getParent().getType().getASuperType+().getDeclaration()
}

// NewTypeBranch covered(ToString toString, NewType nt) {
//   toString = getToStringsOnClassExtendingNewtype(nt) and
//   toString.getADisjunct()
// }
select 1
