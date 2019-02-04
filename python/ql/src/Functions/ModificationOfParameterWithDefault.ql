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
import semmle.python.security.Paths

predicate safe_method(string name) {
    name = "count" or name = "index" or name = "copy" or name =  "get"  or name = "has_key" or
    name = "items" or name = "keys" or name = "values" or name = "iteritems" or name = "iterkeys" or name = "itervalues"
}

predicate maybe_parameter(SsaVariable var, Function f, Parameter p) {
    p = var.getAnUltimateDefinition().getDefinition().getNode() and
    f.getAnArg() = p
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

class MutableValue extends TaintKind {
    MutableValue() {
        this = "mutable value"
    }
}

class MutableDefaultValue extends TaintSource {
    MutableDefaultValue() {
        has_mutable_default(this.(NameNode).getNode())
    }

    override string toString() {
        result = "mutable default value"
    }

    override predicate isSourceOf(TaintKind kind) {
        kind instanceof MutableValue
    }
}

class Mutation extends TaintSink {
    Mutation() {
        exists(AugAssign a | a.getTarget().getAFlowNode() = this)
        or
        exists(Call c, Attribute a |
            c.getFunc() = a |
            a.getObject().getAFlowNode() = this and
            not safe_method(a.getName())
        )
    }

    override predicate sinks(TaintKind kind) {
        kind instanceof MutableValue
    }
}

from TaintedPathSource src, TaintedPathSink sink
where src.flowsTo(sink)
select sink.getSink(), src, sink, "$@ flows to here and is mutated.", src.getSource(), "Default value"
