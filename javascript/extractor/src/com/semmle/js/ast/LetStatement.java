package com.semmle.js.ast;

import java.util.List;

/** An old-style let statement of the form <code>let(vardecls) stmt</code>. */
public class LetStatement extends Statement {
  private final List<VariableDeclarator> head;
  private final Statement body;

  public LetStatement(SourceLocation loc, List<VariableDeclarator> head, Statement body) {
    super("LetStatement", loc);
    this.head = head;
    this.body = body;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }

  public List<VariableDeclarator> getHead() {
    return head;
  }

  public Statement getBody() {
    return body;
  }
}
