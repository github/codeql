package com.semmle.ts.ast;

import com.semmle.js.ast.Expression;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Statement;
import com.semmle.js.ast.Visitor;

public class ExportWholeDeclaration extends Statement {
  private final Expression rhs;

  public ExportWholeDeclaration(SourceLocation loc, Expression rhs) {
    super("ExportWholeDeclaration", loc);
    this.rhs = rhs;
  }

  public Expression getRhs() {
    return rhs;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
