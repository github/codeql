import python

// Helper predicates for multiple call to __init__/__del__ queries.
pragma[noinline]
private predicate multiple_invocation_paths_helper(
  FunctionInvocation top, FunctionInvocation i1, FunctionInvocation i2, FunctionObject multi
) {
  i1 != i2 and
  i1 = top.getACallee+() and
  i2 = top.getACallee+() and
  i1.getFunction() = multi
}

pragma[noinline]
private predicate multiple_invocation_paths(
  FunctionInvocation top, FunctionInvocation i1, FunctionInvocation i2, FunctionObject multi
) {
  multiple_invocation_paths_helper(top, i1, i2, multi) and
  i2.getFunction() = multi
}

/** Holds if `self.name` calls `multi` by multiple paths, and thus calls it more than once. */
predicate multiple_calls_to_superclass_method(ClassObject self, FunctionObject multi, string name) {
  exists(FunctionInvocation top, FunctionInvocation i1, FunctionInvocation i2 |
    multiple_invocation_paths(top, i1, i2, multi) and
    top.runtime(self.declaredAttribute(name)) and
    self.getASuperType().declaredAttribute(name) = multi
  |
    // Only called twice if called from different functions,
    // or if one call-site can reach the other.
    i1.getCall().getScope() != i2.getCall().getScope()
    or
    i1.getCall().strictlyReaches(i2.getCall())
  )
}

/** Holds if all attributes called `name` can be inferred to be methods. */
private predicate named_attributes_not_method(ClassObject cls, string name) {
  cls.declaresAttribute(name) and not cls.declaredAttribute(name) instanceof FunctionObject
}

/** Holds if `f` actually does something. */
private predicate does_something(FunctionObject f) {
  f.isBuiltin() and not f = theObjectType().lookupAttribute("__init__")
  or
  exists(Stmt s | s = f.getFunction().getAStmt() and not s instanceof Pass)
}

/** Holds if `meth` looks like it should have a call to `name`, but does not */
private predicate missing_call(FunctionObject meth, string name) {
  exists(CallNode call, AttrNode attr |
    call.getScope() = meth.getFunction() and
    call.getFunction() = attr and
    attr.getName() = name and
    not exists(FunctionObject f | f.getACall() = call)
  )
}

/** Holds if `self.name` does not call `missing`, even though it is expected to. */
predicate missing_call_to_superclass_method(
  ClassObject self, FunctionObject top, FunctionObject missing, string name
) {
  missing = self.getASuperType().declaredAttribute(name) and
  top = self.lookupAttribute(name) and
  /* There is no call to missing originating from top */
  not top.getACallee*() = missing and
  /* Make sure that all named 'methods' are objects that we can understand. */
  not exists(ClassObject sup |
    sup = self.getAnImproperSuperType() and
    named_attributes_not_method(sup, name)
  ) and
  not self.isAbstract() and
  does_something(missing) and
  not missing_call(top, name)
}
