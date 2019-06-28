/** Provides classes and predicates for determining the uses and definitions of 
 * variables for ESSA form.
 */

import python
private import semmle.python.pointsto.Base


/* Classification of variables. These should be non-overlapping and complete.
 *
 * Function local variables - Non escaping variables in a function, except 'self'
 * Self variables - The 'self' variable for a method.
 * Class local variables - Local variables declared in a class
 * Non-local variables - Escaping variables in a function
 * Built-in variables - Global variables with no definition
 * Non-escaping globals -- Global variables that have definitions and all of those definitions are in the module scope
 * Escaping globals -- Global variables that have definitions and at least one of those definitions is in another scope.
 */

/** Python specific version of `SsaSourceVariable`. */
abstract class PythonSsaSourceVariable extends SsaSourceVariable {

    PythonSsaSourceVariable() {
        /* Exclude `True`, `False` and `None` */
        not this.(Variable).getALoad() instanceof NameConstant
    }

    override string getName() {
        variable(this, _, result)
    }

    Scope getScope() {
        variable(this, result, _)
    }

    abstract ControlFlowNode getAnImplicitUse();

    abstract ControlFlowNode getScopeEntryDefinition();

    override ControlFlowNode getAUse() {
        result = this.getASourceUse()
        or
        result = this.getAnImplicitUse()
        or
        /* `import *` is a definition of *all* variables, so must be a use as well, for pass-through
         * once we have established that a variable is not redefined.
         */
        SsaSource::import_star_refinement(this, result, _)
        or
        /* Add a use at the end of scope for all variables to keep them live 
         * This is necessary for taint-tracking.
         */
        result = this.getScope().getANormalExit()
    }

    override predicate hasDefiningNode(ControlFlowNode def) {
        def = this.getScopeEntryDefinition()
        or
        SsaSource::assignment_definition(this, def, _)
        or
        SsaSource::multi_assignment_definition(this, def, _, _)
        or
        SsaSource::deletion_definition(this, def)
        or
        SsaSource::init_module_submodule_defn(this, def)
        or
        SsaSource::parameter_definition(this, def)
        or
        SsaSource::exception_capture(this, def)
        or
        SsaSource::with_definition(this, def)
    }

    override predicate hasDefiningEdge(BasicBlock pred, BasicBlock succ) {
        none()
    }

    override predicate hasRefinement(ControlFlowNode use, ControlFlowNode def) {
        this.hasDefiningNode(_) and /* Can't have a refinement unless there is a definition */
        refinement(this, use, def)
    }

    override predicate hasRefinementEdge(ControlFlowNode use, BasicBlock pred, BasicBlock succ) {
        test_contains(pred.getLastNode(), use) and
        use.(NameNode).uses(this) and
        (pred.getAFalseSuccessor() = succ or pred.getATrueSuccessor() = succ) and
        /* There is a store to this variable -- We don't want to refine builtins */
        exists(this.(Variable).getAStore())
    }
    override ControlFlowNode getASourceUse() {
        result.(NameNode).uses(this)
        or
        result.(NameNode).deletes(this)
    }

    abstract CallNode redefinedAtCallSite();

}

class FunctionLocalVariable extends PythonSsaSourceVariable {

    FunctionLocalVariable() {
        this.(LocalVariable).getScope() instanceof Function and
        not this instanceof NonLocalVariable
    }

    override ControlFlowNode getAnImplicitUse() {
        this.(Variable).isSelf() and this.(Variable).getScope().getANormalExit() = result
    }

    override ControlFlowNode getScopeEntryDefinition() {
        exists(Scope s |
            s.getEntryNode() = result |
            s = this.(LocalVariable).getScope() and
            not this.(LocalVariable).isParameter()
            or
            s != this.(LocalVariable).getScope() and
            s = this.(LocalVariable).getALoad().getScope()
        )
    }

    override CallNode redefinedAtCallSite() { none() }

}

class NonLocalVariable extends PythonSsaSourceVariable {

