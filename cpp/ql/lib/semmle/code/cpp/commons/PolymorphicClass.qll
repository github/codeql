import cpp

/**
 * A C++ class or structure which (possibly by inheritance) has at least one virtual method.
 */
class PolymorphicClass extends Class {
  PolymorphicClass() {
    exists(MemberFunction f | this.getABaseClass*() = f.getDeclaringType() and f.isVirtual())
  }
}
