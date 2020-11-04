package com.semmle.jcorn;

import static com.semmle.jcorn.Whitespace.isNewLine;
import static com.semmle.jcorn.Whitespace.lineBreak;

import com.semmle.jcorn.Identifiers.Dialect;
import com.semmle.jcorn.Options.AllowReserved;
import com.semmle.jcorn.TokenType.Properties;
import com.semmle.js.ast.ArrayExpression;
import com.semmle.js.ast.ArrayPattern;
import com.semmle.js.ast.ArrowFunctionExpression;
import com.semmle.js.ast.AssignmentExpression;
import com.semmle.js.ast.AssignmentPattern;
import com.semmle.js.ast.AwaitExpression;
import com.semmle.js.ast.BinaryExpression;
import com.semmle.js.ast.BlockStatement;
import com.semmle.js.ast.BreakStatement;
import com.semmle.js.ast.CallExpression;
import com.semmle.js.ast.CatchClause;
import com.semmle.js.ast.Chainable;
import com.semmle.js.ast.ClassBody;
import com.semmle.js.ast.ClassDeclaration;
import com.semmle.js.ast.ClassExpression;
import com.semmle.js.ast.ConditionalExpression;
import com.semmle.js.ast.ContinueStatement;
import com.semmle.js.ast.DebuggerStatement;
import com.semmle.js.ast.DeclarationFlags;
import com.semmle.js.ast.DoWhileStatement;
import com.semmle.js.ast.EmptyStatement;
import com.semmle.js.ast.EnhancedForStatement;
import com.semmle.js.ast.ExportAllDeclaration;
import com.semmle.js.ast.ExportDeclaration;
import com.semmle.js.ast.ExportDefaultDeclaration;
import com.semmle.js.ast.ExportNamedDeclaration;
import com.semmle.js.ast.ExportSpecifier;
import com.semmle.js.ast.Expression;
import com.semmle.js.ast.ExpressionStatement;
import com.semmle.js.ast.ForInStatement;
import com.semmle.js.ast.ForOfStatement;
import com.semmle.js.ast.ForStatement;
import com.semmle.js.ast.FunctionDeclaration;
import com.semmle.js.ast.FunctionExpression;
import com.semmle.js.ast.IFunction;
import com.semmle.js.ast.INode;
import com.semmle.js.ast.IPattern;
import com.semmle.js.ast.Identifier;
import com.semmle.js.ast.IfStatement;
import com.semmle.js.ast.FieldDefinition;
import com.semmle.js.ast.ImportDeclaration;
import com.semmle.js.ast.ImportDefaultSpecifier;
import com.semmle.js.ast.ImportNamespaceSpecifier;
import com.semmle.js.ast.ImportSpecifier;
import com.semmle.js.ast.LabeledStatement;
import com.semmle.js.ast.Literal;
import com.semmle.js.ast.LogicalExpression;
import com.semmle.js.ast.MemberDefinition;
import com.semmle.js.ast.MemberExpression;
import com.semmle.js.ast.MetaProperty;
import com.semmle.js.ast.MethodDefinition;
import com.semmle.js.ast.NewExpression;
import com.semmle.js.ast.Node;
import com.semmle.js.ast.ObjectExpression;
import com.semmle.js.ast.ObjectPattern;
import com.semmle.js.ast.ParenthesizedExpression;
import com.semmle.js.ast.Position;
import com.semmle.js.ast.Program;
import com.semmle.js.ast.Property;
import com.semmle.js.ast.RestElement;
import com.semmle.js.ast.ReturnStatement;
import com.semmle.js.ast.SequenceExpression;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.SpreadElement;
import com.semmle.js.ast.Statement;
import com.semmle.js.ast.Super;
import com.semmle.js.ast.SwitchCase;
import com.semmle.js.ast.SwitchStatement;
import com.semmle.js.ast.TaggedTemplateExpression;
import com.semmle.js.ast.TemplateElement;
import com.semmle.js.ast.TemplateLiteral;
import com.semmle.js.ast.ThisExpression;
import com.semmle.js.ast.ThrowStatement;
import com.semmle.js.ast.Token;
import com.semmle.js.ast.TryStatement;
import com.semmle.js.ast.UnaryExpression;
import com.semmle.js.ast.UpdateExpression;
import com.semmle.js.ast.VariableDeclaration;
import com.semmle.js.ast.VariableDeclarator;
import com.semmle.js.ast.WhileStatement;
import com.semmle.js.ast.WithStatement;
import com.semmle.js.ast.YieldExpression;
import com.semmle.ts.ast.ITypeExpression;
import com.semmle.util.collections.CollectionUtil;
import com.semmle.util.data.Pair;
import com.semmle.util.data.StringUtil;
import com.semmle.util.exception.CatastrophicError;
import com.semmle.util.exception.Exceptions;
import com.semmle.util.io.WholeIO;
import java.io.File;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.Stack;
import java.util.function.Function;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Java port of Acorn.
 *
 * <p>This version corresponds to <a
 * href="https://github.com/ternjs/acorn/commit/bb54adcdbceef01997a9549732139ca8f53a4e28">Acorn
 * 4.0.3</a>, but does not support plugins, and always tracks full source locations.
 */
public class Parser {
  protected final Options options;
  protected final Set<String> keywords;
  private final Set<String> reservedWords, reservedWordsStrict, reservedWordsStrictBind;
  protected final String input;
  private boolean containsEsc;
  protected boolean exprAllowed;
  protected boolean strict;
  private boolean inModule;
  protected boolean inFunction;
  protected boolean inGenerator;
  protected boolean inClass;
  protected boolean inAsync;
  protected boolean inTemplateElement;
  protected int pos;
  protected int lineStart;
  protected int curLine;
  protected int start;
  protected int end;
  protected TokenType type;
  protected Object value;
  protected Position startLoc;
  protected Position endLoc;
  protected Position lastTokEndLoc, lastTokStartLoc;
  protected int lastTokStart, lastTokEnd;
  protected Stack<TokContext> context;
  protected int potentialArrowAt;
  private Stack<LabelInfo> labels;
  protected int yieldPos, awaitPos;

  /**
   * Set to true by {@link ESNextParser#readInt} if the parsed integer contains an underscore.
   */
  protected boolean seenUnderscoreNumericSeparator = false;

  /**
   * For readability purposes, we pass this instead of false as the argument to the
   * hasDeclareKeyword parameter (which only exists in TypeScript).
   */
  private static final boolean noDeclareKeyword = false;

  /**
   * For readability purposes, we pass this instead of false as the argument to the isAbstract
   * parameter (which only exists in TypeScript).
   */
  protected static final boolean notAbstract = false;

  /**
   * For readability purposes, we pass this instead of null as the argument to the type annotation
   * parameters (which only exists in TypeScript).
   */
  private static final ITypeExpression noTypeAnnotation = null;

  protected static class LabelInfo {
    String name, kind;
    int statementStart;

    public LabelInfo(String name, String kind, int statementStart) {
      this.name = name;
      this.kind = kind;
      this.statementStart = statementStart;
    }
  }

  public static void main(String[] args) {
    new Parser(new Options(), new WholeIO().strictread(new File(args[0])), 0).parse();
  }

  /// begin state.js

  public Parser(Options options, String input, int startPos) {
    this.options = options;
    this.keywords =
        new LinkedHashSet<String>(
            Identifiers.keywords.get(
                options.ecmaVersion() >= 6
                    ? Identifiers.Dialect.ECMA_6
                    : Identifiers.Dialect.ECMA_5));
    this.reservedWords = new LinkedHashSet<String>();
    if (!options.allowReserved().isTrue()) {
      this.reservedWords.addAll(Identifiers.reservedWords.get(options.getDialect()));
      if (options.sourceType().equals("module")) this.reservedWords.add("await");
    }
    this.reservedWordsStrict = new LinkedHashSet<String>(this.reservedWords);
    this.reservedWordsStrict.addAll(Identifiers.reservedWords.get(Dialect.STRICT));
    this.reservedWordsStrictBind = new LinkedHashSet<String>(this.reservedWordsStrict);
    this.reservedWordsStrictBind.addAll(Identifiers.reservedWords.get(Dialect.STRICT_BIND));
    this.input = input;

    // Used to signal to callers of `readWord1` whether the word
    // contained any escape sequences. This is needed because words with
    // escape sequences must not be interpreted as keywords.
    this.containsEsc = false;

    // Set up token state

    // The current position of the tokenizer in the input.
    if (startPos != 0) {
      this.pos = startPos;
      this.lineStart = this.input.lastIndexOf("\n", startPos - 1) + 1;
      this.curLine = inputSubstring(0, this.lineStart).split(Whitespace.lineBreak).length;
    } else {
      this.pos = this.lineStart = 0;
      this.curLine = 1;
    }

    // Properties of the current token:
    // Its type
    this.type = TokenType.eof;
    // For tokens that include more information than their type, the value
    this.value = null;
    // Its start and end offset
    this.start = this.end = this.pos;
    // And, if locations are used, the {line, column} object
    // corresponding to those offsets
    this.startLoc = this.endLoc = this.curPosition();

    // Position information for the previous token
    this.lastTokEndLoc = this.lastTokStartLoc = null;
    this.lastTokStart = this.lastTokEnd = this.pos;

    // The context stack is used to superficially track syntactic
    // context to predict whether a regular expression is allowed in a
    // given position.
    this.context = this.initialContext();
    this.exprAllowed = true;

    // Figure out if it's a module code.
    this.strict = this.inModule = options.sourceType().equals("module");

    // Used to signify the start of a potential arrow function
    this.potentialArrowAt = -1;

    // Flags to track whether we are in a function, a generator, an async function, a class.
    this.inFunction = this.inGenerator = this.inAsync = this.inClass = false;
    // Positions to delayed-check that yield/await does not exist in default parameters.
    this.yieldPos = this.awaitPos = 0;
    // Labels in scope.
    this.labels = new Stack<LabelInfo>();

    // If enabled, skip leading hashbang line.
    if (this.pos == 0 && options.allowHashBang() && this.input.startsWith("#!"))
      this.skipLineComment(2);
  }

  public Program parse() {
    Position startLoc = this.startLoc;
    this.nextToken();
    return this.parseTopLevel(startLoc, this.options.program());
  }

  /// end state.js

  /// begin location.js
  protected void raise(int pos, String msg, boolean recoverable) {
    Position loc = Locutil.getLineInfo(input, pos);
    raise(loc, msg, recoverable);
  }

  protected void raise(int pos, String msg) {
    raise(pos, msg, false);
  }

  protected void raise(Position loc, String msg, boolean recoverable) {
    msg += " (" + loc.getLine() + ":" + loc.getColumn() + ")";
    SyntaxError err = new SyntaxError(msg, loc, this.pos);
    if (recoverable && options.onRecoverableError() != null)
      options.onRecoverableError().apply(err);
    else throw err;
  }

  protected void raise(Position loc, String msg) {
    raise(loc, msg, false);
  }

  protected void raise(INode nd, String msg) {
    raise(nd.getLoc().getStart(), msg, false);
  }

  protected void raiseRecoverable(int pos, String msg) {
    raise(pos, msg, true);
  }

  protected void raiseRecoverable(INode nd, String msg) {
    raise(nd.getLoc().getStart(), msg, true);
  }

  protected Position curPosition() {
    return new Position(curLine, pos - lineStart, pos);
  }

  /// end location.js

  /// begin tokenize.js

  // Move to the next token

  protected void next() {
    if (this.options.onToken() != null) this.options.onToken().apply(mkToken());

    this.lastTokEnd = this.end;
    this.lastTokStart = this.start;
    this.lastTokEndLoc = this.endLoc;
    this.lastTokStartLoc = this.startLoc;
    this.nextToken();
  }

  // Toggle strict mode. Re-reads the next number or string to please
  // pedantic tests (`"use strict"; 010;` should fail).

  public void setStrict(boolean strict) {
    this.strict = strict;
    if (this.type != TokenType.num && this.type != TokenType.string) return;
    this.pos = this.start;
    while (this.pos < this.lineStart) {
      this.lineStart = this.input.lastIndexOf("\n", this.lineStart - 2) + 1;
      --this.curLine;
    }
    this.nextToken();
  }

  public TokContext curContext() {
    return context.peek();
  }

  // Read a single token, updating the parser object's token-related
  // properties.

  public Token nextToken() {
    TokContext curContext = this.curContext();
    if (curContext == null || !curContext.preserveSpace) this.skipSpace();

    this.start = this.pos;
    this.startLoc = this.curPosition();
    if (this.pos >= this.input.length()) return this.finishToken(TokenType.eof);

    if (curContext != null && curContext.override != null) return curContext.override.apply(this);
    else return this.readToken(this.fullCharCodeAtPos());
  }

  protected Token readToken(int code) {
    // Identifier or keyword. '\\uXXXX' sequences are allowed in
    // identifiers, so '\' also dispatches to that.
    if (Identifiers.isIdentifierStart(code, this.options.ecmaVersion() >= 6)
        || code == 92 /* '\' */) return this.readWord();

    return this.getTokenFromCode(code);
  }

  protected int fullCharCodeAtPos() {
    int code = charAt(this.pos);
    if (code <= 0xd7ff || code >= 0xe000) return code;
    int next = charAt(this.pos + 1);
    return (code << 10) + next - 0x35fdc00;
  }

  protected void skipBlockComment() {
    Position startLoc = this.options.onComment() != null ? this.curPosition() : null;
    int start = this.pos, end = this.input.indexOf("*/", this.pos += 2);
    if (end == -1) this.raise(this.pos - 2, "Unterminated comment");
    this.pos = end + 2;
    Matcher m = Whitespace.lineBreakG.matcher(this.input);
    int next = start;
    while (m.find(next) && m.start() < this.pos) {
      ++this.curLine;
      lineStart = m.end();
      next = lineStart;
    }
    if (this.options.onComment() != null)
      this.options
          .onComment()
          .call(
              true,
              this.input,
              inputSubstring(start + 2, end),
              start,
              this.pos,
              startLoc,
              this.curPosition());
  }

  protected void skipLineComment(int startSkip) {
    int start = this.pos;
    Position startLoc = this.options.onComment() != null ? this.curPosition() : null;
    this.pos += startSkip;
    int ch = charAt(this.pos);
    while (this.pos < this.input.length() && ch != 10 && ch != 13 && ch != 8232 && ch != 8233) {
      ++this.pos;
      ch = charAt(this.pos);
    }
    if (this.options.onComment() != null)
      this.options
          .onComment()
          .call(
              false,
              this.input,
              inputSubstring(start + startSkip, this.pos),
              start,
              this.pos,
              startLoc,
              this.curPosition());
  }

  // Called at the start of the parse and after every token. Skips
  // whitespace and comments, and.

  protected void skipSpace() {
    loop:
    while (this.pos < this.input.length()) {
      int ch = this.input.charAt(this.pos);
      switch (ch) {
        case 32:
        case 160: // ' '
          ++this.pos;
          break;
        case 13:
          if (charAt(this.pos + 1) == 10) {
            ++this.pos;
          }
        case 10:
        case 8232:
        case 8233:
          ++this.pos;
          ++this.curLine;
          this.lineStart = this.pos;
          break;
        case 47: // '/'
          switch (charAt(this.pos + 1)) {
            case 42: // '*'
              this.skipBlockComment();
              break;
            case 47:
              this.skipLineComment(2);
              break;
            default:
              break loop;
          }
          break;
        default:
          if (ch > 8 && ch < 14 || ch >= 5760 && Whitespace.nonASCIIwhitespace.indexOf(ch) > -1) {
            ++this.pos;
          } else {
            break loop;
          }
      }
    }
  }

  // Called at the end of every token. Sets `end`, `val`, and
  // maintains `context` and `exprAllowed`, and skips the space after
  // the token, so that the next one's `start` will point at the
  // right position.

  protected Token finishToken(TokenType type, Object val) {
    this.end = this.pos;
    this.endLoc = this.curPosition();
    TokenType prevType = this.type;
    this.type = type;
    this.value = val;
    this.updateContext(prevType);
    return mkToken();
  }

  private Token mkToken() {
    String src = inputSubstring(start, end);
    SourceLocation loc = new SourceLocation(src, startLoc, endLoc);
    String label, keyword;
    if (isKeyword(src)) {
      label = keyword = src;
    } else {
      label = type.label;
      keyword = type.keyword;
    }
    return new Token(loc, label, keyword);
  }

  protected boolean isKeyword(String src) {
    if (type.keyword != null) return true;
    if (type == TokenType.name) {
      if (keywords.contains(src)) return true;
      if (options.ecmaVersion() >= 6 && ("let".equals(src) || "yield".equals(src))) return true;
    }
    return false;
  }

  protected Token finishToken(TokenType type) {
    return finishToken(type, null);
  }

  // ### Token reading

