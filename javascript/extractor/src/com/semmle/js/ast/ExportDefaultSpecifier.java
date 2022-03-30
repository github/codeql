package com.semmle.js.ast;

/** A default export specifier, such as <code>f</code> in <code>export f from 'foo';</code>. */
public class ExportDefaultSpecifier extends ExportSpecifier {
  public ExportDefaultSpecifier(SourceLocation loc, Identifier exported) {
    super("ExportDefaultSpecifier", loc, null, exported);
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
