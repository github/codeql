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

  /** Holds if this element has undecorated name 'name'. */
  final predicate hasUndecoratedName(string name) { name = this.getUndecoratedName() }

  /** Gets the type containing this declaration, if any. */
  Type getDeclaringType() { none() }

  /**
   * Gets the unbound version of this declaration, that is, the declaration where
   * all type arguments have been removed. For example, in
   *
   * ```csharp
   * class C<T>
   * {
   *     class Nested
   *     {
   *     }
   *
   *     void Method<S>() { }
   * }
   * ```
   *
   * we have the following
   *
   * | Declaration             | Unbound declaration |
   * |-------------------------|---------------------|
   * | `C<int>`                | `C<>`               |
   * | `C<>.Nested`            | `C<>.Nested`        |
   * | `C<int>.Nested`         | `C<>.Nested`        |
   * | `C<>.Method<>`          | `C<>.Method<>`      |
   * | `C<int>.Method<>`       | `C<>.Method<>`      |
   * | `C<int>.Method<string>` | `C<>.Method<>`      |
   */
  Declaration getUnboundDeclaration() { result = this }

  /** Holds if this declaration is unbound. */
  final predicate isUnboundDeclaration() { this.getUnboundDeclaration() = this }
}

/** A member of a type. */
class Member extends Declaration, @dotnet_member {
  /** Holds if this member is declared `public`. */
  predicate isPublic() { none() }

  /** Holds if this member is declared `protected.` */
  predicate isProtected() { none() }

  /** Holds if this member is `private`. */
  predicate isPrivate() { none() }

  /** Holds if this member is `internal`. */
  predicate isInternal() { none() }

  /** Holds if this member is `sealed`. */
  predicate isSealed() { none() }

  /** Holds if this member is `abstract`. */
  predicate isAbstract() { none() }

  /** Holds if this member is `static`. */
  predicate isStatic() { none() }
}

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
