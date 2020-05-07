/**
 * @name Disabled Django CSRF protection
 * @description No csrf Middleware/ Decorator to protect Django application from CSRF
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id py/django-csrf
 * @tags security
 *       external/cwe/cwe-352
 */

import python
import semmle.python.strings

from GlobalVariable g, Assign assign, Expr elt
where
  /*
   * Checks if an GlobalVariable named MIDDLEWARE or MIDDLEWARE_CLASSES is present
   * and contains the middleware string
   */

  g.getId() in ["MIDDLEWARE", "MIDDLEWARE_CLASSES"] and
  assign.getATarget() = g.getAStore() and
  (
    elt = assign.getValue().(List).getAnElt()
    or
    elt = assign.getValue().(Tuple).getAnElt()
  ) and
  not elt.(StrConst).getS() in ["django.middleware.csrf.CsrfViewMiddleware",
        "session_csrf.CsrfMiddleware"] and
  /* Check if any CSRF decorator is used (csrf_protect) */
  not exists(FunctionExpr f |
    f.getADecorator().pointsTo() = Value::named("django.views.decorators.csrf.csrf_protect")
  )
select g.getAStore(),
  "csrf_middleware is not enabled in MIDDLEWARE() and CSRF is not implemented using decorator such as csrf_protect as well."
