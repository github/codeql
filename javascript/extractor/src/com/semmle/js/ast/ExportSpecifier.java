package com.semmle.js.ast;

/**
 * An export specifier in an {@linkplain ExportNamedDeclaration}; may either be a plain identifier
 * <code>x</code>, or a rename export <code>x as y</code>.
 */
public class ExportSpecifier extends Expression {
  private final Identifier local, exported;

  public ExportSpecifier(SourceLocation loc, Identifier local, Identifier exported) {
    this("ExportSpecifier", loc, local, exported);
  }

  public ExportSpecifier(String type, SourceLocation loc, Identifier local, Identifier exported) {
    super(type, loc);
    this.local = local;
    this.exported = exported == local ? new NodeCopier().copy(exported) : exported;
  }

  public Identifier getLocal() {
    return local;
  }

  public Identifier getExported() {
    return exported;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
