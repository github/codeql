/**
 * @name Modification of parameter with default
 * @description Modifying the default value of a parameter can lead to unexpected
 *              results.
 * @kind problem
 * @tags reliability
 *       maintainability
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/modification-of-default-value
 */

import python

predicate safe_method(string name) {
    name = "count" or name = "index" or name = "copy" or name =  "get"  or name = "has_key" or
    name = "items" or name = "keys" or name = "values" or name = "iteritems" or name = "iterkeys" or name = "itervalues"
}

predicate maybe_parameter(SsaVariable var, Function f, Parameter p) {
    p = var.getAnUltimateDefinition().getDefinition().getNode() and
    f.getAnArg() = p
}

Name use_of_parameter(Parameter p) {
    exists(SsaVariable var |
        p = var.getAnUltimateDefinition().getDefinition().getNode() and
        var.getAUse().getNode() = result
    )
}

predicate modifying_call(Call c, Parameter p) {
    exists(Attribute a |
        c.getFunc() = a |
        a.getObject() = use_of_parameter(p) and
        not safe_method(a.getName())
    )
}

predicate is_modification(AstNode a, Parameter p) {
    modifying_call(a, p)
    or
    a.(AugAssign).getTarget() = use_of_parameter(p)
}

predicate has_mutable_default(Parameter p) {
    exists(SsaVariable v, FunctionExpr f | maybe_parameter(v, f.getInnerScope(), p) and
        exists(int i, int def_cnt, int arg_cnt |
            def_cnt = count(f.getArgs().getADefault()) and
            arg_cnt = count(f.getInnerScope().getAnArg()) and
            i in [1 .. arg_cnt] and
           (f.getArgs().getDefault(def_cnt - i) instanceof Dict or f.getArgs().getDefault(def_cnt - i) instanceof List) and
            f.getInnerScope().getArgName(arg_cnt - i) = v.getId()
        )
    )
}

from AstNode a, Parameter p
where has_mutable_default(p) and is_modification(a, p)
select a, "Modification of parameter $@, which has mutable default value.", p, p.asName().getId()
