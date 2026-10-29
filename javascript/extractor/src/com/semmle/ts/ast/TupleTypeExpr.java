package com.semmle.ts.ast;

import com.semmle.js.ast.Identifier;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;
import java.util.List;

/** A tuple type, such as <code>[number, string]</code>. */
public class TupleTypeExpr extends TypeExpression {
  private final List<ITypeExpression> elementTypes;
  private final List<Identifier> elementNames;

  public TupleTypeExpr(SourceLocation loc, List<ITypeExpression> elementTypes, List<Identifier> elementNames) {
    super("TupleTypeExpr", loc);
    this.elementTypes = elementTypes;
    this.elementNames = elementNames;
  }

  public List<ITypeExpression> getElementTypes() {
    return elementTypes;
  }

  public List<Identifier> getElementNames() {
    return elementNames;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
