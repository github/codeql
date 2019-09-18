/**
 * Provides classes for .Net declarations.
 */

import Element
import Type

/** A declaration. */
class Declaration extends NamedElement, @dotnet_declaration {
  override predicate hasQualifiedName(string qualifier, string name) {
    qualifier = this.getDeclaringType().getQualifiedName() and
    name = this.getName()
  }

  /** Gets the name of this declaration, without additional decoration such as `<...>`. */
  string getUndecoratedName() { none() }

  /** Gets the type containing this declaration, if any. */
  Type getDeclaringType() { none() }

  /** Gets the unbound version of this declaration. */
  Declaration getSourceDeclaration() { result = this }
}

/** A member of a type. */
class Member extends Declaration, @dotnet_member { }

/** A property. */
class Property extends Member, @dotnet_property {
  /** Gets the getter of this property, if any. */
  Callable getGetter() { none() }

  /** Gets the setter of this property, if any. */
  Callable getSetter() { none() }

  /** Gets the type of this property. */
  Type getType() { none() }
}

/** An event. */
class Event extends Member, @dotnet_event {
  /** Gets the adder of this event, if any. */
  Callable getAdder() { none() }

  /** Gets the remover of this event, if any. */
  Callable getRemover() { none() }
}
