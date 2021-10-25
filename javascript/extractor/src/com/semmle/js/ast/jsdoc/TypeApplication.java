package com.semmle.js.ast.jsdoc;

import com.semmle.js.ast.SourceLocation;
import java.util.List;

/** A type application like <code>Map.&lt;String, Object&gt;</code>. */
public class TypeApplication extends JSDocTypeExpression {
  private final JSDocTypeExpression expression;
  private final List<JSDocTypeExpression> applications;

  public TypeApplication(
      SourceLocation loc, JSDocTypeExpression expression, List<JSDocTypeExpression> applications) {
    super(loc, "TypeApplication");
    this.expression = expression;
    this.applications = applications;
  }

  @Override
  public String pp() {
    StringBuilder sb = new StringBuilder();
    boolean first = true;

    sb.append(expression.pp());
    sb.append(".<");
    for (JSDocTypeExpression application : applications) {
      if (first) first = false;
      else sb.append(", ");
      sb.append(application.pp());
    }
    sb.append(">");

    return sb.toString();
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }

  /** The type constructor being applied. */
  public JSDocTypeExpression getExpression() {
    return expression;
  }

  /** The arguments to the type constructor. */
  public List<JSDocTypeExpression> getApplications() {
    return applications;
  }
}
