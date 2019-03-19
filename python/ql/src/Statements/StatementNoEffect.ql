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

predicate understood_attribute(Attribute attr, ClassObject cls, ClassObject attr_cls) {
    exists(string name |
        attr.getName() = name |
        attr.getObject().refersTo(_, cls, _) and
        cls.attributeRefersTo(name, _, attr_cls, _)
    )
}

/* Conservative estimate of whether attribute lookup has a side effect */
predicate side_effecting_attribute(Attribute attr) {
    exists(ClassObject cls, ClassObject attr_cls |
        understood_attribute(attr, cls, attr_cls) and
        side_effecting_descriptor_type(attr_cls)
    )
}

predicate maybe_side_effecting_attribute(Attribute attr) {
    not understood_attribute(attr, _, _) and not attr.refersTo(_)
    or
    side_effecting_attribute(attr)
}

predicate side_effecting_descriptor_type(ClassObject descriptor) {
    descriptor.isDescriptorType() and
    /* Technically all descriptor gets have side effects, 
     * but some are indicative of a missing call and 
     * we want to treat them as having no effect. */
   not descriptor = thePyFunctionType() and
   not descriptor = theStaticMethodType() and
   not descriptor = theClassMethodType()
}

/** Side effecting binary operators are rare, so we assume they are not
 * side-effecting unless we know otherwise.
 */
predicate side_effecting_binary(Expr b) {
    exists(Expr sub, string method_name |
        sub = b.(BinaryExpr).getLeft() and
        method_name = b.(BinaryExpr).getOp().getSpecialMethodName()
        or
        exists(Cmpop op |
            b.(Compare).compares(sub, op, _) and
            method_name = op.getSpecialMethodName()
        )
        |
        exists(ClassObject cls |
            sub.refersTo(_, cls, _) and
            cls.hasAttribute(method_name)
            and
            not exists(ClassObject declaring |
                declaring.declaresAttribute(method_name)
                and declaring = cls.getAnImproperSuperType() and
                declaring.isBuiltin() and not declaring = theObjectType()
            )
        )
    )
}

predicate is_notebook(File f) {
    exists(Comment c |
        c.getLocation().getFile() = f |
        c.getText().regexpMatch("#\\s*<nbformat>.+</nbformat>\\s*")
    )
}

/** Expression (statement) in a jupyter/ipython notebook */
predicate in_notebook(Expr e) {
    is_notebook(e.getScope().(Module).getFile())
}

FunctionObject assertRaises() {
    result = ModuleObject::named("unittest").attr("TestCase").(ClassObject).lookupAttribute("assertRaises")
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
    not e instanceof StrConst and
    not ((StrConst)e).isDocString() and
    not e.hasSideEffects() and
    forall(Expr sub |
        sub = e.getASubExpression*()
        |
        not side_effecting_binary(sub)
        and
        not maybe_side_effecting_attribute(sub)
    ) and
    not in_notebook(e) and
    not in_raises_test(e) and
    not python2_print(e)
}

from ExprStmt stmt
where no_effect(stmt.getValue())
select stmt, "This statement has no effect."

