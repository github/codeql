/**
 * @name Double compilation
 * @description Recompiling an already compiled part of the DOM can lead to
 *              unexpected behavior of directives, performance problems, and memory leaks.
 * @kind problem
 * @problem.severity warning
 * @security-severity 8.8
 * @id js/angular/double-compilation
 * @tags reliability
 *       frameworks/angularjs
 *       security
 *       external/cwe/cwe-1176
 * @precision very-high
 */

import javascript

from AngularJS::ServiceReference compile, DataFlow::ParameterNode elem, DataFlow::CallNode c
where
  compile.getName() = "$compile" and
  elem =
    any(AngularJS::CustomDirective d)
        .getALinkFunction()
        .(AngularJS::LinkFunction)
        .getElementParameter() and
  c = compile.getACall() and
  elem.flowsTo(c.getArgument(0)) and
  // don't flag $compile calls that specify a `maxPriority`
  c.getNumArgument() < 3
select c, "This call to $compile may cause double compilation of '" + elem + "'."
