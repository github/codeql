import semmle.code.cpp.Declaration
import semmle.code.cpp.Type
import semmle.code.cpp.Member
import semmle.code.cpp.Function
private import semmle.code.cpp.internal.Type

/**
 * A C/C++ user-defined type. Examples include `Class`, `Struct`, `Union`,
 * `Enum`, and `TypedefType`.
 */
class UserType extends Type, Declaration, NameQualifyingElement, AccessHolder, @usertype {
  /** the name of this type */
  override string getName() { usertypes(unresolveElement(this),result,_) }

  /** the simple name of this type, without any template parameters */
  string getSimpleName() {
    result = getName().regexpReplaceAll("<.*", "")
  }

  override predicate hasName(string name) {
    usertypes(unresolveElement(this),name,_)
  }
  predicate isAnonymous() {
    getName().matches("(unnamed%")
  }

  override predicate hasSpecifier(string s) {
    Type.super.hasSpecifier(s)
  }
  override Specifier getASpecifier() {
    result = Type.super.getASpecifier()
  }

  override Location getLocation() {
    if isDefined() then
      result = this.getDefinitionLocation()
    else
      result = this.getADeclarationLocation()
  }

  override TypeDeclarationEntry getADeclarationEntry() {
    if type_decls(_, unresolveElement(this), _) then
      type_decls(unresolveElement(result), unresolveElement(this), _)
    else
      exists(Class t | this.(Class).isConstructedFrom(t) and result = t.getADeclarationEntry())
  }

  override Location getADeclarationLocation() {
    result = getADeclarationEntry().getLocation()
  }

  override TypeDeclarationEntry getDefinition() {
    result = getADeclarationEntry() and
    result.isDefinition()
  }

  /** the location of the definition */
  override Location getDefinitionLocation() {
    if exists(getDefinition()) then
      result = getDefinition().getLocation()
    else
      exists(Class t | this.(Class).isConstructedFrom(t) and result = t.getDefinition().getLocation())
  }

  /** Gets the function that directly encloses this type (if any). */
  Function getEnclosingFunction() {
    enclosingfunction(unresolveElement(this),unresolveElement(result))
  }

  /** Whether this is a local type (i.e. a type that has a directly-enclosing function). */
  predicate isLocal() {
    exists(getEnclosingFunction())
  }

  // Dummy implementations of inherited methods. This class must not be
  // made abstract, because it is important that it captures the @usertype
  // type exactly - but this is not apparent from its subclasses

  Declaration getADeclaration() { none() }

  override string explain() { result = this.getName() }

  // further overridden in LocalClass
  override AccessHolder getEnclosingAccessHolder() {
    result = this.getDeclaringType()
  }
}

/**
 * A particular definition or forward declaration of a C/C++ user-defined type.
 */
class TypeDeclarationEntry extends DeclarationEntry, @type_decl {
  override UserType getDeclaration() { result = getType() }
  override string getName() { result = getType().getName() }

  /**
   * The type which is being declared or defined.
   */
  override Type getType() { type_decls(unresolveElement(this),unresolveElement(result),_) }

  override Location getLocation() { type_decls(unresolveElement(this),_,result) }
  override predicate isDefinition() { type_def(unresolveElement(this)) }
  override string getASpecifier() { none() }

  /**
   * A top level type declaration entry is not declared within a function, function declaration,
   * class or typedef.
   */
  predicate isTopLevel() { type_decl_top(unresolveElement(this)) }
}
