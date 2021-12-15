package com.semmle.js.ast;

import com.semmle.ts.ast.INodeWithSymbol;
import com.semmle.ts.ast.ITypeExpression;

/** A member expression, either computed (<code>e[f]</code>) or static (<code>e.f</code>). */
public class MemberExpression extends Expression
    implements ITypeExpression, INodeWithSymbol, Chainable {
  private final Expression object, property;
  private final boolean computed;
  private final boolean optional;
  private final boolean onOptionalChain;
  private int symbol = -1;

  public MemberExpression(
      SourceLocation loc,
      Expression object,
      Expression property,
      Boolean computed,
      Boolean optional,
      Boolean onOptionalChain) {
    super("MemberExpression", loc);
    this.object = object;
    this.property = property;
    this.computed = computed == Boolean.TRUE;
    this.optional = optional == Boolean.TRUE;
    this.onOptionalChain = onOptionalChain == Boolean.TRUE;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The base expression of this member expression. */
  public Expression getObject() {
    return object;
  }

  /**
   * The property expression of this member expression; for static member expressions this is always
   * an {@link Identifier}.
   */
  public Expression getProperty() {
    return property;
  }

  /** Is this a computed member expression? */
  public boolean isComputed() {
    return computed;
  }

  @Override
  public boolean isOptional() {
    return optional;
  }

  @Override
  public boolean isOnOptionalChain() {
    return onOptionalChain;
  }

  @Override
  public int getSymbol() {
    return symbol;
  }

  @Override
  public void setSymbol(int symbol) {
    this.symbol = symbol;
  }
}
