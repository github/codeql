package com.semmle.js.ast;

import com.semmle.ts.ast.INodeWithSymbol;
import java.util.List;

/**
 * An import declaration, which can be of one of the following forms:
 *
 * <pre>
 *   import v from "m";
 *   import * as ns from "m";
 *   import {x, y, w as z} from "m";
 *   import v, * as ns from "m";
 *   import v, {x, y, w as z} from "m";
 *   import "m";
 * </pre>
 */
public class ImportDeclaration extends Statement implements INodeWithSymbol {
  /** List of import specifiers detailing how declarations are imported; may be empty. */
  private final List<ImportSpecifier> specifiers;

  /** The module from which declarations are imported. */
  private final Literal source;

  private final Expression attributes;

  private int symbol = -1;

  private ImportPhaseModifier phaseModifier;

  public ImportDeclaration(
      SourceLocation loc, List<ImportSpecifier> specifiers, Literal source, Expression attributes) {
    this(loc, specifiers, source, attributes, ImportPhaseModifier.NONE);
  }

  public ImportDeclaration(
      SourceLocation loc,
      List<ImportSpecifier> specifiers,
      Literal source,
      Expression attributes,
      ImportPhaseModifier phaseModifier) {
    super("ImportDeclaration", loc);
    this.specifiers = specifiers;
    this.source = source;
    this.attributes = attributes;
    this.phaseModifier = phaseModifier;
  }

  public Literal getSource() {
    return source;
  }

  public List<ImportSpecifier> getSpecifiers() {
    return specifiers;
  }

  /**
   * Returns the expression after the <code>with</code> keyword, if any, such as <code>
   * { type: "json" }</code>.
   */
  public Expression getAttributes() {
    return attributes;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }

  @Override
  public int getSymbol() {
    return this.symbol;
  }

  @Override
  public void setSymbol(int symbol) {
    this.symbol = symbol;
  }

  /** Returns true if this is an <code>import type</code> declaration. */
  public boolean hasTypeKeyword() {
    return phaseModifier == ImportPhaseModifier.TYPE;
  }

  /** Returns true if this is an <code>import defer</code> declaration. */
  public boolean hasDeferKeyword() {
    return phaseModifier == ImportPhaseModifier.DEFER;
  }

  public ImportPhaseModifier getPhaseModifier() {
    return phaseModifier;
  }
}
