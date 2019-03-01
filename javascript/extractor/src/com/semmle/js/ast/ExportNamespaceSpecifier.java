package com.semmle.js.ast;

/**
 * A namespace export specifier such as <code>* as foo</code> in <code>export * as foo from 'foo';
 * </code>.
 */
public class ExportNamespaceSpecifier extends ExportSpecifier {
  public ExportNamespaceSpecifier(SourceLocation loc, Identifier exported) {
    super("ExportNamespaceSpecifier", loc, null, exported);
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