  // This is the function that is called to fetch the next token. It
  // is somewhat obscure, because it works in character codes rather
  // than characters, and because operator parsing has been inlined
  // into it.
  //
  // All in the name of speed.
  //
  private Token readToken_dot() {
    int next = charAt(this.pos + 1);
    if (next >= 48 && next <= 57) return this.readNumber(true);
    int next2 = charAt(this.pos + 2);
    if (this.options.ecmaVersion() >= 6 && next == 46 && next2 == 46) { // 46 = dot '.'
      this.pos += 3;
      return this.finishToken(TokenType.ellipsis);
    } else {
      ++this.pos;
      return this.finishToken(TokenType.dot);
    }
  }

  private Token readToken_question() { // '?'
    int next = charAt(this.pos + 1);
    int next2 = charAt(this.pos + 2);
    if (this.options.esnext()) {
      if (next == '.' && !('0' <= next2 && next2 <= '9')) // '?.', but not '?.X' where X is a digit
        return this.finishOp(TokenType.questiondot, 2);
      if (next == '?') { // '??'
        if (next2 == '=') { // ??=
          return this.finishOp(TokenType.assign, 3);
        }
        return this.finishOp(TokenType.questionquestion, 2);
      }
      
    }
    return this.finishOp(TokenType.question, 1);
  }

  private Token readToken_slash() { // '/'
    int next = charAt(this.pos + 1);
    if (this.exprAllowed) {
      ++this.pos;
      return this.readRegexp();
    }
    if (next == 61) return this.finishOp(TokenType.assign, 2);
    return this.finishOp(TokenType.slash, 1);
  }

  private Token readToken_mult_modulo_exp(int code) { // '%*'
    int next = charAt(this.pos + 1);
    int size = 1;
    TokenType tokentype = code == 42 ? TokenType.star : TokenType.modulo;

    // exponentiation operator ** and **=
    if (this.options.ecmaVersion() >= 7 && code == 42 && next == 42) {
      ++size;
      tokentype = TokenType.starstar;
      next = charAt(this.pos + 2);
    }

    if (next == 61) return this.finishOp(TokenType.assign, size + 1);
    return this.finishOp(tokentype, size);
  }

  private Token readToken_pipe_amp(int code) { // '|&'
    int next = charAt(this.pos + 1);
    int next2 = charAt(this.pos + 2);
    if (next == code) { // && ||
      if (next2 == 61) return this.finishOp(TokenType.assign, 3); // &&= ||=
      return this.finishOp(code == 124 ? TokenType.logicalOR : TokenType.logicalAND, 2);
    }
    if (next == 61) return this.finishOp(TokenType.assign, 2);
    return this.finishOp(code == 124 ? TokenType.bitwiseOR : TokenType.bitwiseAND, 1);
  }

  private Token readToken_caret() { // '^'
    int next = charAt(this.pos + 1);
    if (next == 61) return this.finishOp(TokenType.assign, 2);
    return this.finishOp(TokenType.bitwiseXOR, 1);
  }

  private Token readToken_plus_min(int code) { // '+-'
    int next = charAt(this.pos + 1);
    if (next == code) {
      if (next == 45
          && charAt(this.pos + 2) == 62
          && inputSubstring(this.lastTokEnd, this.pos).matches("(?s).*(?:" + lineBreak + ").*")) {
        // A `-->` line comment
        this.skipLineComment(3);
        this.skipSpace();
        return this.nextToken();
      }
      return this.finishOp(TokenType.incDec, 2);
    }
    if (next == 61) return this.finishOp(TokenType.assign, 2);
    return this.finishOp(TokenType.plusMin, 1);
  }

  private Token readToken_lt_gt(int code) { // '<>'
    int next = charAt(this.pos + 1);
    int size = 1;
    if (next == code) {
      size = code == 62 && charAt(this.pos + 2) == 62 ? 3 : 2;
      if (charAt(this.pos + size) == 61) return this.finishOp(TokenType.assign, size + 1);
      return this.finishOp(TokenType.bitShift, size);
    }
    if (next == 33 && code == 60 && charAt(this.pos + 2) == 45 && charAt(this.pos + 3) == 45) {
      if (this.inModule) this.unexpected();
      // `<!--`, an XML-style comment that should be interpreted as a line comment
      this.skipLineComment(4);
      this.skipSpace();
      return this.nextToken();
    }
    if (next == 61) size = 2;
    return this.finishOp(TokenType.relational, size);
  }

  private Token readToken_eq_excl(int code) { // '=!'
    int next = charAt(this.pos + 1);
    if (next == 61) return this.finishOp(TokenType.equality, charAt(this.pos + 2) == 61 ? 3 : 2);
    if (code == 61 && next == 62 && this.options.ecmaVersion() >= 6) { // '=>'
      this.pos += 2;
      return this.finishToken(TokenType.arrow);
    }
    return this.finishOp(code == 61 ? TokenType.eq : TokenType.prefix, 1);
  }

  protected Token getTokenFromCode(int code) {
    switch (code) {
        // The interpretation of a dot depends on whether it is followed
        // by a digit or another two dots.
      case 46: // '.'
        return this.readToken_dot();

        // Punctuation tokens.
      case 40:
        ++this.pos;
        return this.finishToken(TokenType.parenL);
      case 41:
        ++this.pos;
        return this.finishToken(TokenType.parenR);
      case 59:
        ++this.pos;
        return this.finishToken(TokenType.semi);
      case 44:
        ++this.pos;
        return this.finishToken(TokenType.comma);
      case 91:
        ++this.pos;
        return this.finishToken(TokenType.bracketL);
      case 93:
        ++this.pos;
        return this.finishToken(TokenType.bracketR);
      case 123:
        ++this.pos;
        return this.finishToken(TokenType.braceL);
      case 125:
        ++this.pos;
        return this.finishToken(TokenType.braceR);
      case 58:
        ++this.pos;
        return this.finishToken(TokenType.colon);
      case 35:
        ++this.pos;
        return this.finishToken(TokenType.pound);
      case 63:
        return this.readToken_question();

      case 96: // '`'
        if (this.options.ecmaVersion() < 6) break;
        ++this.pos;
        return this.finishToken(TokenType.backQuote);

      case 48: // '0'
        int next = charAt(this.pos + 1);
        if (next == 120 || next == 88) return this.readRadixNumber(16); // '0x', '0X' - hex number
        if (this.options.ecmaVersion() >= 6) {
          if (next == 111 || next == 79)
            return this.readRadixNumber(8); // '0o', '0O' - octal number
          if (next == 98 || next == 66)
            return this.readRadixNumber(2); // '0b', '0B' - binary number
        }
        // Anything else beginning with a digit is an integer, octal
        // number, or float.
      case 49:
      case 50:
      case 51:
      case 52:
      case 53:
      case 54:
      case 55:
      case 56:
      case 57: // 1-9
        return this.readNumber(false);

        // Quotes produce strings.
      case 34:
      case 39: // '"', "'"
        return this.readString((char) code);

        // Operators are parsed inline in tiny state machines. '=' (61) is
        // often referred to. `finishOp` simply skips the amount of
        // characters it is given as second argument, and returns a token
        // of the type given by its first argument.

      case 47: // '/'
        return this.readToken_slash();

      case 37:
      case 42: // '%*'
        return this.readToken_mult_modulo_exp(code);

      case 124: // '|'
      case 38: // '&'
        return this.readToken_pipe_amp(code);

      case 94: // '^'
        return this.readToken_caret();

      case 43:
      case 45: // '+-'
        return this.readToken_plus_min(code);

      case 60:
      case 62: // '<>'
        return this.readToken_lt_gt(code);

      case 61:
      case 33: // '=!'
        return this.readToken_eq_excl(code);

      case 126: // '~'
        return this.finishOp(TokenType.prefix, 1);
    }

    String msg = String.format("Unexpected character '%s' (U+%04X)", codePointToString(code), code);
    this.raise(this.pos, msg);
    return null;
  }

  protected Token finishOp(TokenType type, int size) {
    String str = inputSubstring(this.pos, this.pos + size);
    this.pos += size;
    return this.finishToken(type, str);
  }

  private Token readRegexp() {
    boolean escaped = false, inClass = false;
    int start = this.pos;
    for (; ; ) {
      if (this.pos >= this.input.length()) this.raise(start, "Unterminated regular expression");
      int ch = this.input.charAt(this.pos);
      if (isNewLine(ch)) this.raise(start, "Unterminated regular expression");
      if (!escaped) {
        if (ch == '[') inClass = true;
        else if (ch == ']' && inClass) inClass = false;
        else if (ch == '/' && !inClass) break;
        escaped = ch == '\\';
      } else {
        escaped = false;
      }
      ++this.pos;
    }
    String content = inputSubstring(start, this.pos);
    ++this.pos;
    // Need to use `readWord1` because '\\uXXXX' sequences are allowed
    // here (don't ask).
    String mods = this.readWord1();
    if (mods != null) {
      String validFlags = "gim";
      if (this.options.ecmaVersion() >= 6) validFlags = "gimuy";
      if (this.options.ecmaVersion() >= 9) validFlags = "gimsuy";
      if (!mods.matches("^[" + validFlags + "]*$"))
        this.raise(start, "Invalid regular expression flag");
      if (mods.indexOf('u') >= 0) {
        Matcher m = Pattern.compile("\\\\u\\{([0-9a-fA-F]+)\\}").matcher(content);
        while (m.find()) {
          try {
            int code = Integer.parseInt(m.group(1), 16);
            if (code > 0x10FFFF)
              this.raiseRecoverable(start + m.start() + 3, "Code point out of bounds");
          } catch (NumberFormatException nfe) {
            Exceptions.ignore(nfe, "Don't complain about code points we don't understand.");
          }
        }
      }
    }
    return this.finishToken(TokenType.regexp, content);
  }

  // Read an integer in the given radix. Return null if zero digits
  // were read, the integer value otherwise. When `len` is given, this
  // will return `null` unless the integer has exactly `len` digits.
  protected Number readInt(int radix, Integer len) {
    int start = this.pos;
    double total = 0;
    for (int i = 0, e = len == null ? Integer.MAX_VALUE : len; i < e; ++i) {
      if (this.pos >= this.input.length()) break;
      int code = this.input.charAt(this.pos), val;
      if (code >= 97) val = code - 97 + 10; // a
      else if (code >= 65) val = code - 65 + 10; // A
      else if (code >= 48 && code <= 57) val = code - 48; // 0-9
      else val = Integer.MAX_VALUE;
      if (val >= radix) break;
      ++this.pos;
      total = total * radix + val;
    }
    if (this.pos == start || len != null && this.pos - start != len) return null;

    return total;
  }

  protected Token readRadixNumber(int radix) {
    this.pos += 2; // 0x
    Number val = this.readInt(radix, null);
    if (val == null) this.raise(this.start + 2, "Expected number in radix " + radix);

    // check for bigint literal
    if (options.esnext() && this.fullCharCodeAtPos() == 'n') {
      ++this.pos;
      return this.finishToken(TokenType.bigint, val);
    }

    if (Identifiers.isIdentifierStart(this.fullCharCodeAtPos(), false))
      this.raise(this.pos, "Identifier directly after number");
    return this.finishToken(TokenType.num, val);
  }

  // Read an integer, octal integer, or floating-point number.
  protected Token readNumber(boolean startsWithDot) {
    int start = this.pos;
    boolean isFloat = false, octal = charAt(this.pos) == 48, isBigInt = false;
    if (!startsWithDot && this.readInt(10, null) == null) this.raise(start, "Invalid number");
    if (octal && this.pos == start + 1) octal = false;

    if (this.pos < this.input.length()) {
      int next = this.input.charAt(this.pos);
      if (next == 46 && !octal) { // '.'
        ++this.pos;
        this.readInt(10, null);
        isFloat = true;
        next = charAt(this.pos);
      }
      if ((next == 69 || next == 101) && !octal) { // 'eE'
        next = charAt(++this.pos);
        if (next == 43 || next == 45) ++this.pos; // '+-'
        if (this.readInt(10, null) == null) this.raise(start, "Invalid number");
        isFloat = true;
      }
      if (!isFloat && options.esnext() && this.fullCharCodeAtPos() == 'n') isBigInt = true;
      else if (Identifiers.isIdentifierStart(this.fullCharCodeAtPos(), false))
        this.raise(this.pos, "Identifier directly after number");
    }

    String str = inputSubstring(start, this.pos);
    if (seenUnderscoreNumericSeparator) {
      str = str.replace("_", "");
      seenUnderscoreNumericSeparator = false;
    }
    Number val = null;
    if (isFloat) val = parseFloat(str);
    else if (!octal || str.length() == 1) val = parseInt(str, 10);
    else if (str.matches(".*[89].*") || this.strict) this.raise(start, "Invalid number");
    else val = parseInt(str, 8);

    // handle bigints
    if (isBigInt) {
      ++this.pos;
      return this.finishToken(TokenType.bigint, val);
    }

    return this.finishToken(TokenType.num, val);
  }

  // Read a string value, interpreting backslash-escapes.
  protected int readCodePoint() {
    int ch = charAt(this.pos), code;

    if (ch == 123) {
      if (this.options.ecmaVersion() < 6) this.unexpected();
      int codePos = ++this.pos;
      code = this.readHexChar(this.input.indexOf('}', this.pos) - this.pos);
      ++this.pos;
      if (code > 0x10FFFF) this.invalidStringToken(codePos, "Code point out of bounds");
    } else {
      code = this.readHexChar(4);
    }
    return code;
  }

  protected String codePointToString(int code) {
    // UTF-16 Decoding
    if (code <= 0xFFFF) return String.valueOf((char) code);
    code -= 0x10000;
    return new String(new char[] {(char) ((code >> 10) + 0xD800), (char) ((code & 1023) + 0xDC00)});
  }

  protected Token readString(char quote) {
    StringBuilder out = new StringBuilder();
    int chunkStart = ++this.pos;
    for (; ; ) {
      if (this.pos >= this.input.length()) this.raise(this.start, "Unterminated string constant");
      int ch = this.input.charAt(this.pos);
      if (ch == quote) break;
      if (ch == 92) { // '\'
        out.append(inputSubstring(chunkStart, this.pos));
        out.append(this.readEscapedChar(false));
        chunkStart = this.pos;
      } else if (options.ecmaVersion() >= 10 && (ch == 0x2028 || ch == 0x2029)) {
        // ECMAScript 2019 allows Unicode newlines in string literals
        ++this.pos;
      } else {
        if (Whitespace.isNewLine(ch)) this.raise(this.start, "Unterminated string constant");
        ++this.pos;
      }
    }
    out.append(inputSubstring(chunkStart, this.pos++));
    return this.finishToken(TokenType.string, out.toString());
  }

  // Reads template string tokens.
  private static final RuntimeException INVALID_TEMPLATE_ESCAPE_ERROR = new RuntimeException();

  private Token tryReadTemplateToken() {
    this.inTemplateElement = true;
    try {
      return this.readTmplToken();
    } catch (RuntimeException err) {
      if (err == INVALID_TEMPLATE_ESCAPE_ERROR) {
        return this.readInvalidTemplateToken();
      } else {
        throw err;
      }
    } finally {
      this.inTemplateElement = false;
    }
  }

  private void invalidStringToken(int position, String message) {
    if (this.inTemplateElement && this.options.ecmaVersion() >= 9) {
      throw INVALID_TEMPLATE_ESCAPE_ERROR;
    } else {
      this.raise(position, message);
    }
  }

  protected Token readTmplToken() {
    StringBuilder out = new StringBuilder();
    int chunkStart = this.pos;
    for (; ; ) {
      if (this.pos >= this.input.length()) this.raise(this.start, "Unterminated template");
      int ch = this.input.charAt(this.pos);
      if (ch == 96 || ch == 36 && charAt(this.pos + 1) == 123) { // '`', '${'
        if (this.pos == this.start
            && (this.type == TokenType.template || this.type == TokenType.invalidTemplate)) {
          if (ch == 36) {
            this.pos += 2;
            return this.finishToken(TokenType.dollarBraceL);
          } else {
            ++this.pos;
            return this.finishToken(TokenType.backQuote);
          }
        }
        out.append(inputSubstring(chunkStart, this.pos));
        return this.finishToken(TokenType.template, out.toString());
      }
      if (ch == 92) { // '\'
        out.append(inputSubstring(chunkStart, this.pos));
        out.append(this.readEscapedChar(true));
        chunkStart = this.pos;
      } else if (Whitespace.isNewLine(ch)) {
        out.append(inputSubstring(chunkStart, this.pos));
        ++this.pos;
        switch (ch) {
          case 13:
            if (charAt(this.pos) == 10) ++this.pos;
          case 10:
            out.append('\n');
            break;
          default:
            out.append((char) ch);
            break;
        }
        ++this.curLine;
        this.lineStart = this.pos;
        chunkStart = this.pos;
      } else {
        ++this.pos;
      }
    }
  }

  // Reads a template token to search for the end, without validating any escape sequences
  private Token readInvalidTemplateToken() {
    for (; this.pos < this.input.length(); this.pos++) {
      switch (this.input.charAt(this.pos)) {
        case '\\':
          ++this.pos;
          break;

        case '$':
          if (this.charAt(this.pos + 1) != '{') {
            break;
          }
          // falls through

        case '`':
          return this.finishToken(
              TokenType.invalidTemplate, this.inputSubstring(this.start, this.pos));

          // no default
      }
    }

    this.raise(this.start, "Unterminated template");
    return null;
  }

