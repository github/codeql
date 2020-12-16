/**
 * Provides a class to represent `modopt` and `modreq` declarations.
 */

private import CIL
private import dotnet

/**
 * A class to represent entities that can recive custom modifiers. Custom modifiers can be attached to
 * - the type of a `Field`,
 * - the return type of a `Method` or `Property`,
 * - the type of parameters.
 * A `CustomModifierReceiver` is therefore either a `Field`, `Property`, `Method`, or `Parameter`.
 */
class CustomModifierReceiver extends Declaration, @cil_custom_modifier_receiver {
  /** Holds if this targeted type has `modifier` applied as `modreq`. */
  predicate hasRequiredCustomModifier(Type modifier) { cil_custom_modifiers(this, modifier, 1) }

  /** Holds if this targeted type has `modifier` applied as `modopt`. */
  predicate hasOptionalCustomModifier(Type modifier) { cil_custom_modifiers(this, modifier, 0) }

  /**
   * Holds if this targeted type has `modifier` applied as `kind`. `kind` 1 means `modreq`,
   * `kind` 0 represents `modopt`.
   */
  predicate hasCustomModifier(Type modifier, int kind) {
    cil_custom_modifiers(this, modifier, kind)
  }
}
