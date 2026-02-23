/**
 * @name Wrong name for an argument in a class instantiation
 * @description Using a named argument whose name does not correspond to a
 *              parameter of the __init__ method of the class being
 *              instantiated, will result in a TypeError at runtime.
 * @kind problem
 * @tags quality
 *       reliability
 *       correctness
 *       external/cwe/cwe-628
 * @problem.severity error
 * @sub-severity low
 * @precision very-high
 * @id py/call/wrong-named-class-argument
 */

import python
private import semmle.python.dataflow.new.internal.DataFlowDispatch

/**
 * Holds if `name` is a legal argument name for calling `init`.
 */
bindingset[name]
predicate isLegalArgumentName(Function init, string name) {
  exists(init.getArgByName(name))
  or
  init.hasKwArg()
}

/**
 * Holds if `call` constructs class `cls` and passes a keyword argument `name`
 * that does not correspond to any parameter of `cls.__init__`.
 */
predicate illegally_named_parameter(Call call, Class cls, string name) {
  exists(Function init |
    resolveClassCall(call.getAFlowNode(), cls) and
    init = DuckTyping::getInit(cls) and
    name = call.getANamedArgumentName() and
    not isLegalArgumentName(init, name)
  )
}

from Call call, Class cls, string name, Function init
where
  illegally_named_parameter(call, cls, name) and
  init = DuckTyping::getInit(cls)
select call, "Keyword argument '" + name + "' is not a supported parameter name of $@.", init,
  init.getQualifiedName()
