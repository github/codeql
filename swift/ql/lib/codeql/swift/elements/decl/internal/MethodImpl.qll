private import swift
private import codeql.swift.elements.decl.internal.FunctionImpl::Impl as FunctionImpl

module Impl {
  private Decl getAMember(Decl ctx) {
    ctx.getAMember() = result
    or
    exists(VarDecl var |
      ctx.getAMember() = var and
      var.getAnAccessor() = result
    )
  }

  /**
   * A function that is a member of a class, struct, enum or protocol.
   */
  class Method extends FunctionImpl::Function {
    Method() {
      this = getAMember(any(ClassDecl c))
      or
      this = getAMember(any(StructDecl c))
      or
      this = getAMember(any(ExtensionDecl c))
      or
      this = getAMember(any(EnumDecl c))
      or
      this = getAMember(any(ProtocolDecl c))
    }

    /**
     * Holds if this function is called `funcName` and is a member of a
     * class, struct, extension, enum or protocol called `typeName`.
     */
    cached
    predicate hasQualifiedName(string typeName, string funcName) {
      this.getName() = funcName and
      exists(Decl d |
        d.asNominalTypeDecl().getFullName() = typeName and
        d.getAMember() = this
      )
    }

    /**
     * Holds if this function is called `funcName` and is a member of a
     * class, struct, extension, enum or protocol called `typeName` in a module
     * called `moduleName`.
     */
    predicate hasQualifiedName(string moduleName, string typeName, string funcName) {
      this.hasQualifiedName(typeName, funcName) and
      this.getModule().getFullName() = moduleName
    }

    /**
     * Holds if this function is a `static` or `class` method, as opposed to an instance method.
     */
    predicate isStaticOrClassMethod() { this.getSelfParam().getType() instanceof MetatypeType }

    /**
     * Holds if this function is an instance method, as opposed to a `static` or `class` method.
     */
    predicate isInstanceMethod() { not this.isStaticOrClassMethod() }
  }
}