  // Used to read escaped characters
  protected String readEscapedChar(boolean inTemplate) {
    int ch = charAt(++this.pos);
    ++this.pos;
    switch (ch) {
      case 110:
        return "\n"; // 'n' -> '\n'
      case 114:
        return "\r"; // 'r' -> '\r'
      case 120:
        return String.valueOf((char) this.readHexChar(2)); // 'x'
      case 117:
        return codePointToString(this.readCodePoint()); // 'u'
      case 116:
        return "\t"; // 't' -> '\t'
      case 98:
        return "\b"; // 'b' -> '\b'
      case 118:
        return "\u000b"; // 'v' -> '\u000b'
      case 102:
        return "\f"; // 'f' -> '\f'
      case 13:
        if (charAt(this.pos) == 10) ++this.pos; // '\r\n'
      case 10: // ' \n'
        this.lineStart = this.pos;
        ++this.curLine;
        return "";
      default:
        if (ch >= 48 && ch <= 55) {
          String octalStr = inputSubstring(this.pos - 1, this.pos + 2);
          Matcher m = Pattern.compile("^[0-7]+").matcher(octalStr);
          m.find();
          octalStr = m.group();
          int octal = parseInt(octalStr, 8).intValue();
          if (octal > 255) {
            octalStr = octalStr.substring(0, octalStr.length() - 1);
            octal = parseInt(octalStr, 8).intValue();
          }
          if (!octalStr.equals("0") && (this.strict || inTemplate)) {
            this.invalidStringToken(this.pos - 2, "Octal literal in strict mode");
          }
          this.pos += octalStr.length() - 1;
          return String.valueOf((char) octal);
        }
        return String.valueOf((char) ch);
    }
  }

  // Used to read character escape sequences ('\x', '\\u', '\U').
  protected int readHexChar(int len) {
    int codePos = this.pos;
    Number n = this.readInt(16, len);
    if (n == null) this.invalidStringToken(codePos, "Bad character escape sequence");
    return n.intValue();
  }

  // Read an identifier, and return it as a string. Sets `this.containsEsc`
  // to whether the word contained a '\\u' escape.
  //
  // Incrementally adds only escaped chars, adding other chunks as-is
  // as a micro-optimization.
  protected String readWord1() {
    this.containsEsc = false;
    String word = "";
    boolean first = true;
    int chunkStart = this.pos;
    boolean astral = this.options.ecmaVersion() >= 6;
    while (this.pos < this.input.length()) {
      int ch = this.fullCharCodeAtPos();
      if (Identifiers.isIdentifierChar(ch, astral)) {
        this.pos += ch <= 0xffff ? 1 : 2;
      } else if (ch == 92) { // "\"
        this.containsEsc = true;
        word += inputSubstring(chunkStart, this.pos);
        int escStart = this.pos;
        if (charAt(++this.pos) != 117) // "u"
        this.invalidStringToken(this.pos, "Expecting Unicode escape sequence \\uXXXX");
        ++this.pos;
        int esc = this.readCodePoint();
        if (!(first
            ? Identifiers.isIdentifierStart(esc, astral)
            : Identifiers.isIdentifierChar(esc, astral)))
          this.invalidStringToken(escStart, "Invalid Unicode escape");
        word += codePointToString(esc);
        chunkStart = this.pos;
      } else {
        break;
      }
      first = false;
    }
    return word + inputSubstring(chunkStart, this.pos);
  }

  // Read an identifier or keyword token. Will check for reserved
  // words when necessary.
  protected Token readWord() {
    String word = this.readWord1();
    TokenType type = TokenType.name;
    if ((this.options.ecmaVersion() >= 6 || !this.containsEsc) && this.keywords.contains(word))
      type = TokenType.keywords.get(word);
    return this.finishToken(type, word);
  }

  /// end tokenize.js

  /// begin parseutil.js

  // ## Parser utilities

  // Test whether a statement node is the string literal `"use strict"`.
  protected boolean isUseStrict(Statement stmt) {
    if (!(this.options.ecmaVersion() >= 5 && stmt instanceof ExpressionStatement)) return false;
    Expression e = ((ExpressionStatement) stmt).getExpression();
    if (!(e instanceof Literal)) return false;
    String raw = ((Literal) e).getRaw();
    return raw.length() >= 2 && raw.substring(1, raw.length() - 1).equals("use strict");
  }

  // Predicate that tests whether the next token is of the given
  // type, and if yes, consumes it as a side effect.
  protected boolean eat(TokenType type) {
    if (this.type == type) {
      this.next();
      return true;
    } else {
      return false;
    }
  }

  // Tests whether parsed token is a contextual keyword.
  protected boolean isContextual(String name) {
    return this.type == TokenType.name && Objects.equals(this.value, name);
  }

  // Consumes contextual keyword if possible.
  protected boolean eatContextual(String name) {
    return Objects.equals(this.value, name) && this.eat(TokenType.name);
  }

  // Asserts that following token is given contextual keyword.
  protected void expectContextual(String name) {
    if (!this.eatContextual(name)) this.unexpected();
  }

  private static final Pattern CONTAINS_LINEBREAK =
      Pattern.compile("(?s).*(?:" + lineBreak + ").*");

  // Test whether a semicolon can be inserted at the current position.
  protected boolean canInsertSemicolon() {
    return this.type == TokenType.eof
        || this.type == TokenType.braceR
        || CONTAINS_LINEBREAK.matcher(inputSubstring(this.lastTokEnd, this.start)).matches();
  }

  protected boolean insertSemicolon() {
    if (this.canInsertSemicolon()) {
      if (this.options.onInsertedSemicolon() != null)
        this.options.onInsertedSemicolon().apply(this.lastTokEnd, this.lastTokEndLoc);
      return true;
    }
    return false;
  }

  // Consume a semicolon, or, failing that, see if we are allowed to
  // pretend that there is a semicolon at this position.
  protected void semicolon() {
    if (!this.eat(TokenType.semi) && !this.insertSemicolon()) this.unexpected();
  }

  protected boolean afterTrailingComma(TokenType tokType, boolean notNext) {
    if (this.type == tokType) {
      if (this.options.onTrailingComma() != null)
        this.options.onTrailingComma().apply(this.lastTokStart, this.lastTokStartLoc);
      if (!notNext) this.next();
      return true;
    }
    return false;
  }

  // Expect a token of a given type. If found, consume it, otherwise,
  // raise an unexpected token error.
  protected void expect(TokenType type) {
    if (!this.eat(type)) this.unexpected();
  }

  // Raise an unexpected token error.
  protected void unexpected(Integer pos) {
    this.raise(pos != null ? pos : this.start, "Unexpected token");
  }

  protected void unexpected(Position pos) {
    this.raise(pos, "Unexpected token");
  }

  protected void unexpected() {
    unexpected((Integer) null);
  }

  public static class DestructuringErrors {
    private int shorthandAssign, trailingComma;

    public void reset() {
      this.shorthandAssign = 0;
      this.trailingComma = 0;
    }
  }

  protected boolean checkPatternErrors(
      DestructuringErrors refDestructuringErrors, boolean andThrow) {
    int trailing = refDestructuringErrors != null ? refDestructuringErrors.trailingComma : 0;
    if (!andThrow) return trailing != 0;
    if (trailing != 0) this.raise(trailing, "Comma is not permitted after the rest element");
    return false;
  }

  protected boolean checkExpressionErrors(
      DestructuringErrors refDestructuringErrors, boolean andThrow) {
    int pos = refDestructuringErrors != null ? refDestructuringErrors.shorthandAssign : 0;
    if (!andThrow) return pos != 0;
    if (pos != 0)
      this.raise(pos, "Shorthand property assignments are valid only in destructuring patterns");
    return false;
  }

  private void checkYieldAwaitInDefaultParams() {
    if (this.yieldPos > 0 && (this.awaitPos == 0 || this.yieldPos < this.awaitPos))
      this.raise(this.yieldPos, "Yield expression cannot be a default value");
    if (this.awaitPos > 0) this.raise(this.awaitPos, "Await expression cannot be a default value");
  }

  /// end parseutil.js

  /// begin node.js

  protected <T extends INode> T finishNode(T node) {
    return finishNodeAt(node, this.lastTokEndLoc);
  }

  protected <T extends INode> T finishNodeAt(T node, Position pos) {
    SourceLocation loc = node.getLoc();
    loc.setSource(inputSubstring(loc.getStart().getOffset(), pos.getOffset()));
    loc.setEnd(pos);
    return node;
  }

  /// begin expression.js

  protected static class PropInfo {
    boolean init, get, set;

    boolean is(Property.Kind kind) {
      switch (kind) {
        case INIT:
          return init;
        case GET:
          return get;
        case SET:
          return set;
        default:
          throw new CatastrophicError("Unexpected kind " + kind + ".");
      }
    }

    void set(Property.Kind kind) {
      switch (kind) {
        case INIT:
          init = true;
          break;
        case GET:
          get = true;
          break;
        case SET:
          set = true;
          break;
        default:
          throw new CatastrophicError("Unexpected kind " + kind + ".");
      }
    }
  }

  // Check if property name clashes with already added.
  // Object/class getters and setters are not allowed to clash ---
  // either with each other or with an init property --- and in
  // strict mode, init properties are also not allowed to be repeated.
  private void checkPropClash(Property prop, Map<String, PropInfo> propHash) {
    if (this.options.ecmaVersion() >= 6
        && (prop.isComputed() || prop.isMethod() || prop.isShorthand())) return;

    Expression key = prop.getKey();

    String name;
    if (key instanceof Identifier) name = ((Identifier) key).getName();
    else if (key instanceof Literal) name = ((Literal) key).getStringValue();
    else return;

    Property.Kind kind = prop.getKind();
    if (this.options.ecmaVersion() >= 6) {
      if ("__proto__".equals(name) && kind == Property.Kind.INIT) {
        if (propHash.containsKey(name))
          this.raiseRecoverable(key, "Redefinition of __proto__ property");
        PropInfo pi = new PropInfo();
        pi.set(Property.Kind.INIT);
        propHash.put(name, pi);
      }
      return;
    }

    PropInfo other = propHash.get(name);
    if (other != null) {
      boolean isGetSet = kind.isAccessor;
      if ((this.strict || isGetSet) && other.is(kind) || !(isGetSet ^ other.init))
        this.raiseRecoverable(key, "Redefinition of property");
    } else {
      propHash.put(name, other = new PropInfo());
    }
    other.set(kind);
  }

  // ### Expression parsing

  // These nest, from the most general expression type at the top to
  // 'atomic', nondivisible expression types at the bottom. Most of
  // the functions will simply let the function(s) below them parse,
  // and, *if* the syntactic construct they handle is present, wrap
  // the AST node that the inner parser gave them in another node.

  // Parse a full expression. The optional arguments are used to
  // forbid the `in` operator (in for loops initalization expressions)
  // and provide reference for storing '=' operator inside shorthand
  // property assignment in contexts where both object expression
  // and object pattern might appear (so it's possible to raise
  // delayed syntax error at correct position).
  protected Expression parseExpression(boolean noIn, DestructuringErrors refDestructuringErrors) {
    Position startLoc = this.startLoc;
    Expression expr = this.parseMaybeAssign(noIn, refDestructuringErrors, null);
    if (this.type == TokenType.comma) {
      List<Expression> expressions = CollectionUtil.makeList(expr);
      SequenceExpression node = new SequenceExpression(new SourceLocation(startLoc), expressions);
      while (this.eat(TokenType.comma))
        expressions.add(this.parseMaybeAssign(noIn, refDestructuringErrors, null));
      return this.finishNode(node);
    }
    return expr;
  }

  public interface AfterLeftParse {
    Expression call(Expression left, int startPos, Position startLoc);
  }

  // Parse an assignment expression. This includes applications of
  // operators like `+=`.
  protected Expression parseMaybeAssign(
      boolean noIn, DestructuringErrors refDestructuringErrors, AfterLeftParse afterLeftParse) {
    if (this.inGenerator && this.isContextual("yield")) return this.parseYield();

    boolean ownDestructuringErrors = false;
    if (refDestructuringErrors == null) {
      refDestructuringErrors = new DestructuringErrors();
      ownDestructuringErrors = true;
    }
    int startPos = this.start;
    Position startLoc = this.startLoc;
    if (this.type == TokenType.parenL || this.type == TokenType.name)
      this.potentialArrowAt = this.start;
    Expression left = this.parseMaybeConditional(noIn, refDestructuringErrors);
    if (afterLeftParse != null) left = afterLeftParse.call(left, startPos, startLoc);
    if (this.type.isAssign) {
      this.checkPatternErrors(refDestructuringErrors, true);
      if (!ownDestructuringErrors) refDestructuringErrors.reset();
      Expression l = this.type == TokenType.eq ? (Expression) this.toAssignable(left, false) : left;
      refDestructuringErrors.shorthandAssign =
          0; // reset because shorthand default was used correctly
      String operator = String.valueOf(this.value);
      this.checkLVal(l, false, null);
      this.next();
      Expression r = this.parseMaybeAssign(noIn, null, null);
      AssignmentExpression node =
          new AssignmentExpression(new SourceLocation(startLoc), operator, l, r);
      return this.finishNode(node);
    } else {
      if (ownDestructuringErrors) this.checkExpressionErrors(refDestructuringErrors, true);
    }
    return left;
  }

  // Parse a ternary conditional (`?:`) operator.
  protected Expression parseMaybeConditional(
      boolean noIn, DestructuringErrors refDestructuringErrors) {
    Position startLoc = this.startLoc;
    Expression expr = this.parseExprOps(noIn, refDestructuringErrors);
    if (this.checkExpressionErrors(refDestructuringErrors, false)) return expr;
    if (this.eat(TokenType.question)) {
      return parseConditionalRest(noIn, startLoc, expr);
    }
    return expr;
  }

  protected Expression parseConditionalRest(boolean noIn, Position start, Expression test) {
    Expression consequent = this.parseMaybeAssign(false, null, null);
    this.expect(TokenType.colon);
    Expression alternate = this.parseMaybeAssign(noIn, null, null);
    ConditionalExpression node =
        new ConditionalExpression(new SourceLocation(start), test, consequent, alternate);
    return this.finishNode(node);
  }

  // Start the precedence parser.
  protected Expression parseExprOps(boolean noIn, DestructuringErrors refDestructuringErrors) {
    int startPos = this.start;
    Position startLoc = this.startLoc;
    Expression expr = this.parseMaybeUnary(refDestructuringErrors, false);
    if (this.checkExpressionErrors(refDestructuringErrors, false)) return expr;
    return this.parseExprOp(expr, startPos, startLoc, -1, noIn);
  }

  // Parse binary operators with the operator precedence parsing
  // algorithm. `left` is the left-hand side of the operator.
  // `minPrec` provides context that allows the function to stop and
  // defer further parser to one of its callers when it encounters an
  // operator that has a lower precedence than the set it is parsing.
  protected Expression parseExprOp(
      Expression left, int leftStartPos, Position leftStartLoc, int minPrec, boolean noIn) {
    int prec = this.type.binop;
    if (prec != 0 && (!noIn || this.type != TokenType._in)) {
      if (prec > minPrec) {
        boolean logical = this.type == TokenType.logicalOR || this.type == TokenType.logicalAND;
        String op = String.valueOf(this.value);
        this.next();
        int startPos = this.start;
        Position startLoc = this.startLoc;
        Expression right =
            this.parseExprOp(this.parseMaybeUnary(null, false), startPos, startLoc, prec, noIn);
        Expression node = this.buildBinary(leftStartPos, leftStartLoc, left, right, op, logical);
        return this.parseExprOp(node, leftStartPos, leftStartLoc, minPrec, noIn);
      }
    }
    return left;
  }

  private Expression buildBinary(
      int startPos,
      Position startLoc,
      Expression left,
      Expression right,
      String op,
      boolean logical) {
    SourceLocation loc = new SourceLocation(startLoc);
    Expression node =
        logical
            ? new LogicalExpression(loc, op, left, right)
            : new BinaryExpression(loc, op, left, right);
    return this.finishNode(node);
  }

  // Parse unary operators, both prefix and postfix.
  protected Expression parseMaybeUnary(
      DestructuringErrors refDestructuringErrors, boolean sawUnary) {
    int startPos = this.start;
    Position startLoc = this.startLoc;
    Expression expr;
    if ((this.inAsync || options.esnext() && !this.inFunction) && this.isContextual("await")) {
      expr = this.parseAwait();
      sawUnary = true;
    } else if (this.type.isPrefix) {
      String operator = String.valueOf(this.value);
      boolean update = this.type == TokenType.incDec;
      this.next();
      Expression argument = this.parseMaybeUnary(null, true);
      SourceLocation loc = new SourceLocation(startLoc);
      Expression node =
          update
              ? new UpdateExpression(loc, operator, argument, true)
              : new UnaryExpression(loc, operator, argument, true);
      this.checkExpressionErrors(refDestructuringErrors, true);
      if (update) this.checkLVal(argument, false, null);
      else if (this.strict && operator.equals("delete") && argument instanceof Identifier)
        this.raiseRecoverable(node, "Deleting local variable in strict mode");
      else sawUnary = true;
      expr = this.finishNode(node);
    } else {
      expr = this.parseExprSubscripts(refDestructuringErrors);
      if (this.checkExpressionErrors(refDestructuringErrors, false)) return expr;
      while (this.type.isPostfix && !this.canInsertSemicolon()) {
        UpdateExpression node =
            new UpdateExpression(
                new SourceLocation(startLoc), String.valueOf(this.value), expr, false);
        this.checkLVal(expr, false, null);
        this.next();
        expr = this.finishNode(node);
      }
    }

    if (!sawUnary && this.eat(TokenType.starstar))
      return this.buildBinary(
          startPos, startLoc, expr, this.parseMaybeUnary(null, false), "**", false);
    else return expr;
  }

