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
   * Gets a type which is available by its simple name in this compilation unit.
   * Reasons for this can be:
   * - The type is declared in this compilation unit as top-level type
   * - The type is imported
   * - The type is declared in the same package as this compilation unit
   * - The type is declared in the package `java.lang`
   */
  ClassOrInterface getATypeAvailableBySimpleName() {
    // See "Shadowing", https://docs.oracle.com/javase/specs/jls/se17/html/jls-6.html#jls-6.4.1
    // Note: Currently the logic below does not consider shadowing and might have multiple results
    // with the same type name
    result.(TopLevelType).getCompilationUnit() = this
    or
    exists(ImportStaticTypeMember importDecl |
      importDecl.getCompilationUnit() = this and
      result = importDecl.getATypeImport()
    )
    or
    exists(ImportType importDecl |
      importDecl.getCompilationUnit() = this and
      result = importDecl.getImportedType()
    )
    or
    exists(ImportStaticOnDemand importDecl |
      importDecl.getCompilationUnit() = this and
      result = importDecl.getATypeImport()
    )
    or
    exists(ImportOnDemandFromType importDecl |
      importDecl.getCompilationUnit() = this and
      result = importDecl.getAnImport()
    )
    or
    exists(ImportOnDemandFromPackage importDecl |
      importDecl.getCompilationUnit() = this and
      result = importDecl.getAnImport()
    )
    or
    // From same package or java.lang, see https://docs.oracle.com/javase/specs/jls/se17/html/jls-7.html
    result.(TopLevelType).getPackage() = this.getPackage()
    or
    result.(TopLevelType).getPackage().hasName("java.lang")
  }

  override string getAPrimaryQlClass() { result = "CompilationUnit" }
}
