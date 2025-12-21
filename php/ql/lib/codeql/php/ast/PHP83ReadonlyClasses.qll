/**
 * @name PHP 8.2+ Readonly Classes
 * @description Analysis for readonly classes
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS

/**
 * A readonly class declaration.
 */
class ReadonlyClass extends TS::PHP::ClassDeclaration {
  ReadonlyClass() {
    exists(TS::PHP::ReadonlyModifier r | r = this.getChild(_))
  }

  /** Gets the class name */
  string getClassName() {
    result = this.getName().getValue()
  }
}

/**
 * Checks if a class is readonly.
 */
predicate isReadonlyClass(TS::PHP::ClassDeclaration c) {
  c instanceof ReadonlyClass
}
