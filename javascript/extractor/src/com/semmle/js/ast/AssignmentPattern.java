package com.semmle.js.ast;

/**
 * An assignment pattern occurring in an lvalue position.
 *
 * <p>Assignment patterns specify default values for function parameters, for-in/for-of loop
 * variables and in destructuring assignments. We normalise them away during AST construction,
 * attaching information about the default value directly to the parameter or variable in question.
 * Hence, assignment patterns are not expected to appear in the AST the extractor works on.
 */
public class AssignmentPattern extends ABinaryExpression implements IPattern {
  public AssignmentPattern(SourceLocation loc, String operator, Expression left, Expression right) {
    super(loc, "AssignmentPattern", operator, left, right);
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }
}
