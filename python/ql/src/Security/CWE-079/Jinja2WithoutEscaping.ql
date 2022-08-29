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
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs

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

private API::Node jinja2EnvironmentOrTemplate() {
  result = API::moduleImport("jinja2").getMember("Environment")
  or
  result = API::moduleImport("jinja2").getMember("Template")
}

from API::CallNode call
where
  call = jinja2EnvironmentOrTemplate().getACall() and
  not exists(call.asCfgNode().(CallNode).getNode().getStarargs()) and
  not exists(call.asCfgNode().(CallNode).getNode().getKwargs()) and
  (
    not exists(call.getArgByName("autoescape"))
    or
    call.getKeywordParameter("autoescape")
        .getAValueReachingSink()
        .asExpr()
        .(ImmutableLiteral)
        .booleanValue() = false
  )
select call, "Using jinja2 templates with autoescape=False can potentially allow XSS attacks."
