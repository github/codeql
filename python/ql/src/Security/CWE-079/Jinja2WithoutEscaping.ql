/**
 * @name Jinja2 templating with autoescape=False
 * @description Using jinja2 templates with 'autoescape=False' can
 *              cause a cross-site scripting vulnerability.
 * @kind problem
 * @problem.severity error
 * @security-severity 6.1
 * @precision medium
 * @id py/jinja2/autoescape-false
 * @tags security
 *       external/cwe/cwe-079
 */

import python

/*
 * Jinja 2 Docs:
 * https://jinja.palletsprojects.com/en/2.11.x/api/#jinja2.Environment
 * https://jinja.palletsprojects.com/en/2.11.x/api/#jinja2.Template
 *
 * Although the docs doesn't say very clearly, autoescape is a valid argument when constructing
 * a Template manually
 *
 * unsafe_tmpl = Template('Hello {{ name }}!')
 * safe1_tmpl = Template('Hello {{ name }}!', autoescape=True)
 */

ClassValue jinja2EnvironmentOrTemplate() {
  result = Value::named("jinja2.Environment")
  or
  result = Value::named("jinja2.Template")
}

ControlFlowNode getAutoEscapeParameter(CallNode call) { result = call.getArgByName("autoescape") }

from CallNode call
where
  call.getFunction().pointsTo(jinja2EnvironmentOrTemplate()) and
  not exists(call.getNode().getStarargs()) and
  not exists(call.getNode().getKwargs()) and
  (
    not exists(getAutoEscapeParameter(call))
    or
    exists(Value isFalse |
      getAutoEscapeParameter(call).pointsTo(isFalse) and
      isFalse.getDefiniteBooleanValue() = false
    )
  )
select call, "Using jinja2 templates with autoescape=False can potentially allow XSS attacks."
