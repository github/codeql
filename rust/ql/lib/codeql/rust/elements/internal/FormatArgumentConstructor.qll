/**
 *  This module defines the hook used internally to tweak the characteristic predicate of
 *  `FormatArgument` synthesized instances.
 *  INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Raw
private import codeql.rust.elements.internal.generated.Synth
private import codeql.rust.elements.internal.FormatConstructor

/**
 *  The characteristic predicate of `FormatArgument` synthesized instances.
 *  INTERNAL: Do not use.
 */
predicate constructFormatArgument(
  Raw::FormatArgsExpr parent, int index, int kind, string value, boolean positional, int offset
) {
  exists(string text, int formatOffset, int group |
    group = [3, 4] and offset = formatOffset + 1 and kind = 0
    or
    group = [15, 16] and
    offset = formatOffset + min(text.indexOf(value + "$")) and
    kind = 1
    or
    group = [23, 24] and
    offset = formatOffset + max(text.indexOf(value + "$")) and
    kind = 2
  |
    text = formatElement(parent, index, formatOffset) and
    value = text.regexpCapture(formatRegex(), group) and
    if group % 2 = 1 then positional = true else positional = false
  )
}
