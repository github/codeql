package com.semmle.ts.ast;

import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

/**
 * A unary operator applied to a type.
 *
 * <p>This can be <tt>keyof T</tt> or <tt>readonly T</tt>.
 */
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
