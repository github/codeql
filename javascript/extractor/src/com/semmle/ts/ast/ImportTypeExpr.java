package com.semmle.ts.ast;

import com.semmle.js.ast.Expression;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

/** An import type such as in <tt>import("http").ServerRequest</tt>. */
public class ImportTypeExpr extends Expression implements ITypeExpression {
  private final ITypeExpression path;

  public ImportTypeExpr(SourceLocation loc, ITypeExpression path) {
    super("ImportTypeExpr", loc);
    this.path = path;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }

  public ITypeExpression getPath() {
    return path;
  }
}
