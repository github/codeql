package com.semmle.js.parser;

import com.semmle.js.ast.Position;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.regexp.BackReference;
import com.semmle.js.ast.regexp.Caret;
import com.semmle.js.ast.regexp.CharacterClass;
import com.semmle.js.ast.regexp.CharacterClassEscape;
import com.semmle.js.ast.regexp.CharacterClassRange;
import com.semmle.js.ast.regexp.Constant;
import com.semmle.js.ast.regexp.ControlEscape;
import com.semmle.js.ast.regexp.ControlLetter;
import com.semmle.js.ast.regexp.DecimalEscape;
import com.semmle.js.ast.regexp.Disjunction;
import com.semmle.js.ast.regexp.Dollar;
import com.semmle.js.ast.regexp.Dot;
import com.semmle.js.ast.regexp.Error;
import com.semmle.js.ast.regexp.Group;
import com.semmle.js.ast.regexp.HexEscapeSequence;
import com.semmle.js.ast.regexp.IdentityEscape;
import com.semmle.js.ast.regexp.NamedBackReference;
import com.semmle.js.ast.regexp.NonWordBoundary;
import com.semmle.js.ast.regexp.OctalEscape;
import com.semmle.js.ast.regexp.Opt;
import com.semmle.js.ast.regexp.Plus;
import com.semmle.js.ast.regexp.Range;
import com.semmle.js.ast.regexp.RegExpTerm;
import com.semmle.js.ast.regexp.Sequence;
import com.semmle.js.ast.regexp.Star;
import com.semmle.js.ast.regexp.UnicodeEscapeSequence;
import com.semmle.js.ast.regexp.UnicodePropertyEscape;
import com.semmle.js.ast.regexp.WordBoundary;
import com.semmle.js.ast.regexp.ZeroWidthNegativeLookahead;
import com.semmle.js.ast.regexp.ZeroWidthNegativeLookbehind;
import com.semmle.js.ast.regexp.ZeroWidthPositiveLookahead;
import com.semmle.js.ast.regexp.ZeroWidthPositiveLookbehind;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/** A parser for ECMAScript 2018 regular expressions. */
public class RegExpParser {
  /** The result of a parse. */
  public static class Result {
    /** The root of the parsed AST. */
    public final RegExpTerm ast;

    /** A list of errors encountered during parsing. */
    public final List<Error> errors;

    public Result(RegExpTerm ast, List<Error> errors) {
      this.ast = ast;
      this.errors = errors;
    }

    public RegExpTerm getAST() {
      return ast;
    }

    public List<Error> getErrors() {
      return errors;
    }
  }

  private String src;
  private int pos;
  private List<Error> errors;
  private List<BackReference> backrefs;
  private int maxbackref;

  /** Parse the given string as a regular expression. */
  public Result parse(String src) {
    this.src = src;
    this.pos = 0;
    this.errors = new ArrayList<>();
    this.backrefs = new ArrayList<>();
    this.maxbackref = 0;
    RegExpTerm root = parsePattern();
    for (BackReference backref : backrefs)
      if (backref.getValue() > maxbackref)
        errors.add(new Error(backref.getLoc(), Error.INVALID_BACKREF));
    return new Result(root, errors);
  }

  private static String fromCodePoint(int codepoint) {
    if (Character.isValidCodePoint(codepoint)) return new String(Character.toChars(codepoint));
    // replacement character
    return "\ufffd";
  }

  private Position pos() {
    return new Position(1, pos, pos);
  }

  private void error(int code, int start, int end) {
    Position startPos, endPos;
    startPos = new Position(1, start, start);
    endPos = new Position(1, end, end);
    this.errors.add(
        new Error(new SourceLocation(inputSubstring(start, end), startPos, endPos), code));
  }

  private void error(int code, int start) {
    error(code, start, start + 1);
  }

  private void error(int code) {
    error(code, this.pos);
  }

  private boolean atEOS() {
    return pos >= src.length();
  }

  private char peekChar(boolean opt) {
    if (this.atEOS()) {
      if (!opt) this.error(Error.UNEXPECTED_EOS);
      return '\0';
    } else {
      return this.src.charAt(this.pos);
    }
  }

  private char nextChar() {
    char c = peekChar(false);
    if (this.pos < src.length()) ++this.pos;
    return c;
  }

  private String readHexDigit() {
    char c = this.peekChar(false);
    if (c >= '0' && c <= '9' || c >= 'a' && c <= 'f' || c >= 'A' && c <= 'F') {
      ++this.pos;
      return String.valueOf(c);
    }
    if (c != '\0') this.error(Error.EXPECTED_HEX_DIGIT, this.pos);
    return "";
  }

