package com.semmle.js.ast;

import java.util.List;

/** An old-style let expression of the form <code>let (vardecls) expr</code>. */
public class LetExpression extends Expression {
  private final List<VariableDeclarator> head;
  private final Expression body;

  public LetExpression(SourceLocation loc, List<VariableDeclarator> head, Expression body) {
    super("LetExpression", loc);
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

  public Expression getBody() {
    return body;
  }
}
