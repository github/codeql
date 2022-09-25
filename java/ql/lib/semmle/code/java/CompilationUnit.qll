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

  /**
   * Gets a type which is available in the top-level scope of this compilation unit.
   * This can be a type:
   * - declared in this compilation unit as top-level type
   * - imported with an `import` declaration
   * - declared in the same package as this compilation unit
   * - declared in the package `java.lang`
   *
   * This predicate not consider "shadowing", it can have types as result whose simple name is
   * shadowed by another type in scope.
   */
  ClassOrInterface getATypeInScope() {
    // See "Shadowing", https://docs.oracle.com/javase/specs/jls/se17/html/jls-6.html#jls-6.4.1
    // Currently shadowing is not considered
    result.(TopLevelType).getCompilationUnit() = this
    or
    exists(Import importDecl | importDecl.getCompilationUnit() = this |
      result =
        [
          importDecl.(ImportStaticTypeMember).getATypeImport(),
          importDecl.(ImportType).getImportedType(),
          importDecl.(ImportStaticOnDemand).getATypeImport(),
          importDecl.(ImportOnDemandFromType).getAnImport(),
          importDecl.(ImportOnDemandFromPackage).getAnImport(),
        ]
    )
    or
    // From same package or java.lang, see https://docs.oracle.com/javase/specs/jls/se17/html/jls-7.html
    result.(TopLevelType).getPackage() = this.getPackage()
    or
    result.(TopLevelType).getPackage().hasName("java.lang")
  }

  override string getAPrimaryQlClass() { result = "CompilationUnit" }
}
