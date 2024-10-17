/**
 * This module provides a hand-modifiable wrapper around the generated class `ImplicitVariableAccess`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.ImplicitVariableAccess
private import codeql.rust.elements.internal.ImplicitVariableAccessConstructor
private import codeql.rust.elements.internal.generated.Raw
private import codeql.rust.elements.internal.generated.Synth
private import codeql.rust.elements.FormatTemplate

/**
 * INTERNAL: This module contains the customizable definition of `ImplicitVariableAccess` and should not
 * be referenced directly.
 */
module Impl {
  class ImplicitVariableAccess extends Generated::ImplicitVariableAccess {
    private NamedFormatArgument argument;

    ImplicitVariableAccess() {
      exists(Raw::FormatArgsExpr parent, int index, int kind |
        this = Synth::TImplicitVariableAccess(parent, index, kind) and
        unboundNamedFormatArgument(parent, index, kind, argument)
      )
    }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      argument.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    override string toString() { result = this.getName() }

    /** Gets the name of the variable */
    string getName() { result = argument.getName() }

    /** Gets the underlying `NamedFormatArgument` . */
    NamedFormatArgument getArgument() { result = argument }
  }
}
