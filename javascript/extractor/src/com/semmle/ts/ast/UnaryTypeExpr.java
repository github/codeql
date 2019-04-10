package com.semmle.ts.ast;

import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

/** A type of form <tt>keyof T</tt> where <tt>T</tt> is a type. */
public class UnaryTypeExpr extends TypeExpression {
  private final ITypeExpression elementType;
  private final Kind kind;

  public enum Kind {
    Keyof,
    Readonly
  }

  public UnaryTypeExpr(SourceLocation loc, Kind kind, ITypeExpression elementType) {
    super("UnaryTypeExpr", loc);
    this.kind = kind;
    this.elementType = elementType;
  }

  public ITypeExpression getElementType() {
    return elementType;
  }

  public Kind getKind() {
    return kind;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
