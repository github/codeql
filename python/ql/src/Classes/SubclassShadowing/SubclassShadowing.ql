/**
 * @name Superclass attribute shadows subclass method
 * @description Defining an attribute in a superclass method with a name that matches a subclass
 *              method, hides the method in the subclass.
 * @kind problem
 * @problem.severity error
 * @tags quality
 *       reliability
 *       correctness
 * @sub-severity low
 * @precision high
 * @id py/attribute-shadows-method
 */

import python
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.internal.DataFlowDispatch

predicate isSettableProperty(Function prop) {
  isProperty(prop) and
  exists(Function setter |
    setter.getScope() = prop.getScope() and
    setter.getName() = prop.getName() and
    isSetter(setter)
  )
}

predicate isSetter(Function f) {
  exists(DataFlow::AttrRead attr |
    f.getADecorator() = attr.asExpr() and
    attr.getAttributeName() = "setter"
  )
}

predicate isProperty(Function prop) {
  prop.getADecorator() = API::builtin("property").asSource().asExpr()
}

predicate shadowedBySuperclass(
  Class cls, Class superclass, DataFlow::AttrWrite write, Function shadowed
) {
  getADirectSuperclass+(cls) = superclass and
  shadowed = cls.getAMethod() and
  exists(Function init |
    init = superclass.getInitMethod() and
    DataFlow::parameterNode(init.getArg(0)).(DataFlow::LocalSourceNode).flowsTo(write.getObject()) and
    write.getAttributeName() = shadowed.getName()
  ) and
  // Allow cases in which the super class defines the method as well.
  // We assume that the original method must have been defined for a reason.
  not exists(Function superShadowed |
    superShadowed = superclass.getAMethod() and
    superShadowed.getName() = shadowed.getName()
  ) and
  // Allow properties if they have setters, as the write in the superclass will call the setter.
  not isSettableProperty(shadowed) and
  not isSetter(shadowed)
}

from Class cls, Class superclass, DataFlow::AttrWrite write, Function shadowed, string extra
where
  shadowedBySuperclass(cls, superclass, write, shadowed) and
  (
    if isProperty(shadowed)
    then
      // it's not a setter, so it's a read-only property
      extra = " (read-only property may cause an error if written to in the superclass)"
    else extra = ""
  )
select shadowed, "This method is shadowed by $@ in superclass $@." + extra, write,
  "attribute " + write.getAttributeName(), superclass, superclass.getName()
