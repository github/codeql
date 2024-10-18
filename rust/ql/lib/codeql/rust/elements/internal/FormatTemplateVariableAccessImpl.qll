/**
 * This module provides a hand-modifiable wrapper around the generated class `FormatTemplateVariableAccess`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.FormatTemplateVariableAccess
private import codeql.rust.elements.internal.FormatTemplateVariableAccessConstructor
private import codeql.rust.elements.internal.generated.Raw
private import codeql.rust.elements.internal.generated.Synth
private import codeql.rust.elements.Format
private import codeql.rust.elements.NamedFormatArgument

/**
 * INTERNAL: This module contains the customizable definition of `FormatTemplateVariableAccess` and should not
 * be referenced directly.
 */
module Impl {
  class FormatTemplateVariableAccess extends Generated::FormatTemplateVariableAccess {
    private NamedFormatArgument argument;

    FormatTemplateVariableAccess() {
      exists(Raw::FormatArgsExpr parent, int index, int kind |
        this = Synth::TFormatTemplateVariableAccess(parent, index, kind) and
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
