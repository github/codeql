package com.semmle.js.ast;

import java.util.List;

/** A block statement such as <code>{ console.log("Hi"); }</code>. */
public class BlockStatement extends Statement {
  private final List<Statement> body;

  public BlockStatement(SourceLocation loc, List<Statement> body) {
    super("BlockStatement", loc);
    this.body = body;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The statements in the block. */
  public List<Statement> getBody() {
    return body;
  }
}
