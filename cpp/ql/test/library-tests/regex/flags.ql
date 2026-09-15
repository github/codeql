/**
 * Tests for the construction-site flag detection wired into `RegExpLiteral`.
 */

import cpp
import semmle.code.cpp.regex.RegexTreeView

query predicate ignoreCase(RegExpLiteral lit) { lit.isIgnoreCase() }

query predicate multiline(RegExpLiteral lit) { lit.isMultiline() }

query predicate dotAll(RegExpLiteral lit) { lit.isDotAll() }

query predicate flags(RegExpLiteral lit, string f) { f = lit.getFlags() }
