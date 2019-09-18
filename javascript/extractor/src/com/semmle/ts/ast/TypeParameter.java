package com.semmle.ts.ast;

import com.semmle.js.ast.Identifier;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

/**
 * A type parameter declared on a class, interface, function, or type alias.
 *
 * <p>The general form of a type parameter is: <tt>S extends T = U</tt>.
 */
public class TypeParameter extends TypeExpression {
  private final Identifier id;
  private final ITypeExpression bound;
  private final ITypeExpression default_;

  public TypeParameter(
      SourceLocation loc, Identifier id, ITypeExpression bound, ITypeExpression default_) {
    super("TypeParameter", loc);
    this.id = id;
    this.bound = bound;
    this.default_ = default_;
  }

  public Identifier getId() {
    return id;
  }

  /**
   * Returns the bound on the type parameter, or {@code null} if there is no bound.
   *
   * <p>For example, in <tt>T extends Array = number[]</tt> the bound is <tt>Array</tt>.
   */
  public ITypeExpression getBound() {
    return bound;
  }

  /**
   * Returns the type parameter default, or {@code null} if there is no default,
   *
   * <p>For example, in <tt>T extends Array = number[]</tt> the default is <tt>number[]</tt>.
   */
  public ITypeExpression getDefault() {
    return default_;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
