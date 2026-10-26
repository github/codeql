package com.semmle.ts.ast;

import com.semmle.js.ast.Expression;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;
import java.util.List;

/**
 * An expression with type arguments, occurring as the super-class expression of a class. For
 * example:
 *
 * <pre>
 * class StringList extends List&lt;string&gt; {}
 * </pre>
 *
 * Above, <code>List</code> is a concrete expression whereas its type argument is a type.
 */
public class ExpressionWithTypeArguments extends Expression {
  private final Expression expression;
  private final List<ITypeExpression> typeArguments;

  public ExpressionWithTypeArguments(
      SourceLocation loc, Expression expression, List<ITypeExpression> typeArguments) {
    super("ExpressionWithTypeArguments", loc);
    this.expression = expression;
    this.typeArguments = typeArguments;
  }

  public Expression getExpression() {
    return expression;
  }

  public List<ITypeExpression> getTypeArguments() {
    return typeArguments;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
