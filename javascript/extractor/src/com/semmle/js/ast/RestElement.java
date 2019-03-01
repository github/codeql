package com.semmle.js.ast;

/**
 * A rest element <code>...xs</code> in lvalue position.
 *
 * <p>Rest elements can only appear as part of a function's parameter list or in an array pattern;
 * they are rewritten away by the constructors of {@linkplain AFunction} and {@link ArrayPattern},
 * and don't appear in the AST the extractor works on.
 */
public class RestElement extends Expression implements IPattern {
  private final Expression argument;

  public RestElement(SourceLocation loc, Expression argument) {
    super("RestElement", loc);
    this.argument = argument;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The argument expression of this spread element. */
  public Expression getArgument() {
    return argument;
  }
}
