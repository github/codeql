/**
 * @name Class Resolution
 * @description Resolves class names and inheritance relationships
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS

/**
 * A PHP class declaration with extended analysis methods.
 */
class PhpClassDecl extends TS::PHP::ClassDeclaration {
  /** Gets the class name */
  string getClassName() {
    result = this.getName().getValue()
  }

  /** Gets the parent class name if this extends another class */
  string getParentClassName() {
    exists(TS::PHP::BaseClause base |
      base = this.getChild(_) and
      result = base.getChild(0).(TS::PHP::Name).getValue()
    )
  }

  /** Checks if this class extends another */
  predicate hasParent() {
    exists(TS::PHP::BaseClause base | base = this.getChild(_))
  }

  /** Gets a method defined in this class */
  TS::PHP::MethodDeclaration getAMethod() {
    result = this.getBody().getChild(_)
  }

  /** Gets a method by name */
  TS::PHP::MethodDeclaration getMethodByName(string name) {
    result = this.getAMethod() and
    result.getName().getValue() = name
  }

  /** Checks if this class is abstract */
  predicate isAbstract() {
    exists(TS::PHP::AbstractModifier m | m = this.getChild(_))
  }

  /** Checks if this class is final */
  predicate isFinal() {
    exists(TS::PHP::FinalModifier m | m = this.getChild(_))
  }
}

/**
 * A PHP interface declaration with extended analysis methods.
 */
class PhpInterfaceDecl extends TS::PHP::InterfaceDeclaration {
  /** Gets the interface name */
  string getInterfaceName() {
    result = this.getName().getValue()
  }

  /** Gets a method defined in this interface */
  TS::PHP::MethodDeclaration getAMethod() {
    result = this.getBody().getChild(_)
  }
}

/**
 * A PHP trait declaration with extended analysis methods.
 */
class PhpTraitDecl extends TS::PHP::TraitDeclaration {
  /** Gets the trait name */
  string getTraitName() {
    result = this.getName().getValue()
  }

  /** Gets a method defined in this trait */
  TS::PHP::MethodDeclaration getAMethod() {
    result = this.getBody().getChild(_)
  }
}

/**
 * Resolves a class name to its declaration.
 */
PhpClassDecl resolveClassName(string className) {
  result.getClassName() = className
}

/**
 * Gets the inheritance depth of a class.
 */
int getInheritanceDepth(PhpClassDecl c) {
  not c.hasParent() and result = 0 or
  c.hasParent() and
  exists(PhpClassDecl parent |
    parent.getClassName() = c.getParentClassName() and
    result = getInheritanceDepth(parent) + 1
  )
}

/**
 * Checks if one class is a subclass of another.
 */
predicate isSubclassOf(PhpClassDecl sub, PhpClassDecl sup) {
  sub.getParentClassName() = sup.getClassName() or
  exists(PhpClassDecl intermediate |
    sub.getParentClassName() = intermediate.getClassName() and
    isSubclassOf(intermediate, sup)
  )
}

/**
 * Gets the number of implemented interfaces for a class.
 */
int getImplementedInterfaceCount(PhpClassDecl c) {
  result = count(TS::PHP::ClassInterfaceClause clause | clause = c.getChild(_))
}
