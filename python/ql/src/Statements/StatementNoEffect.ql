/**
 * @name Statement has no effect
 * @description A statement has no effect
 * @kind problem
 * @tags maintainability
 *       useless-code
 *       external/cwe/cwe-561
 * @problem.severity recommendation
 * @sub-severity high
 * @precision high
 * @id py/ineffectual-statement
 */

import python

predicate understood_attribute(Attribute attr, ClassValue cls, ClassValue attr_cls) {
  exists(string name | attr.getName() = name |
    attr.getObject().pointsTo().getClass() = cls and
    cls.attr(name).getClass() = attr_cls
  )
}

/* Conservative estimate of whether attribute lookup has a side effect */
predicate side_effecting_attribute(Attribute attr) {
  exists(ClassValue attr_cls |
    understood_attribute(attr, _, attr_cls) and
    side_effecting_descriptor_type(attr_cls)
  )
}

predicate maybe_side_effecting_attribute(Attribute attr) {
  not understood_attribute(attr, _, _) and not attr.pointsTo(_)
  or
  side_effecting_attribute(attr)
}

predicate side_effecting_descriptor_type(ClassValue descriptor) {
  descriptor.isDescriptorType() and
  // Technically all descriptor gets have side effects,
  // but some are indicative of a missing call and
  // we want to treat them as having no effect.
  not descriptor = ClassValue::functionType() and
  not descriptor = ClassValue::staticmethod() and
  not descriptor = ClassValue::classmethod()
}

/**
 * Side effecting binary operators are rare, so we assume they are not
 * side-effecting unless we know otherwise.
 */
predicate side_effecting_binary(Expr b) {
  exists(Expr sub, ClassValue cls, string method_name |
    binary_operator_special_method(b, sub, cls, method_name)
    or
    comparison_special_method(b, sub, cls, method_name)
  |
    method_name = special_method() and
    cls.hasAttribute(method_name) and
    not exists(ClassValue declaring |
      declaring.declaresAttribute(method_name) and
      declaring = cls.getASuperType() and
      declaring.isBuiltin() and
      not declaring = ClassValue::object()
    )
  )
}

pragma[nomagic]
private predicate binary_operator_special_method(
  BinaryExpr b, Expr sub, ClassValue cls, string method_name
) {
  method_name = special_method() and
  sub = b.getLeft() and
  method_name = b.getOp().getSpecialMethodName() and
  sub.pointsTo().getClass() = cls
}

pragma[nomagic]
private predicate comparison_special_method(Compare b, Expr sub, ClassValue cls, string method_name) {
  exists(Cmpop op |
    b.compares(sub, op, _) and
    method_name = op.getSpecialMethodName()
  ) and
  sub.pointsTo().getClass() = cls
}

private string special_method() {
  result = any(Cmpop c).getSpecialMethodName()
  or
  result = any(BinaryExpr b).getOp().getSpecialMethodName()
}

predicate is_notebook(File f) {
  exists(Comment c | c.getLocation().getFile() = f |
    c.getText().regexpMatch("#\\s*<nbformat>.+</nbformat>\\s*")
  )
}

/** Expression (statement) in a jupyter/ipython notebook */
predicate in_notebook(Expr e) { is_notebook(e.getScope().(Module).getFile()) }

FunctionValue assertRaises() {
  result = Value::named("unittest.TestCase").(ClassValue).lookup("assertRaises")
}

/** Holds if expression `e` is in a `with` block that tests for exceptions being raised. */
predicate in_raises_test(Expr e) {
  exists(With w |
    w.contains(e) and
    w.getContextExpr() = assertRaises().getACall().getNode()
  )
}

/** Holds if expression has the form of a Python 2 `print >> out, ...` statement */
predicate python2_print(Expr e) {
  e.(BinaryExpr).getLeft().(Name).getId() = "print" and
  e.(BinaryExpr).getOp() instanceof RShift
  or
  python2_print(e.(Tuple).getElt(0))
}

predicate no_effect(Expr e) {
  // strings can be used as comments
  not e instanceof StringLiteral and
  not e.hasSideEffects() and
  forall(Expr sub | sub = e.getASubExpression*() |
    not side_effecting_binary(sub) and
    not maybe_side_effecting_attribute(sub)
  ) and
  not in_notebook(e) and
  not in_raises_test(e) and
  not python2_print(e)
}

from ExprStmt stmt
where no_effect(stmt.getValue())
select stmt, "This statement has no effect."
