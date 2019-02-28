package com.semmle.js.ast;

/** A tagged template expression. */
public class TaggedTemplateExpression extends Expression {
  private final Expression tag;
  private final TemplateLiteral quasi;

  public TaggedTemplateExpression(SourceLocation loc, Expression tag, TemplateLiteral quasi) {
    super("TaggedTemplateExpression", loc);
    this.tag = tag;
    this.quasi = quasi;
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
}
