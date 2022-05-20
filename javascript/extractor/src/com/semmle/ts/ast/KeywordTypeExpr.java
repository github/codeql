package com.semmle.ts.ast;

import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

/**
 * One of the TypeScript keyword types, such as <code>string</code> or <code>any</code>.
 *
 * <p>This includes the type <code>unique symbol</code> which consists of two keywords but is
 * represented as a keyword single type expression.
 *
 * <p>At the QL level, the <code>null</code> type is also a keyword type. In the extractor, however,
 * this is represented by a Literal, because the TypeScript AST does not distinguish those two uses
 * of <code>null</code>.
 */
public class KeywordTypeExpr extends TypeExpression {
  private final String keyword;

  public KeywordTypeExpr(SourceLocation loc, String keyword) {
    super("KeywordTypeExpr", loc);
    this.keyword = keyword;
  }

  public String getKeyword() {
    return keyword;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
