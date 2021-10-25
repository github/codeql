package com.semmle.js.ast;

import java.util.List;

/** A comprehension expression. */
public class ComprehensionExpression extends Expression {
  private final Expression body;
  private final List<ComprehensionBlock> blocks;
  private final Expression filter;
  private final boolean generator;

  public ComprehensionExpression(
      SourceLocation loc,
      Expression body,
      List<ComprehensionBlock> blocks,
      Expression filter,
      Boolean generator) {
    super("ComprehensionExpression", loc);
    this.body = body;
    this.blocks = blocks;
    this.filter = filter;
    this.generator = generator == Boolean.TRUE;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The body expression of this comprehension. */
  public Expression getBody() {
    return body;
  }

  /** The comprehension blocks of this comprehension. */
  public List<ComprehensionBlock> getBlocks() {
    return blocks;
  }

  /** Does this comprehension expression have a filter expression? */
  public boolean hasFilter() {
    return filter != null;
  }

  /** The filter expression of this comprehension; may be null. */
  public Expression getFilter() {
    return filter;
  }

  /** Is this a generator expression? */
  public boolean isGenerator() {
    return generator;
  }
}
