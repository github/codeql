/**
 * @name Useless class
 * @description Class only defines one public method (apart from __init__ or __new__) and should be replaced by a function
 * @kind problem
 * @tags maintainability
 *       useless-code
 * @problem.severity recommendation
 * @sub-severity low
 * @precision medium
 * @id py/useless-class
 */

import python

predicate fewer_than_two_public_methods(Class cls, int methods) {
  (methods = 0 or methods = 1) and
  methods = count(Function f | f = cls.getAMethod() and not f = cls.getInitMethod())
}

predicate does_not_define_special_method(Class cls) {
  not exists(Function f | f = cls.getAMethod() and f.isSpecialMethod())
}

predicate no_inheritance(Class c) {
  not exists(ClassValue cls, ClassValue other |
    cls.getScope() = c and
    other != ClassValue::object()
  |
    other.getABaseType() = cls or
    cls.getABaseType() = other
  ) and
  not exists(Expr base | base = c.getABase() |
    not base instanceof Name or base.(Name).getId() != "object"
  )
}

predicate is_decorated(Class c) { exists(c.getADecorator()) }

predicate is_stateful(Class c) {
  exists(Function method, ExprContext ctx |
    method.getScope() = c and
    (ctx instanceof Store or ctx instanceof AugStore)
  |
    exists(Subscript s | s.getScope() = method and s.getCtx() = ctx)
    or
    exists(Attribute a | a.getScope() = method and a.getCtx() = ctx)
  )
  or
  exists(Function method, Call call, Attribute a, string name |
    method.getScope() = c and
    call.getScope() = method and
    call.getFunc() = a and
    a.getName() = name
  |
    name = "pop" or
    name = "remove" or
    name = "discard" or
    name = "extend" or
    name = "append"
  )
}

predicate useless_class(Class c, int methods) {
  c.isTopLevel() and
  c.isPublic() and
  no_inheritance(c) and
  fewer_than_two_public_methods(c, methods) and
  does_not_define_special_method(c) and
  not c.isProbableMixin() and
  not is_decorated(c) and
  not is_stateful(c)
}

from Class c, int methods, string msg
where
  useless_class(c, methods) and
  (
    methods = 1 and
    msg =
      "Class " + c.getName() +
        " defines only one public method, which should be replaced by a function."
    or
    methods = 0 and
    msg =
      "Class " + c.getName() +
        " defines no public methods and could be replaced with a namedtuple or dictionary."
  )
select c, msg
