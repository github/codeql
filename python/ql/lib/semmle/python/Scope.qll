import python
private import semmle.python.dataflow.new.internal.ImportResolution

/**
 * Gets a name exported by module `m`, that is the names that will be added to a namespace by 'from this-module import *'.
 *
 * This aims to be the same as m.getAnExport(), but without using the points-to machinery.
 */
private string getAModuleExport(Module m) {
  py_exports(m, result)
  or
  ImportResolution::module_export(m, result, _)
}

/**
 * A Scope. A scope is the lexical extent over which all identifiers with the same name refer to the same variable.
 * Modules, Classes and Functions are all Scopes. There are no other scopes.
 * The scopes for expressions that create new scopes, lambdas and comprehensions, are handled by creating an anonymous Function.
 */
class Scope extends Scope_ {
  Module getEnclosingModule() { result = this.getEnclosingScope().getEnclosingModule() }

  /**
   * Gets the scope enclosing this scope (modules have no enclosing scope).
   *
   * This method will be deprecated in the next release. Please use `getEnclosingScope()` instead.
   * The reason for this is to avoid confusion around use of `x.getScope+()` where `x` might be an
   * `AstNode` or a `Variable`. Forcing the users to write `x.getScope().getEnclosingScope*()` ensures that
   * the apparent semantics and the actual semantics coincide.
   */
  Scope getScope() { none() }

  /** Gets the scope enclosing this scope (modules have no enclosing scope) */
  Scope getEnclosingScope() { none() }

  /** Gets the statements forming the body of this scope */
  StmtList getBody() { none() }

  /** Gets the nth statement of this scope */
  Stmt getStmt(int n) { none() }

  /** Gets a top-level statement in this scope */
  Stmt getAStmt() { none() }

  Location getLocation() { none() }

  /** Gets the name of this scope */
  string getName() { py_strs(result, this, 0) }

  /** Gets the docstring for this scope */
  StringLiteral getDocString() { result = this.getStmt(0).(ExprStmt).getValue() }

  /** Gets the entry point into this Scope's control flow graph */
  ControlFlowNode getEntryNode() { py_scope_flow(result, this, -1) }

  /** Gets the non-explicit exit from this Scope's control flow graph */
  ControlFlowNode getFallthroughNode() { py_scope_flow(result, this, 0) }

  /** Gets the exit of this scope following from a return statement */
  ControlFlowNode getReturnNode() { py_scope_flow(result, this, 2) }

  /** Gets an exit from this Scope's control flow graph */
  ControlFlowNode getAnExitNode() { exists(int i | py_scope_flow(result, this, i) and i >= 0) }

  /**
   * Gets an exit from this Scope's control flow graph,
   * that does not result from an exception
   */
  ControlFlowNode getANormalExit() {
    result = this.getFallthroughNode()
    or
    result = this.getReturnNode()
  }

  /** Holds if this a top-level (non-nested) class or function */
  predicate isTopLevel() { this.getEnclosingModule() = this.getEnclosingScope() }

  /** Holds if this scope is deemed to be public */
  predicate isPublic() {
    /* Not inside a function */
    not this.getEnclosingScope() instanceof Function and
    /* Not implicitly private */
    this.getName().charAt(0) != "_" and
    (
      this instanceof Module
      or
      exists(Module m | m = this.getEnclosingScope() and m.isPublic() |
        // The module is implicitly exported
        not exists(getAModuleExport(m))
        or
        // The module is explicitly exported
        getAModuleExport(m) = this.getName()
      )
      or
      exists(Class c | c = this.getEnclosingScope() |
        this instanceof Function and
        c.isPublic()
      )
    )
  }

  predicate contains(AstNode a) {
    this.getBody().contains(a)
    or
    exists(Scope inner | inner.getEnclosingScope() = this | inner.contains(a))
  }

  /**
   * Holds if this scope can be expected to execute before `other`.
   * Modules precede functions and methods in those modules
   * `__init__` precedes other methods. `__enter__` precedes `__exit__`.
   * NOTE that this is context-insensitive, so a module "precedes" a function
   * in that module, even if that function is called from the module scope.
   */
  predicate precedes(Scope other) {
    exists(Function f, string name | f = other and name = f.getName() |
      if f.isMethod()
      then
        // The __init__ method is preceded by the enclosing module
        this = f.getEnclosingModule() and name = "__init__"
        or
        exists(Class c, string pred_name |
          // __init__ -> __enter__ -> __exit__
          // __init__ -> other-methods
          f.getScope() = c and
          (
            pred_name = "__init__" and not name = "__init__" and not name = "__exit__"
            or
            pred_name = "__enter__" and name = "__exit__"
          )
        |
          this.getScope() = c and
          pred_name = this.(Function).getName()
          or
          not exists(Function pre_func |
            pre_func.getName() = pred_name and
            pre_func.getScope() = c
          ) and
          this = other.getEnclosingModule()
        )
      else
        // Normal functions are preceded by the enclosing module
        this = f.getEnclosingModule()
    )
  }

  /**
   * Gets the evaluation scope for code in this (lexical) scope.
   * This is usually the scope itself, but may be an enclosing scope.
   * Notably, for list comprehensions in Python 2.
   */
  Scope getEvaluatingScope() { result = this }

  /**
   * Holds if this scope is in the source archive,
   * that is it is part of the code specified, not library code
   */
  predicate inSource() { exists(this.getEnclosingModule().getFile().getRelativePath()) }

  Stmt getLastStatement() { result = this.getBody().getLastItem().getLastStatement() }

  /** Whether this contains `inner` syntactically and `inner` has the same scope as `this` */
  predicate containsInScope(AstNode inner) {
    this.getBody().contains(inner) and
    this = inner.getScope()
  }
}
