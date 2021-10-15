package com.semmle.ts.ast;

import com.semmle.js.ast.Decorator;
import com.semmle.js.ast.Expression;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;
import java.util.List;

public class DecoratorList extends Expression {
  private final List<Decorator> decorators;

  public DecoratorList(SourceLocation loc, List<Decorator> decorators) {
    super("DecoratorList", loc);
    this.decorators = decorators;
  }

  public List<Decorator> getDecorators() {
    return decorators;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
