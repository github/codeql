/**
 * @name Use of AngularJS markup in URL-valued attribute
 * @description Using AngularJS markup in an HTML attribute that references a URL
 *              (such as 'href' or 'src') may cause the browser to send a request
 *              with an invalid URL.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id js/angular/expression-in-url-attribute
 * @tags maintainability
 *       frameworks/angularjs
 */

import javascript

from HTML::Attribute attr, string name
where
  name = attr.getName() and
  // only flag URL-valued attributes...
  (name = "href" or name = "src" or name = "srcset") and
  // ...where the value contains some interpolated expressions
  attr.getValue().matches("%{{%}}") and
  // check that there is at least one use of an AngularJS attribute directive nearby
  // (`{{...}}` is used by other templating frameworks as well)
  any(AngularJS::DirectiveInstance d).getATarget().getElement().getRoot() = attr.getRoot()
select attr, "Use 'ng-" + name + "' instead of '" + name + "'."
