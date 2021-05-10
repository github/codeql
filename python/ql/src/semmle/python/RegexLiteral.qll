import python
import semmle.python.regex as R
private import RegexParserExtended

class RegexLiteralValue extends ParsedString {
  R::Regex lit;

  RegexLiteralValue() { this = lit.getText() }

  override ParserConfiguration getConfiguration() { result instanceof RegexParserConfiguration }

  override predicate getLocationInfo(
    string file, int startline, int startcol, int endline, int endcol
  ) {
    lit.getLocation().hasLocationInfo(file, startline + 1, startcol - 2, endline + 1, endcol - 2)
  }

  R::Regex getLiteral() { result = lit }
}

class RegexLiteral extends R::Regex {
  RegexLiteralValue val;

  RegexLiteral() { val.getLiteral() = this }

  Regex getRegex() { result.getText() = val and result.isRoot() }
}
