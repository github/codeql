/**
 * @name Polymorphism Optimization
 * @description Optimization hints for polymorphic code
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.polymorphism.ClassResolver

/**
 * A method call that appears to be monomorphic.
 */
class MonomorphicCallSite extends TS::PHP::MemberCallExpression {
  MonomorphicCallSite() {
    // Calls on $this are often monomorphic
    this.getObject().(TS::PHP::VariableName).getChild().(TS::PHP::Name).getValue() = "$this"
  }
}

/**
 * Checks if a call site is a good inlining candidate.
 */
predicate isInliningCandidate(TS::PHP::MemberCallExpression call) {
  call instanceof MonomorphicCallSite
}

/**
 * Checks if dispatch is deterministic.
 */
predicate isDeterministicDispatch(TS::PHP::MemberCallExpression call) {
  call instanceof MonomorphicCallSite
}