    NonLocalVariable() {
        exists(Function f |
            this.(LocalVariable).getScope() = f and
            this.(LocalVariable).getAStore().getScope() != f
        )
    }

    override ControlFlowNode getAnImplicitUse() {
        result.(CallNode).getScope().getScope*() = this.(LocalVariable).getScope()
    }

    override ControlFlowNode getScopeEntryDefinition() {
        exists(Function f |
            f.getScope+() = this.(LocalVariable).getScope() and
            f.getEntryNode() = result
        )
        or
        not this.(LocalVariable).isParameter() and
        this.(LocalVariable).getScope().getEntryNode() = result
    }

    override CallNode redefinedAtCallSite() {
        result.getScope().getScope*() = this.(LocalVariable).getScope()
    }

}

class ClassLocalVariable extends PythonSsaSourceVariable {

    ClassLocalVariable() {
        this.(LocalVariable).getScope() instanceof Class
    }

    override ControlFlowNode getAnImplicitUse() {
        none()
    }

    override ControlFlowNode getScopeEntryDefinition() {
        result = this.(LocalVariable).getScope().getEntryNode()
    }

    override CallNode redefinedAtCallSite() { none() }

}

class BuiltinVariable extends PythonSsaSourceVariable {

    BuiltinVariable() {
        this instanceof GlobalVariable and 
        not exists(this.(Variable).getAStore()) and
        not this.(Variable).getId() = "__name__" and
        not this.(Variable).getId() = "__package__" and
        not exists(ImportStar is | is.getScope() = this.(Variable).getScope())
    }

    override ControlFlowNode getAnImplicitUse() {
        none()
    }

    override ControlFlowNode getScopeEntryDefinition() {
        none()
    }

    override CallNode redefinedAtCallSite() { none() }

}

class ModuleVariable extends PythonSsaSourceVariable {

    ModuleVariable() {
        this instanceof GlobalVariable and
        (
            exists(this.(Variable).getAStore())
            or
            this.(Variable).getId() = "__name__"
            or
            this.(Variable).getId() = "__package__"
            or
            exists(ImportStar is | is.getScope() = this.(Variable).getScope())
        )
    }

    override ControlFlowNode getAnImplicitUse() {
        result.getScope() = this.(GlobalVariable).getScope() and
        (
            result instanceof CallNode
            or
            import_from_dot_in_init(result.(ImportMemberNode).getModule(this.getName()))
        )
        or
        exists(ImportTimeScope scope |
            scope.entryEdge(result, _) |
            this = scope.getOuterVariable(_) or
            this.(Variable).getAUse().getScope() = scope
        )
        or
        /* For implicit use of __metaclass__ when constructing class */
        exists(Class c |
            class_with_global_metaclass(c, this) and
            c.(ImportTimeScope).entryEdge(result, _)
        )
        or
        exists(ImportTimeScope s |
            result = s.getANormalExit() and this.(Variable).getScope() = s and
            implicit_definition(this)
        )
    }

    override ControlFlowNode getScopeEntryDefinition() {
        exists(Scope s |
            s.getEntryNode() = result |
            /* Module entry point */
            this.(GlobalVariable).getScope() = s
            or
            /* For implicit use of __metaclass__ when constructing class */
            class_with_global_metaclass(s, this)
            or
            /* Variable is used in scope */
            this.(GlobalVariable).getAUse().getScope() = s
        )
        or
        exists(ImportTimeScope scope |
            scope.entryEdge(_, result) |
            this = scope.getOuterVariable(_) or
            this.(Variable).getAUse().getScope() = scope
        )
    }

    override CallNode redefinedAtCallSite() { none() }

}

class NonEscapingGlobalVariable extends ModuleVariable {

    NonEscapingGlobalVariable() {
        this instanceof GlobalVariable and
        exists(this.(Variable).getAStore()) and
        not variable_or_attribute_defined_out_of_scope(this)
    }

}

