/** Provides predicates for reasoning about uses of `import *` in Python. */

private import python
private import semmle.python.dataflow.new.internal.Builtins

cached
module ImportStar {
  /**
   * Holds if `n` is an access of a variable called `name` (which is _not_ the name of a
   * built-in, and which is _not_ a global defined in the enclosing module) inside the scope `s`.
   */
  cached
  predicate namePossiblyDefinedInImportStar(NameNode n, string name, Scope s) {
    n.isLoad() and
    name = n.getId() and
    s = n.getScope().getEnclosingScope*() and
    exists(potentialImportStarBase(s)) and
    // Not already defined in an enclosing scope.
    not isDefinedLocally(n.getNode())
  }

  /** Holds if `n` refers to a variable that is defined in the module in which it occurs. */
  cached
  private predicate isDefinedLocally(Name n) {
    // Defined in an enclosing scope
    enclosing_scope_defines_name(n.getScope(), n.getId())
    or
    // Defined as a built-in
    n.getId() = Builtins::getBuiltinName()
    or
    // Defined as a global in this module
    globalNameDefinedInModule(n.getId(), n.getEnclosingModule())
    or
    // A non-built-in that still has file-specific meaning
    n.getId() in ["__name__", "__package__"]
  }

  pragma[nomagic]
  private predicate enclosing_scope_defines_name(Scope s, string name) {
    exists(LocalVariable v |
      v.getId() = name and v.getScope() = s and not name = Builtins::getBuiltinName()
    )
    or
    enclosing_scope_defines_name(s.getEnclosingScope(), name)
  }

  /** Holds if a global variable called `name` is assigned a value in the module `m`. */
  cached
  predicate globalNameDefinedInModule(string name, Module m) {
    exists(NameNode n |
      not exists(LocalVariable v | n.defines(v)) and
      n.isStore() and
      name = n.getId() and
      m = n.getEnclosingModule()
    )
  }

  /**
   * Holds if `n` may refer to a global variable of the same name in the module `m`, accessible
   *  from the scope of `n` by a chain of `import *` imports.
   */
  cached
  predicate importStarResolvesTo(NameNode n, Module m) {
    m = getStarImported+(n.getEnclosingModule()) and
    globalNameDefinedInModule(n.getId(), m) and
    not isDefinedLocally(n.getNode())
  }

  /**
   * Gets a module that is imported from `m` via `import *`.
   */
  cached
  Module getStarImported(Module m) {
    exists(ImportStar i |
      i.getScope() = m and result = i.getModule().pointsTo().(ModuleValue).getScope()
    )
  }

  /**
   * Gets the data-flow node for a module imported with `from ... import *` inside the scope `s`.
   *
   * For example, given
   *
   * ```python
   * from foo.bar import *
   * from quux import *
   * ```
   *
   * this would return the data-flow nodes corresponding to `foo.bar` and `quux`.
   */
  cached
  ControlFlowNode potentialImportStarBase(Scope s) {
    result = any(ImportStarNode n | n.getScope() = s).getModule()
  }
}
