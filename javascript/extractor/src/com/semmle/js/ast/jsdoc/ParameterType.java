package com.semmle.js.ast.jsdoc;

import com.semmle.js.ast.SourceLocation;

/** A parameter type expression describing the type of a named function parameter. */
public class ParameterType extends JSDocTypeExpression {
  private final String name;
  private final JSDocTypeExpression expression;

  public ParameterType(SourceLocation loc, String name, JSDocTypeExpression expression) {
    super(loc, "ParameterType");
    this.name = name;
    this.expression = expression;
  }

  /** The name of the parameter. */
  public String getName() {
    return name;
  }

  /** The type of the parameter. */
  public JSDocTypeExpression getExpression() {
    return expression;
  }

  @Override
  public String pp() {
    return name + ": " + expression.pp();
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }
}