class EscapingGlobalVariable extends ModuleVariable {

    EscapingGlobalVariable() {
        this instanceof GlobalVariable and exists(this.(Variable).getAStore()) and variable_or_attribute_defined_out_of_scope(this)
    }

    override ControlFlowNode getAnImplicitUse() {
        result = ModuleVariable.super.getAnImplicitUse()
        or
        result.(CallNode).getScope().getScope+() = this.(GlobalVariable).getScope()
        or
        result = this.innerScope().getANormalExit()
    }

    private Scope innerScope() {
        result.getScope+() = this.(GlobalVariable).getScope() and
        not result instanceof ImportTimeScope
    }

    override ControlFlowNode getScopeEntryDefinition() {
        result = ModuleVariable.super.getScopeEntryDefinition()
        or
        result = this.innerScope().getEntryNode()
    }

    override CallNode redefinedAtCallSite() {
        result.(CallNode).getScope().getScope*() = this.(GlobalVariable).getScope()
    }

}

class EscapingAssignmentGlobalVariable extends EscapingGlobalVariable {

    EscapingAssignmentGlobalVariable() {
        exists(NameNode n | n.defines(this) and not n.getScope() = this.getScope())
    }

}


class SpecialSsaSourceVariable extends PythonSsaSourceVariable {

    SpecialSsaSourceVariable() {
        variable(this, _, "*") or variable(this, _, "$")
    }

    override ControlFlowNode getAnImplicitUse() {
        exists(ImportTimeScope s |
            result = s.getANormalExit() and this.getScope() = s
        )
    }

    override ControlFlowNode getScopeEntryDefinition() {
        /* Module entry point */
        this.getScope().getEntryNode() = result
    }

    override CallNode redefinedAtCallSite() {
        result.(CallNode).getScope().getScope*() = this.(GlobalVariable).getScope()
    }

}

private predicate variable_or_attribute_defined_out_of_scope(Variable v) {
    exists(NameNode n | n.defines(v) and not n.getScope() = v.getScope())
    or
    exists(AttrNode a | a.isStore() and a.getObject() = v.getAUse() and not a.getScope() = v.getScope())
}

private predicate class_with_global_metaclass(Class cls, GlobalVariable metaclass) {
    metaclass.getId() = "__metaclass__" and major_version() = 2 and
    cls.getEnclosingModule() = metaclass.getScope()
}


/** Holds if this variable is implicitly defined */
private predicate implicit_definition(Variable v) {
    v.getId() = "*" or v.getId() = "$"
    or
    exists(ImportStar is | is.getScope() = v.getScope())
}

