import ognl.Ognl;
import ognl.OgnlException;

public void evaluate(HttpServletRequest request, Object root) throws OgnlException {
  String expression = request.getParameter("expression");

  // BAD: User provided expression is evaluated
  Ognl.getValue(expression, root);
  
  // GOOD: The name is validated and expression is evaluated in sandbox
  System.setProperty("ognl.security.manager", ""); // Or add -Dognl.security.manager to JVM args
  if (isValid(expression)) {
    Ognl.getValue(expression, root);
  } else {
    // Reject the request
  }
} 