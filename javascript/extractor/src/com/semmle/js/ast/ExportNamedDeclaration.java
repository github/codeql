package com.semmle.js.ast;

import java.util.List;

/**
 * A named export declaration, which can be of one of the following forms:
 *
 * <ul>
 *   <li><code>export var x = 23;</code>
 *   <li><code>export { x, y } from 'foo';</code>
 *   <li><code>export { x, y };</code>
 * </ul>
 */
public class ExportNamedDeclaration extends ExportDeclaration {
  private final Statement declaration;
  private final List<ExportSpecifier> specifiers;
  private final Literal source;
  private final Expression attributes;
  private final boolean hasTypeKeyword;

  public ExportNamedDeclaration(
      SourceLocation loc,
      Statement declaration,
      List<ExportSpecifier> specifiers,
      Literal source,
      Expression attributes) {
    this(loc, declaration, specifiers, source, attributes, false);
  }

  public ExportNamedDeclaration(
      SourceLocation loc,
      Statement declaration,
      List<ExportSpecifier> specifiers,
      Literal source,
      Expression attributes,
      boolean hasTypeKeyword) {
    super("ExportNamedDeclaration", loc);
    this.declaration = declaration;
    this.specifiers = specifiers;
    this.source = source;
    this.attributes = attributes;
    this.hasTypeKeyword = hasTypeKeyword;
  }

  public Statement getDeclaration() {
    return declaration;
  }

  public boolean hasDeclaration() {
    return declaration != null;
  }

  public List<ExportSpecifier> getSpecifiers() {
    return specifiers;
  }

  public Literal getSource() {
    return source;
  }

  public boolean hasSource() {
    return source != null;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }

  /**
   * Returns the expression after the <code>with</code> keyword, if any, such as <code>
   * { type: "json" }</code>.
   */
  public Expression getAttributes() {
    return attributes;
  }

  /** Returns true if this is an <code>export type</code> declaration. */
  public boolean hasTypeKeyword() {
    return hasTypeKeyword;
  }
}