  // Parse call, dot, and `[]`-subscript expressions.
  protected Expression parseExprSubscripts(DestructuringErrors refDestructuringErrors) {
    int startPos = this.start;
    Position startLoc = this.startLoc;
    Expression expr = this.parseExprAtom(refDestructuringErrors);
    boolean skipArrowSubscripts =
        expr instanceof ArrowFunctionExpression
            && !inputSubstring(this.lastTokStart, this.lastTokEnd).equals(")");
    if (this.checkExpressionErrors(refDestructuringErrors, false) || skipArrowSubscripts)
      return expr;
    return this.parseSubscripts(expr, startPos, startLoc, false);
  }

  protected Expression parseSubscripts(
      Expression base, int startPos, Position startLoc, boolean noCalls) {
    for (; ; ) {
      Pair<Expression, Boolean> p = parseSubscript(base, startLoc, noCalls);
      if (p.snd()) base = p.fst();
      else return p.fst();
    }
  }

  /**
   * Parse a single subscript {@code s}; if more subscripts could follow, return {@code Pair.make(s,
   * true}, otherwise return {@code Pair.make(s, false)}.
   */
  protected Pair<Expression, Boolean> parseSubscript(
      final Expression base, Position startLoc, boolean noCalls) {
    boolean maybeAsyncArrow =
        this.options.ecmaVersion() >= 8
            && base instanceof Identifier
            && "async".equals(((Identifier) base).getName())
            && !this.canInsertSemicolon();
    boolean optional = this.eat(TokenType.questiondot);
    if (this.eat(TokenType.bracketL)) {
      MemberExpression node =
          new MemberExpression(
              new SourceLocation(startLoc),
              base,
              this.parseExpression(false, null),
              true,
              optional,
              Chainable.isOnOptionalChain(optional, base));
      this.expect(TokenType.bracketR);
      return Pair.make(this.finishNode(node), true);
    } else if (!noCalls && this.eat(TokenType.parenL)) {
      DestructuringErrors refDestructuringErrors = new DestructuringErrors();
      int oldYieldPos = this.yieldPos, oldAwaitPos = this.awaitPos;
      this.yieldPos = 0;
      this.awaitPos = 0;
      List<Expression> exprList =
          this.parseExprList(
              TokenType.parenR, this.options.ecmaVersion() >= 8, false, refDestructuringErrors);
      if (maybeAsyncArrow && shouldParseAsyncArrow()) {
        this.checkPatternErrors(refDestructuringErrors, true);
        this.checkYieldAwaitInDefaultParams();
        this.yieldPos = oldYieldPos;
        this.awaitPos = oldAwaitPos;
        return Pair.make(this.parseArrowExpression(startLoc, exprList, true), false);
      }
      this.checkExpressionErrors(refDestructuringErrors, true);
      if (oldYieldPos > 0) this.yieldPos = oldYieldPos;
      if (oldAwaitPos > 0) this.awaitPos = oldAwaitPos;
      CallExpression node =
          new CallExpression(
              new SourceLocation(startLoc),
              base,
              new ArrayList<>(),
              exprList,
              optional,
              Chainable.isOnOptionalChain(optional, base));
      return Pair.make(this.finishNode(node), true);
    } else if (this.type == TokenType.backQuote) {
      if (Chainable.isOnOptionalChain(optional, base)) {
        this.raise(base, "An optional chain may not be used in a tagged template expression.");
      }
      TaggedTemplateExpression node =
          new TaggedTemplateExpression(
              new SourceLocation(startLoc), base, this.parseTemplate(true));
      return Pair.make(this.finishNode(node), true);
    } else if (optional || this.eat(TokenType.dot)) {
      MemberExpression node =
          new MemberExpression(
              new SourceLocation(startLoc),
              base,
              this.parseIdent(true),
              false,
              optional,
              Chainable.isOnOptionalChain(optional, base));
      return Pair.make(this.finishNode(node), true);
    } else {
      return Pair.make(base, false);
    }
  }

  protected boolean shouldParseAsyncArrow() {
    return !this.canInsertSemicolon() && this.eat(TokenType.arrow);
  }

  // Parse an atomic expression --- either a single token that is an
  // expression, an expression started by a keyword like `function` or
  // `new`, or an expression wrapped in punctuation like `()`, `[]`,
  // or `{}`.
  protected Expression parseExprAtom(DestructuringErrors refDestructuringErrors) {
    Expression node;
    boolean canBeArrow = this.potentialArrowAt == this.start;
    if (this.type == TokenType._super) {
      if (!this.inFunction) this.raise(this.start, "'super' outside of function or class");
      node = new Super(new SourceLocation(this.startLoc));
      this.next();
      return this.finishNode(node);
    } else if (this.type == TokenType._this) {
      node = new ThisExpression(new SourceLocation(this.startLoc));
      this.next();
      return this.finishNode(node);
    } else if (this.type == TokenType.name) {
      Position startLoc = this.startLoc;
      Identifier id = this.parseIdent(this.type != TokenType.name);
      if (this.options.ecmaVersion() >= 8
          && "async".equals(id.getName())
          && !this.canInsertSemicolon()
          && this.eat(TokenType._function))
        return (Expression) this.parseFunction(startLoc, false, false, true);
      if (canBeArrow && !this.canInsertSemicolon()) {
        if (this.eat(TokenType.arrow))
          return this.parseArrowExpression(startLoc, CollectionUtil.makeList(id), false);
        if (this.options.ecmaVersion() >= 8
            && id.getName().equals("async")
            && this.type == TokenType.name) {
          id = this.parseIdent(false);
          if (this.canInsertSemicolon() || !this.eat(TokenType.arrow)) this.unexpected();
          return this.parseArrowExpression(startLoc, CollectionUtil.makeList(id), true);
        }
      }
      return id;
    } else if (this.type == TokenType.regexp
        || this.type == TokenType.num
        || this.type == TokenType.string
        || this.type == TokenType.bigint) {
      return this.parseLiteral(this.type, this.value);
    } else if (this.type == TokenType._null
        || this.type == TokenType._true
        || this.type == TokenType._false) {
      Object val = this.type == TokenType._null ? null : this.type == TokenType._true;
      node = new Literal(new SourceLocation(this.type.keyword, startLoc), this.type, val);
      this.next();
      return this.finishNode(node);
    } else if (this.type == TokenType.parenL) {
      return this.parseParenAndDistinguishExpression(canBeArrow);
    } else if (this.type == TokenType.bracketL) {
      Position startLoc = this.startLoc;
      this.next();
      List<Expression> elements =
          this.parseExprList(TokenType.bracketR, true, true, refDestructuringErrors);
      node = new ArrayExpression(new SourceLocation(startLoc), elements);
      return this.finishNode(node);
    } else if (this.type == TokenType.braceL) {
      return this.parseObj(false, refDestructuringErrors);
    } else if (this.type == TokenType._function) {
      Position startLoc = this.startLoc;
      this.next();
      return (Expression) this.parseFunction(startLoc, false, false, false);
    } else if (this.type == TokenType._class) {
      return (Expression) this.parseClass(this.startLoc, false);
    } else if (this.type == TokenType._new) {
      return this.parseNew();
    } else if (this.type == TokenType.backQuote) {
      return this.parseTemplate(false);
    } else {
      this.unexpected();
      return null;
    }
  }

  protected Literal parseLiteral(TokenType tokenType, Object value) {
    SourceLocation loc = new SourceLocation(inputSubstring(this.start, this.end), this.startLoc);
    Literal node = new Literal(loc, tokenType, value);
    this.next();
    return this.finishNode(node);
  }

  protected Expression parseParenExpression() {
    this.expect(TokenType.parenL);
    Expression val = this.parseExpression(false, null);
    this.expect(TokenType.parenR);
    return val;
  }

  protected Expression parseParenAndDistinguishExpression(boolean canBeArrow) {
    Position startLoc = this.startLoc;
    Expression val;
    if (this.options.ecmaVersion() >= 6) {
      this.next();

      DestructuringErrors refDestructuringErrors = new DestructuringErrors();
      int oldYieldPos = this.yieldPos, oldAwaitPos = this.awaitPos;
      ParenthesisedExpressions parenExprs = parseParenthesisedExpressions(refDestructuringErrors);

      if (canBeArrow && !this.canInsertSemicolon() && this.eat(TokenType.arrow)) {
        this.checkPatternErrors(refDestructuringErrors, true);
        this.checkYieldAwaitInDefaultParams();
        if (parenExprs.innerParenStart != 0) this.unexpected(parenExprs.innerParenStart);
        this.yieldPos = oldYieldPos;
        this.awaitPos = oldAwaitPos;
        return this.parseParenArrowList(startLoc, parenExprs.exprList);
      }

      if (parenExprs.exprList.isEmpty() || parenExprs.lastIsComma)
        this.unexpected(this.lastTokStart);
      if (parenExprs.spreadStart != 0) this.unexpected(parenExprs.spreadStart);
      this.checkExpressionErrors(refDestructuringErrors, true);
      if (oldYieldPos > 0) this.yieldPos = oldYieldPos;
      if (oldAwaitPos > 0) this.awaitPos = oldAwaitPos;

      if (parenExprs.exprList.size() > 1) {
        val = new SequenceExpression(new SourceLocation(parenExprs.startLoc), parenExprs.exprList);
        this.finishNodeAt(val, parenExprs.endLoc);
      } else {
        val = parenExprs.exprList.get(0);
      }
    } else {
      val = this.parseParenExpression();
    }

    if (this.options.preserveParens()) {
      ParenthesizedExpression par = new ParenthesizedExpression(new SourceLocation(startLoc), val);
      return this.finishNode(par);
    } else {
      return val;
    }
  }

  /** Information about a list of expressions between parentheses. */
  protected static class ParenthesisedExpressions {
    /** If non-zero, indicates the location of a spread expression in the list. */
    int spreadStart = 0;

    /** If non-zero, indicates the location of a parenthesised expression in the list. */
    int innerParenStart = 0;

    /**
     * The start position (i.e., right after the opening parenthesis) and end location (i.e., before
     * the closing parenthesis) of the list.
     */
    Position startLoc, endLoc;

    /** The list itself. */
    List<Expression> exprList = new ArrayList<Expression>();

    boolean lastIsComma;
  }

  protected ParenthesisedExpressions parseParenthesisedExpressions(
      DestructuringErrors refDestructuringErrors) {
    boolean allowTrailingComma = this.options.ecmaVersion() >= 8;
    ParenthesisedExpressions parenExprs = new ParenthesisedExpressions();
    parenExprs.startLoc = this.startLoc;
    boolean first = true;
    this.yieldPos = 0;
    this.awaitPos = 0;
    while (this.type != TokenType.parenR) {
      if (first) first = false;
      else this.expect(TokenType.comma);
      if (!parseParenthesisedExpression(
          refDestructuringErrors, allowTrailingComma, parenExprs, first)) break;
    }
    parenExprs.endLoc = this.startLoc;
    this.expect(TokenType.parenR);
    return parenExprs;
  }

  /**
   * Parse an expression that forms part of a comma-separated list of expressions between
   * parentheses, adding it to `parenExprs`.
   *
   * @return true if more expressions may follow this one, false if it must be the last one
   */
  protected boolean parseParenthesisedExpression(
      DestructuringErrors refDestructuringErrors,
      boolean allowTrailingComma,
      ParenthesisedExpressions parenExprs,
      boolean first) {
    if (allowTrailingComma && this.afterTrailingComma(TokenType.parenR, true)) {
      parenExprs.lastIsComma = true;
      return false;
    } else if (this.type == TokenType.ellipsis) {
      parenExprs.spreadStart = this.start;
      parenExprs.exprList.add(this.parseParenItem(this.parseRest(false), -1, null));
      if (this.type == TokenType.comma)
        this.raise(this.startLoc, "Comma is not permitted after the rest element");
      return false;
    } else {
      if (this.type == TokenType.parenL && parenExprs.innerParenStart == 0) {
        parenExprs.innerParenStart = this.start;
      }
      parenExprs.exprList.add(
          this.parseMaybeAssign(false, refDestructuringErrors, this::parseParenItem));
    }
    return true;
  }

  protected Expression parseParenItem(Expression left, int startPos, Position startLoc) {
    return left;
  }

  protected Expression parseParenArrowList(Position startLoc, List<Expression> exprList) {
    return this.parseArrowExpression(startLoc, exprList, false);
  }

  // New's precedence is slightly tricky. It must allow its argument to
  // be a `[]` or dot subscript expression, but not a call --- at least,
  // not without wrapping it in parentheses. Thus, it uses the noCalls
  // argument to parseSubscripts to prevent it from consuming the
  // argument list.
  protected Expression parseNew() {
    Position startLoc = this.startLoc;
    Identifier meta = this.parseIdent(true);
    if (this.options.ecmaVersion() >= 6 && this.eat(TokenType.dot)) {
      Identifier property = this.parseIdent(true);
      if (!property.getName().equals("target"))
        this.raiseRecoverable(property, "The only valid meta property for new is new.target");
      if (!this.inFunction) this.raiseRecoverable(meta, "new.target can only be used in functions");
      MetaProperty node = new MetaProperty(new SourceLocation(startLoc), meta, property);
      return this.finishNode(node);
    }
    int innerStartPos = this.start;
    Position innerStartLoc = this.startLoc;
    Expression callee =
        this.parseSubscripts(this.parseExprAtom(null), innerStartPos, innerStartLoc, true);

    if (Chainable.isOnOptionalChain(false, callee))
      this.raise(callee, "An optional chain may not be used in a `new` expression.");

    return parseNewArguments(startLoc, callee);
  }

  protected Expression parseNewArguments(Position startLoc, Expression callee) {
    List<Expression> arguments;
    if (this.eat(TokenType.parenL))
      arguments =
          this.parseExprList(TokenType.parenR, this.options.ecmaVersion() >= 8, false, null);
    else arguments = new ArrayList<Expression>();
    NewExpression node =
        new NewExpression(new SourceLocation(startLoc), callee, new ArrayList<>(), arguments);
    return this.finishNode(node);
  }

  // Parse template expression.
  protected TemplateElement parseTemplateElement(boolean isTagged) {
    Position startLoc = this.startLoc;
    String raw, cooked;
    if (this.type == TokenType.invalidTemplate) {
      if (!isTagged) {
        this.raiseRecoverable(this.start, "Bad escape sequence in untagged template literal");
      }
      raw = String.valueOf(this.value);
      cooked = null;
    } else {
      raw = inputSubstring(this.start, this.end).replaceAll("\r\n?", "\n");
      cooked = String.valueOf(this.value);
    }
    this.next();
    boolean tail = this.type == TokenType.backQuote;
    TemplateElement elem = new TemplateElement(new SourceLocation(startLoc), cooked, raw, tail);
    return this.finishNode(elem);
  }

  protected TemplateLiteral parseTemplate(boolean isTagged) {
    Position startLoc = this.startLoc;
    this.next();
    List<Expression> expressions = new ArrayList<Expression>();
    TemplateElement curElt = this.parseTemplateElement(isTagged);
    List<TemplateElement> quasis = CollectionUtil.makeList(curElt);
    while (!curElt.isTail()) {
      this.expect(TokenType.dollarBraceL);
      expressions.add(this.parseExpression(false, null));
      this.expect(TokenType.braceR);
      quasis.add(curElt = this.parseTemplateElement(isTagged));
    }
    this.next();
    TemplateLiteral node = new TemplateLiteral(new SourceLocation(startLoc), expressions, quasis);
    return this.finishNode(node);
  }

  /*
   * Auxiliary class used to collect information about properties during parsing.
   *
   * This is needed because parsing properties and methods requires a fair bit of lookahead.
   */
  protected static class PropertyInfo {
    Expression key, value;
    String kind = "init";
    boolean computed = false, method = false, isPattern, isGenerator, isAsync;
    Position startLoc;

    public PropertyInfo(boolean isPattern, boolean isGenerator, Position startLoc) {
      this.isPattern = isPattern;
      this.isGenerator = isGenerator;
      this.startLoc = startLoc;
    }

    MethodDefinition.Kind getMethodKind() {
      return MethodDefinition.Kind.valueOf(StringUtil.uc(kind));
    }
  }

