/**
 * @name Jinja2 templating with autoescape=False
 * @description Using jinja2 templates with 'autoescape=False' can
 *              cause a cross-site scripting vulnerability.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id py/jinja2/autoescape-false
 * @tags security
 *       external/cwe/cwe-079
 */

import python

ClassObject jinja2EnvironmentOrTemplate() {
    exists(ModuleObject jinja2, string name |
        jinja2.getName() = "jinja2" and
        jinja2.attr(name) = result |
        name = "Environment" or
        name = "Template"
    )
}

ControlFlowNode getAutoEscapeParameter(CallNode call) {
    exists(Object callable |
        call.getFunction().refersTo(callable) |
        callable = jinja2EnvironmentOrTemplate() and
        result = call.getArgByName("autoescape")
    )
}

from CallNode call
where
not exists(call.getNode().getStarargs()) and
not exists(call.getNode().getKwargs()) and
(
    not exists(getAutoEscapeParameter(call)) and
    exists(Object env |
        call.getFunction().refersTo(env) and
        env = jinja2EnvironmentOrTemplate()
    )
    or
    exists(Object isFalse |
        getAutoEscapeParameter(call).refersTo(isFalse) and isFalse.booleanValue() = false
    )
)

select call, "Using jinja2 templates with autoescape=False can potentially allow XSS attacks."
