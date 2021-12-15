package com.semmle.js.ast;

import java.util.List;

/** A comma expression containing two or more expressions evaluated in sequence. */
public class SequenceExpression extends Expression {
  private final List<Expression> expressions;

  public SequenceExpression(SourceLocation loc, List<Expression> expressions) {
    super("SequenceExpression", loc);
    this.expressions = expressions;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The expressions in this sequence. */
  public List<Expression> getExpressions() {
    return expressions;
  }
}
