package com.semmle.js.ast;

/**
 * A namespace import specifier such as <code>* as foo</code> in <code>import * as foo from 'foo';
 * </code>.
 *
 * <p>Namespace import specifiers do not have an imported name.
 */
public class ImportNamespaceSpecifier extends ImportSpecifier {
  public ImportNamespaceSpecifier(SourceLocation loc, Identifier local) {
    super("ImportNamespaceSpecifier", loc, null, local);
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
