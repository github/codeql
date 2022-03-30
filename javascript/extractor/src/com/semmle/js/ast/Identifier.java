package com.semmle.js.ast;

import com.semmle.ts.ast.INodeWithSymbol;
import com.semmle.ts.ast.ITypeExpression;

/**
 * An identifier.
 *
 * <p>Identifiers can either be variable declarations (like <code>x</code> in <code>var x;</code>),
 * variable references (like <code>x</code> in <code>x = 42</code>), property names (like <code>f
 * </code> in <code>e.f</code>), statement labels (like <code>l</code> in <code>l: while(true);
 * </code>), or statement label references (like <code>l</code> in <code>break l;</code>).
 */
public class Identifier extends Expression implements IPattern, ITypeExpression, INodeWithSymbol {
  private final String name;
  private int symbol = -1;

  public Identifier(SourceLocation loc, String name) {
    super("Identifier", loc);
    this.name = name;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The name of this identifier. */
  public String getName() {
    return name;
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
