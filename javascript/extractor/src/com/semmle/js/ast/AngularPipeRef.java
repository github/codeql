package com.semmle.js.ast;

/**
 * An identifier occurring as the right operand of an Angular pipe expression,
 * which has been desugared to a function call with this expression as the callee.
 * <p>
 * For example, <code>x | f:y</code> is desugared to <code>f(x, y)</code> where the
 * <code>f</code> is an instance of {@link AngularPipeRef}, and evaluates to the function
 * being invoked.
 */
public class AngularPipeRef extends Expression {
  private final Identifier identifier;

  public AngularPipeRef(SourceLocation loc, Identifier identifier) {
    super("AngularPipeRef", loc);
    this.identifier = identifier;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  public Identifier getIdentifier() {
    return identifier;
  }
}
