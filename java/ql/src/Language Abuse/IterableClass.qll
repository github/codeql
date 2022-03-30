import java

/** A class that implements `java.lang.Iterable`. */
class Iterable extends Class {
  Iterable() {
    isSourceDeclaration() and
    getASourceSupertype+().hasQualifiedName("java.lang", "Iterable")
  }

  /** The return value of a one-statement `iterator()` method. */
  Expr simpleIterator() {
    exists(Method m |
      m.getDeclaringType().getSourceDeclaration() = this and
      m.getName() = "iterator" and
      m.getBody().(SingletonBlock).getStmt().(ReturnStmt).getResult() = result
    )
  }
}