  // Parse an object literal or binding pattern.
  protected Expression parseObj(boolean isPattern, DestructuringErrors refDestructuringErrors) {
    Position startLoc = this.startLoc;
    boolean first = true;
    Map<String, PropInfo> propHash = new LinkedHashMap<>();
    List<Property> properties = new ArrayList<Property>();
    this.next();
    while (!this.eat(TokenType.braceR)) {
      if (!first) {
        this.expect(TokenType.comma);
        if (this.afterTrailingComma(TokenType.braceR, false)) break;
      } else {
        first = false;
      }

      properties.add(this.finishNode(parseProperty(isPattern, refDestructuringErrors, propHash)));
    }
    SourceLocation loc = new SourceLocation(startLoc);
    Expression node =
        isPattern ? new ObjectPattern(loc, properties) : new ObjectExpression(loc, properties);
    return this.finishNode(node);
  }

  protected Property parseProperty(
      boolean isPattern,
      DestructuringErrors refDestructuringErrors,
      Map<String, PropInfo> propHash) {
    Position propStartLoc = this.startLoc;
    boolean isGenerator = false;
    if (this.options.ecmaVersion() >= 6) {
      if (!isPattern) isGenerator = this.eat(TokenType.star);
    }
    PropertyInfo pi = new PropertyInfo(isPattern, isGenerator, propStartLoc);
    this.parsePropertyName(pi);
    if (!isPattern && this.options.ecmaVersion() >= 8 && !isGenerator && this.isAsyncProp(pi)) {
      pi.isAsync = true;
      pi.isGenerator = this.eat(TokenType.star);
      this.parsePropertyName(pi);
    } else {
      pi.isAsync = false;
    }
    this.parsePropertyValue(pi, refDestructuringErrors);
    Property prop =
        new Property(
            new SourceLocation(pi.startLoc), pi.key, pi.value, pi.kind, pi.computed, pi.method);
    this.checkPropClash(prop, propHash);
    return prop;
  }

  private boolean isAsyncProp(PropertyInfo pi) {
    return !pi.computed
        && pi.key instanceof Identifier
        && ((Identifier) pi.key).getName().equals("async")
        && (this.type == TokenType.name
            || this.type == TokenType.num
            || this.type == TokenType.string
            || this.type == TokenType.bracketL
            || this.type == TokenType.star
            || this.type.keyword != null)
        && !this.canInsertSemicolon();
  }

  protected void parsePropertyValue(PropertyInfo pi, DestructuringErrors refDestructuringErrors) {
    if ((pi.isGenerator || pi.isAsync) && this.type == TokenType.colon) this.unexpected();

    if (this.eat(TokenType.colon)) {
      pi.value =
          pi.isPattern
              ? this.parseMaybeDefault(this.startLoc, null)
              : this.parseMaybeAssign(false, refDestructuringErrors, null);
      pi.kind = "init";
    } else if (this.options.ecmaVersion() >= 6 && this.type == TokenType.parenL) {
      if (pi.isPattern) this.unexpected();
      pi.kind = "init";
      pi.method = true;
      pi.value = this.parseMethod(pi.isGenerator, pi.isAsync);
    } else if (this.options.ecmaVersion() >= 5
        && !pi.computed
        && pi.key instanceof Identifier
        && (((Identifier) pi.key).getName().equals("get")
            || ((Identifier) pi.key).getName().equals("set"))
        && (this.type != TokenType.comma && this.type != TokenType.braceR)) {
      if (pi.isGenerator || pi.isAsync || pi.isPattern) this.unexpected();
      pi.kind = ((Identifier) pi.key).getName();
      PropertyInfo pi2 = new PropertyInfo(false, false, this.startLoc);
      this.parsePropertyName(pi2);
      pi.key = pi2.key;
      pi.computed = pi2.computed;
      pi.value = this.parseMethod(false, false);
      int paramCount = pi.kind.equals("get") ? 0 : 1;
      FunctionExpression fn = (FunctionExpression) pi.value;
      List<Expression> params = fn.getRawParameters();
      if (params.size() != paramCount) {
        if (pi.kind.equals("get")) this.raiseRecoverable(pi.value, "getter should have no params");
        else this.raiseRecoverable(pi.value, "setter should have exactly one param");
      }
      if (pi.kind.equals("set") && fn.hasRest())
        this.raiseRecoverable(params.get(params.size() - 1), "Setter cannot use rest params");
    } else if (this.options.ecmaVersion() >= 6 && !pi.computed && pi.key instanceof Identifier) {
      String name = ((Identifier) pi.key).getName();
      if (this.keywords.contains(name)
          || (this.strict ? this.reservedWordsStrict : this.reservedWords).contains(name)
          || (this.inGenerator && name.equals("yield"))
          || (this.inAsync && name.equals("await")))
        this.raiseRecoverable(pi.key, "'" + name + "' can not be used as shorthand property");
      pi.kind = "init";
      if (pi.isPattern) {
        pi.value = this.parseMaybeDefault(pi.startLoc, pi.key);
      } else if (this.type == TokenType.eq && refDestructuringErrors != null) {
        if (refDestructuringErrors.shorthandAssign == 0)
          refDestructuringErrors.shorthandAssign = this.start;
        pi.value = this.parseMaybeDefault(pi.startLoc, pi.key);
      } else {
        pi.value = pi.key;
      }
    } else {
      this.unexpected();
    }
  }

  protected void parsePropertyName(PropertyInfo result) {
    if (this.options.ecmaVersion() >= 6) {
      if (this.eat(TokenType.bracketL)) {
        result.key = this.parseMaybeAssign(false, null, null);
        result.computed = true;
        this.expect(TokenType.bracketR);
        return;
      }
    }
    if (this.type == TokenType.num || this.type == TokenType.string)
      result.key = this.parseExprAtom(null);
    else result.key = this.parseIdent(true);
  }

  // Parse object or class method.
  protected FunctionExpression parseMethod(boolean isGenerator, boolean isAsync) {
    Position startLoc = this.startLoc;
    boolean oldInGen = this.inGenerator, oldInAsync = this.inAsync;
    int oldYieldPos = this.yieldPos, oldAwaitPos = this.awaitPos;

    this.inGenerator = isGenerator;
    this.inAsync = isAsync;
    this.yieldPos = 0;
    this.awaitPos = 0;

    this.expect(TokenType.parenL);
    List<Expression> params =
        this.parseBindingList(TokenType.parenR, false, this.options.ecmaVersion() >= 8, false);
    this.checkYieldAwaitInDefaultParams();
    boolean generator = this.options.ecmaVersion() >= 6 && isGenerator;
    Node body = this.parseFunctionBody(null, params, false);

    this.inGenerator = oldInGen;
    this.inAsync = oldInAsync;
    this.yieldPos = oldYieldPos;
    this.awaitPos = oldAwaitPos;
    Identifier id = null;
    FunctionExpression node =
        new FunctionExpression(new SourceLocation(startLoc), id, params, body, generator, isAsync);
    return this.finishNode(node);
  }

  // Parse arrow function expression with given parameters.
  protected ArrowFunctionExpression parseArrowExpression(
      Position startLoc, List<Expression> rawParams, boolean isAsync) {
    boolean oldInGen = this.inGenerator, oldInAsync = this.inAsync;
    int oldYieldPos = this.yieldPos, oldAwaitPos = this.awaitPos;

    this.inGenerator = false;
    this.inAsync = isAsync;
    this.yieldPos = 0;
    this.awaitPos = 0;

    List<Expression> params = this.toAssignableList(rawParams, true);
    Node body = this.parseFunctionBody(null, params, true);

    this.inGenerator = oldInGen;
    this.inAsync = oldInAsync;
    this.yieldPos = oldYieldPos;
    this.awaitPos = oldAwaitPos;
    ArrowFunctionExpression node =
        new ArrowFunctionExpression(new SourceLocation(startLoc), params, body, false, isAsync);
    return this.finishNode(node);
  }

  // Parse function body and check parameters.
  protected Node parseFunctionBody(
      Identifier id, List<Expression> params, boolean isArrowFunction) {
    boolean isExpression = isArrowFunction && this.type != TokenType.braceL;
    Node body;
    if (isExpression) {
      body = this.parseMaybeAssign(false, null, null);
    } else {
      // Start a new scope with regard to labels and the `inFunction`
      // flag (restore them to their old value afterwards).
      boolean oldInFunc = this.inFunction;
      Stack<LabelInfo> oldLabels = this.labels;
      this.inFunction = true;
      this.labels = new Stack<LabelInfo>();
      body = this.parseBlock(true);
      this.inFunction = oldInFunc;
      this.labels = oldLabels;
    }

    // If this is a strict mode function, verify that argument names
    // are not repeated, and it does not try to bind the words `eval`
    // or `arguments`.
    Statement useStrict = null;
    if (!isExpression && body instanceof BlockStatement) {
      List<Statement> bodyStmts = ((BlockStatement) body).getBody();
      if (!bodyStmts.isEmpty() && isUseStrict(bodyStmts.get(0))) useStrict = bodyStmts.get(0);
    }
    if (useStrict != null && options.ecmaVersion() >= 7 && !isSimpleParamList(params))
      raiseRecoverable(
          useStrict, "Illegal 'use strict' directive in function with non-simple parameter list");

    if (this.strict || useStrict != null) {
      boolean oldStrict = this.strict;
      this.strict = true;
      if (id != null) this.checkLVal(id, true, null);
      this.checkParams(params);
      this.strict = oldStrict;
    } else if (isArrowFunction || !isSimpleParamList(params)) {
      this.checkParams(params);
    }

    return body;
  }

  private boolean isSimpleParamList(List<Expression> params) {
    for (Expression param : params) if (!(param instanceof Identifier)) return false;
    return true;
  }

  // Checks function params for various disallowed patterns such as using "eval"
  // or "arguments" and duplicate parameters.
  protected void checkParams(List<? extends INode> params) {
    Set<String> nameHash = new LinkedHashSet<>();
    for (INode param : params) this.checkLVal(param, true, nameHash);
  }

  // Parses a comma-separated list of expressions, and returns them as
  // an array. `close` is the token type that ends the list, and
  // `allowEmpty` can be turned on to allow subsequent commas with
  // nothing in between them to be parsed as `null` (which is needed
  // for array literals).
  protected List<Expression> parseExprList(
      TokenType close,
      boolean allowTrailingComma,
      boolean allowEmpty,
      DestructuringErrors refDestructuringErrors) {
    List<Expression> elts = new ArrayList<Expression>();
    boolean first = true;
    while (!this.eat(close)) {
      if (!first) {
        this.expect(TokenType.comma);
        if (allowTrailingComma && this.afterTrailingComma(close, false)) break;
      } else {
        first = false;
      }

      Expression elt;
      if (allowEmpty && this.type == TokenType.comma) {
        elt = null;
      } else if (this.type == TokenType.ellipsis) {
        elt = this.processExprListItem(this.parseSpread(refDestructuringErrors));
        if (this.type == TokenType.comma
            && refDestructuringErrors != null
            && refDestructuringErrors.trailingComma == 0) {
          refDestructuringErrors.trailingComma = this.start;
        }
      } else
        elt = this.processExprListItem(this.parseMaybeAssign(false, refDestructuringErrors, null));
      elts.add(elt);
    }
    return elts;
  }

  protected Expression processExprListItem(Expression e) {
    return e;
  }

  // Parse the next token as an identifier. If `liberal` is true (used
  // when parsing properties), it will also convert keywords into
  // identifiers.
  protected Identifier parseIdent(boolean liberal) {
    Position startLoc = this.startLoc;
    boolean isPrivateField = liberal && this.eat(TokenType.pound);
    if (liberal && this.options.allowReserved() == AllowReserved.NEVER) liberal = false;
    String name = null;
    if (this.type == TokenType.name) {
      if (!liberal
          && (this.strict ? this.reservedWordsStrict : this.reservedWords).contains(this.value)
          && (this.options.ecmaVersion() >= 6
              || inputSubstring(this.start, this.end).indexOf("\\") == -1))
        this.raiseRecoverable(this.start, "The keyword '" + this.value + "' is reserved");
      if (!isPrivateField && this.inGenerator && this.value.equals("yield"))
        this.raiseRecoverable(this.start, "Can not use 'yield' as identifier inside a generator");
      if (!isPrivateField && this.inAsync && this.value.equals("await"))
        this.raiseRecoverable(
            this.start, "Can not use 'await' as identifier inside an async function");
      name = String.valueOf(this.value);
    } else if (this.type.keyword != null) {
      name = this.type.keyword;
      if (!liberal)
        raiseRecoverable(this.start, "Cannot use keyword '" + name + "' as an identifier.");
    } else {
      this.unexpected();
    }
    this.next();
    if (isPrivateField) {
      if (!this.inClass) {
        this.raiseRecoverable(this.start, "Cannot use private fields outside a class");
      }
      name = "#" + name;
    }
    Identifier node = new Identifier(new SourceLocation(startLoc), name);
    return this.finishNode(node);
  }

  // Parses yield expression inside generator.
  protected YieldExpression parseYield() {
    if (this.awaitPos == 0) this.awaitPos = this.start;

    Position startLoc = this.startLoc;
    this.next();
    boolean delegate;
    Expression argument;
    if (this.type == TokenType.semi
        || this.canInsertSemicolon()
        || (this.type != TokenType.star && !this.type.startsExpr)) {
      delegate = false;
      argument = null;
    } else {
      delegate = this.eat(TokenType.star);
      argument = this.parseMaybeAssign(false, null, null);
    }
    YieldExpression node = new YieldExpression(new SourceLocation(startLoc), argument, delegate);
    return this.finishNode(node);
  }

  protected AwaitExpression parseAwait() {
    Position startLoc = this.startLoc;
    this.next();
    Expression argument = this.parseMaybeUnary(null, true);
    AwaitExpression node = new AwaitExpression(new SourceLocation(startLoc), argument);
    return this.finishNode(node);
  }

  /// end expression.js

  /// begin lval.js

  // Convert existing expression atom to assignable pattern
  // if possible.
  protected INode toAssignable(INode node, boolean isBinding) {
    if (this.options.ecmaVersion() >= 6 && node != null) {
      if (node instanceof Identifier) {
        if (this.inAsync && ((Identifier) node).getName().equals("await"))
          this.raise(node, "Can not use 'await' as identifier inside an async function");
        return node;
      }

      if (node instanceof ObjectPattern || node instanceof ArrayPattern) {
        return node;
      }

      if (node instanceof ObjectExpression) {
        List<Property> properties = new ArrayList<Property>();
        for (Property prop : ((ObjectExpression) node).getProperties()) {
          if (prop.getKind().isAccessor)
            this.raise(prop.getKey(), "Object pattern can't contain getter or setter");
          Expression val = (Expression) this.toAssignable(prop.getRawValue(), isBinding);
          properties.add(
              new Property(
                  prop.getLoc(),
                  prop.getKey(),
                  val,
                  prop.getKind().name(),
                  prop.isComputed(),
                  prop.isMethod()));
        }
        return new ObjectPattern(node.getLoc(), properties);
      }

      if (node instanceof ArrayExpression)
        return new ArrayPattern(
            node.getLoc(),
            this.toAssignableList(((ArrayExpression) node).getElements(), isBinding));

      if (node instanceof AssignmentExpression) {
        AssignmentExpression assgn = (AssignmentExpression) node;
        if (assgn.getOperator().equals("=")) {
          this.toAssignable(assgn.getLeft(), isBinding);
          return new AssignmentPattern(node.getLoc(), "=", assgn.getLeft(), assgn.getRight());
        } else {
          this.raise(
              assgn.getLeft().getLoc().getEnd(),
              "Only '=' operator can be used for specifying default value.");
        }
      }

      if (node instanceof AssignmentPattern) {
        return node;
      }

      if (node instanceof ParenthesizedExpression) {
        Expression expr = ((ParenthesizedExpression) node).getExpression();
        return new ParenthesizedExpression(
            node.getLoc(), (Expression) this.toAssignable(expr, isBinding));
      }

      if (node instanceof MemberExpression) {
        if (Chainable.isOnOptionalChain(false, (MemberExpression) node))
          this.raise(node, "Invalid left-hand side in assignment");
        if (!isBinding) return node;
      }

      this.raise(node, "Assigning to rvalue");
    }
    return node;
  }

  // Convert list of expression atoms to binding list.
  protected List<Expression> toAssignableList(List<Expression> exprList, boolean isBinding) {
    int end = exprList.size();
    if (end > 0) {
      Expression last = exprList.get(end - 1);
      if (last != null && last instanceof RestElement) {
        --end;
      } else if (last != null && last instanceof SpreadElement) {
        Expression arg = ((SpreadElement) last).getArgument();
        arg = (Expression) this.toAssignable(arg, isBinding);
        if (!(arg instanceof Identifier
            || arg instanceof MemberExpression
            || arg instanceof ArrayPattern)) this.unexpected(arg.getLoc().getStart());
        exprList.set(end - 1, last = new RestElement(last.getLoc(), arg));
        --end;
      }

      if (isBinding
          && last instanceof RestElement
          && !(((RestElement) last).getArgument() instanceof Identifier))
        this.unexpected(((RestElement) last).getArgument().getLoc().getStart());
    }
    for (int i = 0; i < end; ++i)
      exprList.set(i, (Expression) this.toAssignable(exprList.get(i), isBinding));
    return exprList;
  }

