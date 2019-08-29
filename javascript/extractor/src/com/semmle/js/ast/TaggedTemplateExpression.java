package com.semmle.js.ast;

import com.semmle.ts.ast.ITypeExpression;
import java.util.Collections;
import java.util.List;

/** A tagged template expression. */
public class TaggedTemplateExpression extends Expression {
  private final Expression tag;
  private final TemplateLiteral quasi;
  private final List<ITypeExpression> typeArguments;

  public TaggedTemplateExpression(
      SourceLocation loc,
      Expression tag,
      TemplateLiteral quasi,
      List<ITypeExpression> typeArguments) {
    super("TaggedTemplateExpression", loc);
    this.tag = tag;
    this.quasi = quasi;
    this.typeArguments = typeArguments;
  }

  public TaggedTemplateExpression(SourceLocation loc, Expression tag, TemplateLiteral quasi) {
    this(loc, tag, quasi, Collections.emptyList());
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The tagging expression. */
  public Expression getTag() {
    return tag;
  }

  /** The tagged template literal. */
  public TemplateLiteral getQuasi() {
    return quasi;
  }

  /** The type arguments, or an empty list if there are none. */
  public List<ITypeExpression> getTypeArguments() {
    return typeArguments;
  }
}
