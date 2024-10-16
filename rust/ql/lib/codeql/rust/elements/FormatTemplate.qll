/**
 * This module provides the classes modeling formatting templates. See also https://doc.rust-lang.org/std/fmt
 */

private import FormatArgsExpr
private import LiteralExpr

/**
 * A regular expression for matching format elements in a formatting template. The
 * regular expression is generated from the following python code:
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
private string formatRegex() {
  result =
    "(\\{(([0-9]+)|([A-Za-z_][A-Za-z0-9_]*))?(:((.)?([<^>]))?([+-])?(#)?(0)?(((([0-9]+)|([A-Za-z_][A-Za-z0-9_]*))\\$)|([0-9]+))?(\\.((((([0-9]+)|([A-Za-z_][A-Za-z0-9_]*))\\$)|([0-9]+))|(\\*)))?(|\\?|x\\?|X\\?|([A-Za-z_][A-Za-z0-9_]*)))?\\s*\\})"
}

private string textRegex() { result = "([^{}]|\\{\\{|\\}\\})+" }

private string part(FormatArgsExpr parent, int occurrenceIndex, int occurrenceOffset) {
  result =
    parent
        .getTemplate()
        .(LiteralExpr)
        .getTextValue()
        // TODO: should also handle surrounding quotes and escaped characters
        .regexpFind(textRegex() + "|" + formatRegex(), occurrenceIndex, occurrenceOffset)
}

private newtype TFormatTemplateElem =
  TFormat(FormatArgsExpr parent, string text, int index, int offset) {
    text = part(parent, index, offset) and text.regexpMatch(formatRegex())
  }

private newtype TFormatArgumentKind =
  TElement() or
  TWidth() or
  TPrecision()

private newtype TFormatArgumentT =
  TFormatArgument(
    TFormat parent, TFormatArgumentKind kind, string value, boolean positional, int offset
  ) {
    exists(string text, int formatOffset, int group |
      group = [3, 4] and offset = formatOffset + 1 and kind = TElement()
      or
      group = [15, 16] and
      offset = formatOffset + min(text.indexOf(value + "$")) and
      kind = TWidth()
      or
      group = [23, 24] and
      offset = formatOffset + max(text.indexOf(value + "$")) and
      kind = TPrecision()
    |
      parent = TFormat(_, text, _, formatOffset) and
      value = text.regexpCapture(formatRegex(), group) and
      if group % 2 = 1 then positional = true else positional = false
    )
  }

/**
 * A format element in a formatting template. For example the `{}` in:
 * ```rust
 * println!("Hello {}", "world");
 * ```
 */
class Format extends TFormat {
  private FormatArgsExpr parent;
  private string text;
  private int index;
  private int offset;

  Format() { this = TFormat(parent, text, index, offset) }

  /** Gets a textual representation of this element. */
  string toString() { result = text }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Providing locations in CodeQL queries](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    parent
        .getTemplate()
        .getLocation()
        .hasLocationInfo(filepath, startline, startcolumn - offset, _, _) and
    endline = startline and
    endcolumn = startcolumn + text.length() - 1
  }

  /** Gets a the parent of this `Format`. */
  FormatArgsExpr getParent() { result = parent }

  /** Gets the index of this `Format` node. */
  int getIndex() { result = index }

  /**
   * Gets the name or position reference of this format, if any. For example `name` and `0` in:
   * ```rust
   * let name = "Alice";
   * println!("{name} in wonderland");
   * println!("{0} in wonderland", name);
   * ```
   */
  FormatArgument getArgumentRef() {
    result.getParent() = this and result = TFormatArgument(_, TElement(), _, _, _)
  }

  /**
   * Gets the name or position reference of the width parameter in this format, if any. For example `width` and `1` in:
   * ```rust
   * let width = 6;
   * println!("{:width$}", PI);
   * println!("{:1$}", PI, width);
   * ```
   */
  FormatArgument getWidthArgument() {
    result.getParent() = this and result = TFormatArgument(_, TWidth(), _, _, _)
  }

  /**
   * Gets the name or position reference of the width parameter in this format, if any. For example `prec` and `1` in:
   * ```rust
   * let prec = 6;
   * println!("{:.prec$}", PI);
   * println!("{:.1$}", PI, prec);
   * ```
   */
  FormatArgument getPrecisionArgument() {
    result.getParent() = this and result = TFormatArgument(_, TPrecision(), _, _, _)
  }
}

/**
 * An argument in a format element in a formatting template. For example the `width`, `precision`, and `value` in:
 * ```rust
 * println!("Value {value:#width$.precision$}");
 * ```
 * or the `0`, `1` and `2` in:
 * ```rust
 * println!("Value {0:#1$.2$}", value, width, precision);
 * ```
 */
class FormatArgument extends TFormatArgumentT {
  private Format parent;
  string name;
  private int offset;

  FormatArgument() { this = TFormatArgument(parent, _, name, _, offset) }

  /** Gets a textual representation of this element. */
  string toString() { result = name }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Providing locations in CodeQL queries](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    // TODO: handle locations in multi-line comments
    // TODO: handle the case where the template is from a nested macro call
    parent
        .getParent()
        .getTemplate()
        .getLocation()
        .hasLocationInfo(filepath, startline, startcolumn - offset, _, _) and
    endline = startline and
    endcolumn = startcolumn + name.length() - 1
  }

  /** Gets a the parent of this `FormatArgument`. */
  Format getParent() { result = parent }
}

/**
 * A positional `FormatArgument`. For example `0` in
 * ```rust
 * let name = "Alice";
 * println!("{0} in wonderland", name);
 * ```
 */
class PositionalFormatArgument extends FormatArgument {
  PositionalFormatArgument() { this = TFormatArgument(_, _, _, true, _) }

  /** Gets the index of this positional argument */
  int getIndex() { result = name.toInt() }
}

/**
 * A named `FormatArgument`. For example `name` in
 * ```rust
 * let name = "Alice";
 * println!("{name} in wonderland");
 * ```
 */
class NamedFormatArgument extends FormatArgument {
  NamedFormatArgument() { this = TFormatArgument(_, _, _, false, _) }

  /** Gets the name of this named argument */
  string getName() { result = name }
}
