package com.semmle.js.ast;

import java.util.List;

/** The body of a {@linkplain ClassDeclaration} or {@linkplain ClassExpression}. */
public class ClassBody extends Node {
  private final List<Node> body; // either MemberDefinition or BlockStatement (static initialization blocks)

  public ClassBody(SourceLocation loc, List<Node> body) {
    super("ClassBody", loc);
    this.body = body;
  }

  public List<Node> getBody() {
    return body;
  }

  public void addMember(Node md) {
    body.add(md);
  }

  public MethodDefinition getConstructor() {
    for (Node md : body) if (md instanceof MethodDefinition && ((MethodDefinition)md).isConstructor()) return (MethodDefinition) md;
    return null;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
