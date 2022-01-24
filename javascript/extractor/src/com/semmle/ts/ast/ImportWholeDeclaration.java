package com.semmle.ts.ast;

import com.semmle.js.ast.Expression;
import com.semmle.js.ast.Identifier;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Statement;
import com.semmle.js.ast.Visitor;

/** An import of form <code>import a = E</code>. */
public class ImportWholeDeclaration extends Statement {
  private final Identifier lhs;
  private final Expression rhs;

  public ImportWholeDeclaration(SourceLocation loc, Identifier lhs, Expression rhs) {
    super("ImportWholeDeclaration", loc);
    this.lhs = lhs;
    this.rhs = rhs;
  }

  public Identifier getLhs() {
    return lhs;
  }

  public Expression getRhs() {
    return rhs;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
