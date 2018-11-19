/**
 * @name Jinja2 templating with autoescape=False
 * @description Using jinja2 templates with autoescape=False can
 *              cause a cross-site scripting vulnerability.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id py/jinja2/autoescape-false
 * @tags security
 *       external/cwe/cwe-079
 */

import python

predicate jinja2Environment(Object callable, int autoescape) {
    exists(ModuleObject jinja2 |
        jinja2.getName() = "jinja2" |
        jinja2.getAttribute("Environment") = callable and
        callable.(ClassObject).getPyClass().getInitMethod().getArg(autoescape+1).asName().getId() = "autoescape"
        or
        exists(ModuleObject environment |
            environment.getAttribute("Template") = callable and
            callable.(ClassObject).lookupAttribute("__new__").(FunctionObject).getFunction().getArg(autoescape+1).asName().getId() = "autoescape"
        )
    )
}

ControlFlowNode getAutoEscapeParameter(CallNode call) {
    exists(Object callable |
        call.getFunction().refersTo(callable) |
        jinja2Environment(callable, _) and
        result = call.getArgByName("autoescape")
        or
        exists(int arg |
            jinja2Environment(callable, arg) and
            result = call.getArg(arg)
        )
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
        jinja2Environment(env, _)
    )
    or
    exists(Object isFalse |
      getAutoEscapeParameter(call).refersTo(isFalse) and isFalse.booleanValue() = false
    )
)
select call, "Using jinja2 templates with autoescape=False can potentially allow XSS attacks."
