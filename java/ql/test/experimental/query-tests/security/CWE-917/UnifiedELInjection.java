import javax.el.ELProcessor;
import javax.el.ExpressionFactory;
import javax.el.MethodExpression;
import javax.el.ValueExpression;

import org.springframework.web.bind.annotation.RequestParam;

public class UnifiedELInjection {
  public void testMethodExpression(@RequestParam String expr) {
    MethodExpression me = ExpressionFactory.newInstance().createMethodExpression(null, expr, null, null);
    me.invoke(null, null);
  }

  public void testValueExpression(@RequestParam String expr) {
    ExpressionFactory ef = ExpressionFactory.newInstance();
    ValueExpression ve = ef.createValueExpression(null, expr, null);
    ve.getValue(null);
    ve.setValue(null, null);
  }

  public void testELProcessor(@RequestParam String expr) {
    ELProcessor proc = new ELProcessor();
    proc.eval(expr);
    proc.getValue(expr, null);
    proc.setValue(expr, null);
  }
}
