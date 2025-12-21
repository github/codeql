/**
 * @name Magic Methods
 * @description Handles PHP magic methods (__call, __get, __set, etc.)
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.polymorphism.ClassResolver

/**
 * Checks if a method name is a magic method name.
 */
predicate isMagicMethodName(string name) {
  name in [
    "__call", "__callStatic", "__get", "__set", "__isset", "__unset",
    "__invoke", "__toString", "__debugInfo", "__set_state", "__clone",
    "__sleep", "__wakeup", "__serialize", "__unserialize",
    "__construct", "__destruct"
  ]
}

/**
 * A magic method declaration.
 */
class MagicMethod extends TS::PHP::MethodDeclaration {
  MagicMethod() {
    isMagicMethodName(this.getName().(TS::PHP::Name).getValue())
  }

  /** Gets the magic method type */
  string getMagicType() {
    result = this.getName().(TS::PHP::Name).getValue()
  }
}

/**
 * Checks if a class has a __call magic method.
 */
predicate hasCallMagic(PhpClassDecl c) {
  exists(c.getMethodByName("__call"))
}

/**
 * Checks if a class has a __callStatic magic method.
 */
predicate hasCallStaticMagic(PhpClassDecl c) {
  exists(c.getMethodByName("__callStatic"))
}

/**
 * Checks if a class has a __get magic method.
 */
predicate hasGetMagic(PhpClassDecl c) {
  exists(c.getMethodByName("__get"))
}

/**
 * Checks if a class has a __set magic method.
 */
predicate hasSetMagic(PhpClassDecl c) {
  exists(c.getMethodByName("__set"))
}

/**
 * Checks if a class has a __invoke magic method.
 */
predicate hasInvokeMagic(PhpClassDecl c) {
  exists(c.getMethodByName("__invoke"))
}

/**
 * Checks if a class has a __toString magic method.
 */
predicate hasToStringMagic(PhpClassDecl c) {
  exists(c.getMethodByName("__toString"))
}

/**
 * Checks if a class has a constructor.
 */
predicate hasConstructor(PhpClassDecl c) {
  exists(c.getMethodByName("__construct"))
}

/**
 * Checks if a class has a destructor.
 */
predicate hasDestructor(PhpClassDecl c) {
  exists(c.getMethodByName("__destruct"))
}

/**
 * Checks if a class acts as a proxy (has magic interceptors).
 */
predicate actsAsProxy(PhpClassDecl c) {
  hasCallMagic(c) or hasCallStaticMagic(c) or hasGetMagic(c) or hasSetMagic(c)
}

/**
 * Checks if an object can be invoked as a function.
 */
predicate isCallableObject(PhpClassDecl c) {
  hasInvokeMagic(c)
}

/**
 * Checks if an object can be converted to string.
 */
predicate isStringifiable(PhpClassDecl c) {
  hasToStringMagic(c)
}
