package com.semmle.ts.ast;

import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

/**
 * One of the TypeScript keyword types, such as <tt>string</tt> or <tt>any</tt>.
 *
 * <p>This includes the type <tt>unique symbol</tt> which consists of two keywords but is
 * represented as a keyword single type expression.
 *
 * <p>At the QL level, the <tt>null</tt> type is also a keyword type. In the extractor, however,
 * this is represented by a Literal, because the TypeScript AST does not distinguish those two uses
 * of <tt>null</tt>.
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
