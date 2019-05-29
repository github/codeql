/**
 * INTERNAL: Do not use. Provides classes and predicates for getting names of
 * declarations, especially qualified names. Import this library `private` and
 * qualified.
 *
 * This file contains classes that mirror the standard AST classes for C++, but
 * these classes are only concerned with naming. The other difference is that
 * these classes don't use the `ResolveClass.qll` mechanisms like
 * `unresolveElement` because these classes should eventually be part of the
 * implementation of `ResolveClass.qll`, allowing it to match up classes when
 * their qualified names and parameters match.
 */

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

  string getQualifierForMembers() {
    if namespacembrs(_, this)
    then
      exists(Namespace ns |
        namespacembrs(ns, this)
      |
        result = ns.getQualifierForMembers() + "::" + this.getName()
        or
        // If this is an inline namespace, its members are also visible in any
        // namespace where the members of the parent are visible.
        namespace_inline(this) and
        result = ns.getQualifierForMembers()
      )
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
  cached
  abstract string getName();

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
        if ns != ""
        then result = ns + "::" + t + "::" + name
        else result = t + "::" + name
      )
      or
      not hasTypeQualifier(this) and
      if ns != ""
      then result = ns + "::" + name
      else result = name
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
      this instanceof TemplateParameter or
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
  override string getName() { none() }

  VariableDeclarationEntry getADeclarationEntry() { result.getDeclaration() = this }
}

class TemplateVariable extends Variable {
  TemplateVariable() { is_variable_template(this) }

  Variable getAnInstantiation() { variable_instantiation(result, this) }
}

class LocalScopeVariable extends Variable, @localscopevariable { }

class LocalVariable extends LocalScopeVariable, @localvariable {
  override string getName() { localvariables(this, _, result) }
}

/**
 * A particular declaration or definition of a C/C++ variable.
 */
class VariableDeclarationEntry extends @var_decl {
  string toString() { result = "QualifiedName DeclarationEntry" }

  Variable getDeclaration() { result = getVariable() }

  /**
   * Gets the variable which is being declared or defined.
   */
  Variable getVariable() { var_decls(this, result, _, _, _) }

  predicate isDefinition() { var_def(this) }

  string getName() { var_decls(this, _, _, result, _) and result != "" }
}

class Parameter extends LocalScopeVariable, @parameter {
  @functionorblock function;

  int index;

  Parameter() { params(this, function, index, _) }

  /**
   * Gets the canonical name, or names, of this parameter.
   *
   * The canonical names are the first non-empty category from the
   * following list:
   *  1. The name given to the parameter at the function's definition or
   *     (for catch block parameters) at the catch block.
   *  2. A name given to the parameter at a function declaration.
   *  3. The name "p#i" where i is the index of the parameter.
   */
  override string getName() {
    exists(VariableDeclarationEntry vde |
      vde = getANamedDeclarationEntry() and result = vde.getName()
    |
      vde.isDefinition() or not getANamedDeclarationEntry().isDefinition()
    )
    or
    not exists(getANamedDeclarationEntry()) and
    result = "p#" + index.toString()
  }

  VariableDeclarationEntry getANamedDeclarationEntry() {
    result = getAnEffectiveDeclarationEntry() and exists(result.getName())
  }

  /**
   * Gets a declaration entry corresponding to this declaration.
   *
   * This predicate is the same as getADeclarationEntry(), except that for
   * parameters of instantiated function templates, gives the declaration
   * entry of the prototype instantiation of the parameter (as
   * non-prototype instantiations don't have declaration entries of their
   * own).
   */
  VariableDeclarationEntry getAnEffectiveDeclarationEntry() {
    if function.(Function).isConstructedFrom(_)
    then
      exists(Function prototypeInstantiation |
        prototypeInstantiation.getParameter(index) = result.getVariable() and
        function.(Function).isConstructedFrom(prototypeInstantiation)
      )
    else result = getADeclarationEntry()
  }
}

class GlobalOrNamespaceVariable extends Variable, @globalvariable {
  override string getName() { globalvariables(this, _, result) }
}

class MemberVariable extends Variable, @membervariable {
  MemberVariable() { this.isMember() }

  override string getName() { membervariables(this, _, result) }
}

// Unlike the usual `EnumConstant`, this one doesn't have a
// `getDeclaringType()`. This simplifies the recursive computation of type
// qualifier names since it can assume that any declaration with a
// `getDeclaringType()` should use that type in its type qualifier name.
class EnumConstant extends Declaration, @enumconstant {
  override string getName() { enumconstants(this, _, _, _, result, _) }

  UserType getDeclaringEnum() { enumconstants(this, result, _, _, _, _) }
}

class Function extends Declaration, @function {
  override string getName() { functions(this, result, _) }

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
  override string getName() { result = getUserTypeNameWithArgs(this) }

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

class TemplateParameter extends UserType {
  TemplateParameter() { usertypes(this, _, 7) or usertypes(this, _, 8) }
}

class TemplateClass extends UserType {
  TemplateClass() { usertypes(this, _, 6) }

  UserType getAnInstantiation() {
    class_instantiation(result, this) and
    class_template_argument(result, _, _)
  }
}

class FriendDecl extends Declaration, @frienddecl {
  override string getName() {
    result = getUserTypeNameWithArgs(this.getDeclaringClass()) + "'s friend"
  }

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
  namespaceQualifier = d.getNamespace().getQualifierForMembers() and
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
