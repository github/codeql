/**
 * Provides classes for declarations and members.
 */

import CIL
private import dotnet
private import semmle.code.csharp.Member as CS

/**
 * A declaration. Either a member (`Member`) or a variable (`Variable`).
 */
class Declaration extends DotNet::Declaration, Element, @cil_declaration {
  /** Gets an attribute (for example `[Obsolete]`) of this declaration, if any. */
  Attribute getAnAttribute() { result.getDeclaration() = this }

  /**
   * Gets the C# declaration corresponding to this CIL declaration, if any.
   * Note that this is only for source/unconstructed declarations.
   */
  CS::Declaration getCSharpDeclaration() {
    result = toCSharpNonTypeParameter(this) or
    result = toCSharpTypeParameter(this)
  }

  override Declaration getUnboundDeclaration() { result = this }

  /**
   * DEPRECATED: Use `isUnboundDeclaration()` instead.
   *
   * Holds if this declaration is a source declaration.
   */
  deprecated final predicate isSourceDeclaration() { this.isUnboundDeclaration() }
}

private CS::Declaration toCSharpNonTypeParameter(Declaration d) { result.matchesHandle(d) }

private CS::TypeParameter toCSharpTypeParameter(TypeParameter tp) {
  toCSharpTypeParameterJoin(tp, result.getIndex(), result.getGeneric())
}

pragma[nomagic]
private predicate toCSharpTypeParameterJoin(TypeParameter tp, int i, CS::UnboundGeneric ug) {
  exists(TypeContainer tc |
    tp.getIndex() = i and
    tc = tp.getGeneric() and
    ug = toCSharpNonTypeParameter(tc)
  )
}

/**
 * A member of a type. Either a type (`Type`), a method (`Method`), a property (`Property`), or an event (`Event`).
 */
class Member extends DotNet::Member, Declaration, @cil_member {
  override predicate isPublic() { cil_public(this) }

  override predicate isProtected() { cil_protected(this) }

  override predicate isPrivate() { cil_private(this) }

  override predicate isInternal() { cil_internal(this) }

  override predicate isSealed() { cil_sealed(this) }

  override predicate isAbstract() { cil_abstract(this) }

  override predicate isStatic() { cil_static(this) }

  /** Holds if this member has a security attribute. */
  predicate hasSecurity() { cil_security(this) }

  override Location getLocation() { result = getDeclaringType().getLocation() }
}

/** A property. */
class Property extends DotNet::Property, Member, CustomModifierReceiver, @cil_property {
  override string getName() { cil_property(this, _, result, _) }

  /** Gets the type of this property. */
  override Type getType() { cil_property(this, _, _, result) }

  override ValueOrRefType getDeclaringType() { cil_property(this, result, _, _) }

  /** Gets the getter of this property, if any. */
  override Getter getGetter() { this = result.getProperty() }

  /** Gets the setter of this property, if any. */
  override Setter getSetter() { this = result.getProperty() }

  /** Gets an accessor of this property. */
  Accessor getAnAccessor() { result = getGetter() or result = getSetter() }

  override string toString() { result = "property " + getName() }

  override string toStringWithTypes() {
    result =
      getType().toStringWithTypes() + " " + getDeclaringType().toStringWithTypes() + "." + getName()
  }
}

/** A property that is trivial (wraps a field). */
class TrivialProperty extends Property {
  TrivialProperty() {
    getGetter().(TrivialGetter).getField() = getSetter().(TrivialSetter).getField()
  }

  /** Gets the underlying field of this property. */
  Field getField() { result = getGetter().(TrivialGetter).getField() }
}

/** An event. */
class Event extends DotNet::Event, Member, @cil_event {
  override string getName() { cil_event(this, _, result, _) }

  /** Gets the type of this event. */
  Type getType() { cil_event(this, _, _, result) }

  override ValueOrRefType getDeclaringType() { cil_event(this, result, _, _) }

  /** Gets the add event accessor. */
  Method getAddEventAccessor() { cil_adder(this, result) }

  /** Gets the remove event accessor. */
  Method getRemoveEventAccessor() { cil_remover(this, result) }

  /** Gets the raiser. */
  Method getRaiser() { cil_raiser(this, result) }

  override string toString() { result = "event " + getName() }

  override string toStringWithTypes() {
    result = getDeclaringType().toStringWithTypes() + "." + getName()
  }
}