  // Parses spread element.
  protected SpreadElement parseSpread(DestructuringErrors refDestructuringErrors) {
    Position start = this.startLoc;
    this.next();
    SpreadElement node =
        new SpreadElement(
            new SourceLocation(start), this.parseMaybeAssign(false, refDestructuringErrors, null));
    return this.finishNode(node);
  }

  protected RestElement parseRest(boolean allowNonIdent) {
    Position start = this.startLoc;
    this.next();

    // RestElement inside of a function parameter must be an identifier
    Expression argument = null;
    if (allowNonIdent)
      if (this.type == TokenType.name) argument = this.parseIdent(false);
      else this.unexpected();
    else if (this.type == TokenType.name || this.type == TokenType.bracketL)
      argument = this.parseBindingAtom();
    else this.unexpected();
    RestElement node = new RestElement(new SourceLocation(start), argument);
    return this.finishNode(node);
  }

  // Parses lvalue (assignable) atom.
  protected Expression parseBindingAtom() {
    if (this.options.ecmaVersion() < 6) return this.parseIdent(false);

    if (this.type == TokenType.bracketL) {
      Position start = this.startLoc;
      this.next();
      List<Expression> elements = this.parseBindingList(TokenType.bracketR, true, true, false);
      ArrayPattern node = new ArrayPattern(new SourceLocation(start), elements);
      return this.finishNode(node);
    }

    if (this.type == TokenType.braceL) return this.parseObj(true, null);

    return this.parseIdent(false);
  }

  protected List<Expression> parseBindingList(
      TokenType close, boolean allowEmpty, boolean allowTrailingComma, boolean allowNonIdent) {
    List<Expression> result = new ArrayList<Expression>();
    boolean first = true;
    while (!this.eat(close)) {
      if (first) first = false;
      else this.expect(TokenType.comma);
      if (allowEmpty && this.type == TokenType.comma) {
        result.add(null);
      } else if (allowTrailingComma && this.afterTrailingComma(close, false)) {
        break;
      } else if (this.type == TokenType.ellipsis) {
        result.add(this.processBindingListItem(this.parseRest(allowNonIdent)));
        if (this.type == TokenType.comma)
          this.raise(this.start, "Comma is not permitted after the rest element");
        this.expect(close);
        break;
      } else {
        result.add(this.processBindingListItem(this.parseMaybeDefault(this.startLoc, null)));
      }
    }
    return result;
  }

  protected Expression processBindingListItem(Expression e) {
    return e;
  }

  // Parses assignment pattern around given atom if possible.
  protected Expression parseMaybeDefault(Position startLoc, Expression left) {
    if (left == null) left = this.parseBindingAtom();
    if (this.options.ecmaVersion() < 6 || !this.eat(TokenType.eq)) return left;
    AssignmentPattern node =
        new AssignmentPattern(
            new SourceLocation(startLoc), "=", left, this.parseMaybeAssign(false, null, null));
    return this.finishNode(node);
  }

  // Verify that a node is an lval --- something that can be assigned
  // to.
  protected void checkLVal(INode expr, boolean isBinding, Set<String> checkClashes) {
    if (expr instanceof Identifier) {
      String name = ((Identifier) expr).getName();
      if (this.strict && this.reservedWordsStrictBind.contains(name))
        this.raiseRecoverable(
            expr, (isBinding ? "Binding " : "Assigning to ") + name + " in strict mode");
      if (checkClashes != null) {
        if (!checkClashes.add(name)) this.raiseRecoverable(expr, "Argument name clash");
      }
    } else if (expr instanceof MemberExpression) {
      if (isBinding)
        this.raiseRecoverable(
            expr, (isBinding ? "Binding" : "Assigning to") + " member expression");
    } else if (expr instanceof ObjectPattern) {
      for (Property prop : ((ObjectPattern) expr).getProperties())
        this.checkLVal(prop.getRawValue(), isBinding, checkClashes);
    } else if (expr instanceof ArrayPattern) {
      for (Expression elem : ((ArrayPattern) expr).getRawElements())
        if (elem != null) this.checkLVal(elem, isBinding, checkClashes);
    } else if (expr instanceof AssignmentPattern) {
      this.checkLVal(((AssignmentPattern) expr).getLeft(), isBinding, checkClashes);
    } else if (expr instanceof RestElement) {
      this.checkLVal(((RestElement) expr).getArgument(), isBinding, checkClashes);
    } else if (expr instanceof ParenthesizedExpression) {
      this.checkLVal(((ParenthesizedExpression) expr).getExpression(), isBinding, checkClashes);
    } else {
      this.raise(expr.getLoc().getStart(), (isBinding ? "Binding" : "Assigning to") + " rvalue");
    }
  }

  /// end lval.js

  /// begin tokencontext.js

  public static class TokContext {
    public static final TokContext b_stat = new TokContext("{", false),
        b_expr = new TokContext("{", true),
        b_tmpl = new TokContext("${", true),
        p_stat = new TokContext("(", false),
        p_expr = new TokContext("(", true),
        q_tmpl = new TokContext("`", true, true, p -> p.tryReadTemplateToken()),
        f_expr = new TokContext("function", true);

    public final String token;
    public final boolean isExpr, preserveSpace;
    public final Function<Parser, Token> override;

    public TokContext(
        String token, boolean isExpr, boolean preserveSpace, Function<Parser, Token> override) {
      this.token = token;
      this.isExpr = isExpr;
      this.preserveSpace = preserveSpace;
      this.override = override;
    }

    public TokContext(String token, boolean isExpr) {
      this(token, isExpr, false, null);
    }
  }

  private Stack<TokContext> initialContext() {
    Stack<TokContext> s = new Stack<TokContext>();
    s.push(TokContext.b_stat);
    return s;
  }

  protected boolean braceIsBlock(TokenType prevType) {
    if (prevType == TokenType.colon) {
      TokContext parent = this.curContext();
      if (parent == TokContext.b_stat || parent == TokContext.b_expr) return !parent.isExpr;
    }
    if (prevType == TokenType._return)
      return inputSubstring(this.lastTokEnd, this.start).matches("(?s).*(?:" + lineBreak + ").*");
    if (prevType == TokenType._else
        || prevType == TokenType.semi
        || prevType == TokenType.eof
        || prevType == TokenType.parenR) return true;
    if (prevType == TokenType.braceL) return this.curContext() == TokContext.b_stat;
    return !this.exprAllowed;
  }

  protected void updateContext(TokenType prevType) {
    TokenType type = this.type;
    if (type.keyword != null && prevType == TokenType.dot) this.exprAllowed = false;
    else type.updateContext(this, prevType);
  }

  /// end tokencontext.js

  /// begin statement.js
  // ### Statement parsing

  // Parse a program. Initializes the parser, reads any number of
  // statements, and wraps them in a Program node.  Optionally takes a
  // `program` argument.  If present, the statements will be appended
  // to its body instead of creating a new node.
  protected Program parseTopLevel(Position startLoc, Program node) {
    boolean first = true;
    Set<String> exports = new LinkedHashSet<String>();
    List<Statement> body = new ArrayList<Statement>();
    while (this.type != TokenType.eof) {
      Statement stmt = this.parseStatement(true, true, exports);
      if (stmt != null) body.add(stmt);
      if (first) {
        if (this.isUseStrict(stmt)) this.setStrict(true);
        first = false;
      }
    }
    this.next();
    if (node == null) {
      String sourceType = this.options.ecmaVersion() >= 6 ? this.options.sourceType() : null;
      node = new Program(new SourceLocation(startLoc), body, sourceType);
    } else {
      node.getBody().addAll(body);
    }
    return this.finishNode(node);
  }

  private final LabelInfo loopLabel = new LabelInfo(null, "loop", -1);
  private final LabelInfo switchLabel = new LabelInfo(null, "switch", -1);

  protected boolean isLet() {
    if (this.type != TokenType.name || this.options.ecmaVersion() < 6 || !this.value.equals("let"))
      return false;
    Matcher m = Whitespace.skipWhiteSpace.matcher(this.input);
    m.find(this.pos);
    int next = m.end(), nextCh = charAt(next);
    if (mayFollowLet(nextCh)) return true; // '{' and '['
    if (Identifiers.isIdentifierStart(nextCh, true)) {
      int endPos;
      for (endPos = next + 1; Identifiers.isIdentifierChar(charAt(endPos), true); ++endPos) ;
      String ident = inputSubstring(next, endPos);
      if (!this.keywords.contains(ident)) return true;
    }
    return false;
  }

  protected boolean mayFollowLet(int c) {
    return c == 91 || c == 123;
  }

  protected final Statement parseStatement(boolean declaration, boolean topLevel) {
    return parseStatement(declaration, topLevel, null);
  }

  // check 'async [no LineTerminator here] function'
  // - 'async /*foo*/ function' is OK.
  // - 'async /*\n*/ function' is invalid.
  boolean isAsyncFunction() {
    if (this.type != TokenType.name
        || this.options.ecmaVersion() < 8
        || !this.value.equals("async")) return false;

    Matcher m = Whitespace.skipWhiteSpace.matcher(this.input);
    m.find(this.pos);
    int next = m.end();
    return !Whitespace.lineBreakG.matcher(inputSubstring(this.pos, next)).matches()
        && inputSubstring(next, next + 8).equals("function")
        && (next + 8 == this.input.length()
            || !Identifiers.isIdentifierChar(this.input.codePointAt(next + 8), false));
  }

  /**
   * Parse a single statement.
   *
   * <p>If expecting a statement and finding a slash operator, parse a regular expression literal.
   * This is to handle cases like <code>if (foo) /blah/.exec(foo)</code>, where looking at the
   * previous token does not help.
   *
   * <p>If {@code declaration} is true, this method may return {@code null}, indicating the parsed
   * statement was a declaration that has no semantic meaning (such as a Flow interface
   * declaration). This is never the case in standard ECMAScript.
   */
  protected Statement parseStatement(boolean declaration, boolean topLevel, Set<String> exports) {
    TokenType starttype = this.type;
    String kind = null;
    Position startLoc = this.startLoc;

    if (this.isLet()) {
      starttype = TokenType._var;
      kind = "let";
    }

    // Most types of statements are recognized by the keyword they
    // start with. Many are trivial to parse, some require a bit of
    // complexity.

    if (starttype == TokenType._break || starttype == TokenType._continue) {
      return this.parseBreakContinueStatement(startLoc, starttype.keyword);
    } else if (starttype == TokenType._debugger) {
      return this.parseDebuggerStatement(startLoc);
    } else if (starttype == TokenType._do) {
      return this.parseDoStatement(startLoc);
    } else if (starttype == TokenType._for) {
      this.next();
      return this.parseForStatement(startLoc);
    } else if (starttype == TokenType._function) {
      if (!declaration && this.options.ecmaVersion() >= 6) this.unexpected();
      return this.parseFunctionStatement(startLoc, false);
    } else if (starttype == TokenType._class) {
      if (!declaration) this.unexpected();
      return (Statement) this.parseClass(startLoc, true);
    } else if (starttype == TokenType._if) {
      return this.parseIfStatement(startLoc);
    } else if (starttype == TokenType._return) {
      return this.parseReturnStatement(startLoc);
    } else if (starttype == TokenType._switch) {
      return this.parseSwitchStatement(startLoc);
    } else if (starttype == TokenType._throw) {
      return this.parseThrowStatement(startLoc);
    } else if (starttype == TokenType._try) {
      return this.parseTryStatement(startLoc);
    } else if (starttype == TokenType._const || starttype == TokenType._var) {
      if (kind == null) kind = String.valueOf(this.value);
      if (!declaration && !kind.equals("var")) this.unexpected();
      return this.parseVarStatement(startLoc, kind);
    } else if (starttype == TokenType._while) {
      return this.parseWhileStatement(startLoc);
    } else if (starttype == TokenType._with) {
      return this.parseWithStatement(startLoc);
    } else if (starttype == TokenType.braceL) {
      return this.parseBlock(false);
    } else if (starttype == TokenType.semi) {
      return this.parseEmptyStatement(startLoc);
    } else if (starttype == TokenType._export || starttype == TokenType._import) {
      if (!this.options.allowImportExportEverywhere()) {
        if (!topLevel)
          this.raise(this.start, "'import' and 'export' may only appear at the top level");
        if (!this.inModule)
          this.raise(this.start, "'import' and 'export' may appear only with 'sourceType: module'");
      }
      return starttype == TokenType._import
          ? this.parseImport(startLoc)
          : this.parseExport(startLoc, exports);

    } else {
      if (this.isAsyncFunction() && declaration) {
        this.next();
        return this.parseFunctionStatement(startLoc, true);
      }

      // If the statement does not start with a statement keyword or a
      // brace, it's an ExpressionStatement or LabeledStatement. We
      // simply start parsing an expression, and afterwards, if the
      // next token is a colon and the expression was a simple
      // Identifier node, we switch to interpreting it as a label.
      String maybeName = String.valueOf(this.value);
      Expression expr = this.parseExpression(false, null);
      if (starttype == TokenType.name && expr instanceof Identifier && this.eat(TokenType.colon))
        return this.parseLabeledStatement(startLoc, maybeName, (Identifier) expr);
      else return this.parseExpressionStatement(declaration, startLoc, expr);
    }
  }

  protected Statement parseBreakContinueStatement(Position startLoc, String keyword) {
    SourceLocation loc = new SourceLocation(startLoc);
    boolean isBreak = keyword.equals("break");
    this.next();
    Identifier label = null;
    if (this.eat(TokenType.semi) || this.insertSemicolon()) {
      label = null;
    } else if (this.type != TokenType.name) {
      this.unexpected();
    } else {
      label = this.parseIdent(false);
      this.semicolon();
    }

    // Verify that there is an actual destination to break or
    // continue to.
    int i = 0;
    for (; i < labels.size(); ++i) {
      LabelInfo lab = labels.get(i);
      if (label == null || label.getName().equals(lab.name)) {
        if (lab.kind != null && (isBreak || lab.kind.equals("loop"))) break;
        if (label != null && isBreak) break;
      }
    }
    if (i == this.labels.size()) this.raise(startLoc, "Unsyntactic " + keyword);
    Statement node = isBreak ? new BreakStatement(loc, label) : new ContinueStatement(loc, label);
    return this.finishNode(node);
  }

  protected DebuggerStatement parseDebuggerStatement(Position startLoc) {
    SourceLocation loc = new SourceLocation(startLoc);
    this.next();
    this.semicolon();
    return this.finishNode(new DebuggerStatement(loc));
  }

  protected DoWhileStatement parseDoStatement(Position startLoc) {
    this.next();
    this.labels.push(loopLabel);
    Statement body = this.parseStatement(false, false);
    this.labels.pop();
    this.expect(TokenType._while);
    Expression test = this.parseParenExpression();
    if (this.options.ecmaVersion() >= 6) this.eat(TokenType.semi);
    else this.semicolon();
    return this.finishNode(new DoWhileStatement(new SourceLocation(startLoc), test, body));
  }

  // Disambiguating between a `for` and a `for`/`in` or `for`/`of`
  // loop is non-trivial. Basically, we have to parse the init `var`
  // statement or expression, disallowing the `in` operator (see
  // the second parameter to `parseExpression`), and then check
  // whether the next token is `in` or `of`. When there is no init
  // part (semicolon immediately after the opening parenthesis), it
  // is a regular `for` loop.
  // This method assumes that the initial `for` token has already been consumed.
  protected Statement parseForStatement(Position startLoc) {
    this.labels.push(loopLabel);
    this.expect(TokenType.parenL);
    if (this.type == TokenType.semi) return this.parseFor(startLoc, null);
    boolean isLet = this.isLet();
    if (this.type == TokenType._var || this.type == TokenType._const || isLet) {
      Position initStartLoc = this.startLoc;
      String kind = isLet ? "let" : String.valueOf(this.value);
      this.next();
      VariableDeclaration init = this.finishNode(this.parseVar(initStartLoc, true, kind));
      if ((this.type == TokenType._in
              || (this.options.ecmaVersion() >= 6 && this.isContextual("of")))
          && init.getDeclarations().size() == 1
          && !(!kind.equals("var") && init.getDeclarations().get(0).hasInit()))
        return this.parseForIn(startLoc, init);
      return this.parseFor(startLoc, init);
    }
    DestructuringErrors refDestructuringErrors = new DestructuringErrors();
    Expression init = this.parseExpression(true, refDestructuringErrors);
    if (this.type == TokenType._in
        || (this.options.ecmaVersion() >= 6 && this.isContextual("of"))) {
      this.checkPatternErrors(refDestructuringErrors, true);
      init = (Expression) this.toAssignable(init, false);
      this.checkLVal(init, false, null);
      return this.parseForIn(startLoc, init);
    } else {
      this.checkExpressionErrors(refDestructuringErrors, true);
    }
    return this.parseFor(startLoc, init);
  }

