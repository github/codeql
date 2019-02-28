package com.semmle.ts.ast;

import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Statement;
import com.semmle.js.ast.Visitor;
import java.util.List;

/** A statement of form: <tt>declare global { ... }</tt> */
public class GlobalAugmentationDeclaration extends Statement {
  private final List<Statement> body;

  public GlobalAugmentationDeclaration(SourceLocation loc, List<Statement> body) {
    super("GlobalAugmentationDeclaration", loc);
    this.body = body;
  }

  public List<Statement> getBody() {
    return body;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
