package com.semmle.js.ast;

/**
 * A placeholder for generated code, speculatively parsed as a primary expression.
 *
 * <p>For example, in this snippet,
 *
 * <pre>
 * let data = {{user_data}};
 * </pre>
 *
 * the expression <code>{{user_data}}</code> is assumed to be filled in by a templating engine so
 * that it can be parsed as an expression, and a <code>GeneratedCodeExpr</code> is thus created to
 * represent it.
 */
public class GeneratedCodeExpr extends Expression {
  private String openingDelimiter;
  private String closingDelimiter;
  private String body;

  public GeneratedCodeExpr(
      SourceLocation loc, String openingDelimiter, String closingDelimiter, String body) {
    super("GeneratedCodeExpr", loc);
    this.openingDelimiter = openingDelimiter;
    this.closingDelimiter = closingDelimiter;
    this.body = body;
  }

  public String getOpeningDelimiter() {
    return openingDelimiter;
  }

  public String getClosingDelimiter() {
    return closingDelimiter;
  }

  public String getBody() {
    return body;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
