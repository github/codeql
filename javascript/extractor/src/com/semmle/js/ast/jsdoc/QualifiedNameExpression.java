package com.semmle.js.ast.jsdoc;

import com.semmle.js.ast.SourceLocation;

/** A qualified name in a JSDoc type. */
public class QualifiedNameExpression extends JSDocTypeExpression {
  private final JSDocTypeExpression base;
  private final Identifier name;

  public QualifiedNameExpression(SourceLocation loc, JSDocTypeExpression base, Identifier name) {
    super(loc, "QualifiedNameExpression");
    this.base = base;
    this.name = name;
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }

  /** Returns the expression on the left side of the dot character. */
  public JSDocTypeExpression getBase() {
      return base;
  }

  /** Returns the identifier on the right-hand side of the dot character. */
  public Identifier getNameNode() {
    return name;
  }

  @Override
  public String pp() {
    return base.pp() + "." + name.pp();
  }
}