  private String readHexDigits(int n) {
    StringBuilder res = new StringBuilder();
    while (n-- > 0) {
      res.append(readHexDigit());
    }
    if (res.length() == 0) return "0";
    return res.toString();
  }

  private String readDigits(boolean opt) {
    StringBuilder res = new StringBuilder();
    for (char c = peekChar(true); c >= '0' && c <= '9'; nextChar(), c = peekChar(true))
      res.append(c);
    if (res.length() == 0 && !opt) this.error(Error.EXPECTED_DIGIT);
    return res.toString();
  }

  private Double toNumber(String s) {
    if (s.isEmpty()) return 0.0;
    return Double.valueOf(s);
  }

  private String readIdentifier() {
    StringBuilder res = new StringBuilder();
    for (char c = peekChar(true);
        c != '\0' && Character.isJavaIdentifierPart(c);
        nextChar(), c = peekChar(true)) res.append(c);
    if (res.length() == 0) this.error(Error.EXPECTED_IDENTIFIER);
    return res.toString();
  }

  private void expectRParen() {
    if (!this.match(")")) this.error(Error.EXPECTED_CLOSING_PAREN, this.pos - 1);
  }

  private void expectRBrace() {
    if (!this.match("}")) this.error(Error.EXPECTED_CLOSING_BRACE, this.pos - 1);
  }

  private void expectRAngle() {
    if (!this.match(">")) this.error(Error.EXPECTED_CLOSING_ANGLE, this.pos - 1);
  }

  private boolean lookahead(String... arguments) {
    for (String prefix : arguments) {
      if (prefix == null) {
        if (atEOS()) return true;
      } else if (inputSubstring(pos, pos + prefix.length()).equals(prefix)) {
        return true;
      }
    }
    return false;
  }

  private boolean match(String... arguments) {
    for (String prefix : arguments) {
      if (this.lookahead(prefix)) {
        if (prefix == null) prefix = "";
        this.pos += prefix.length();
        return true;
      }
    }
    return false;
  }

  private RegExpTerm parsePattern() {
    RegExpTerm res = parseDisjunction();
    if (!this.atEOS()) this.error(Error.EXPECTED_EOS);
    return res;
  }

  protected String inputSubstring(int start, int end) {
    if (start >= src.length()) return "";
    if (end > src.length()) end = src.length();
    return src.substring(start, end);
  }

  private <T extends RegExpTerm> T finishTerm(T term) {
    SourceLocation loc = term.getLoc();
    Position end = pos();
    loc.setSource(inputSubstring(loc.getStart().getOffset(), end.getOffset()));
    loc.setEnd(end);
    return term;
  }

  private RegExpTerm parseDisjunction() {
    SourceLocation loc = new SourceLocation(pos());
    List<RegExpTerm> disjuncts = new ArrayList<>();
    disjuncts.add(this.parseAlternative());
    while (this.match("|")) disjuncts.add(this.parseAlternative());
    if (disjuncts.size() == 1) return disjuncts.get(0);
    return this.finishTerm(new Disjunction(loc, disjuncts));
  }

  private RegExpTerm parseAlternative() {
    SourceLocation loc = new SourceLocation(pos());
    List<RegExpTerm> elements = new ArrayList<>();
    while (!this.lookahead(null, "|", ")")) elements.add(this.parseTerm());
    if (elements.size() == 1) return elements.get(0);
    return this.finishTerm(new Sequence(loc, elements));
  }

  private RegExpTerm parseTerm() {
    SourceLocation loc = new SourceLocation(pos());

    if (this.match("^")) return this.finishTerm(new Caret(loc));

    if (this.match("$")) return this.finishTerm(new Dollar(loc));

    if (this.match("\\b")) return this.finishTerm(new WordBoundary(loc));

    if (this.match("\\B")) return this.finishTerm(new NonWordBoundary(loc));

    if (this.match("(?=")) {
      RegExpTerm dis = this.parseDisjunction();
      this.expectRParen();
      return this.finishTerm(new ZeroWidthPositiveLookahead(loc, dis));
    }

    if (this.match("(?!")) {
      RegExpTerm dis = this.parseDisjunction();
      this.expectRParen();
      return this.finishTerm(new ZeroWidthNegativeLookahead(loc, dis));
    }

    if (this.match("(?<=")) {
      RegExpTerm dis = this.parseDisjunction();
      this.expectRParen();
      return this.finishTerm(new ZeroWidthPositiveLookbehind(loc, dis));
    }

    if (this.match("(?<!")) {
      RegExpTerm dis = this.parseDisjunction();
      this.expectRParen();
      return this.finishTerm(new ZeroWidthNegativeLookbehind(loc, dis));
    }

    return this.finishTerm(this.parseQuantifierOpt(loc, this.parseAtom()));
  }

