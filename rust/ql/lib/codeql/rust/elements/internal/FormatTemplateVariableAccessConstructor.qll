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

pragma[nomagic]
private predicate formatArgsHasArg(
  Raw::FormatArgsExpr parent, NamedFormatArgument arg, string name, int index, int kind
) {
  exists(Format format |
    parent = Synth::convertFormatArgsExprToRaw(format.getParent()) and
    name = arg.getName() and
    format.getIndex() = index
  |
    arg = format.getArgumentRef() and kind = 0
    or
    arg = format.getWidthArgument() and kind = 1
    or
    arg = format.getPrecisionArgument() and kind = 2
  )
}

pragma[nomagic]
private predicate formatArgsHasArgName(Raw::FormatArgsExpr parent, string name) {
  parent.getArg(_).getName().getText() = name
}

/**
 * A named format argument for which no binding is found in the parent `FormatArgsExpr::getArg(_)`.
 * INTERNAL: Do not use.
 */
predicate unboundNamedFormatArgument(
  Raw::FormatArgsExpr parent, int index, int kind, NamedFormatArgument arg
) {
  exists(string name |
    formatArgsHasArg(parent, arg, name, index, kind) and
    not formatArgsHasArgName(parent, name)
  )
}
