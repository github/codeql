/**
 * INTERNAL: Do not use. Provides classes and predicates for getting names of
 * declarations, especially qualified names. Import this library `private` and
 * qualified.
 *
 * This file contains classes that mirror the standard AST classes for C++, but
 * these classes are only concerned with naming.
 */

private import semmle.code.cpp.Declaration as D

class Namespace extends @namespace {
  string toString() { result = "QualifiedName Namespace" }

  string getName() { namespaces(this, result) }

  string getQualifiedName() {
    if namespacembrs(_, this)
    then
      exists(Namespace ns |
        namespacembrs(ns, this) and
        result = ns.getQualifiedName() + "::" + this.getName()
      )
    else result = this.getName()
  }

  /**
   * Gets a namespace qualifier, like `"namespace1::namespace2"`, through which
   * the members of this namespace can be named. When `inline namespace` is
   * used, this predicate may have multiple results.
   *
   * This predicate does not take namespace aliases into account. Unlike inline
   * namespaces, specialization of templates cannot happen through an alias.
   * Aliases are also local to the compilation unit, while inline namespaces
   * affect the whole program.
   */
  string getAQualifierForMembers() {
    if namespacembrs(_, this)
    then
      exists(Namespace ns | namespacembrs(ns, this) |
        result = ns.getAQualifierForMembers() + "::" + this.getName()
        or
        // If this is an inline namespace, its members are also visible in any
        // namespace where the members of the parent are visible.
        namespace_inline(this) and
        result = ns.getAQualifierForMembers()
      )
    else result = this.getName()
  }

  Declaration getADeclaration() {
    if this.getName() = ""
    then result.isTopLevel() and not namespacembrs(_, result)
    else namespacembrs(this, result)
  }
}

class Declaration extends @declaration {
  string toString() { result = "QualifiedName Declaration" }

  /** Gets the name of this declaration. */
  final string getName() { result = this.(D::Declaration).getName() }

  string getTypeQualifierWithoutArgs() {
    exists(UserType declaringType |
      declaringType = this.(EnumConstant).getDeclaringEnum()
      or
      declaringType = this.getDeclaringType()
    |
      result = getTypeQualifierForMembersWithoutArgs(declaringType)
    )
  }

  string getTypeQualifierWithArgs() {
    exists(UserType declaringType |
      declaringType = this.(EnumConstant).getDeclaringEnum()
      or
      declaringType = this.getDeclaringType()
    |
      result = getTypeQualifierForMembersWithArgs(declaringType)
    )
  }

  Namespace getNamespace() {
    // Top level declaration in a namespace ...
    result.getADeclaration() = this
    or
    // ... or nested in another structure.
    exists(Declaration m | m = this and result = m.getDeclaringType().getNamespace())
    or
    exists(EnumConstant c | c = this and result = c.getDeclaringEnum().getNamespace())
  }

  predicate hasQualifiedName(string namespaceQualifier, string typeQualifier, string baseName) {
    declarationHasQualifiedName(baseName, typeQualifier, namespaceQualifier, this)
  }

  string getQualifiedName() {
    exists(string ns, string name |
      ns = this.getNamespace().getQualifiedName() and
      name = this.getName() and
      this.canHaveQualifiedName()
    |
      exists(string t | t = this.getTypeQualifierWithArgs() |
        if ns != "" then result = ns + "::" + t + "::" + name else result = t + "::" + name
      )
      or
      not hasTypeQualifier(this) and
      if ns != "" then result = ns + "::" + name else result = name
    )
  }

  predicate canHaveQualifiedName() {
    this.hasDeclaringType()
    or
    this instanceof EnumConstant
    or
    this instanceof Function
    or
    this instanceof UserType
    or
    this instanceof GlobalOrNamespaceVariable
  }

  predicate isTopLevel() {
    not (
      this.isMember() or
      this instanceof FriendDecl or
      this instanceof EnumConstant or
      this instanceof Parameter or
      this instanceof ProxyClass or
      this instanceof LocalVariable or
      this instanceof TypeTemplateParameter or
      this.(UserType).isLocal()
    )
  }

  /** Holds if this declaration is a member of a class/struct/union. */
  predicate isMember() { this.hasDeclaringType() }

  /** Holds if this declaration is a member of a class/struct/union. */
  predicate hasDeclaringType() { exists(this.getDeclaringType()) }

  /**
   * Gets the class where this member is declared, if it is a member.
   * For templates, both the template itself and all instantiations of
   * the template are considered to have the same declaring class.
   */
  UserType getDeclaringType() { this = result.getAMember() }
}

class Variable extends Declaration, @variable {
  VariableDeclarationEntry getADeclarationEntry() { result.getDeclaration() = this }
}

class TemplateVariable extends Variable {
  TemplateVariable() { is_variable_template(this) }

