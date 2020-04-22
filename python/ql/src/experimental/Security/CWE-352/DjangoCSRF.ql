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

from GlobalVariable g
where
  /*
   * Regex matching MIDDLEWARE & MIDDLEWARE_CLASSES(backwards compatibility)
   * Checks if there is a GlobalVariable(List/Tuple) named MIDDLEWARE or MIDDLEWARE_CLASES
   * and contains the middleware string
   */

  g.getId().regexpMatch("MIDDLEWARE(_CLASSES)?") and
  not exists(List l |
    l.getParentNode().getAChildNode().toString().regexpMatch(g.getId()) and
    exists(StrConst mw | mw.getS().regexpMatch(".*csrf.*") and l.contains(mw))
  ) and
  not exists(Tuple t |
    t.getParentNode().getAChildNode().toString().regexpMatch(g.getId()) and
    exists(StrConst mw | mw.getS().regexpMatch(".*csrf.*") and t.contains(mw))
  ) and
  /* Check if any CSRF decorator is used (requires_csrf_token | ensure_csrf_cookie  | csrf_protect) */
  not exists(FunctionExpr f |
    f.getADecoratorCall().getFunc().toString().regexpMatch(".*csrf_(protect|exempt|cookie).*")
  )
select g.getAStore(),"csrf_middleware is not enabled in MIDDLEWARE() and CSRF is not implemented using decorator such as csrf_protect, ensure_csrf as well."