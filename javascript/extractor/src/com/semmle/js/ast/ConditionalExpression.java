package com.semmle.js.ast;

/** A conditional expression such as <code>i &gt;= 0 ? a[i] : null</code>. */
public class ConditionalExpression extends Expression {
  private final Expression test;
  private final Expression consequent, alternate;

  public ConditionalExpression(
      SourceLocation loc, Expression test, Expression consequent, Expression alternate) {
    super("ConditionalExpression", loc);
    this.test = test;
    this.consequent = consequent;
    this.alternate = alternate;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The test expression of this conditional expression. */
  public Expression getTest() {
    return test;
  }

  /** The then-branch of this conditional expression. */
  public Expression getConsequent() {
    return consequent;
  }

  /** The else-branch of this conditional expression. */
  public Expression getAlternate() {
    return alternate;
  }
}
