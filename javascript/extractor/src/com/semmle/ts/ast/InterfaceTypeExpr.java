package com.semmle.ts.ast;

import com.semmle.js.ast.MemberDefinition;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;
import java.util.List;

/** An inline interface type, such as <tt>{x: number; y: number}</tt>. */
public class InterfaceTypeExpr extends TypeExpression {
  private final List<MemberDefinition<?>> body;

  public InterfaceTypeExpr(SourceLocation loc, List<MemberDefinition<?>> body) {
    super("InterfaceTypeExpr", loc);
    this.body = body;
  }

  public List<MemberDefinition<?>> getBody() {
    return body;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
