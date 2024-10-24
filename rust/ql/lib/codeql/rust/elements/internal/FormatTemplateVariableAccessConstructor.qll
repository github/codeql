/**
 *  This module defines the hook used internally to tweak the characteristic predicate of
 *  `FormatTemplateVariableAccess` synthesized instances.
 *  INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Raw
private import codeql.rust.elements.internal.generated.Synth
private import codeql.rust.elements.Format
private import codeql.rust.elements.NamedFormatArgument

/**
 *  The characteristic predicate of `FormatTemplateVariableAccess` synthesized instances.
 *  INTERNAL: Do not use.
 */
predicate constructFormatTemplateVariableAccess(Raw::FormatArgsExpr parent, int index, int kind) {
  unboundNamedFormatArgument(parent, index, kind, _)
}

/**
 * A named format argument for which no binding is found in the parent `FormatArgsExpr::getArg(_)`.
 * INTERNAL: Do not use.
 */
predicate unboundNamedFormatArgument(
  Raw::FormatArgsExpr parent, int index, int kind, NamedFormatArgument arg
) {
  exists(Format format, string name |
    not parent.getArg(_).getName().getText() = name and
    name = arg.getName() and
    Synth::convertFormatArgsExprToRaw(format.getParent()) = parent and
    format.getIndex() = index
  |
    arg = format.getArgumentRef() and kind = 0
    or
    arg = format.getWidthArgument() and kind = 1
    or
    arg = format.getPrecisionArgument() and kind = 2
  )
}
