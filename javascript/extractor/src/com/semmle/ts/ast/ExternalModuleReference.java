package com.semmle.ts.ast;

import com.semmle.js.ast.Expression;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

public class ExternalModuleReference extends Expression implements INodeWithSymbol {
  private final Expression expression;
  private int symbol = -1;

  public ExternalModuleReference(SourceLocation loc, Expression expression) {
    super("ExternalModuleReference", loc);
    this.expression = expression;
  }

  public Expression getExpression() {
    return expression;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
  
  @Override
  public int getSymbol() {
    return this.symbol;
  }

  @Override
  public void setSymbol(int symbol) {
    this.symbol = symbol;
  }
}