  private RegExpTerm parseQuantifierOpt(SourceLocation loc, RegExpTerm atom) {
    if (this.match("*")) return this.finishTerm(new Star(loc, atom, !this.match("?")));
    if (this.match("+")) return this.finishTerm(new Plus(loc, atom, !this.match("?")));
    if (this.match("?")) return this.finishTerm(new Opt(loc, atom, !this.match("?")));
    if (this.match("{")) {
      Double lo = toNumber(this.readDigits(false)), hi;
      if (this.match(",")) {
        if (!this.lookahead("}")) {
          // atom{lo, hi}
          hi = toNumber(this.readDigits(false));
        } else {
          // atom{lo,}
          hi = null;
        }
      } else {
        // atom{lo}
        hi = lo;
      }
      this.expectRBrace();
      return this.finishTerm(new Range(loc, atom, !this.match("?"), lo, hi));
    }
    return atom;
  }

  private RegExpTerm parseAtom() {
    SourceLocation loc = new SourceLocation(pos());

    if (this.match(".")) return this.finishTerm(new Dot(loc));

    if (this.match("\\")) return this.parseAtomEscape(loc, false);

    if (this.lookahead("[")) return this.parseCharacterClass();

    if (this.match("(")) {
      boolean capture = !this.match("?:");
      String name = null;

      if (this.match("?<")) {
        name = this.readIdentifier();
        this.expectRAngle();
      }

      if (capture) ++this.maxbackref;
      int number = this.maxbackref;
      RegExpTerm dis = this.parseDisjunction();
      this.expectRParen();
      return this.finishTerm(new Group(loc, capture, number, name, dis));
    }

    // Parse consecutive constants into a single Constant node.
    // Due to speculative parsing of string literals, this part of the code is fairly hot.
    int startPos = this.pos;
    int endPos = startPos;
    while (endPos < src.length()) {
      if ("^$\\.*+?()[]{}|".indexOf(src.charAt(endPos)) != -1) break;
      ++endPos;
    }
    if (startPos == endPos) {
      this.error(Error.UNEXPECTED_CHARACTER, endPos);
      endPos = startPos + 1; // To ensure progress, make sure we parse at least one character.
    }
    // Check if the end of the constant belongs under an upcoming quantifier.
    if (endPos != startPos + 1
        && endPos < src.length()
        && "*+?{".indexOf(src.charAt(endPos)) != -1) {
      if (Character.isLowSurrogate(src.charAt(endPos - 1))
          && Character.isHighSurrogate(src.charAt(endPos - 2))) {
        // Don't split the surrogate pair.
        if (endPos == startPos + 2) {
          // The whole constant is a single wide character.
        } else {
          endPos -= 2; // Last 2 characters belong to an upcoming quantifier.
        }
      } else {
        endPos--; // Last character belongs to an upcoming quantifier.
      }
    }
    String str = src.substring(startPos, endPos);
    this.pos = endPos;
    loc.setEnd(pos());
    loc.setSource(str);
    // Do not call finishTerm as it will create another copy of 'str'.
    return new Constant(loc, str);
  }