  protected Statement parseFunctionStatement(Position startLoc, boolean isAsync) {
    this.next();
    INode fn = this.parseFunction(startLoc, true, false, isAsync);
    // if we encountered an anonymous function, wrap it in an expression
    // statement (we will have logged a syntax error already)
    if (fn instanceof Expression)
      return this.finishNode(
          new ExpressionStatement(new SourceLocation(startLoc), (Expression) fn));
    return (Statement) fn;
  }

  private boolean isFunction() {
    return this.type == TokenType._function || this.isAsyncFunction();
  }

  protected Statement parseIfStatement(Position startLoc) {
    this.next();
    Expression test = this.parseParenExpression();
    // allow function declarations in branches, but only in non-strict mode
    Statement consequent = this.parseStatement(!this.strict && this.isFunction(), false);
    Statement alternate =
        this.eat(TokenType._else)
            ? this.parseStatement(!this.strict && this.isFunction(), false)
            : null;
    return this.finishNode(
        new IfStatement(new SourceLocation(startLoc), test, consequent, alternate));
  }

  protected ReturnStatement parseReturnStatement(Position startLoc) {
    if (!this.inFunction && !this.options.allowReturnOutsideFunction())
      this.raise(this.start, "'return' outside of function");
    this.next();

    // In `return` (and `break`/`continue`), the keywords with
    // optional arguments, we eagerly look for a semicolon or the
    // possibility to insert one.
    Expression argument;
    if (this.eat(TokenType.semi) || this.insertSemicolon()) {
      argument = null;
    } else {
      argument = this.parseExpression(false, null);
      this.semicolon();
    }
    return this.finishNode(new ReturnStatement(new SourceLocation(startLoc), argument));
  }

  protected SwitchStatement parseSwitchStatement(Position startLoc) {
    this.next();
    Expression discriminant = this.parseParenExpression();
    List<SwitchCase> cases = new ArrayList<SwitchCase>();
    this.expect(TokenType.braceL);
    this.labels.push(switchLabel);

    // Statements under must be grouped (by label) in SwitchCase
    // nodes. `cur` is used to keep the node that we are currently
    // adding statements to.

    boolean sawDefault = false;
    Position curCaseStart = null;
    Expression curTest = null;
    List<Statement> curConsequent = null;
    while (this.type != TokenType.braceR) {
      if (this.type == TokenType._case || this.type == TokenType._default) {
        boolean isCase = this.type == TokenType._case;
        if (curConsequent != null)
          cases.add(
              this.finishNode(
                  new SwitchCase(new SourceLocation(curCaseStart), curTest, curConsequent)));
        curCaseStart = this.startLoc;
        curTest = null;
        curConsequent = new ArrayList<Statement>();
        this.next();
        if (isCase) {
          curTest = this.parseExpression(false, null);
        } else {
          if (sawDefault) this.raiseRecoverable(this.lastTokStart, "Multiple default clauses");
          sawDefault = true;
          curTest = null;
        }
        this.expect(TokenType.colon);
      } else {
        if (curConsequent == null) this.unexpected();
        Statement stmt = this.parseStatement(true, false);
        if (stmt != null) curConsequent.add(stmt);
      }
    }
    if (curConsequent != null)
      cases.add(
          this.finishNode(
              new SwitchCase(new SourceLocation(curCaseStart), curTest, curConsequent)));
    this.next(); // Closing brace
    this.labels.pop();
    return this.finishNode(new SwitchStatement(new SourceLocation(startLoc), discriminant, cases));
  }

  protected ThrowStatement parseThrowStatement(Position startLoc) {
    this.next();
    if (inputSubstring(this.lastTokEnd, this.start).matches("(?s).*(?:" + lineBreak + ").*"))
      this.raise(this.lastTokEnd, "Illegal newline after throw");
    Expression argument = this.parseExpression(false, null);
    this.semicolon();
    return this.finishNode(new ThrowStatement(new SourceLocation(startLoc), argument));
  }

  protected TryStatement parseTryStatement(Position startLoc) {
    this.next();
    BlockStatement block = this.parseBlock(false);
    CatchClause handler =
        this.type == TokenType._catch ? this.parseCatchClause(this.startLoc) : null;
    BlockStatement finalizer = this.eat(TokenType._finally) ? this.parseBlock(false) : null;
    if (handler == null && finalizer == null)
      this.raise(startLoc, "Missing catch or finally clause");
    return this.finishNode(
        new TryStatement(new SourceLocation(startLoc), block, handler, null, finalizer));
  }

  protected CatchClause parseCatchClause(Position startLoc) {
    this.next();
    this.expect(TokenType.parenL);
    Expression param = this.parseBindingAtom();
    this.checkLVal(param, true, null);
    this.expect(TokenType.parenR);
    BlockStatement catchBody = this.parseBlock(false);
    return this.finishNode(
        new CatchClause(new SourceLocation(startLoc), (IPattern) param, null, catchBody));
  }

  protected Statement parseVarStatement(Position startLoc, String kind) {
    this.next();
    VariableDeclaration node = this.parseVar(startLoc, false, kind);
    this.semicolon();
    return this.finishNode(node);
  }

  protected WhileStatement parseWhileStatement(Position startLoc) {
    this.next();
    Expression test = this.parseParenExpression();
    this.labels.push(loopLabel);
    Statement body = this.parseStatement(false, false);
    this.labels.pop();
    return this.finishNode(new WhileStatement(new SourceLocation(startLoc), test, body));
  }

  protected WithStatement parseWithStatement(Position startLoc) {
    if (this.strict) this.raise(startLoc, "'with' in strict mode");
    this.next();
    Expression object = this.parseParenExpression();
    Statement body = this.parseStatement(false, false);
    return this.finishNode(new WithStatement(new SourceLocation(startLoc), object, body));
  }

  protected EmptyStatement parseEmptyStatement(Position startLoc) {
    this.next();
    return this.finishNode(new EmptyStatement(new SourceLocation(startLoc)));
  }

  protected LabeledStatement parseLabeledStatement(
      Position startLoc, String maybeName, Identifier expr) {
    for (int i = 0; i < this.labels.size(); ++i)
      if (maybeName.equals(this.labels.get(i).name))
        this.raise(expr, "Label '" + maybeName + "' is already declared");
    String kind = this.type.isLoop ? "loop" : this.type == TokenType._switch ? "switch" : null;
    for (int i = this.labels.size() - 1; i >= 0; i--) {
      LabelInfo label = this.labels.get(i);
      if (label.statementStart == startLoc.getOffset()) {
        label.statementStart = this.start;
        label.kind = kind;
      } else {
        break;
      }
    }
    this.labels.push(new LabelInfo(maybeName, kind, this.start));
    Statement body = this.parseStatement(true, false);
    this.labels.pop();
    if (body == null) return null;
    Identifier label = expr;
    return this.finishNode(new LabeledStatement(new SourceLocation(startLoc), label, body));
  }

  protected ExpressionStatement parseExpressionStatement(
      boolean declaration, Position startLoc, Expression expr) {
    this.semicolon();
    return this.finishNode(new ExpressionStatement(new SourceLocation(startLoc), expr));
  }

  // Parse a semicolon-enclosed block of statements, handling `"use
  // strict"` declarations when `allowStrict` is true (used for
  // function bodies).
  protected BlockStatement parseBlock(boolean allowStrict) {
    Position startLoc = this.startLoc;
    boolean first = true;
    Boolean oldStrict = null;
    List<Statement> body = new ArrayList<Statement>();
    this.expect(TokenType.braceL);
    while (!this.eat(TokenType.braceR)) {
      Statement stmt = this.parseStatement(true, false);
      if (stmt != null) body.add(stmt);
      if (first && allowStrict && this.isUseStrict(stmt)) {
        oldStrict = this.strict;
        this.setStrict(this.strict = true);
      }
      first = false;
    }
    if (oldStrict == Boolean.FALSE) this.setStrict(false);
    return this.finishNode(new BlockStatement(new SourceLocation(startLoc), body));
  }

  // Parse a regular `for` loop. The disambiguation code in
  // `parseStatement` will already have parsed the init statement or
  // expression.
  protected ForStatement parseFor(Position startLoc, Node init) {
    this.expect(TokenType.semi);
    Expression test = this.type == TokenType.semi ? null : this.parseExpression(false, null);
    this.expect(TokenType.semi);
    Expression update = this.type == TokenType.parenR ? null : this.parseExpression(false, null);
    this.expect(TokenType.parenR);
    Statement body = this.parseStatement(false, false);
    this.labels.pop();
    return this.finishNode(
        new ForStatement(new SourceLocation(startLoc), init, test, update, body));
  }

  // Parse a `for`/`in` and `for`/`of` loop, which are almost
  // same from parser's perspective.
  protected Statement parseForIn(Position startLoc, Node left) {
    SourceLocation loc = new SourceLocation(startLoc);
    boolean isForIn = this.type == TokenType._in;
    this.next();
    Expression right = this.parseExpression(false, null);
    this.expect(TokenType.parenR);
    Statement body = this.parseStatement(false, false);
    this.labels.pop();
    EnhancedForStatement node;
    if (isForIn) node = new ForInStatement(loc, left, right, body, false);
    else node = new ForOfStatement(loc, left, right, body);
    return this.finishNode(node);
  }

  // Parse a list of variable declarations.
  protected VariableDeclaration parseVar(Position startLoc, boolean isFor, String kind) {
    List<VariableDeclarator> declarations = new ArrayList<VariableDeclarator>();
    for (; ; ) {
      Position varDeclStart = this.startLoc;
      Expression id = this.parseVarId();
      Expression init = null;
      if (this.eat(TokenType.eq)) {
        init = this.parseMaybeAssign(isFor, null, null);
      } else if (kind.equals("const")
          && !(this.type == TokenType._in
              || (this.options.ecmaVersion() >= 6 && this.isContextual("of")))) {
        this.raiseRecoverable(
            this.lastTokEnd, "Constant declarations require an initialization value");
      } else if (!(id instanceof Identifier)
          && !(isFor && (this.type == TokenType._in || this.isContextual("of")))) {
        this.raiseRecoverable(
            this.lastTokEnd, "Complex binding patterns require an initialization value");
      }
      declarations.add(
          this.finishNode(
              new VariableDeclarator(
                  new SourceLocation(varDeclStart),
                  (IPattern) id,
                  init,
                  noTypeAnnotation,
                  DeclarationFlags.none)));
      if (!this.eat(TokenType.comma)) break;
    }
    return new VariableDeclaration(
        new SourceLocation(startLoc), kind, declarations, noDeclareKeyword);
  }

  protected Expression parseVarId() {
    Expression res = this.parseBindingAtom();
    this.checkLVal(res, true, null);
    return res;
  }

  /**
   * If {@code isStatement} is true and the function has a name, the result is a {@linkplain
   * FunctionDeclaration}, otherwise it is a {@linkplain FunctionExpression}.
   */
  protected INode parseFunction(
      Position startLoc, boolean isStatement, boolean allowExpressionBody, boolean isAsync) {
    boolean oldInGen = this.inGenerator, oldInAsync = this.inAsync;
    int oldYieldPos = this.yieldPos, oldAwaitPos = this.awaitPos;
    Pair<Boolean, Identifier> p = parseFunctionName(isStatement, isAsync);
    return parseFunctionRest(
        startLoc,
        isStatement,
        allowExpressionBody,
        oldInGen,
        oldInAsync,
        oldYieldPos,
        oldAwaitPos,
        p.fst(),
        p.snd());
  }

  protected Pair<Boolean, Identifier> parseFunctionName(boolean isStatement, boolean isAsync) {
    boolean generator = parseGeneratorMarker(isAsync);
    Identifier id = null;
    if (isStatement)
      if (this.type == TokenType.name) id = this.parseIdent(false);
      else this.raise(this.start, "Missing function name", true);

    this.inGenerator = generator;
    this.inAsync = isAsync;
    this.yieldPos = 0;
    this.awaitPos = 0;

    if (!isStatement && this.type == TokenType.name) id = this.parseIdent(false);
    return Pair.make(generator, id);
  }

  protected boolean parseGeneratorMarker(boolean isAsync) {
    boolean generator = false;
    if (this.options.ecmaVersion() >= 6 && !isAsync) generator = this.eat(TokenType.star);
    return generator;
  }

  protected IFunction parseFunctionRest(
      Position startLoc,
      boolean isStatement,
      boolean allowExpressionBody,
      boolean oldInGen,
      boolean oldInAsync,
      int oldYieldPos,
      int oldAwaitPos,
      boolean generator,
      Identifier id) {
    boolean async = this.inAsync;
    List<Expression> params = this.parseFunctionParams();
    Node body = this.parseFunctionBody(id, params, allowExpressionBody);
    this.inGenerator = oldInGen;
    this.inAsync = oldInAsync;
    this.yieldPos = oldYieldPos;
    this.awaitPos = oldAwaitPos;
    IFunction node;
    SourceLocation loc = new SourceLocation(startLoc);
    if (isStatement && id != null)
      node = new FunctionDeclaration(loc, id, params, body, generator, async);
    else node = new FunctionExpression(loc, id, params, body, generator, async);
    return this.finishNode(node);
  }

  protected List<Expression> parseFunctionParams() {
    this.expect(TokenType.parenL);
    List<Expression> params =
        this.parseBindingList(TokenType.parenR, false, this.options.ecmaVersion() >= 8, true);
    this.checkYieldAwaitInDefaultParams();
    return params;
  }

  // Parse a class declaration or literal (depending on the
  // `isStatement` parameter).
  protected Node parseClass(Position startLoc, boolean isStatement) {
    boolean oldInClass = this.inClass;
    this.inClass = true;
    SourceLocation loc = new SourceLocation(startLoc);
    this.next();
    Identifier id = this.parseClassId(isStatement);
    Expression superClass = this.parseClassSuper();
    Position bodyStartLoc = this.startLoc;
    boolean hadConstructor = false;
    List<MemberDefinition<?>> body = new ArrayList<MemberDefinition<?>>();
    this.expect(TokenType.braceL);
    while (!this.eat(TokenType.braceR)) {
      if (this.eat(TokenType.semi)) continue;
      MemberDefinition<?> member = parseClassMember(hadConstructor);
      body.add(member);
      hadConstructor = hadConstructor || member.isConstructor();
    }
    ClassBody classBody = this.finishNode(new ClassBody(new SourceLocation(bodyStartLoc), body));
    Node node;
    if (isStatement) node = new ClassDeclaration(loc, id, superClass, classBody);
    else node = new ClassExpression(loc, id, superClass, classBody);

    this.inClass = oldInClass;
    return this.finishNode(node);
  }

  /** Parse a member declaration in a class. */
  protected MemberDefinition<?> parseClassMember(boolean hadConstructor) {
    Position methodStartLoc = this.startLoc;
    boolean isGenerator = this.eat(TokenType.star);
    boolean isMaybeStatic = this.type == TokenType.name && this.value.equals("static");
    PropertyInfo pi = new PropertyInfo(false, isGenerator, methodStartLoc);
    this.parsePropertyName(pi);
    boolean isStatic = isMaybeStatic && this.type != TokenType.parenL;
    if (isStatic) {
      if (isGenerator) this.unexpected();
      isGenerator = this.eat(TokenType.star);
      pi = new PropertyInfo(false, isGenerator, methodStartLoc);
      this.parsePropertyName(pi);
    }
    if (this.options.ecmaVersion() >= 8 && !isGenerator && this.isAsyncProp(pi)) {
      pi.isAsync = true;
      pi.isGenerator = this.eat(TokenType.star);
      this.parsePropertyName(pi);
    }
    return parseClassPropertyBody(pi, hadConstructor, isStatic);
  }

  protected boolean atGetterSetterName(PropertyInfo pi) {
    return !pi.isGenerator
        && !pi.isAsync
        && pi.key instanceof Identifier
        && this.type != TokenType.parenL
        && (((Identifier) pi.key).getName().equals("get")
            || ((Identifier) pi.key).getName().equals("set"));
  }

  /** Parse a method declaration in a class, assuming that its name has already been consumed. */
  protected MemberDefinition<?> parseClassPropertyBody(
      PropertyInfo pi, boolean hadConstructor, boolean isStatic) {
    pi.kind = "method";
    boolean isGetSet = false;
    if (!pi.computed) {
      if (atGetterSetterName(pi)) {
        isGetSet = true;
        pi.kind = ((Identifier) pi.key).getName();
        this.parsePropertyName(pi);
      }
      if (!isStatic
          && (pi.key instanceof Identifier && ((Identifier) pi.key).getName().equals("constructor")
              || pi.key instanceof Literal
                  && ((Literal) pi.key).getStringValue().equals("constructor"))) {
        if (hadConstructor) this.raise(pi.key, "Duplicate constructor in the same class");
        if (isGetSet) this.raise(pi.key, "Constructor can't have get/set modifier");
        if (pi.isGenerator) this.raise(pi.key, "Constructor can't be a generator");
        if (pi.isAsync) this.raise(pi.key, "Constructor can't be an async method");
        pi.kind = "constructor";
      }
    }
    MethodDefinition node =
        this.parseClassMethod(
            pi.startLoc,
            pi.isGenerator,
            pi.isAsync,
            isStatic,
            pi.computed,
            pi.getMethodKind(),
            pi.key);
    if (isGetSet) {
      int paramCount = pi.kind.equals("get") ? 0 : 1;
      List<Expression> params = node.getValue().getRawParameters();
      if (params.size() != paramCount) {
        if (pi.kind.equals("get"))
          this.raiseRecoverable(node.getValue(), "getter should have no params");
        else this.raiseRecoverable(node.getValue(), "setter should have exactly one param");
      }
      if (pi.kind.equals("set") && node.getValue().hasRest())
        this.raiseRecoverable(params.get(params.size() - 1), "Setter cannot use rest params");
    }
    if (pi.key instanceof Identifier && ((Identifier)pi.key).getName().startsWith("#")) {
      raiseRecoverable(pi.key, "Only fields, not methods, can be declared private.");
    }
    return node;
  }

