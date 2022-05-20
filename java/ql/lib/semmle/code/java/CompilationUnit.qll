/**
 * Provides classes and predicates for working with Java compilation units.
 */

import Element
import Package
import semmle.code.FileSystem

/**
 * A compilation unit is a `.java` or `.class` file.
 */
class CompilationUnit extends Element, File {
  CompilationUnit() { cupackage(this, _) }

  /** Gets the name of the compilation unit (not including its extension). */
  override string getName() { result = Element.super.getName() }

  /**
   * Holds if this compilation unit has the specified `name`,
   * which must not include the file extension.
   */
  override predicate hasName(string name) { Element.super.hasName(name) }

  override string toString() { result = Element.super.toString() }

  /** Gets the declared package of this compilation unit. */
  Package getPackage() { cupackage(this, result) }

  /**
   * Gets the module associated with this compilation unit, if any.
   */
  Module getModule() { cumodule(this, result) }

  override string getAPrimaryQlClass() { result = "CompilationUnit" }
}
