package com.semmle.js.ast;

/**
 * A default import specifier, such as <code>f</code> in <code>import f, { x, y } from 'foo';</code>
 * .
 *
 * <p>Default import specifiers do not have an explicit imported name (the imported name is,
 * implicitly, <code>default</code>).
 */
public class ImportDefaultSpecifier extends ImportSpecifier {
  public ImportDefaultSpecifier(SourceLocation loc, Identifier local) {
    super("ImportDefaultSpecifier", loc, null, local);
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
