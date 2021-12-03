/**
 * @name Conflicting attributes in base classes
 * @description When a class subclasses multiple base classes and more than one base class defines the same attribute, attribute overriding may result in unexpected behavior by instances of this class.
 * @kind problem
 * @tags reliability
 *       maintainability
 *       modularity
 * @problem.severity warning
 * @sub-severity low
 * @precision high
 * @id py/conflicting-attributes
 */

import python

predicate does_nothing(PyFunctionObject f) {
  not exists(Stmt s | s.getScope() = f.getFunction() |
    not s instanceof Pass and not s.(ExprStmt).getValue() = f.getFunction().getDocString()
  )
}

/* If a method performs a super() call then it is OK as the 'overridden' method will get called */
predicate calls_super(FunctionObject f) {
  exists(Call sup, Call meth, Attribute attr, GlobalVariable v |
    meth.getScope() = f.getFunction() and
    meth.getFunc() = attr and
    attr.getObject() = sup and
    attr.getName() = f.getName() and
    sup.getFunc() = v.getAnAccess() and
    v.getId() = "super"
  )
}

/** Holds if the given name is allowed for some reason */
predicate allowed(string name) {
  /*
   * The standard library specifically recommends this :(
   * See https://docs.python.org/3/library/socketserver.html#asynchronous-mixins
   */

  name = "process_request"
}

from
  ClassObject c, ClassObject b1, ClassObject b2, string name, int i1, int i2, Object o1, Object o2
where
  c.getBaseType(i1) = b1 and
  c.getBaseType(i2) = b2 and
  i1 < i2 and
  o1 != o2 and
  o1 = b1.lookupAttribute(name) and
  o2 = b2.lookupAttribute(name) and
  not name.matches("\\_\\_%\\_\\_") and
  not calls_super(o1) and
  not does_nothing(o2) and
  not allowed(name) and
  not o1.overrides(o2) and
  not o2.overrides(o1) and
  not c.declaresAttribute(name)
select c, "Base classes have conflicting values for attribute '" + name + "': $@ and $@.", o1,
  o1.toString(), o2, o2.toString()
