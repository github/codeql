/**
 * Provides classes for working with various JavaScript linters.
 */

import javascript

module Linting {
  /**
   * A linter directive that declares one or more global variables.
   */
  abstract class GlobalDeclaration extends Locatable {
    /**
     * Holds if `name` is a global variable declared by this directive, with
     * `writable` indicating whether the variable is declared to be writable or not.
     */
    abstract predicate declaresGlobal(string name, boolean writable);

    /**
     * Holds if this directive applies to statement or expression `s`, meaning that
     * `s` is nested in the directive's scope.
     */
    abstract predicate appliesTo(ExprOrStmt s);

    /**
     * Holds if this directive applies to `gva` and declares the variable it references.
     */
    predicate declaresGlobalForAccess(GlobalVarAccess gva) {
      appliesTo(gva) and declaresGlobal(gva.getName(), _)
    }
  }
}
