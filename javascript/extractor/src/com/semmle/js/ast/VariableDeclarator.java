package com.semmle.js.ast;

import com.semmle.ts.ast.ITypeExpression;

/** A variable declarator in a variable declaration statement. */
public class VariableDeclarator extends Expression {
  private final IPattern id;
  private final Expression init;
  private final ITypeExpression typeAnnotation;

  /**
   * A bitmask of flags defined in {@linkplain DeclarationFlags}.
   *
   * <p>Currently only {@link DeclarationFlags#definiteAssignmentAssertion} may be set on variable
   * declarators.
   */
  private final int flags;

  public VariableDeclarator(
      SourceLocation loc, IPattern id, Expression init, ITypeExpression typeAnnotation, int flags) {
    super("VariableDeclarator", loc);
    this.id = id;
    this.init = init;
    this.typeAnnotation = typeAnnotation;
    this.flags = flags;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The declared variable(s). */
  public IPattern getId() {
    return id;
  }

  /** Does this variable declarator have an initializing expression? */
  public boolean hasInit() {
    return init != null;
  }

  /** The initializing expression of this variable declarator; may be null. */
  public Expression getInit() {
    return init;
  }

  /** The TypeScript type annotation for this variable; may be null. */
  public ITypeExpression getTypeAnnotation() {
    return typeAnnotation;
  }

  /** Returns the modifiers set on this variable, as defined by {@link DeclarationFlags}. */
  public int getFlags() {
    return this.flags;
  }
}