  Variable getAnInstantiation() { variable_instantiation(result, this) }
}

class LocalScopeVariable extends Variable, @localscopevariable { }

class LocalVariable extends LocalScopeVariable, @localvariable { }

/**
 * A particular declaration or definition of a C/C++ variable.
 */
class VariableDeclarationEntry extends @var_decl {
  string toString() { result = "QualifiedName DeclarationEntry" }

  Variable getDeclaration() { result = this.getVariable() }

  /**
   * Gets the variable which is being declared or defined.
   */
  Variable getVariable() { var_decls(this, result, _, _, _) }

  predicate isDefinition() { var_def(this) }

  string getName() { var_decls(this, _, _, result, _) and result != "" }
}

class Parameter extends LocalScopeVariable, @parameter { }

class GlobalOrNamespaceVariable extends Variable, @globalvariable { }

// Unlike the usual `EnumConstant`, this one doesn't have a
// `getDeclaringType()`. This simplifies the recursive computation of type
// qualifier names since it can assume that any declaration with a
// `getDeclaringType()` should use that type in its type qualifier name.
class EnumConstant extends Declaration, @enumconstant {
  UserType getDeclaringEnum() { enumconstants(this, result, _, _, _, _) }
}

class Function extends Declaration, @function {
  predicate isConstructedFrom(Function f) { function_instantiation(this, f) }

  Parameter getParameter(int n) { params(result, this, n, _) }
}

class TemplateFunction extends Function {
  TemplateFunction() { is_function_template(this) and function_template_argument(this, _, _) }

  Function getAnInstantiation() {
    function_instantiation(result, this) and
    not exists(@fun_decl fd | fun_decls(fd, this, _, _, _) and fun_specialized(fd))
  }
}

class UserType extends Declaration, @usertype {
  predicate isLocal() { enclosingfunction(this, _) }

  // Gets a member of this class, if it's a class.
  Declaration getAMember() {
    exists(Declaration d | member(this, _, d) |
      result = d or
      result = d.(TemplateClass).getAnInstantiation() or
      result = d.(TemplateFunction).getAnInstantiation() or
      result = d.(TemplateVariable).getAnInstantiation()
    )
  }
}

class ProxyClass extends UserType {
  ProxyClass() { usertypes(this, _, 9) }
}

class TypeTemplateParameter extends UserType {
  TypeTemplateParameter() { usertypes(this, _, [7, 8]) }
}

class TemplateClass extends UserType {
  TemplateClass() { usertypes(this, _, [15, 16, 17]) }

  UserType getAnInstantiation() {
    class_instantiation(result, this) and
    class_template_argument(result, _, _)
  }
}

class FriendDecl extends Declaration, @frienddecl {
  UserType getDeclaringClass() { frienddecls(this, result, _, _) }
}

private string getUserTypeNameWithArgs(UserType t) { usertypes(t, result, _) }

private string getUserTypeNameWithoutArgs(UserType t) {
  result = getUserTypeNameWithArgs(t).splitAt("<", 0)
}

private predicate hasTypeQualifier(Declaration d) {
  d instanceof EnumConstant
  or
  d.hasDeclaringType()
}

private string getTypeQualifierForMembersWithArgs(UserType t) {
  result = t.getTypeQualifierWithArgs() + "::" + getUserTypeNameWithArgs(t)
  or
  not hasTypeQualifier(t) and
  result = getUserTypeNameWithArgs(t)
}

private string getTypeQualifierForMembersWithoutArgs(UserType t) {
  result = t.getTypeQualifierWithoutArgs() + "::" + getUserTypeNameWithoutArgs(t)
  or
  not hasTypeQualifier(t) and
  result = getUserTypeNameWithoutArgs(t)
}

// The order of parameters on this predicate is chosen to match the most common
// use case: finding a declaration that has a specific name. The declaration
// comes last because it's the output.
cached
private predicate declarationHasQualifiedName(
  string baseName, string typeQualifier, string namespaceQualifier, Declaration d
) {
  namespaceQualifier = d.getNamespace().getAQualifierForMembers() and
  (
    if hasTypeQualifier(d)
    then typeQualifier = d.getTypeQualifierWithoutArgs()
    else typeQualifier = ""
  ) and
  (
    baseName = getUserTypeNameWithoutArgs(d)
    or
    // If a declaration isn't a `UserType`, there are two ways it can still
    // contain `<`:
    // 1. If it's `operator<` or `operator<<`.
    // 2. If it's a conversion operator like `operator TemplateClass<Arg>`.
    //    Perhaps these names ought to be fixed up, but we don't do that
    //    currently.
    not d instanceof UserType and
    baseName = d.getName()
  ) and
  d.canHaveQualifiedName()
}
