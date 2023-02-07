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

// TODO:
// - Some classes are restircted in their charpred to some branch types.
//   We should take that into account when computing coverage.
// - Some classes rely on onther classes for cover. Example is
//   `ReturnCompletion`:
//   ```codeql
// /**
//  * A completion that represents evaluation of a statement or an
//  * expression resulting in a return from a callable.
//  */
// class ReturnCompletion extends Completion {
//   ReturnCompletion() {
//     this = TReturnCompletion() or
//     this = TNestedCompletion(_, TReturnCompletion(), _)
//   }
//   override ReturnSuccessor getAMatchingSuccessorType() { any() }
//   override string toString() {
//     // `NestedCompletion` defines `toString()` for the other case
//     this = TReturnCompletion() and result = "return"
//   }
// }
// ```
//
// `getUnionMember` and `Branches` help to recursively unfold
// definitions of the form
// `class TMethodBase = TMethod or TSingletonMethod;`
TypeDeclaration getUnionMember(Class c) {
  result = c.getUnionMember().getResolvedType().getDeclaration() or
  result = getUnionMember(c.getUnionMember().getResolvedType().getDeclaration())
}

class Branches extends TypeDeclaration {
  NewTypeBranch branch;

  Branches() {
    branch = this
    or
    branch = getUnionMember(this)
  }

  NewTypeBranch getBranch() { result = branch }

  NewType getNewType() { result = branch.getNewType() }
}

/**
 * A toString member predicate
 *
 * Supports looking through the disjucts of its definition in order to
 * find restrictions on the class type (`this`).
 *
 * - `getRestrictions` gets the branch types that the class type is restricted to.
 * - `hasUnrestrictedDisjunct` holds if one of the disjucts does not restrict
 *   the class type.
 *
 * Together, these two predicates can answer whether all branches are covered.
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

  private Branches getRestrictions(Formula disjunct) {
    // Treat each branch on its own
    disjunct = this.getADisjunct() and
    (
      // this = (BranchType)...
      // TODO: consider `not`
      exists(ThisAccess ta, ComparisonFormula eq |
        eq = disjunct.getAChild*() and
        eq.getOperator() = "=" and
        eq.getAnOperand() = ta and
        result = eq.getAnOperand().(PredicateCall).getTarget()
      )
      or
      // this.(BranchType)
      // we currently do not do this anywhere
      exists(ThisAccess ta, InlineCast ic |
        ic = disjunct.getAChild*() and
        ic.getBase() = ta and
        result = ic.getTypeExpr().getResolvedType().getDeclaration()
      )
      or
      // this instanceof BranchType
      // TODO: consider `not`
      exists(ThisAccess ta, InstanceOf io |
        io = disjunct.getAChild*() and
        ta = io.getExpr() and
        result = io.getType().getResolvedType().getDeclaration()
      )
    )
  }

  NewTypeBranch getRestrictions() { result = this.getRestrictions(_).getBranch() }

  predicate hasUnrestrictedDisjunct() {
    exists(Formula disjunct | disjunct = this.getADisjunct() |
      not exists(this.getRestrictions(disjunct))
    )
  }
}

ToString getToStringsOnClassExtendingNewtype(NewType nt) {
  nt = result.getParent().getType().getASuperType+().getDeclaration() and
  not result.hasAnnotation("abstract") and
  // if the class of the toString also inherits directly
  // from a branch type, it is not interesting.
  not exists(NewTypeBranch branch | branch.getNewType() = nt |
    branch = result.getParent().getType().getASuperType+().getDeclaration()
  )
}

from ToString ts, NewType nt, NewTypeBranch branch
where
  ts = getToStringsOnClassExtendingNewtype(nt) and
  branch.getNewType() = nt and
  not branch = ts.getRestrictions() and
  not ts.hasUnrestrictedDisjunct()
select ts, nt, branch