  protected MethodDefinition parseClassMethod(
      Position startLoc,
      boolean isGenerator,
      boolean isAsync,
      boolean isStatic,
      boolean isComputed,
      MethodDefinition.Kind kind,
      Expression key) {
    SourceLocation loc = new SourceLocation(startLoc);
    FunctionExpression body = this.parseMethod(isGenerator, isAsync);
    int flags = DeclarationFlags.getStatic(isStatic) | DeclarationFlags.getComputed(isComputed);
    MethodDefinition m = new MethodDefinition(loc, flags, kind, key, body);
    return this.finishNode(m);
  }

  protected Identifier parseClassId(boolean isStatement) {
    if (this.type == TokenType.name) return this.parseIdent(false);
    if (isStatement) this.unexpected();
    return null;
  }

  protected Expression parseClassSuper() {
    return this.eat(TokenType._extends) ? this.parseExprSubscripts(null) : null;
  }

  // Parses module export declaration.
  protected ExportDeclaration parseExport(Position startLoc, Set<String> exports) {
    SourceLocation loc = new SourceLocation(startLoc);
    this.next();
    return parseExportRest(loc, exports);
  }

  /**
   * Parse the body of an {@code export} declaration, assuming that the {@code export} keyword
   * itself has already been consumed.
   */
  protected ExportDeclaration parseExportRest(SourceLocation loc, Set<String> exports) {
    Position exportRestLoc = startLoc;
    // export * from '...'
    if (this.eat(TokenType.star)) {
      return parseExportAll(loc, exportRestLoc, exports);
    }
    if (this.eat(TokenType._default)) { // export default ...
      this.checkExport(exports, "default", this.lastTokStartLoc);
      boolean isAsync = false;
      Node declaration;
      if (this.type == TokenType._function || (isAsync = this.isAsyncFunction())) {
        Position startLoc = this.startLoc;
        this.next();
        if (isAsync) this.next();
        FunctionExpression fe =
            (FunctionExpression) this.parseFunction(startLoc, false, false, isAsync);
        if (fe.hasId())
          declaration =
              new FunctionDeclaration(
                  fe.getLoc(),
                  fe.getId(),
                  fe.getRawParameters(),
                  (BlockStatement) fe.getBody(),
                  fe.isGenerator(),
                  fe.isAsync());
        else declaration = fe;
      } else if (this.type == TokenType._class) {
        ClassExpression ce = (ClassExpression) parseClass(this.startLoc, false);
        if (ce.getClassDef().hasId())
          declaration =
              new ClassDeclaration(ce.getLoc(), ce.getClassDef(), noDeclareKeyword, notAbstract);
        else declaration = ce;
      } else {
        declaration = this.parseMaybeAssign(false, null, null);
        this.semicolon();
      }
      return this.finishNode(new ExportDefaultDeclaration(loc, declaration));
    }
    // export var|const|let|function|class ...
    Statement declaration;
    List<ExportSpecifier> specifiers;
    Expression source = null;
    if (this.shouldParseExportStatement()) {
      declaration = this.parseStatement(true, false);
      if (declaration == null) return null;
      if (declaration instanceof VariableDeclaration) {
        checkVariableExport(exports, ((VariableDeclaration) declaration).getDeclarations());
      } else {
        Identifier id = getId(declaration);
        if (id != null) checkExport(exports, id.getName(), id.getLoc().getStart());
      }
      specifiers = new ArrayList<ExportSpecifier>();
      source = null;
    } else { // export { x, y as z } [from '...']
      declaration = null;
      specifiers = this.parseExportSpecifiers(exports);
      source = parseExportFrom(specifiers, source, false);
    }
    return this.finishNode(
        new ExportNamedDeclaration(loc, declaration, specifiers, (Literal) source));
  }

  protected Expression parseExportFrom(
      List<ExportSpecifier> specifiers, Expression source, boolean expectFrom) {
    if (this.eatContextual("from")) {
      if (this.type == TokenType.string) source = this.parseExprAtom(null);
      else this.unexpected();
    } else {
      if (expectFrom) this.unexpected();

      // check for keywords used as local names
      for (ExportSpecifier specifier : specifiers) {
        String localName = specifier.getLocal().getName();
        if (this.keywords.contains(localName) || this.reservedWords.contains(localName)) {
          this.unexpected(specifier.getLoc().getStart());
        }
      }

      source = null;
    }
    this.semicolon();
    return source;
  }

  protected ExportDeclaration parseExportAll(
      SourceLocation loc, Position starLoc, Set<String> exports) {
    Expression source = parseExportFrom(null, null, true);
    return this.finishNode(new ExportAllDeclaration(loc, (Literal) source));
  }

  private void checkExport(Set<String> exports, String name, Position pos) {
    if (exports == null) return;
    if (exports.contains(name))
      raiseRecoverable(pos.getOffset(), "Duplicate export '" + name + "'");
    exports.add(name);
  }

  private void checkPatternExport(Set<String> exports, Expression pat) {
    if (pat instanceof Identifier) {
      checkExport(exports, ((Identifier) pat).getName(), pat.getLoc().getStart());
    } else if (pat instanceof ObjectPattern) {
      for (Property prop : ((ObjectPattern) pat).getProperties())
        checkPatternExport(exports, prop.getValue());
    } else if (pat instanceof ArrayPattern) {
      for (Expression elt : ((ArrayPattern) pat).getElements())
        if (elt != null) checkPatternExport(exports, elt);
    } else if (pat instanceof AssignmentPattern) {
      checkPatternExport(exports, ((AssignmentPattern) pat).getLeft());
    } else if (pat instanceof ParenthesizedExpression) {
      checkPatternExport(exports, ((ParenthesizedExpression) pat).getExpression());
    }
  }

  private void checkVariableExport(Set<String> exports, List<VariableDeclarator> decls) {
    if (exports == null) return;
    for (VariableDeclarator decl : decls) checkPatternExport(exports, (Expression) decl.getId());
  }

  protected boolean shouldParseExportStatement() {
    return this.type.keyword != null || this.isLet() || this.isAsyncFunction();
  }

  // Parses a comma-separated list of module exports.
  protected List<ExportSpecifier> parseExportSpecifiers(Set<String> exports) {
    List<ExportSpecifier> nodes = new ArrayList<ExportSpecifier>();
    boolean first = true;
    // export { x, y as z } [from '...']
    this.expect(TokenType.braceL);
    while (!this.eat(TokenType.braceR)) {
      if (!first) {
        this.expect(TokenType.comma);
        if (this.afterTrailingComma(TokenType.braceR, false)) break;
      } else {
        first = false;
      }

      SourceLocation loc = new SourceLocation(this.startLoc);
      Identifier local = this.parseIdent(this.type == TokenType._default);
      Identifier exported = this.eatContextual("as") ? this.parseIdent(true) : local;
      checkExport(exports, exported.getName(), exported.getLoc().getStart());
      nodes.add(this.finishNode(new ExportSpecifier(loc, local, exported)));
    }
    return nodes;
  }

  // Parses import declaration.
  protected Statement parseImport(Position startLoc) {
    SourceLocation loc = new SourceLocation(startLoc);
    this.next();
    return parseImportRest(loc);
  }

  protected ImportDeclaration parseImportRest(SourceLocation loc) {
    List<ImportSpecifier> specifiers;
    Literal source;
    // import '...'
    if (this.type == TokenType.string) {
      specifiers = new ArrayList<ImportSpecifier>();
      source = (Literal) this.parseExprAtom(null);
    } else {
      specifiers = this.parseImportSpecifiers();
      this.expectContextual("from");
      if (this.type != TokenType.string) this.unexpected();
      source = (Literal) this.parseExprAtom(null);
    }
    this.semicolon();
    if (specifiers == null) return null;
    return this.finishNode(new ImportDeclaration(loc, specifiers, source));
  }

  // Parses a comma-separated list of module imports.
  protected List<ImportSpecifier> parseImportSpecifiers() {
    List<ImportSpecifier> nodes = new ArrayList<ImportSpecifier>();
    boolean first = true;
    if (this.type == TokenType.name) {
      // import defaultObj, { x, y as z } from '...'
      SourceLocation loc = new SourceLocation(this.startLoc);
      Identifier local = this.parseIdent(false);
      this.checkLVal(local, true, null);
      nodes.add(this.finishNode(new ImportDefaultSpecifier(loc, local)));
      if (!this.eat(TokenType.comma)) return nodes;
    }
    if (this.type == TokenType.star) {
      SourceLocation loc = new SourceLocation(this.startLoc);
      this.next();
      this.expectContextual("as");
      Identifier local = this.parseIdent(false);
      this.checkLVal(local, true, null);
      nodes.add(this.finishNode(new ImportNamespaceSpecifier(loc, local)));
      return nodes;
    }
    this.expect(TokenType.braceL);
    while (!this.eat(TokenType.braceR)) {
      if (!first) {
        this.expect(TokenType.comma);
        if (this.afterTrailingComma(TokenType.braceR, false)) break;
      } else {
        first = false;
      }

      ImportSpecifier importSpecifier = parseImportSpecifier();
      if (importSpecifier != null) nodes.add(importSpecifier);
    }
    return nodes;
  }

  protected ImportSpecifier parseImportSpecifier() {
    SourceLocation loc = new SourceLocation(this.startLoc);
    Identifier imported = this.parseIdent(true), local;
    if (this.eatContextual("as")) {
      local = this.parseIdent(false);
    } else {
      local = imported;
      if (this.keywords.contains(local.getName())) this.unexpected(local.getLoc().getStart());
      if (this.reservedWordsStrict.contains(local.getName()))
        this.raiseRecoverable(local, "The keyword '" + local.getName() + "' is reserved");
    }
    this.checkLVal(local, true, null);
    return this.finishNode(new ImportSpecifier(loc, imported, local));
  }

  /// end statement.js

  /// helpers
  protected Number parseInt(String s, int radix) {
    return stringToNumber(s, 0, radix);
  }

  protected Number parseFloat(String s) {
    try {
      return Double.valueOf(s);
    } catch (NumberFormatException nfe) {
      this.raise(this.start, "Invalid number");
      return null;
    }
  }

  protected int charAt(int i) {
    if (i < input.length()) return input.charAt(i);
    else return -1;
  }

  protected String inputSubstring(int start, int end) {
    if (start >= input.length()) return "";
    if (end > input.length()) end = input.length();
    return input.substring(start, end);
  }

  protected Identifier getId(Statement s) {
    if (s instanceof ClassDeclaration) return ((ClassDeclaration) s).getClassDef().getId();
    if (s instanceof FunctionDeclaration) return ((FunctionDeclaration) s).getId();
    return null;
  }

  /*
   * Helper function for toNumber, parseInt, and TokenStream.getToken.
   *
   * Copied from Rhino.
   */
  private static double stringToNumber(String s, int start, int radix) {
    char digitMax = '9';
    char lowerCaseBound = 'a';
    char upperCaseBound = 'A';
    int len = s.length();
    if (radix < 10) {
      digitMax = (char) ('0' + radix - 1);
    }
    if (radix > 10) {
      lowerCaseBound = (char) ('a' + radix - 10);
      upperCaseBound = (char) ('A' + radix - 10);
    }
    int end;
    double sum = 0.0;
    for (end = start; end < len; end++) {
      char c = s.charAt(end);
      int newDigit;
      if ('0' <= c && c <= digitMax) newDigit = c - '0';
      else if ('a' <= c && c < lowerCaseBound) newDigit = c - 'a' + 10;
      else if ('A' <= c && c < upperCaseBound) newDigit = c - 'A' + 10;
      else break;
      sum = sum * radix + newDigit;
    }
    if (start == end) {
      return Double.NaN;
    }
    if (sum >= 9007199254740992.0) {
      if (radix == 10) {
        /* If we're accumulating a decimal number and the number
         * is >= 2^53, then the result from the repeated multiply-add
         * above may be inaccurate.  Call Java to get the correct
         * answer.
         */
        try {
          return Double.parseDouble(s.substring(start, end));
        } catch (NumberFormatException nfe) {
          return Double.NaN;
        }
      } else if (radix == 2 || radix == 4 || radix == 8 || radix == 16 || radix == 32) {
        /* The number may also be inaccurate for one of these bases.
         * This happens if the addition in value*radix + digit causes
         * a round-down to an even least significant mantissa bit
         * when the first dropped bit is a one.  If any of the
         * following digits in the number (which haven't been added
         * in yet) are nonzero then the correct action would have
         * been to round up instead of down.  An example of this
         * occurs when reading the number 0x1000000000000081, which
         * rounds to 0x1000000000000000 instead of 0x1000000000000100.
         */
        int bitShiftInChar = 1;
        int digit = 0;

        final int SKIP_LEADING_ZEROS = 0;
        final int FIRST_EXACT_53_BITS = 1;
        final int AFTER_BIT_53 = 2;
        final int ZEROS_AFTER_54 = 3;
        final int MIXED_AFTER_54 = 4;

        int state = SKIP_LEADING_ZEROS;
        int exactBitsLimit = 53;
        double factor = 0.0;
        boolean bit53 = false;
        // bit54 is the 54th bit (the first dropped from the mantissa)
        boolean bit54 = false;

        for (; ; ) {
          if (bitShiftInChar == 1) {
            if (start == end) break;
            digit = s.charAt(start++);
            if ('0' <= digit && digit <= '9') digit -= '0';
            else if ('a' <= digit && digit <= 'z') digit -= 'a' - 10;
            else digit -= 'A' - 10;
            bitShiftInChar = radix;
          }
          bitShiftInChar >>= 1;
          boolean bit = (digit & bitShiftInChar) != 0;

          switch (state) {
            case SKIP_LEADING_ZEROS:
              if (bit) {
                --exactBitsLimit;
                sum = 1.0;
                state = FIRST_EXACT_53_BITS;
              }
              break;
            case FIRST_EXACT_53_BITS:
              sum *= 2.0;
              if (bit) sum += 1.0;
              --exactBitsLimit;
              if (exactBitsLimit == 0) {
                bit53 = bit;
                state = AFTER_BIT_53;
              }
              break;
            case AFTER_BIT_53:
              bit54 = bit;
              factor = 2.0;
              state = ZEROS_AFTER_54;
              break;
            case ZEROS_AFTER_54:
              if (bit) {
                state = MIXED_AFTER_54;
              }
              // fallthrough
            case MIXED_AFTER_54:
              factor *= 2;
              break;
          }
        }
        switch (state) {
          case SKIP_LEADING_ZEROS:
            sum = 0.0;
            break;
          case FIRST_EXACT_53_BITS:
          case AFTER_BIT_53:
            // do nothing
            break;
          case ZEROS_AFTER_54:
            // x1.1 -> x1 + 1 (round up)
            // x0.1 -> x0 (round down)
            if (bit54 & bit53) sum += 1.0;
            sum *= factor;
            break;
          case MIXED_AFTER_54:
            // x.100...1.. -> x + 1 (round up)
            // x.0anything -> x (round down)
            if (bit54) sum += 1.0;
            sum *= factor;
            break;
        }
      }
      /* We don't worry about inaccurate numbers for any other base. */
    }
    return sum;
  }

  /**
   * Return the next {@code n} characters of lookahead (or as many as are available), after skipping
   * over whitespace and comments.
   */
  protected String lookahead(int n, boolean allowNewline) {
    Matcher m =
        (allowNewline ? Whitespace.skipWhiteSpace : Whitespace.skipWhiteSpaceNoNewline)
            .matcher(this.input);
    m.find(this.pos);
    return this.inputSubstring(m.end(), m.end() + n);
  }

  /**
   * Is the next input token (after skipping over whitespace and comments) the identifier {@code
   * name}?
   */
  protected boolean lookaheadIsIdent(String name, boolean allowNewline) {
    int n = name.length();
    String lh = lookahead(n + 1, allowNewline);
    return lh.startsWith(name)
        && (lh.length() == n || !Identifiers.isIdentifierChar(lh.codePointAt(n), true));
  }

  // getters and setters
  public void pushTokenContext(TokContext ctxt) {
    this.context.push(ctxt);
  }

  public TokContext popTokenContext() {
    return this.context.pop();
  }

  public void exprAllowed(boolean exprAllowed) {
    this.exprAllowed = exprAllowed;
  }
}
