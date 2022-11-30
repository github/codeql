/**
 * @name Var only used in one side of disjunct.
 * @description Only using a variable on one side of a disjunction can cause a cartesian product.
 * @kind problem
 * @problem.severity warning
 * @id ql/var-unused-in-disjunct
 * @tags maintainability
 *       performance
 * @precision high
 */

import ql
import codeql_ql.performance.VarUnusedInDisjunctQuery

/**
 * Holds if `node` bind `var` in a (transitive) child node.
 * Is a practical approximation that ignores `not` and many other features.
 */
pragma[noinline]
predicate alwaysBindsVar(VarDef var, AstNode node) {
  (
    // base case
    node.(VarAccess).getDeclaration() = var
    or
    exists(Class clz |
      node.(FieldAccess).getDeclaration().getVarDecl() = var and
      node.(FieldAccess).getDeclaration() = clz.getAField() and // <- ensuring that the field is not inherited from a super class
      node.getEnclosingPredicate() = clz.getCharPred() // <- in non-charpred, the fields are implicitly bound by their relation to `this`.
    )
  ) and
  not isSmallType(var.getType()) // <- early pruning
  or
  // recursive cases
  alwaysBindsVar(var, node.getAChild(_)) and // the recursive step, go one step up to the parent.
  not node.(FullAggregate).getAnArgument() = var and // except if the parent defines the variable, then we stop.
  not node.(Quantifier).getAnArgument() = var and
  not node instanceof EffectiveDisjunction // for disjunctions, we need to check both sides.
  or
  exists(EffectiveDisjunction disj | disj = node |
    alwaysBindsVar(var, disj.getLeft()) and
    alwaysBindsVar(var, disj.getRight())
  )
  or
  exists(EffectiveDisjunction disj | disj = node |
    alwaysBindsVar(var, disj.getAnOperand()) and
    disj.getAnOperand() instanceof NoneCall
  )
  or
  exists(IfFormula ifForm | ifForm = node | alwaysBindsVar(var, ifForm.getCondition()))
}

/**
 * Holds if `pred` is inlined.
 */
predicate isInlined(Predicate pred) {
  exists(Annotation inline |
    inline = pred.getAnAnnotation() and
    inline.getName() = "pragma" and
    inline.getArgs(0).getValue() = "inline"
  )
  or
  pred.getAnAnnotation().getName() = "bindingset"
}

/**
 * An AstNode that acts like a disjunction.
 */
class EffectiveDisjunction extends AstNode {
  EffectiveDisjunction() {
    this instanceof IfFormula
    or
    this instanceof Disjunction
  }

  /** Gets the left operand of this disjunction. */
  AstNode getLeft() {
    result = this.(IfFormula).getThenPart()
    or
    result = this.(Disjunction).getLeft()
  }

  /** Gets the right operand of this disjunction. */
  AstNode getRight() {
    result = this.(IfFormula).getElsePart()
    or
    result = this.(Disjunction).getRight()
  }

  /** Gets any of the operands of this disjunction. */
  AstNode getAnOperand() { result = [this.getLeft(), this.getRight()] }
}

/**
 * Holds if `disj` only uses `var` in one of its branches.
 */
pragma[noinline]
predicate onlyUseInOneBranch(EffectiveDisjunction disj, VarDef var, AstNode notBoundIn) {
  alwaysBindsVar(var, disj.getLeft()) and
  not alwaysBindsVar(var, disj.getRight()) and
  notBoundIn = disj.getRight()
  or
  not alwaysBindsVar(var, disj.getLeft()) and
  alwaysBindsVar(var, disj.getRight()) and
  notBoundIn = disj.getLeft()
}

/**
 * Holds if `comp` is an equality comparison that has a low number of results.
 */
predicate isTinyAssignment(ComparisonFormula comp) {
  comp.getOperator() = "=" and
  (
    isSmallType(comp.getAnOperand().getType())
    or
    comp.getAnOperand() instanceof Literal
  )
}

/**
 * An AstNode that acts like a conjunction.
 */
class EffectiveConjunction extends AstNode {
  EffectiveConjunction() {
    this instanceof Conjunction
    or
    this instanceof Exists
  }

  /** Gets the left operand of this conjunction */
  Formula getLeft() {
    result = this.(Conjunction).getLeft()
    or
    result = this.(Exists).getRange()
  }

  /** Gets the right operand of this conjunction */
  Formula getRight() {
    result = this.(Conjunction).getRight()
    or
    result = this.(Exists).getFormula()
  }
}

/**
 * Holds if `node` is a sub-node of a node that always binds `var`.
 */
predicate varIsAlwaysBound(VarDef var, AstNode node) {
  // base case
  alwaysBindsVar(var, node) and
  onlyUseInOneBranch(_, var, _) // <- manual magic
  or
  // recursive cases
  exists(AstNode parent | node.getParent() = parent | varIsAlwaysBound(var, parent))
  or
  exists(EffectiveConjunction parent |
    varIsAlwaysBound(var, parent.getLeft()) and
    node = parent.getRight()
    or
    varIsAlwaysBound(var, parent.getRight()) and
    node = parent.getLeft()
  )
  or
  exists(IfFormula ifForm | varIsAlwaysBound(var, ifForm.getCondition()) |
    node = [ifForm.getThenPart(), ifForm.getElsePart()]
  )
  or
  exists(Forall for | varIsAlwaysBound(var, for.getRange()) | node = for.getFormula())
}

/**
 * Holds if `disj` only uses `var` in one of its branches.
 * And we should report it as being a bad thing.
 */
predicate badDisjunction(EffectiveDisjunction disj, VarDef var, AstNode notBoundIn) {
  onlyUseInOneBranch(disj, var, notBoundIn) and
  // it's fine if it's always bound further up
  not varIsAlwaysBound(var, disj) and
  // none() on one side makes everything fine. (this happens, it's a type-system hack)
  not disj.getAnOperand() instanceof NoneCall and
  // inlined predicates might bind unused variables in the context they are used in.
  not (
    isInlined(disj.getEnclosingPredicate()) and
    var = disj.getEnclosingPredicate().getParameter(_)
  ) and
  // recursion prevention never runs, it's a compile-time check, so we remove those results here
  not disj.getEnclosingPredicate().getParent().(Class).getName().matches("%RecursionPrevention") and // these are by design
  // not a small type
  not isSmallType(var.getType()) and
  // one of the branches is a tiny assignment. These are usually intentional cartesian products (and not too big).
  not isTinyAssignment(disj.getAnOperand())
}

from EffectiveDisjunction disj, VarDef var, AstNode notBoundIn, string type
where
  badDisjunction(disj, var, notBoundIn) and
  not badDisjunction(disj.getParent(), var, _) and // avoid duplicate reporting of the same error
  if var.getParent() instanceof FieldDecl then type = "field" else type = "variable"
select disj, "The $@ is only used in one side of disjunct.", var, type + " " + var.getName()