  private RegExpTerm parseAtomEscape(SourceLocation loc, boolean inCharClass) {
    String raw, value;
    double codepoint;

    if (this.match("x")) {
      raw = this.readHexDigits(2);
      codepoint = Integer.parseInt(raw, 16);
      value = fromCodePoint((int) codepoint);
      return this.finishTerm(new HexEscapeSequence(loc, value, (double) codepoint, "\\x" + raw));
    }

    if (this.match("u")) {
      if (this.match("{")) {
        int closePos = this.src.indexOf("}", this.pos);
        int n;
        if (closePos == -1) {
          // don't attempt to read any digits, but
          // report missing `}`
          n = 0;
        } else if (closePos == this.pos) {
          // empty escape sequence, trigger an error
          n = 1;
        } else {
          n = closePos - this.pos;
        }
        raw = this.readHexDigits(n);
        this.expectRBrace();
        try {
          codepoint = Long.parseLong(raw, 16);
        } catch (NumberFormatException nfe) {
          codepoint = 0;
        }
        raw = "{" + raw + "}";
      } else {
        raw = this.readHexDigits(4);
        codepoint = Integer.parseInt(raw, 16);
      }
      value = fromCodePoint((int) codepoint);
      return this.finishTerm(
          new UnicodeEscapeSequence(loc, value, (double) codepoint, "\\u" + raw));
    }

    if (this.match("k<")) {
      String name = this.readIdentifier();
      this.expectRAngle();
      return this.finishTerm(new NamedBackReference(loc, name, "\\k<" + name + ">"));
    }

    if (this.match("p{", "P{")) {
      String name = this.readIdentifier();
      if (this.match("=")) {
        value = this.readIdentifier();
        raw = "\\p{" + name + "=" + value + "}";
      } else {
        value = null;
        raw = "\\p{" + name + "}";
      }
      this.expectRBrace();
      return this.finishTerm(new UnicodePropertyEscape(loc, name, value, raw));
    }

    int startpos = this.pos - 1;
    char c = this.nextChar();

    if (c >= '0' && c <= '9') {
      raw = c + this.readDigits(true);
      if (c == '0' || inCharClass) {
        int base = c == '0' && raw.length() > 1 ? 8 : 10;
        try {
          codepoint = Long.parseLong(raw, base);
          value = fromCodePoint((int) codepoint);
        } catch (NumberFormatException nfe) {
          codepoint = 0;
          value = "\0";
        }
        if (base == 8) {
          this.error(Error.OCTAL_ESCAPE, startpos, this.pos);
          return this.finishTerm(new OctalEscape(loc, value, (double) codepoint, "\\" + raw));
        } else {
          return this.finishTerm(new DecimalEscape(loc, value, (double) codepoint, "\\" + raw));
        }
      } else {
        try {
          codepoint = Long.parseLong(raw, 10);
        } catch (NumberFormatException nfe) {
          codepoint = 0;
        }
        BackReference br = this.finishTerm(new BackReference(loc, (double) codepoint, "\\" + raw));
        this.backrefs.add(br);
        return br;
      }
    }

    String ctrltab = "f\fn\nr\rt\tv\u000b";
    int idx;
    if ((idx = ctrltab.indexOf(c)) % 2 == 0) {
      codepoint = ctrltab.charAt(idx + 1);
      value = String.valueOf((char) codepoint);
      return this.finishTerm(new ControlEscape(loc, value, codepoint, "\\" + c));
    }

    if (c == 'c') {
      c = this.nextChar();
      if (!(c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z'))
        this.error(Error.EXPECTED_CONTROL_LETTER, this.pos - 1);
      codepoint = c % 32;
      value = String.valueOf((char) codepoint);
      return this.finishTerm(new ControlLetter(loc, value, codepoint, "\\c" + c));
    }

    if ("dDsSwW".indexOf(c) >= 0) {
      return this.finishTerm(new CharacterClassEscape(loc, String.valueOf(c), "\\" + c));
    }

    codepoint = c;
    value = String.valueOf((char) codepoint);
    return this.finishTerm(new IdentityEscape(loc, value, codepoint, "\\" + c));
  }

  private RegExpTerm parseCharacterClass() {
    SourceLocation loc = new SourceLocation(pos());
    List<RegExpTerm> elements = new ArrayList<>();

    this.match("[");
    boolean inverted = this.match("^");
    while (!this.match("]")) {
      if (this.atEOS()) {
        this.error(Error.EXPECTED_RBRACKET);
        break;
      }
      elements.add(this.parseCharacterClassElement());
    }
    return this.finishTerm(new CharacterClass(loc, elements, inverted));
  }

  private static final List<String> escapeClasses = Arrays.asList("d", "D", "s", "S", "w", "W");

  private RegExpTerm parseCharacterClassElement() {
    SourceLocation loc = new SourceLocation(pos());
    RegExpTerm atom = this.parseCharacterClassAtom();
    if (this.lookahead("-\\")) {
      for (String c : escapeClasses) {
        if (this.lookahead("-\\" + c))
          return atom;
      }
    }
    if (!this.lookahead("-]") && this.match("-") && !(atom instanceof CharacterClassEscape))
      return this.finishTerm(new CharacterClassRange(loc, atom, this.parseCharacterClassAtom()));
    return atom;
  }

  private RegExpTerm parseCharacterClassAtom() {
    SourceLocation loc = new SourceLocation(pos());
    char c = this.nextChar();
    if (c == '\\') {
      if (this.match("b")) return this.finishTerm(new ControlEscape(loc, "\b", 8, "\\b"));
      return this.finishTerm(this.parseAtomEscape(loc, true));
    }
    String value = String.valueOf(c);
    // Extract a surrogate pair as a single constant.
    if (Character.isHighSurrogate(c) && Character.isLowSurrogate(peekChar(true))) {
      value += this.nextChar();
    }
    return this.finishTerm(new Constant(loc, value));
  }
}
