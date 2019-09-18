/** Provides generic utility classes. */

import csharp

/** A `Main` method. */
class MainMethod extends Method {
  MainMethod() {
    this.hasName("Main") and
    this.isStatic() and
    (this.getReturnType() instanceof VoidType or this.getReturnType() instanceof IntType) and
    if this.getNumberOfParameters() = 1
    then this.getParameter(0).getType().(ArrayType).getElementType() instanceof StringType
    else this.getNumberOfParameters() = 0
  }
}
