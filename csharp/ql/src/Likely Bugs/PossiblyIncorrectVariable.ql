/**
 * @name Possibly incorrect variable
 * @description Duplicated variables in adjacent expressions could be an error if there is a
 *              more appropriate variable available in the same scope.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cs/possibly-incorrect-variable
 * @tags correctness
 *       external/cwe/cwe-697
 */

import csharp
import semmle.code.csharp.commons.StructuralComparison

/** A variable scope for the purposes of this query. */
class Scope extends Element {
  Scope() {
    this instanceof Callable or
    this instanceof ValueOrRefType or
    this instanceof BlockStmt
  }
}

/** A declaration within a scope. */
class ScopedDeclaration extends Assignable {
  ScopedDeclaration() {
    (
      this instanceof Variable or
      this instanceof Property
    )
  }

  Scope getScope() {
    this.(LocalVariable).getVariableDeclExpr().getEnclosingStmt() = result
          .(BlockStmt)
          .getAChildStmt() or
    this.(Parameter).getDeclaringElement() = result or
    this.(Member).getDeclaringType() = result
  }
}

class ComparisonOrAssignment extends Expr {
  ComparisonOrAssignment() {
    this instanceof AssignExpr or
    this instanceof EqualityOperation or
    this instanceof LocalVariableDeclAndInitExpr
  }

  Access getLeft() { result = this.getChild(0) }

  Access getRight() { result = this.getChild(1) }
}

/**
 * Holds if two comparisons or assignments are adjacent, either within an expression
 * or in a sequence of assignments or declarations.
 */
predicate adjacent(ComparisonOrAssignment a1, ComparisonOrAssignment a2) {
  exists(BinaryLogicalOperation expr | a1 = expr.getLeftOperand() |
    a2 = expr.getRightOperand() or a2 = expr.getRightOperand().(LogicalAndExpr).getLeftOperand()
  )
  or
  exists(BlockStmt block, ExprStmt s1, ExprStmt s2, int i |
    s1 = block.getChildStmt(i) and s2 = block.getChildStmt(i + 1)
  |
    a1 = s1.getExpr() and a2 = s2.getExpr()
  )
  or
  exists(BlockStmt block, LocalVariableDeclStmt s1, LocalVariableDeclStmt s2, int i |
    s1 = block.getChildStmt(i) and s2 = block.getChildStmt(i + 1)
  |
    a1 = s1.getAVariableDeclExpr() and a2 = s2.getAVariableDeclExpr()
  )
  or
  exists(LocalVariableDeclStmt decl, int i |
    a1 = decl.getVariableDeclExpr(i) and a2 = decl.getVariableDeclExpr(i + 1)
  )
}

class SameVariables extends StructuralComparisonConfiguration {
  SameVariables() { this = "Same variables in operation" }

  override predicate candidate(ControlFlowElement e1, ControlFlowElement e2) {
    duplicatedAccess1(e1, e2, _, _)
  }
}

/*
 * Holds for sequences of expressions of the form
 * ```
 * same1 = different1;
 * same2 = different2;
 * ```
 * where the target of `same1` and `same1` is equal.
 */

pragma[noopt]
predicate duplicatedAccess1(Access same1, Access same2, Access different1, Access different2) {
  exists(ComparisonOrAssignment op1, ComparisonOrAssignment op2 | adjacent(op1, op2) |
    same1 = op1.getLeft() and
    different1 = op1.getRight() and
    same2 = op2.getLeft() and
    different2 = op2.getRight()
    or
    same1 = op1.getRight() and
    different1 = op1.getLeft() and
    same2 = op2.getRight() and
    different2 = op2.getLeft()
  ) and
  same1.getTarget() = same2.getTarget()
}

predicate duplicatedAccess2(Access same1, Access same2, Access different1, Access different2) {
  duplicatedAccess1(same1, same2, different1, different2) and
  any(SameVariables same).same(same1, same2) and
  exists(Declaration target | target = same1.getTarget() |
    not target.(Modifiable).isStatic() and
    not target instanceof ImplicitAccessorParameter and
    not target instanceof EnumConstant
  )
}

predicate duplicatedAccess3(Access same1, Access same2, Access different1, Access different2) {
  duplicatedAccess2(same1, same2, different1, different2) or
  duplicatedAccess2(same2, same1, different2, different1)
}

predicate duplicatedAccess4(
  Access same1, Access same2, Access different1, Access different2, ScopedDeclaration candidateDecl
) {
  duplicatedAccess3(same1, same2, different1, different2) and
  candidateDecl.getScope() = same1.getTarget().(ScopedDeclaration).getScope()
}

/**
 * Finds patterns of the form
 * ```
 * Mx = x;
 * My = x;
 * ```
 * and variations, where one of the variable names may be prefixed with an arbitrary string `M`.
 * `candidateDecl` is a more suitable declaration in the same scope as `same2`, based on its name.
 */
predicate duplicatedAccess5(
  Access same1, Access same2, Access different1, Access different2, ScopedDeclaration candidateDecl
) {
  duplicatedAccess4(same1, same2, different1, different2, candidateDecl) and
  exists(string stem, string a, string b, string candidate | a != b |
    (
      same2.getTarget().getName().toLowerCase() = stem + a and
      different2.getTarget().getName().toLowerCase() = b and
      different1.getTarget().getName().toLowerCase() = a and
      candidate = stem + b
      or
      same2.getTarget().getName().toLowerCase() = a and
      different2.getTarget().getName().toLowerCase() = stem + b and
      different1.getTarget().getName().toLowerCase() = stem + a and
      candidate = b
    ) and
    candidateDecl.getScope() = same1.getTarget().(ScopedDeclaration).getScope() and
    candidateDecl.getName().toLowerCase() = candidate
  )
}

from Access same1, Access same2, Access different1, Access different2, ScopedDeclaration candidate
where duplicatedAccess5(same1, same2, different1, different2, candidate)
select same2,
  "Duplicated variable '" + same1.getTarget().getName() +
    "' may be an error, because '$@' might have been intended.", candidate, candidate.getName()
