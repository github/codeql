/**
 * @name Redundant assignment
 * @description Assigning a variable to itself is useless and very likely indicates an error in the code.
 * @kind problem
 * @tags reliability
 *       useless-code
 *       external/cwe/cwe-563
 * @problem.severity error
 * @sub-severity low
 * @precision very-high
 * @id py/redundant-assignment
 */

import python

predicate assignment(AssignStmt a, Expr left, Expr right) {
  a.getATarget() = left and a.getValue() = right
}

predicate corresponding(Expr left, Expr right) {
  assignment(_, left, right)
  or
  exists(Attribute la, Attribute ra |
    corresponding(la, ra) and
    left = la.getObject() and
    right = ra.getObject()
  )
}

predicate same_value(Expr left, Expr right) {
  same_name(left, right)
  or
  same_attribute(left, right)
}

predicate maybe_defined_in_outer_scope(Name n) {
  exists(SsaVariable v | v.getAUse().getNode() = n | v.maybeUndefined())
}

/*
 * Protection against FPs in projects that offer compatibility between Python 2 and 3,
 * since many of them make assignments such as
 *
 * if PY2:
 *     bytes = str
 * else:
 *     bytes = bytes
 */

predicate isBuiltin(string name) { exists(Value v | v = Value::named(name) and v.isBuiltin()) }

predicate same_name(Name n1, Name n2) {
  corresponding(n1, n2) and
  n1.getVariable() = n2.getVariable() and
  not isBuiltin(n1.getId()) and
  not maybe_defined_in_outer_scope(n2)
}

ClassValue value_type(Attribute a) { a.getObject().pointsTo().getClass() = result }

predicate is_property_access(Attribute a) {
  value_type(a).lookup(a.getName()) instanceof PropertyValue
}

predicate same_attribute(Attribute a1, Attribute a2) {
  corresponding(a1, a2) and
  a1.getName() = a2.getName() and
  same_value(a1.getObject(), a2.getObject()) and
  exists(value_type(a1)) and
  not is_property_access(a1)
}

pragma[nomagic]
Comment pyflakes_comment() { result.getText().toLowerCase().matches("%pyflakes%") }

int pyflakes_commented_line(File file) {
  pyflakes_comment().getLocation().hasLocationInfo(file.getAbsolutePath(), result, _, _, _)
}

predicate pyflakes_commented(AssignStmt assignment) {
  exists(Location loc |
    assignment.getLocation() = loc and
    loc.getStartLine() = pyflakes_commented_line(loc.getFile())
  )
}

predicate side_effecting_lhs(Attribute lhs) {
  exists(ClassValue cls, ClassValue decl |
    lhs.getObject().pointsTo().getClass() = cls and
    decl = cls.getASuperType() and
    not decl.isBuiltin()
  |
    decl.declaresAttribute("__setattr__")
  )
}

from AssignStmt a, Expr left, Expr right
where
  assignment(a, left, right) and
  same_value(left, right) and
  // some people use self-assignment to shut Pyflakes up, such as `ok = ok # Pyflakes`
  not pyflakes_commented(a) and
  not side_effecting_lhs(left)
select a, "This assignment assigns a variable to itself."
