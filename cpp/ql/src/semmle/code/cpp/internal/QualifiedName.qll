private import semmle.code.cpp.internal.ResolveClass as ResolveClass

class Namespace extends @namespace {
  string toString() { result = "QualifiedName Namespace" }

  string getName() { namespaces(this, result) }

  string getQualifiedName() {
    if namespacembrs(_, this)
    then exists(Namespace ns |
                namespacembrs(ns, this) and
                result = ns.getQualifiedName() + "::" + this.getName())
    else result = this.getName()
  }

  Declaration getADeclaration() {
    if this.getName() = ""
    then result.isTopLevel() and not namespacembrs(_, result)
    else namespacembrs(this, result)
  }
}

abstract class Declaration extends @declaration {
  string toString() { result = "QualifiedName Declaration" }

  /** Gets the name of this declaration. */
  abstract string getName();

  // Note: This is not as full featured as the getNamespace in the AST,
  // but it covers the cases we need here.
  Namespace getNamespace() {
    // Top level declaration in a namespace ...
    result.getADeclaration() = this
    // ... or nested in another structure.
    or
    exists (Declaration m
    | m = this and result = m.getDeclaringType().getNamespace())
  }

  string getQualifiedName() {
    // MemberFunction, MemberVariable, MemberType
    exists (Declaration m
    | m = this and
      result = m.getDeclaringType().getQualifiedName() + "::" + m.getName())
    or
    exists (EnumConstant c
    | c = this and
      result = c.getDeclaringEnum().getQualifiedName() + "::" + c.getName())
    or
    exists (GlobalOrNamespaceVariable v, string s1, string s2
    | v = this and
      s2 = v.getNamespace().getQualifiedName() and
      s1 = v.getName()
    | (s2 != "" and result = s2 + "::" + s1) or (s2 = "" and result = s1))
    or
    exists (Function f, string s1, string s2
    | f = this and f.isTopLevel() and
      s2 = f.getNamespace().getQualifiedName() and
      s1 = f.getName()
    | (s2 != "" and result = s2 + "::" + s1) or (s2 = "" and result = s1))
    or
    exists (UserType t, string s1, string s2
    | t = this and t.isTopLevel() and
      s2 = t.getNamespace().getQualifiedName() and
      s1 = t.getName()
    | (s2 != "" and result = s2 + "::" + s1) or (s2 = "" and result = s1))
  }

  predicate isTopLevel() {
    not (this.isMember() or
         this instanceof FriendDecl or
         this instanceof EnumConstant or
         this instanceof Parameter or
         this instanceof ProxyClass or
         this instanceof LocalVariable or
         this instanceof TemplateParameter or
         this.(UserType).isLocal())
  }

  /** Holds if this declaration is a member of a class/struct/union. */
  predicate isMember() { this.hasDeclaringType() }

  /** Holds if this declaration is a member of a class/struct/union. */
  predicate hasDeclaringType() {
    exists(this.getDeclaringType())
  }

  /**
   * Gets the class where this member is declared, if it is a member.
   * For templates, both the template itself and all instantiations of
   * the template are considered to have the same declaring class.
   */
  Class getDeclaringType() {
    this = result.getAMember()
  }
}

class Variable extends Declaration, @variable {
  override string getName() { none() }
}

class TemplateVariable extends Variable {
  TemplateVariable() { is_variable_template(this) }

  Variable getAnInstantiation() { variable_instantiation(result, this) }
}

class LocalScopeVariable extends Variable, @localscopevariable {}

class LocalVariable extends LocalScopeVariable, @localvariable {
  override string getName() { localvariables(this, _, result) }
}

class Parameter extends LocalScopeVariable, @parameter {
  override string getName() {
    exists(int i | params(this, _, i, _) and result = "p#" + i.toString())
  }
}

class GlobalOrNamespaceVariable extends Variable, @globalvariable {
  override string getName() { globalvariables(this, _, result) }
}

class MemberVariable extends Variable, @membervariable {
  MemberVariable() {
    this.isMember()
  }

  override string getName() { membervariables(this, _, result) }
}

class EnumConstant extends Declaration, @enumconstant {
  override string getName() { enumconstants(this, _, _, _, result,_) }

  UserType getDeclaringEnum() { enumconstants(this, result, _, _, _, _) }
}

class Function extends Declaration, @function {
  override string getName() { functions(this, result, _) }
}

class TemplateFunction extends Function {
  TemplateFunction() {
    is_function_template(this) and function_template_argument(this, _, _)
  }

  Function getAnInstantiation() {
    function_instantiation(result, this)
    and not exists(@fun_decl fd |
              fun_decls(fd, this, _, _, _) and fun_specialized(fd))
  }
}

class UserType extends Declaration, @usertype {
  override string getName() { usertypes(this, result, _) }

  predicate isLocal() {
    enclosingfunction(this, _)
  }
}

class ProxyClass extends UserType {
  ProxyClass() { usertypes(this, _, 9) }
}

class TemplateParameter extends UserType {
  TemplateParameter() { usertypes(this, _, 7) or usertypes(this, _, 8) }
}

class Class extends UserType {
  Class() { ResolveClass::isClass(this) }

  Declaration getAMember() {
    exists(Declaration d | member(this, _ ,d) |
      result = d or
      result = d.(TemplateClass).getAnInstantiation() or
      result = d.(TemplateFunction).getAnInstantiation() or
      result = d.(TemplateVariable).getAnInstantiation())
  }
}

class TemplateClass extends Class {
  TemplateClass() { usertypes(this, _, 6) }

  Class getAnInstantiation() {
    class_instantiation(result, this) and
    class_template_argument(result, _, _)
  }
}

deprecated class Property extends Declaration {
  Property() { none() }

  override string getName() { none() }
}

class FriendDecl extends Declaration, @frienddecl {
  override string getName() {
    result = this.getDeclaringClass().getName() + "'s friend"
  }

  Class getDeclaringClass() { frienddecls(this, result, _, _) }
}
