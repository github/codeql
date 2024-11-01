/**
 *  This module defines the hook used internally to tweak the characteristic predicate of
 *  `Format` synthesized instances.
 *  INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Raw
private import codeql.rust.internal.CachedStages

/**
 *  The characteristic predicate of `Format` synthesized instances.
 *  INTERNAL: Do not use.
 *
 * Match an element of a format string, either text (`Hello`) or a format placeholder (`{}`).
 */
predicate constructFormat(Raw::FormatArgsExpr parent, int index, string text, int offset) {
  text = formatElement(parent, index, offset) and
  text.charAt(0) = "{" and
  text.charAt(1) != "{"
}

/**
 * Match an element of a format string, either text (`Hello`) or a format placeholder (`{}`).
 */
string formatElement(Raw::FormatArgsExpr parent, int occurrenceIndex, int occurrenceOffset) {
  Stages::AstStage::ref() and
  result =
    parent
        .getTemplate()
        .(Raw::LiteralExpr)
        .getTextValue()
        // TODO: should also handle surrounding quotes and escaped characters
        .regexpFind(textRegex() + "|" + formatRegex(), occurrenceIndex, occurrenceOffset)
}

/**
 * A regular expression for matching format elements in a formatting template. The syntax of
 * formatting templates is defined at https://doc.rust-lang.org/stable/std/fmt/#syntax . The
 * regular expression is generated from the following python code:
 *
 *
 * ```python
 * identifier = "([A-Za-z_][A-Za-z0-9_]*)"
 * integer = "([0-9]+)"
 *
 * # argument := integer | identifier
 * argument = "({integer}|{identifier})".format(integer=integer, identifier=identifier)
 *
 * # parameter := argument '$'
 * parameter = "(({argument})\\$)".format(argument=argument)
 *
 * # count := parameter | integer
 * count = "({parameter}|{integer})".format(integer=integer, parameter=parameter)
 *
 * # fill := character
 * fill = "(.)"
 *
 * # align := '<' | '^' | '>'
 * align = "([<^>])"
 *
 * # sign := '+' | '-'
 * sign = "([+-])"
 *
 * # width := count
 * width = count
 *
 * # precision := count | '*'
 * precision = "({count}|(\\*))".format(count=count)
 *
 * # type := '' | '?' | 'x?' | 'X?' | identifier
 * type = "(|\\?|x\\?|X\\?|{identifier})".format(identifier=identifier)
 *
 * # format_spec := [[fill]align][sign]['#']['0'][width]['.' precision]type
 * format_spec = "({fill}?{align})?{sign}?(#)?(0)?{width}?(\\.{precision})?{type}".format(fill=fill, align=align, sign=sign, width=width, precision=precision, type=type)
 *
 * # format := '{' [ argument ] [ ':' format_spec ] [ ws ] * '}'
 * format = "(\\{{{argument}?(:{format_spec})?\s*}\\})".format(argument=argument, format_spec=format_spec)
 *
 * ```
 */
string formatRegex() {
  result =
    "(\\{(([0-9]+)|([A-Za-z_][A-Za-z0-9_]*))?(:((.)?([<^>]))?([+-])?(#)?(0)?(((([0-9]+)|([A-Za-z_][A-Za-z0-9_]*))\\$)|([0-9]+))?(\\.((((([0-9]+)|([A-Za-z_][A-Za-z0-9_]*))\\$)|([0-9]+))|(\\*)))?(|\\?|x\\?|X\\?|([A-Za-z_][A-Za-z0-9_]*)))?\\s*\\})"
}

private string textRegex() { result = "([^{}]|\\{\\{|\\}\\})+" }
