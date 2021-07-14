package com.semmle.js.ast;

import java.util.ArrayList;
import java.util.List;

/**
 * A template literal such as <code>`Hello, ${name}!`</code>.
 *
 * <p>In SpiderMonkey parlance, a template literal is composed of <i>quasis</i> (the constant parts
 * of the template literal) and <i>expressions</i> (the variable parts). In the example, <code>
 * "Hello, "</code> and <code>"!"</code> are the quasis, and <code>name</code> is the single
 * expression.
 */
public class TemplateLiteral extends Expression {
  private final List<Expression> expressions;
  private final List<TemplateElement> quasis;
  private final List<Expression> children;

  public TemplateLiteral(
      SourceLocation loc, List<Expression> expressions, List<TemplateElement> quasis) {
    super("TemplateLiteral", loc);
    this.expressions = expressions;
    this.quasis = quasis;
    this.children = TemplateLiteral.<Expression>mergeChildren(expressions, quasis);
  }

  /*
   * Merge quasis and expressions into a single array in textual order.
   * Also filter out the empty constant strings that the parser likes to generate.
   */
  @SuppressWarnings("unchecked")
  public static <E extends INode> List<E> mergeChildren(
      List<? extends INode> expressions,
      List<TemplateElement> quasis) {

    List<INode> children = new ArrayList<INode>();
    int j = 0, n = quasis.size();

    for (int i = 0, m = expressions.size(); i < m; ++i) {
      INode expr = expressions.get(i);
      for (; j < n; ++j) {
        TemplateElement quasi = quasis.get(j);
        if (quasi.getLoc().getStart().compareTo(expr.getLoc().getStart()) > 0) break;
        if (!quasi.getRaw().isEmpty()) children.add(quasi);
      }
      children.add(expr);
    }

    for (; j < n; ++j) {
      TemplateElement quasi = quasis.get(j);
      if (!quasi.getRaw().isEmpty()) children.add(quasi);
    }

    return (List<E>)children;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The expressions in this template. */
  public List<Expression> getExpressions() {
    return expressions;
  }

  /** The template elements in this template. */
  public List<TemplateElement> getQuasis() {
    return quasis;
  }

  /** All expressions and template elements in this template, in lexical order. */
  public List<Expression> getChildren() {
    return children;
  }
}
