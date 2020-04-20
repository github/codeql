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
import semmle.python.Import

/*
* Gets middleware that matches t: django.middleware.csrf.CsrfViewMiddleware | session_csrf.CsrfMiddleware.
*/

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
private string getDecorator(){
  result = "requires_csrf_token"
  or
  result = "ensure_csrf_cookie"
  or
  result = "csrf_protect"
}

from  GlobalVariable g, StrConst s

where

/*
 * This check makes sure that we are dealing with an Django application.
 * Django application has a global variable called MIDDLEWARE.
 */
exists( | g.getId().regexpMatch("MIDDLEWARE.*") ) and
/*
 * Check if there are any CSRF middleware from checking all the stringConst.
*/
count( |
  exists( |
    s.getS().regexpMatch(getCsrfMiddleware())
  )
) = 0 and
/*
 * Check if CsrfViewMiddleware is imported as from django.middleware.csrf import CsrfViewMiddleware
 * and from django.middleware.csrf import *.
*/
count( Import k |
  exists( |
    k.getAnImportedModuleName().regexpMatch(".*csrf.*")
  )
) = 0 and
count( ImportStar is |
  exists( |
    is.getImportedModuleName().regexpMatch(".*csrf.*")
  )
) = 0 and
/*
 * Counts the number of CSRF decorator used and ensures that it's not used explicitly.
*/
count( Function f |
  exists( |
    repr(f.getADecorator()).regexpMatch(getDecorator())
  )
) = 0


select g.getAnAccess(), "CSRF middleware is not enabled in MIDDLEWARE[] and CSRF is not implemented using decorator such as csrf_protect, ensure_csrf as well."