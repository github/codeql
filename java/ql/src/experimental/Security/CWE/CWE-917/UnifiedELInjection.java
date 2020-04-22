import javax.el.ELContext;
import javax.el.ExpressionFactory;
import javax.el.ValueExpression;

public String evaluate(HttpServletRequest request, ELContext ctx) {
  ExpressionFactory ef = ExpressionFactory.newInstance();

  // BAD: User provided expression is evaluated
  ValueExpression ve = ef.createValueExpression(ctx, expr, String.class);
  return (String) ve.getValue(ctx);

  // GOOD: Don't evaluate user provided expressions
}  