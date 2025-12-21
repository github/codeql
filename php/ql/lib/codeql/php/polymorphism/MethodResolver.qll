/**
 * @name Method Resolution
 * @description Resolves method calls to implementations
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.polymorphism.ClassResolver

/**
 * A method call expression.
 */
class MethodCallExpr extends TS::PHP::MemberCallExpression {
  /** Gets the method name being called */
  string getMethodName() {
    result = this.getName().(TS::PHP::Name).getValue()
  }

  /** Gets the object expression */
  TS::PHP::AstNode getObjectExpr() {
    result = this.getObject()
  }
}

/**
 * A static method call expression.
 */
class StaticMethodCallExpr extends TS::PHP::ScopedCallExpression {
  /** Gets the method name being called */
  string getMethodName() {
    result = this.getName().(TS::PHP::Name).getValue()
  }

  /** Gets the class name or scope */
  string getScopeName() {
    result = this.getScope().(TS::PHP::Name).getValue() or
    result = this.getScope().(TS::PHP::QualifiedName).toString()
  }
}

/**
 * A method declaration.
 */
class MethodDecl extends TS::PHP::MethodDeclaration {
  /** Gets the method name */
  string getMethodName() {
    result = this.getName().(TS::PHP::Name).getValue()
  }

  /** Checks if this method is abstract */
  predicate isAbstract() {
    exists(TS::PHP::AbstractModifier m | m = this.getChild(_))
  }

  /** Checks if this method is final */
  predicate isFinal() {
    exists(TS::PHP::FinalModifier m | m = this.getChild(_))
  }

  /** Checks if this method is static */
  predicate isStatic() {
    exists(TS::PHP::StaticModifier m | m = this.getChild(_))
  }

  /** Checks if this method is public */
  predicate isPublic() {
    exists(TS::PHP::VisibilityModifier m |
      m = this.getChild(_) and
      m.toString() = "public"
    )
  }

  /** Checks if this method is protected */
  predicate isProtected() {
    exists(TS::PHP::VisibilityModifier m |
      m = this.getChild(_) and
      m.toString() = "protected"
    )
  }

  /** Checks if this method is private */
  predicate isPrivate() {
    exists(TS::PHP::VisibilityModifier m |
      m = this.getChild(_) and
      m.toString() = "private"
    )
  }

  /** Gets the return type if declared */
  string getReturnTypeName() {
    result = this.getReturnType().(TS::PHP::PrimitiveType).toString() or
    result = this.getReturnType().(TS::PHP::NamedType).getChild().(TS::PHP::Name).getValue()
  }

  /** Gets the number of parameters */
  int getParameterCount() {
    result = count(TS::PHP::SimpleParameter p | p = this.getParameters().(TS::PHP::FormalParameters).getChild(_))
  }
}

/**
 * Looks up a method in a class by name.
 */
MethodDecl lookupMethodInClass(PhpClassDecl c, string methodName) {
  result = c.getMethodByName(methodName)
}

/**
 * Checks if a method is overridden in subclasses.
 */
predicate isMethodOverridden(MethodDecl m) {
  exists(PhpClassDecl definingClass, PhpClassDecl subClass |
    definingClass.getAMethod() = m and
    isSubclassOf(subClass, definingClass) and
    exists(subClass.getMethodByName(m.getMethodName()))
  )
}

/**
 * Gets all methods that override a given method.
 */
MethodDecl getOverridingMethod(MethodDecl baseMethod) {
  exists(PhpClassDecl definingClass, PhpClassDecl subClass |
    definingClass.getAMethod() = baseMethod and
    isSubclassOf(subClass, definingClass) and
    result = subClass.getMethodByName(baseMethod.getMethodName())
  )
}
