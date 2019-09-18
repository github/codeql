import python


predicate comparison_using_is(Compare comp, ControlFlowNode left, Cmpop op, ControlFlowNode right) {
    exists(CompareNode fcomp | fcomp = comp.getAFlowNode() |
        fcomp.operands(left, op, right) and (op instanceof Is or op instanceof IsNot)
    )
}

predicate overrides_eq_or_cmp(ClassValue c) {
    major_version() = 2 and c.hasAttribute("__eq__")
    or
    c.declaresAttribute("__eq__") and not c = Value::named("object")
    or
    exists(ClassValue sup | 
        sup = c.getASuperType() and not sup = Value::named("object") |
        sup.declaresAttribute("__eq__")
    )
    or
    major_version() = 2 and c.hasAttribute("__cmp__")
}

predicate probablySingleton(ClassValue cls) {
    strictcount(Value inst | inst.getClass() = cls) = 1
    or
    cls = Value::named("None").getClass()
}

predicate invalid_to_use_is_portably(ClassValue c) {
    overrides_eq_or_cmp(c) and
    /* Exclude type/builtin-function/bool as it is legitimate to compare them using 'is' but they implement __eq__ */
    not c = Value::named("type") and not c = ClassValue::builtinFunction() and not c = Value::named("bool") and
    /* OK to compare with 'is' if a singleton */
    not probablySingleton(c)
}

predicate simple_constant(ControlFlowNode f) {
    exists(Object obj | f.refersTo(obj) |  obj = theTrueObject() or obj = theFalseObject() or obj = theNoneObject())
}

private predicate cpython_interned_value(Expr e) {
    exists(string text | text = e.(StrConst).getText() |
        text.length() = 0 or 
        text.length() = 1 and text.regexpMatch("[U+0000-U+00ff]")
    ) 
    or
    exists(int i | 
        i = e.(IntegerLiteral).getN().toInt() |
        -5 <= i and i <= 256
    )
    or
    exists(Tuple t | t = e and not exists(t.getAnElt()))
}

/** The set of values that can be expected to be interned across 
 * the main implementations of Python. PyPy, Jython, etc tend to
 * follow CPython, but it varies, so this is a best guess.
 */
private predicate universally_interned_value(Expr e) {
     e.(IntegerLiteral).getN().toInt() = 0
     or
     exists(Tuple t | t = e and not exists(t.getAnElt()))
     or
     e.(StrConst).getText() = ""
}

predicate cpython_interned_constant(Expr e) {
    exists(Expr const | 
        e.refersTo(_, const) | 
        cpython_interned_value(const)
    )
}

predicate universally_interned_constant(Expr e) {
    exists(Expr const | 
        e.refersTo(_, const) | 
        universally_interned_value(const)
    )
}

private predicate comparison_both_types(Compare comp, Cmpop op, ClassValue cls1, ClassValue cls2) {
    exists(ControlFlowNode op1, ControlFlowNode op2 |
        comparison_using_is(comp, op1, op, op2) or comparison_using_is(comp, op2, op, op1) |
        op1.inferredValue().getClass() = cls1 and
        op2.inferredValue().getClass() = cls2
    )
}

private predicate comparison_one_type(Compare comp, Cmpop op, ClassValue cls) {
    not comparison_both_types(comp, _, _, _) and
    exists(ControlFlowNode operand |
        comparison_using_is(comp, operand, op, _) or comparison_using_is(comp, _, op, operand) |
        operand.inferredValue().getClass() = cls 
    )
}

predicate invalid_portable_is_comparison(Compare comp, Cmpop op, ClassValue cls) {
    /* OK to use 'is' when defining '__eq__' */
    not exists(Function eq | eq.getName() = "__eq__" or eq.getName() = "__ne__" | eq = comp.getScope().getScope*())
    and
    (
        comparison_one_type(comp, op, cls) and invalid_to_use_is_portably(cls)
        or
        exists(ClassValue other | comparison_both_types(comp, op, cls, other) |
            invalid_to_use_is_portably(cls) and
            invalid_to_use_is_portably(other)
        )
    )
    and
    /* OK to use 'is' when comparing items from a known set of objects */
    not exists(Expr left, Expr right, Object obj |
        comp.compares(left, op, right) and
        exists(ImmutableLiteral il | il.getLiteralObject() = obj) |
        left.refersTo(obj) and right.refersTo(obj)
        or
        /* Simple constant in module, probably some sort of sentinel */
        exists(AstNode origin |
            not left.refersTo(_) and right.refersTo(obj, origin) and
            origin.getScope().getEnclosingModule() = comp.getScope().getEnclosingModule()
        )
    )
    and
    /* OK to use 'is' when comparing with a member of an enum */
    not exists(Expr left, Expr right, AstNode origin |
        comp.compares(left, op, right) and
        enum_member(origin) |
        left.refersTo(_, origin) or right.refersTo(_, origin)
    )
}

private predicate enum_member(AstNode obj) {
    exists(ClassValue cls, AssignStmt asgn |
        cls.getASuperType().getName() = "Enum" |
        cls.getScope() = asgn.getScope() and
        asgn.getValue() = obj
    )
}

