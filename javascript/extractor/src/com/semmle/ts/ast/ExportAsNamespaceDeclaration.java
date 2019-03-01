package com.semmle.ts.ast;

import com.semmle.js.ast.Identifier;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Statement;
import com.semmle.js.ast.Visitor;

/** A statement of form <tt>export as namespace X</tt> where <tt>X</tt> is an identifier. */
public class ExportAsNamespaceDeclaration extends Statement {
  private Identifier id;

  public ExportAsNamespaceDeclaration(SourceLocation loc, Identifier id) {
    super("ExportAsNamespaceDeclaration", loc);
    this.id = id;
  }

  public Identifier getId() {
    return id;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
