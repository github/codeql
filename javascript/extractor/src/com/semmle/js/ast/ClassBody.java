package com.semmle.js.ast;

import java.util.List;

/** The body of a {@linkplain ClassDeclaration} or {@linkplain ClassExpression}. */
public class ClassBody extends Node {
  private final List<MemberDefinition<?>> body;

  public ClassBody(SourceLocation loc, List<MemberDefinition<?>> body) {
    super("ClassBody", loc);
    this.body = body;
  }

  public List<MemberDefinition<?>> getBody() {
    return body;
  }

  public void addMember(MemberDefinition<?> md) {
    body.add(md);
  }

  public MethodDefinition getConstructor() {
    for (MemberDefinition<?> md : body) if (md.isConstructor()) return (MethodDefinition) md;
    return null;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
