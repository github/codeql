package com.semmle.ts.ast;

import java.util.ArrayList;
import java.util.List;

import com.semmle.js.ast.Expression;
import com.semmle.js.ast.INode;
import com.semmle.js.ast.Node;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.TemplateElement;
import com.semmle.js.ast.TemplateLiteral;
import com.semmle.js.ast.Visitor;

/**
 * A template literal used in a type, such as in <code>type T = `Hello, ${name}!`</code>.
 */
public class TemplateLiteralTypeExpr extends TypeExpression {
  private final List<ITypeExpression> expressions;
  private final List<TemplateElement> quasis;
  private final List<Node> children;

  public TemplateLiteralTypeExpr(
      SourceLocation loc, List<ITypeExpression> expressions, List<TemplateElement> quasis) {
    super("TemplateLiteralTypeExpr", loc);
    this.expressions = expressions;
    this.quasis = quasis;
    this.children = TemplateLiteral.<Node>mergeChildren(expressions, quasis);
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The type expressions in this template. */
  public List<ITypeExpression> getExpressions() {
    return expressions;
  }

  /** The template elements in this template. */
  public List<TemplateElement> getQuasis() {
    return quasis;
  }

  /** All type expressions and template elements in this template, in lexical order. */
  public List<Node> getChildren() {
    return children;
  }
}
