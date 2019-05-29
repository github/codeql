import csharp

class DefaultInterfaceMethod extends Method {
  DefaultInterfaceMethod() {
    this.hasBody() and
    this.getDeclaringType() instanceof Interface
  }
}

query predicate defaultInterfaceMethods(DefaultInterfaceMethod m) { any() }
