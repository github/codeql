/**
 * Provides classes for working with Java modules.
 */

import CompilationUnit

/**
 * A module.
 */
class Module extends @module {
  Module() { modules(this, _) }

  /**
   * Gets the name of this module.
   */
  string getName() { modules(this, result) }

  /**
   * Holds if this module is an `open` module, that is,
   * it grants access _at run time_ to types in all its packages,
   * as if all packages had been exported.
   */
  predicate isOpen() { isOpen(this) }

  /**
   * Gets a directive of this module.
   */
  Directive getADirective() { directives(this, result) }

  /**
   * Gets a compilation unit associated with this module.
   */
  CompilationUnit getACompilationUnit() { cumodule(result, this) }

  /** Gets a textual representation of this module. */
  string toString() { modules(this, result) }
}

/**
 * A directive in a module declaration.
 */
abstract class Directive extends @directive {
  /** Gets a textual representation of this directive. */
  abstract string toString();
}

/**
 * A `requires` directive in a module declaration.
 */
class RequiresDirective extends Directive, @requires {
  RequiresDirective() { requires(this, _) }

  /**
   * Holds if this `requires` directive is `transitive`,
   * that is, any module that depends on this module
   * has an implicitly declared dependency on the
   * module specified in this `requires` directive.
   */
  predicate isTransitive() { isTransitive(this) }

  /**
   * Holds if this `requires` directive is `static`,
   * that is, the dependence specified by this `requires`
   * directive is only mandatory at compile time but
   * optional at run time.
   */
  predicate isStatic() { isStatic(this) }

  /**
   * Gets the module on which this module depends.
   */
  Module getTargetModule() { requires(this, result) }

  override string toString() {
    exists(string transitive, string static |
      (if isTransitive() then transitive = "transitive " else transitive = "") and
      (if isStatic() then static = "static " else static = "")
    |
      result = "requires " + transitive + static + getTargetModule() + ";"
    )
  }
}

/**
 * An `exports` directive in a module declaration.
 */
class ExportsDirective extends Directive, @exports {
  ExportsDirective() { exports(this, _) }

  /**
   * Gets the package exported by this `exports` directive.
   */
  Package getExportedPackage() { exports(this, result) }

  /**
   * Holds if this `exports` directive is qualified, that is,
   * it contains a `to` clause.
   *
   * For qualified `exports` directives, exported types and members
   * are accessible only to code in the specified modules.
   * For unqualified `exports` directives, they are accessible
   * to code in any module.
   */
  predicate isQualified() { exportsTo(this, _) }

  /**
   * Gets a module specified in the `to` clause of this
   * `exports` directive, if any.
   */
  Module getATargetModule() { exportsTo(this, result) }

  override string toString() {
    exists(string toClause |
      if isQualified()
      then toClause = (" to " + concat(getATargetModule().getName(), ", "))
      else toClause = ""
    |
      result = "exports " + getExportedPackage() + toClause + ";"
    )
  }
}

/**
 * An `opens` directive in a module declaration.
 */
class OpensDirective extends Directive, @opens {
  OpensDirective() { opens(this, _) }

  /**
   * Gets the package opened by this `opens` directive.
   */
  Package getOpenedPackage() { opens(this, result) }

  /**
   * Holds if this `opens` directive is qualified, that is,
   * it contains a `to` clause.
   *
   * For qualified `opens` directives, opened types and members
   * are accessible only to code in the specified modules.
   * For unqualified `opens` directives, they are accessible
   * to code in any module.
   */
  predicate isQualified() { opensTo(this, _) }

  /**
   * Gets a module specified in the `to` clause of this
   * `exports` directive, if any.
   */
  Module getATargetModule() { opensTo(this, result) }

  override string toString() {
    exists(string toClause |
      if isQualified()
      then toClause = (" to " + concat(getATargetModule().getName(), ", "))
      else toClause = ""
    |
      result = "opens " + getOpenedPackage() + toClause + ";"
    )
  }
}

/**
 * A `uses` directive in a module declaration.
 */
class UsesDirective extends Directive, @uses {
  UsesDirective() { uses(this, _) }

  /**
   * Gets the qualified name of the service interface specified in this `uses` directive.
   */
  string getServiceInterfaceName() { uses(this, result) }

  override string toString() { result = "uses " + getServiceInterfaceName() + ";" }
}

/**
 * A `provides` directive in a module declaration.
 */
class ProvidesDirective extends Directive, @provides {
  ProvidesDirective() { provides(this, _) }

  /**
   * Gets the qualified name of the service interface specified in this `provides` directive.
   */
  string getServiceInterfaceName() { provides(this, result) }

  /**
   * Gets the qualified name of a service implementation specified in this `provides` directive.
   */
  string getServiceImplementationName() { providesWith(this, result) }

  override string toString() {
    result =
      "provides " + getServiceInterfaceName() + " with " +
        concat(getServiceImplementationName(), ", ") + ";"
  }
}
