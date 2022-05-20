package com.semmle.js.ast;

/** A block in a comprehension expression. */
public class ComprehensionBlock extends Expression {
  private final IPattern left;
  private final Expression right;
  private final boolean of;

  public ComprehensionBlock(SourceLocation loc, IPattern left, Expression right, Boolean of) {
    super("ComprehensionBlock", loc);
    this.left = left;
    this.right = right;
    this.of = of != Boolean.FALSE;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The iterator variable of this comprehension block. */
  public IPattern getLeft() {
    return left;
  }

  /** The expression this comprehension block iterates over. */
  public Expression getRight() {
    return right;
  }

  /** Is this a <code>for-of</code> comprehension block? */
  public boolean isOf() {
    return of;
  }
}
