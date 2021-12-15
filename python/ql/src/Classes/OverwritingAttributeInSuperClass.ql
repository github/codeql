/**
 * @name Overwriting attribute in super-class or sub-class
 * @description Assignment to self attribute overwrites attribute previously defined in subclass or superclass `__init__` method.
 * @kind problem
 * @tags reliability
 *       maintainability
 *       modularity
 * @problem.severity warning
 * @sub-severity low
 * @precision medium
 * @id py/overwritten-inherited-attribute
 */

import python

class InitCallStmt extends ExprStmt {
  InitCallStmt() {
    exists(Call call, Attribute attr | call = this.getValue() and attr = call.getFunc() |
      attr.getName() = "__init__"
    )
  }
}

predicate overwrites_which(Function subinit, AssignStmt write_attr, string which) {
  write_attr.getScope() = subinit and
  self_write_stmt(write_attr, _) and
  exists(Stmt top | top.contains(write_attr) or top = write_attr |
    (
      exists(int i, int j, InitCallStmt call | call.getScope() = subinit |
        i > j and top = subinit.getStmt(i) and call = subinit.getStmt(j) and which = "superclass"
      )
      or
      exists(int i, int j, InitCallStmt call | call.getScope() = subinit |
        i < j and top = subinit.getStmt(i) and call = subinit.getStmt(j) and which = "subclass"
      )
    )
  )
}

predicate self_write_stmt(Stmt s, string attr) {
  exists(Attribute a, Name self |
    self = a.getObject() and
    s.contains(a) and
    self.getId() = "self" and
    a.getCtx() instanceof Store and
    a.getName() = attr
  )
}

predicate both_assign_attribute(Stmt s1, Stmt s2, Function f1, Function f2) {
  exists(string name |
    s1.getScope() = f1 and
    s2.getScope() = f2 and
    self_write_stmt(s1, name) and
    self_write_stmt(s2, name)
  )
}

predicate attribute_overwritten(
  AssignStmt overwrites, AssignStmt overwritten, string name, string classtype, string classname
) {
  exists(
    FunctionObject superinit, FunctionObject subinit, ClassObject superclass, ClassObject subclass,
    AssignStmt subattr, AssignStmt superattr
  |
    (
      classtype = "superclass" and
      classname = superclass.getName() and
      overwrites = subattr and
      overwritten = superattr
      or
      classtype = "subclass" and
      classname = subclass.getName() and
      overwrites = superattr and
      overwritten = subattr
    ) and
    /* OK if overwritten in subclass and is a class attribute */
    (not exists(superclass.declaredAttribute(name)) or classtype = "subclass") and
    superclass.declaredAttribute("__init__") = superinit and
    subclass.declaredAttribute("__init__") = subinit and
    superclass = subclass.getASuperType() and
    overwrites_which(subinit.getFunction(), subattr, classtype) and
    both_assign_attribute(subattr, superattr, subinit.getFunction(), superinit.getFunction()) and
    self_write_stmt(superattr, name)
  )
}

from string classtype, AssignStmt overwrites, AssignStmt overwritten, string name, string classname
where attribute_overwritten(overwrites, overwritten, name, classtype, classname)
select overwrites,
  "Assignment overwrites attribute " + name + ", which was previously defined in " + classtype +
    " $@.", overwritten, classname