cached module SsaSource {

    /** Holds if `v` is used as the receiver in a method call. */
    cached predicate method_call_refinement(Variable v, ControlFlowNode use, CallNode call) {
        use = v.getAUse() and
        call.getFunction().(AttrNode).getObject() = use and
        not test_contains(_, call)
    }

    /** Holds if `v` is defined by assignment at `defn` and given `value`. */
    cached predicate assignment_definition(Variable v, ControlFlowNode defn, ControlFlowNode value) {
        defn.(NameNode).defines(v) and defn.(DefinitionNode).getValue() = value
    }

    /** Holds if `v` is defined by assignment of the captured exception. */
    cached predicate exception_capture(Variable v, NameNode defn) {
        defn.defines(v) and
        exists(ExceptFlowNode ex | ex.getName() = defn)
    }

    /** Holds if `v` is defined by a with statement. */
    cached predicate with_definition(Variable v, ControlFlowNode defn) {
        exists(With with, Name var | 
            with.getOptionalVars() = var and
            var.getAFlowNode() = defn |
            var = v.getAStore()
        )
    }

    /** Holds if `v` is defined by multiple assignment at `defn`. */
    cached predicate multi_assignment_definition(Variable v, ControlFlowNode defn, int n, SequenceNode lhs) {
        defn.(NameNode).defines(v) and 
        not exists(defn.(DefinitionNode).getValue()) and
        lhs.getElement(n) = defn and
        lhs.getBasicBlock().dominates(defn.getBasicBlock())
    }

    /** Holds if `v` is defined by a `for` statement, the definition being `defn` */
    cached predicate iteration_defined_variable(Variable v, ControlFlowNode defn, ControlFlowNode sequence) {
        exists(ForNode for | for.iterates(defn, sequence)) and
        defn.(NameNode).defines(v)
    }

    /** Holds if `v` is a parameter variable and `defn` is the CFG node for that parameter. */
    cached predicate parameter_definition(Variable v, ControlFlowNode defn) {
        exists(Function f, Name param |
            f.getAnArg() = param or
            f.getVararg() = param or
            f.getKwarg() = param or
            f.getKeywordOnlyArg(_) = param |
            defn.getNode() = param and
            param.getVariable() = v
        )
    }

    /** Holds if `v` is deleted at `del`. */
    cached predicate deletion_definition(Variable v, DeletionNode del) {
        del.getTarget().(NameNode).deletes(v)
    }

    /** Holds if the name of `var` refers to a submodule of a package and `f` is the entry point
     * to the __init__ module of that package.
     */
    cached predicate init_module_submodule_defn(PythonSsaSourceVariable var, ControlFlowNode f) {
        var instanceof GlobalVariable and
        exists(Module init |
            init.isPackageInit() and exists(init.getPackage().getSubModule(var.getName())) and
            init.getEntryNode() = f and
            var.getScope() = init
        )
    }

    /** Holds if the `v` is in scope at a `from import ... *` and may thus be redefined by that statement */
    cached predicate import_star_refinement(PythonSsaSourceVariable v, ControlFlowNode use, ControlFlowNode def) {
        use = def and def instanceof ImportStarNode
        and
        (
            v.getScope() = def.getScope()
            or
            exists(NameNode other |
                other.uses(v) and
                def.getScope() = other.getScope()
            )
        )
    }

    /** Holds if an attribute is assigned at `def` and `use` is the use of `v` for that assignment */
    cached predicate attribute_assignment_refinement(Variable v, ControlFlowNode use, ControlFlowNode def) {
        use.(NameNode).uses(v) and
        def.isStore() and def.(AttrNode).getObject() = use
    }

    /** Holds if a `v` is used as an argument to `call`, which *may* modify the object referred to by `v` */
    cached predicate argument_refinement(Variable v, ControlFlowNode use, CallNode call) {
        use.(NameNode).uses(v) and
        call.getArg(0) = use and
        not method_call_refinement(v, _, call) and
        not test_contains(_, call)
    }

    /** Holds if an attribute is deleted  at `def` and `use` is the use of `v` for that deletion */
    cached predicate attribute_deletion_refinement(Variable v, NameNode use, DeletionNode def) {
        use.uses(v) and
        def.getTarget().(AttrNode).getObject() = use
    }

    /** Holds if the set of possible values for `v` is refined by `test` and `use` is the use of `v` in that test. */
    cached predicate test_refinement(Variable v, ControlFlowNode use, ControlFlowNode test) {
        use.(NameNode).uses(v) and
        test.getAChild*() = use and
        test.isBranch() and
        exists(BasicBlock block |
            block = use.getBasicBlock() and
            block = test.getBasicBlock() and
            not block.getLastNode() = test
        )
    }

}

private predicate refinement(PythonSsaSourceVariable v, ControlFlowNode use, ControlFlowNode def) {
    SsaSource::import_star_refinement(v, use, def)
    or
    SsaSource::attribute_assignment_refinement(v, use, def)
    or
    SsaSource::argument_refinement(v, use, def)
    or
    SsaSource::attribute_deletion_refinement(v, use, def)
    or
    SsaSource::test_refinement(v, use, def)
    or
    SsaSource::method_call_refinement(v, use, def)
    or
    def = v.redefinedAtCallSite() and def = use
}
