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

/*
 * Gets middleware that matches t: django.middleware.csrf.CsrfViewMiddleware | session_csrf.CsrfMiddleware.
 */

private string getMiddlewareVar() {
  /*
   * Django's CSRF middleware Var
   */

  result = "MIDDLEWARE"
  or
  result = "MIDDLEWARE_CLASSES"
}

private string getCsrfMiddleware() {
  /*
   * Django's CSRF middle ware and
   * Mozilla's CSRF middle ware
   */

  result = "django.middleware.csrf.CsrfViewMiddleware"
  or
  result = "session_csrf.CsrfMiddleware"
}

/*
 * Gets decorates that match the regex   : requires_csrf_token | ensure_csrf_cookie  | csrf_protect.
 */

private string getDecorator() {
  result = "django.views.decorators.csrf.csrf_protect"
  or
  result = "django.views.decorators.csrf.ensure_csrf_cookie"
  or
  result = "django.views.decorators.requires_csrf_token"
}

from List l, StrConst s, GlobalVariable g
where
  /*
   * This checks if there is a GlobalVariable(list) named MIDDLEWARE or MIDDLEWARE_CLASES
   * and contains the middlware string
   */

  exists( | g.getId().regexpMatch(getMiddlewareVar())) and
  not exists( | s.getS().regexpMatch(getCsrfMiddleware())) and
  not l.getParentNode().getAChildNode().toString().regexpMatch(g.getId()) and
  not l.contains(s) and
  /*
   *  Check if any CSRF decorator is used
   */

  not exists(Function f | f.getADecorator().pointsTo(Value::named(getDecorator())))

select g.getAStore(),
  "CSRF middleware is not enabled in MIDDLEWARE[] and CSRF is not implemented using decorator such as csrf_protect, ensure_csrf as well."
