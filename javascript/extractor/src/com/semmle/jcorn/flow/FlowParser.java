package com.semmle.jcorn.flow;

import com.semmle.jcorn.ESNextParser;
import com.semmle.jcorn.Identifiers;
import com.semmle.jcorn.Options;
import com.semmle.jcorn.SyntaxError;
import com.semmle.jcorn.TokenType;
import com.semmle.jcorn.TokenType.Properties;
import com.semmle.jcorn.Whitespace;
import com.semmle.js.ast.BinaryExpression;
import com.semmle.js.ast.ExportDeclaration;
import com.semmle.js.ast.ExportSpecifier;
import com.semmle.js.ast.Expression;
import com.semmle.js.ast.ExpressionStatement;
import com.semmle.js.ast.FieldDefinition;
import com.semmle.js.ast.Identifier;
import com.semmle.js.ast.ImportSpecifier;
import com.semmle.js.ast.Literal;
import com.semmle.js.ast.MethodDefinition;
import com.semmle.js.ast.Node;
import com.semmle.js.ast.Position;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Statement;
import com.semmle.js.ast.Token;
import com.semmle.js.ast.UnaryExpression;
import com.semmle.util.data.Pair;
import com.semmle.util.exception.Exceptions;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.Stack;
import java.util.function.Function;
import java.util.regex.Matcher;

/**
 * Java port of the <a href="https://github.com/babel/babylon">Babylon</a> <a
 * href="https://github.com/babel/babylon/blob/master/src/plugins/flow.js">Flow plugin</a>. All Flow
 * annotations are simply discarded after parsing.
 */
public class FlowParser extends ESNextParser {
  private boolean inType = false, noAnonFunctionType = false;

  private static final TokenType braceBarL =
      new TokenType(new Properties("{|").beforeExpr().startsExpr());
  private static final TokenType braceBarR = new TokenType(new Properties("|}"));

  public FlowParser(Options options, String input, int startPos) {
    super(options, input, startPos);
  }

  @Override
  protected Token getTokenFromCode(int code) {
    if (code == '{' && charAt(this.pos + 1) == '|') {
      this.pos += 2;
      return this.finishToken(braceBarL);
    } else if (code == '|' && charAt(this.pos + 1) == '}') {
      this.pos += 2;
      return this.finishToken(braceBarR);
    }
    return super.getTokenFromCode(code);
  }

  /**
   * Utility class for saving the parser state so we can later either restore it by calling method
   * {@link #reset()}, or commit to the new state by calling method {@link #commit()}.
   */
  private class State {
    private boolean exprAllowed;
    private int pos, lineStart, curLine, start, end, potentialArrowAt;
    private TokenType type;
    private Object value;
    private Position startLoc, endLoc, lastTokEndLoc, lastTokStartLoc;
    private int lastTokStart, lastTokEnd;
    private Stack<TokContext> context;
    private Function<Token, Void> onToken;
    private boolean inType, noAnonFunctionType;
    private List<Token> tokens = new ArrayList<Token>();
    private Function<SyntaxError, ?> onRecoverableError;
    private List<SyntaxError> errors = new ArrayList<SyntaxError>();

    private State() {
      this.exprAllowed = FlowParser.this.exprAllowed;
      this.pos = FlowParser.this.pos;
      this.lineStart = FlowParser.this.lineStart;
      this.curLine = FlowParser.this.curLine;
      this.start = FlowParser.this.start;
      this.end = FlowParser.this.end;
      this.potentialArrowAt = FlowParser.this.potentialArrowAt;
      this.type = FlowParser.this.type;
      this.value = FlowParser.this.value;
      this.startLoc = FlowParser.this.startLoc;
      this.endLoc = FlowParser.this.endLoc;
      this.lastTokEndLoc = FlowParser.this.lastTokEndLoc;
      this.lastTokStartLoc = FlowParser.this.lastTokStartLoc;
      this.lastTokStart = FlowParser.this.lastTokStart;
      this.lastTokEnd = FlowParser.this.lastTokEnd;
      this.context = new Stack<TokContext>();
      this.context.addAll(FlowParser.this.context);
      this.inType = FlowParser.this.inType;
      this.noAnonFunctionType = FlowParser.this.noAnonFunctionType;

      // buffer tokens while we are in speculative mode
      this.onToken = options.onToken();
      options.onToken(
          (tk) -> {
            tokens.add(tk);
            return null;
          });

      // buffer recoverable errors while we are in speculative mode
      this.onRecoverableError = options.onRecoverableError();
      options.onRecoverableError(
          (err) -> {
            errors.add(err);
            return null;
          });
    }

    private void reset() {
      FlowParser.this.exprAllowed = this.exprAllowed;
      FlowParser.this.pos = this.pos;
      FlowParser.this.lineStart = this.lineStart;
      FlowParser.this.curLine = this.curLine;
      FlowParser.this.start = this.start;
      FlowParser.this.end = this.end;
      FlowParser.this.potentialArrowAt = this.potentialArrowAt;
      FlowParser.this.type = this.type;
      FlowParser.this.value = this.value;
      FlowParser.this.startLoc = this.startLoc;
      FlowParser.this.endLoc = this.endLoc;
      FlowParser.this.lastTokEndLoc = this.lastTokEndLoc;
      FlowParser.this.lastTokStartLoc = this.lastTokStartLoc;
      FlowParser.this.lastTokStart = this.lastTokStart;
      FlowParser.this.lastTokEnd = this.lastTokEnd;
      FlowParser.this.context = this.context;
      options.onToken(this.onToken);
      FlowParser.this.inType = this.inType;
      FlowParser.this.noAnonFunctionType = this.noAnonFunctionType;
      options.onRecoverableError(this.onRecoverableError);
    }

    private void commit() {
      // commit buffered tokens
      options.onToken(this.onToken);
      if (this.onToken != null) for (Token tk : tokens) this.onToken.apply(tk);

      // commit buffered syntax errors
      options.onRecoverableError(this.onRecoverableError);
      if (this.onRecoverableError != null)
        for (SyntaxError err : errors) this.onRecoverableError.apply(err);
    }
  }

  private boolean isRelational(String op) {
    return this.type == TokenType.relational && op.equals(value);
  }

  private void expectRelational(String op) {
    if (isRelational(op)) next();
    else unexpected();
  }

  private void flowParseTypeInitialiser(TokenType tok, boolean allowLeadingPipeOrAnd) {
    boolean oldInType = inType;
    inType = true;
    this.expect(tok == null ? TokenType.colon : tok);
    if (this.type == TokenType.modulo) { // an annotation like '%checks' without a preceeding type
      inType = oldInType;
      return;
    }
    if (allowLeadingPipeOrAnd) {
      if (this.type == TokenType.bitwiseAND || this.type == TokenType.bitwiseOR) {
        this.next();
      }
    }
    this.flowParseType();
    inType = oldInType;
  }

  private void flowParseDeclareClass(Position start) {
    this.next();
    this.flowParseInterfaceish(start, true);
  }

  private void flowParseDeclareFunction(Position start) {
    this.next();

    Identifier id = this.parseIdent(false);

    if (this.isRelational("<")) {
      this.flowParseTypeParameterDeclaration();
    }

    this.expect(TokenType.parenL);
    this.flowParseFunctionTypeParams();
    this.expect(TokenType.parenR);
    this.flowParseTypeInitialiser(null, false);

    this.finishNode(id);

    this.semicolon();
  }

  private void flowParseDeclare(Position start) {
    if (this.type == TokenType._class) {
      this.flowParseDeclareClass(start);
    } else if (this.type == TokenType._function) {
      this.flowParseDeclareFunction(start);
    } else if (this.type == TokenType._var) {
      this.flowParseDeclareVariable(start);
    } else if (this.isContextual("module")) {
      if (".".equals(lookahead(1))) this.flowParseDeclareModuleExports();
      else this.flowParseDeclareModule(start);
    } else if (this.isContextual("type")) {
      this.flowParseDeclareTypeAlias(start);
    } else if (this.isContextual("opaque")) {
      this.flowParseDeclareOpaqueType(start);
    } else if (this.isContextual("interface")) {
      this.flowParseDeclareInterface(start);
    } else if (this.type == TokenType._export) {
      this.flowParseDeclareExportDeclaration(start);
    } else {
      this.unexpected();
    }
  }

  private void flowParseDeclareVariable(Position start) {
    this.next();
    this.flowParseTypeAnnotatableIdentifier(false, false);
    this.semicolon();
  }

  private void flowParseDeclareModule(Position start) {
    this.next();

    if (this.type == TokenType.string) {
      this.parseExprAtom(null);
    } else {
      this.parseIdent(false);
    }

    this.expect(TokenType.braceL);
    while (this.type != TokenType.braceR) {
      Position stmtStart = startLoc;
      if (this.eatContextual("declare")) {
        this.flowParseDeclare(stmtStart);
      } else if (this.eat(TokenType._import)) {
        if (peekAtSpecialFlowImportSpecifier() == null) {
          this.raise(
              stmtStart,
              "Imports within a `declare module` body must always be `import type` or `import typeof`.");
        }
        this.parseImportRest(new SourceLocation(stmtStart));
      } else {
        unexpected();
      }
    }
    this.expect(TokenType.braceR);
  }

  private void flowParseDeclareModuleExports() {
    this.expectContextual("module");
    this.expect(TokenType.dot);
    this.expectContextual("exports");
    this.flowParseTypeAnnotation();
    this.semicolon();
  }

  private void flowParseDeclareTypeAlias(Position start) {
    this.next();
    this.flowParseTypeAlias(start);
  }

  private void flowParseDeclareOpaqueType(Position start) {
    this.next();
    this.flowParseOpaqueType(start, true);
  }

  private void flowParseDeclareInterface(Position start) {
    this.next();
    this.flowParseInterfaceish(start, false);
  }

  private boolean match(TokenType tt) {
    return this.type == tt;
  }

  private void flowParseDeclareExportDeclaration(Position start) {
    this.expect(TokenType._export);

    if (this.eat(TokenType._default)) {
      if (this.match(TokenType._function) || this.match(TokenType._class)) {
        // declare export default class ...
        // declare export default function ...
        this.flowParseDeclare(this.startLoc);
      } else {
        // declare export default [type];
        this.flowParseType();
        this.semicolon();
      }
      return;
    } else {
      if (this.match(TokenType._const) || this.isContextual("let")) {
        this.unexpected();
      }

      if (this.match(TokenType._var)
          || // declare export var ...
          this.match(TokenType._function)
          || // declare export function ...
          this.match(TokenType._class)
          || // declare export class ...
          this.isContextual("opaque") // declare export opaque ..
      ) {
        this.flowParseDeclare(this.startLoc);
        return;
      } else if (this.match(TokenType.star)
          || // declare export * from ''
          this.match(TokenType.braceL)
          || // declare export {} ...
          this.isContextual("interface")
          || // declare export interface ...
          this.isContextual("type")
          || // declare export type ...
          this.isContextual("opaque") // declare export opaque type ...
      ) {
        this.parseExportRest(new SourceLocation(start), new LinkedHashSet<>());
        return;
      }
    }

    this.unexpected();
  }

  // Interfaces

  private void flowParseInterfaceish(Position start, boolean allowStatic) {
    this.parseIdent(false);

    if (this.isRelational("<")) {
      this.flowParseTypeParameterDeclaration();
    }

    if (this.eat(TokenType._extends)) {
      do {
        this.flowParseInterfaceExtends();
      } while (this.eat(TokenType.comma));
    }

    if (this.isContextual("mixins")) {
      this.next();
      do {
        this.flowParseInterfaceExtends();
      } while (this.eat(TokenType.comma));
    }

    this.flowParseObjectType(allowStatic, false, false);
  }

  private void flowParseInterfaceExtends() {
    this.flowParseQualifiedTypeIdentifier(null);

    if (this.isRelational("<")) {
      this.flowParseTypeParameterInstantiation();
    }
  }

  private void flowParseQualifiedTypeIdentifier(Identifier id) {
    if (id == null) this.parseIdent(false);

    while (this.eat(TokenType.dot)) this.parseIdent(false);
  }

  private void flowParseInterface(Position start) {
    this.flowParseInterfaceish(start, false);
  }

  // Type aliases

  private void flowParseTypeAlias(Position start) {
    this.parseIdent(false);

    if (this.isRelational("<")) {
      this.flowParseTypeParameterDeclaration();
    }

    this.flowParseTypeInitialiser(TokenType.eq, /*allowLeadingPipeOrAnd*/ true);
    this.semicolon();
  }

  private void flowParseOpaqueType(Position start, boolean declare) {
    this.expectContextual("type");
    this.parseIdent(false);

    if (this.isRelational("<")) {
      this.flowParseTypeParameterDeclaration();
    }

    // Parse the supertype
    if (this.type == TokenType.colon) {
      this.flowParseTypeInitialiser(TokenType.colon, false);
    }

    if (!declare) {
      this.flowParseTypeInitialiser(TokenType.eq, false);
    }

    this.semicolon();
  }

  // Type annotations

  private void flowParseTypeParameter() {
    this.eat(TokenType.plusMin);

    this.flowParseTypeAnnotatableIdentifier(false, false);

    if (this.eat(TokenType.eq)) {
      this.flowParseType();
    }
  }

  private void flowParseTypeParameterDeclaration() {
    if (this.isRelational("<") || this.type == jsxTagStart) {
      this.next();
    } else {
      this.unexpected();
    }

    do {
      this.flowParseTypeParameter();
      if (!this.isRelational(">")) {
        this.expect(TokenType.comma);
      }
    } while (!this.isRelational(">"));
    this.expectRelational(">");
  }

  private void flowParseTypeParameterInstantiation() {
    boolean oldInType = inType;

    inType = true;

    this.expectRelational("<");
    while (!this.isRelational(">")) {
      this.flowParseType();
      if (!this.isRelational(">")) {
        this.expect(TokenType.comma);
      }
    }
    this.expectRelational(">");

    inType = oldInType;
  }

  private void flowParseObjectPropertyKey() {
    if (this.type == TokenType.num || this.type == TokenType.string) {
      this.parseExprAtom(null);
    } else if ("@@iterator".equals(inputSubstring(start, start + 10))) {
      // allow `@@iterator` as property name; this doesn't appear to be standard Flow syntax,
      // but is used a few times in react-native
      this.expect(at);
      this.expect(at);
      this.expect(TokenType.name);
    } else {
      this.parseIdent(true);
    }
  }

  private void flowParseObjectTypeIndexer(Position start, boolean isStatic) {
    this.expect(TokenType.bracketL);
    if (":".equals(lookahead(1))) {
      this.flowParseObjectPropertyKey();
      this.flowParseTypeInitialiser(null, false);
    } else {
      this.flowParseType();
    }
    this.expect(TokenType.bracketR);
    this.flowParseTypeInitialiser(null, false);

    this.flowObjectTypeSemicolon();
  }

  private void flowParseObjectTypeMethodish(Position start) {
    if (this.isRelational("<")) {
      this.flowParseTypeParameterDeclaration();
    }

    this.expect(TokenType.parenL);
    while (this.type != TokenType.ellipsis && this.type != TokenType.parenR) {
      this.flowParseFunctionTypeParam();
      if (this.type != TokenType.parenR) {
        this.expect(TokenType.comma);
      }
    }

    if (this.eat(TokenType.ellipsis)) {
      this.flowParseFunctionTypeParam();
    }
    this.expect(TokenType.parenR);
    this.flowParseTypeInitialiser(null, false);
  }

  private void flowParseObjectTypeMethod(Position start, boolean isStatic) {
    this.flowParseObjectTypeMethodish(start);
    this.flowObjectTypeSemicolon();
  }

  private void flowParseObjectTypeCallProperty(Position start, boolean isStatic) {
    this.flowParseObjectTypeMethodish(start);
    this.flowObjectTypeSemicolon();
  }

  private void flowParseObjectType(boolean allowStatic, boolean allowExact, boolean allowSpread) {
    boolean isStatic = false;

    TokenType endDelim;
    if (allowExact && this.eat(braceBarL)) {
      endDelim = braceBarR;
    } else {
      this.expect(TokenType.braceL);
      endDelim = TokenType.braceR;
    }

    while (this.type != endDelim) {
      Position innerStart = startLoc;
      if (allowStatic && this.isContextual("static")) {
        this.next();
        isStatic = true;
      }

      // variance annotation
      this.eat(TokenType.plusMin);

      if (this.type == TokenType.bracketL) {
        this.flowParseObjectTypeIndexer(innerStart, isStatic);
      } else if (this.type == TokenType.parenL || this.isRelational("<")) {
        this.flowParseObjectTypeCallProperty(innerStart, allowStatic);
      } else {
        if (isStatic && this.type == TokenType.colon) {
          this.parseIdent(false);
        } else if (allowSpread && this.eat(TokenType.ellipsis)) {
          boolean hasType =
              this.type != endDelim && this.type != TokenType.comma && this.type != TokenType.semi;
          if (hasType) {
            flowParseType();
          }
          flowObjectTypeSemicolon();
          continue;
        } else {
          this.flowParseObjectPropertyKey();
        }
        if (this.isRelational("<") || this.type == TokenType.parenL) {
          // This is a method property
          this.flowParseObjectTypeMethod(innerStart, isStatic);
        } else {
          if (this.eat(TokenType.question)) {
            // do something
          }
          this.flowParseTypeInitialiser(null, false);
          this.flowObjectTypeSemicolon();
        }
      }
    }

    this.expect(endDelim);
  }

  private void flowObjectTypeSemicolon() {
    if (!this.eat(TokenType.semi)
        && !this.eat(TokenType.comma)
        && this.type != TokenType.braceR
        && this.type != braceBarR) {
      this.unexpected();
    }
  }

  private void flowParseGenericType(Position start) {
    while (this.eat(TokenType.dot)) {
      this.parseIdent(false);
    }

    if (this.isRelational("<")) {
      this.flowParseTypeParameterInstantiation();
    }
  }

  private void flowParseTypeofType() {
    this.expect(TokenType._typeof);
    this.flowParsePrimaryType();
  }

  private void flowParseTupleType() {
    this.expect(TokenType.bracketL);
    // We allow trailing commas
    while (this.pos < this.input.length() && this.type != TokenType.bracketR) {
      this.flowParseType();
      if (this.type == TokenType.bracketR) break;
      this.expect(TokenType.comma);
    }
    this.expect(TokenType.bracketR);
  }

  private void flowParseFunctionTypeParam() {
    String lh = lookahead(1);
    if (":".equals(lh) || "?".equals(lh)) {
      this.parseIdent(false);
      this.eat(TokenType.question);
      this.flowParseTypeInitialiser(null, false);
    } else {
      flowParseType();
    }
  }

  private void flowParseFunctionTypeParams() {
    while (this.type != TokenType.parenR && this.type != TokenType.ellipsis) {
      this.flowParseFunctionTypeParam();
      if (this.type != TokenType.parenR) {
        this.expect(TokenType.comma);
      }
    }
    if (this.eat(TokenType.ellipsis)) {
      this.flowParseFunctionTypeParam();
    }
  }

  private void flowIdentToTypeAnnotation(Position start, Identifier id) {
    switch (id.getName()) {
      case "any":
        return;

      case "void":
        return;

      case "bool":
      case "boolean":
        return;

      case "mixed":
        return;

      case "number":
        return;

      case "string":
        return;

      default:
        this.flowParseGenericType(start);
    }
  }

  private String lookahead(int n) {
    Matcher m = Whitespace.skipWhiteSpace.matcher(this.input);
    if (m.find(this.pos)) return inputSubstring(m.end(), m.end() + n);
    return "";
  }

  // The parsing of types roughly parallels the parsing of expressions, and
  // primary types are kind of like primary expressions...they're the
  // primitives with which other types are constructed.
  private void flowParsePrimaryType() {
    Position start = startLoc;
    boolean isGroupedType = false;
    boolean oldNoAnonFunctionType = noAnonFunctionType;

    if (this.type == TokenType.name) {
      this.flowIdentToTypeAnnotation(start, this.parseIdent(false));
      return;
    } else if (this.type == TokenType._void) {
      this.next();
      return;
    } else if (this.type == TokenType.braceL) {
      this.flowParseObjectType(false, false, true);
      return;
    } else if (this.type == braceBarL) {
      this.flowParseObjectType(false, true, true);
      return;
    } else if (this.type == TokenType.bracketL) {
      this.flowParseTupleType();
      return;
    } else if (this.type == TokenType.relational) {
      if ("<".equals(this.value)) {
        this.flowParseTypeParameterDeclaration();
        this.expect(TokenType.parenL);
        this.flowParseFunctionTypeParams();
        this.expect(TokenType.parenR);

        this.expect(TokenType.arrow);

        this.flowParseType();
        return;
      } else {
        this.unexpected();
      }
    } else if (this.type == TokenType.parenL) {
      this.next();

      // Check to see if this is actually a grouped type
      if (this.type != TokenType.parenR && this.type != TokenType.ellipsis) {
        if (this.type == TokenType.name) {
          String lh = lookahead(1);
          if ("?".equals(lh) || ":".equals(lh)) {
            isGroupedType = false;
          } else {
            isGroupedType = true;
          }
        } else {
          isGroupedType = true;
        }
      }

      if (isGroupedType) {
        this.noAnonFunctionType = false;
        this.flowParseType();
        this.noAnonFunctionType = oldNoAnonFunctionType;

        if (noAnonFunctionType
            || !(this.type == TokenType.comma
                || (this.type == TokenType.parenR && "=>".equals(lookahead(2))))) {
          this.expect(TokenType.parenR);
          return;
        } else {
          // Eat a comma if there is one
          this.eat(TokenType.comma);
        }
      }

      this.flowParseFunctionTypeParams();

      this.expect(TokenType.parenR);

      this.expect(TokenType.arrow);

      this.flowParseType();
      return;
    } else if (this.type == TokenType.string) {
      this.next();
      return;
    } else if (this.type == TokenType._true || this.type == TokenType._false) {
      this.next();
      return;
    } else if (this.type == TokenType.plusMin || this.type == TokenType.num) {
      if ("-".equals(this.value)) {
        this.next();
        if (this.type != TokenType.num) this.unexpected();
        this.next();
        return;
      }

      this.next();
      return;
    } else if (this.type == TokenType._null) {
      this.next();
      return;
    } else if (this.type == TokenType._this) {
      this.next();
      return;
    } else if (this.type == TokenType.star) {
      this.next();
      return;
    } else if ("typeof".equals(this.type.keyword)) {
      this.flowParseTypeofType();
      return;
    }

    this.unexpected();
  }

  private void flowParsePostfixType() {
    this.flowParsePrimaryType();
    while (this.type == TokenType.bracketL) {
      this.expect(TokenType.bracketL);
      this.expect(TokenType.bracketR);
    }
  }

  private void flowParsePrefixType() {
    if (this.eat(TokenType.question)) {
      this.flowParsePrefixType();
    } else {
      this.flowParsePostfixType();
    }
  }

  private void flowParseIntersectionType() {
    this.eat(TokenType.bitwiseAND);
    this.flowParseAnonFunctionWithoutParens();
    while (this.eat(TokenType.bitwiseAND)) {
      this.flowParseAnonFunctionWithoutParens();
    }
  }

  private void flowParseAnonFunctionWithoutParens() {
    this.flowParsePrefixType();
    if (!noAnonFunctionType && eat(TokenType.arrow)) flowParseType();
  }

  private void flowParseUnionType() {
    this.eat(TokenType.bitwiseOR);
    this.flowParseIntersectionType();
    while (this.eat(TokenType.bitwiseOR)) {
      this.flowParseIntersectionType();
    }
  }

  private void flowParseType() {
    boolean oldInType = inType;
    inType = true;
    this.flowParseUnionType();
    inType = oldInType;
  }

  private void flowParseTypeAnnotation() {
    this.flowParseTypeInitialiser(null, false);
  }

  private void flowParseTypeAnnotatableIdentifier(
      boolean requireTypeAnnotation, boolean canBeOptionalParam) {
    this.parseIdent(false);
    if (canBeOptionalParam && this.eat(TokenType.question)) {
      this.expect(TokenType.question);
    }

    if (requireTypeAnnotation || this.type == TokenType.colon) {
      this.flowParseTypeAnnotation();
    }
  }

  /** Should Flow syntax be allowed? */
  private boolean flow() {
    return options.allowFlowTypes();
  }

  @Override
  protected Node parseFunctionBody(
      Identifier id, List<Expression> params, boolean isArrowFunction) {
    // plain function return types: `function name(): string {}`
    if (flow() && this.type == TokenType.colon) {
      // if allowExpression is true then we're parsing an arrow function and if
      // there's a return type then it's been handled elsewhere
      this.flowParseTypeAnnotation();
      this.flowParseChecksAnnotation();
    }

    return super.parseFunctionBody(id, params, isArrowFunction);
  }

  private void flowParseChecksAnnotation() {
    // predicate functions with the special '%checks' annotation
    if (this.type == TokenType.modulo && lookaheadIsIdent("checks", true)) {
      this.next();
      this.next();
    }
  }

  // interfaces
  @Override
  protected Statement parseStatement(boolean declaration, boolean topLevel, Set<String> exports) {
    // strict mode handling of `interface` since it's a reserved word
    if (flow()
        && declaration
        && this.strict
        && this.type == TokenType.name
        && "interface".equals(this.value)) {
      Position start = startLoc;
      this.next();
      this.flowParseInterface(start);
      return null;
    } else {
      return super.parseStatement(declaration, topLevel, exports);
    }
  };

  // declares, interfaces and type aliases
  @Override
  protected ExpressionStatement parseExpressionStatement(
      boolean declaration, Position start, Expression expr) {
    if (flow() && declaration && expr instanceof Identifier) {
      String name = ((Identifier) expr).getName();
      if ("declare".equals(name)) {
        if (this.type == TokenType._class
            || this.type == TokenType.name
            || this.type == TokenType._function
            || this.type == TokenType._var
            || this.type == TokenType._export) {
          this.flowParseDeclare(start);
          return null;
        }
      } else if (this.type == TokenType.name) {
        if ("interface".equals(name)) {
          this.flowParseInterface(start);
          return null;
        } else if ("type".equals(name)) {
          this.flowParseTypeAlias(start);
          return null;
        } else if ("opaque".equals(name)) {
          this.flowParseOpaqueType(start, false);
          return null;
        }
      }
    }

    return super.parseExpressionStatement(declaration, start, expr);
  }

  // export type
  @Override
  protected boolean shouldParseExportStatement() {
    return flow()
            && (this.isContextual("type")
                || this.isContextual("interface")
                || this.isContextual("opaque"))
        || super.shouldParseExportStatement();
  }

  @Override
  protected Expression parseParenItem(Expression left, int startPos, Position startLoc) {
    Expression node = super.parseParenItem(left, startPos, startLoc);

    if (flow()) {
      if (this.eat(TokenType.question)) {
        // do something with the information
      }

      if (this.type == TokenType.colon) {
        this.flowParseTypeAnnotation();
      }
    }

    return node;
  };

  @Override
  protected ExportDeclaration parseExportRest(SourceLocation loc, Set<String> exports) {
    if (flow() && (this.type.keyword != null || shouldParseExportStatement())) {
      Position start = startLoc;
      if (this.isContextual("type")) {
        this.next();

        if (this.type == TokenType.braceL) {
          // `export type { foo, bar };`
          List<ExportSpecifier> specifiers = this.parseExportSpecifiers(exports);
          this.parseExportFrom(specifiers, null, false);
          this.parseImportOrExportAttributesAndSemicolon();
          return null;
        } else if (this.eat(TokenType.star)) {
          if (this.eatContextual("as")) this.parseIdent(true);
          this.parseExportFrom(null, null, true);
          this.parseImportOrExportAttributesAndSemicolon();
          return null;
        } else {
          // `export type Foo = Bar;`
          this.flowParseTypeAlias(startLoc);
          return null;
        }
      } else if (this.isContextual("opaque")) {
        this.next();
        this.flowParseOpaqueType(start, false);
        return null;
      } else if (this.isContextual("interface")) {
        this.next();
        this.flowParseInterface(start);
        return null;
      }
    }
    return super.parseExportRest(loc, exports);
  }

  @Override
  protected Identifier parseClassId(boolean isStatement) {
    Identifier id = super.parseClassId(isStatement);
    if (flow() && this.isRelational("<")) this.flowParseTypeParameterDeclaration();
    return id;
  }

  // don't consider `void` to be a keyword as then it'll use the void token type
  // and set startExpr
  @Override
  protected boolean isKeyword(String src) {
    if (inType && "void".equals(src)) return false;
    return super.isKeyword(src);
  }

  // ensure that inside flow types, we bypass the jsx parser plugin
  @Override
  protected Token readToken(int code) {
    if (this.inType && (code == 62 || code == 60)) {
      return this.finishOp(TokenType.relational, 1);
    } else {
      return super.readToken(code);
    }
  }

  @Override
  protected MethodDefinition parseClassMethod(
      Position startLoc,
      boolean isGenerator,
      boolean isAsync,
      boolean isStatic,
      boolean isComputed,
      MethodDefinition.Kind kind,
      Expression key) {
    if (flow() && this.isRelational("<")) {
      this.flowParseTypeParameterDeclaration();
    }
    return super.parseClassMethod(startLoc, isGenerator, isAsync, isStatic, isComputed, kind, key);
  }

  // parse a the super class type parameters and implements
  @Override
  protected Expression parseClassSuper() {
    Expression ext = super.parseClassSuper();
    if (flow() && ext != null && this.isRelational("<")) this.flowParseTypeParameterInstantiation();
    if (flow() && this.isContextual("implements")) {
      this.next();
      do {
        this.parseIdent(false);
        if (this.isRelational("<")) this.flowParseTypeParameterInstantiation();
      } while (this.eat(TokenType.comma));
    }
    return ext;
  }

  @Override
  protected Expression processBindingListItem(Expression param) {
    if (flow()) {
      if (this.eat(TokenType.question)) {
        // do something
      }
      if (this.type == TokenType.colon) {
        this.flowParseTypeAnnotation();
      }
      this.finishNode(param);
    }
    return param;
  }

  private String flowParseImportSpecifiers() {
    String kind = peekAtSpecialFlowImportSpecifier();
    if (kind != null) {
      String lh = lookahead(4);
      if (!lh.isEmpty()) {
        int c = lh.codePointAt(0);
        if ((Identifiers.isIdentifierStart(c, true) && !"from".equals(lh))
            || c == '{'
            || c == '*') {
          this.next();
        }
      }
    }
    return kind;
  }

  private String peekAtSpecialFlowImportSpecifier() {
    String kind = null;
    if (this.type == TokenType._typeof) {
      kind = "typeof";
    } else if (this.isContextual("type")) {
      kind = "type";
    }
    return kind;
  }

  @Override
  protected List<ImportSpecifier> parseImportSpecifiers() {
    String kind = null;
    if (flow()) {
      kind = flowParseImportSpecifiers();
    }

    List<ImportSpecifier> specs = super.parseImportSpecifiers();
    if (kind != null || specs.isEmpty()) return null;
    return specs;
  }

  @Override
  protected ImportSpecifier parseImportSpecifier() {
    if (peekAtSpecialFlowImportSpecifier() != null) {
      String lh = lookahead(2);
      if (lh.charAt(0) == ',' || lh.charAt(0) == '}' || lh.equals("as"))
        return super.parseImportSpecifier();
      this.next();
      super.parseImportSpecifier();
      return null;
    } else {
      return super.parseImportSpecifier();
    }
  }

  @Override
  protected List<Expression> parseFunctionParams() {
    if (flow()) {
      boolean oldInType = this.inType;
      this.inType = true;
      if (this.isRelational("<")) {
        this.flowParseTypeParameterDeclaration();
      }
      this.inType = oldInType;
    }
    return super.parseFunctionParams();
  }

  // parse flow type annotations on variable declarator heads - let foo: string = bar
  @Override
  protected Expression parseVarId() {
    Expression varId = super.parseVarId();
    if (flow() && this.type == TokenType.colon) {
      this.flowParseTypeAnnotation();
      this.finishNode(varId);
    }
    return varId;
  }

  @Override
  protected Expression parseBindingAtom() {
    Expression bindingAtom = super.parseBindingAtom();
    if (flow()) {
      if (this.eat(TokenType.question)) {
        // do something
      }
      if (this.type == TokenType.colon) {
        this.flowParseTypeAnnotation();
      }
      this.finishNode(bindingAtom);
    }
    return bindingAtom;
  }

  @Override
  protected Expression processExprListItem(Expression item) {
    if (flow()) {
      if (this.eat(TokenType.question)) {
        // do something
      }
      if (this.type == TokenType.colon) {
        this.flowParseTypeAnnotation();
      }
      this.finishNode(item);
    }
    return item;
  }

  @Override
  protected Expression parseConditionalRest(boolean noIn, Position start, Expression test) {
    if (flow()) {
      if (this.type == TokenType.colon) {
        this.flowParseTypeAnnotation();
        return test;
      } else if (this.type == TokenType.comma || this.type == TokenType.parenR) {
        return test;
      }
    }
    return super.parseConditionalRest(noIn, start, test);
  }

  @Override
  protected ParenthesisedExpressions parseParenthesisedExpressions(
      DestructuringErrors refDestructuringErrors) {
    ParenthesisedExpressions pe = super.parseParenthesisedExpressions(refDestructuringErrors);

    // handle return types for arrow functions
    if (flow() && this.type == TokenType.colon) {
      // This is a tricky case: we have parsed `c ? (e) :`
      // We could be in the middle of parsing an arrow expression with a declared
      // return type (that is, we are expecting to see `t => b : f`, with `t` the
      // declared return type, `b` the body of the arrow expression, and `f` the
      // "else" branch of the conditional expression), or we could be done parsing
      // the "then" branch of the conditional (that is, we are expecting to see the
      // "else" branch `f`).
      // We model the behaviour of Babel and Flow by trying to parse the following
      // tokens as a type annotation followed by an arrow token. If this fails, we
      // backtrack.
      State backup = new State();
      try {
        boolean oldNoAnonFunctionType = noAnonFunctionType;
        noAnonFunctionType = true;
        flowParseTypeAnnotation();
        flowParseChecksAnnotation();
        noAnonFunctionType = oldNoAnonFunctionType;
        if (this.type != TokenType.arrow) unexpected();
        backup.commit();
      } catch (SyntaxError e) {
        Exceptions.ignore(e, "Backtracking parser.");
        backup.reset();
      }
    }

    return pe;
  }

  @Override
  protected boolean shouldParseAsyncArrow() {
    if (flow() && this.type == TokenType.colon) {
      boolean oldNoAnonFunctionType = noAnonFunctionType;
      noAnonFunctionType = true;
      this.flowParseTypeAnnotation();
      noAnonFunctionType = oldNoAnonFunctionType;
    }
    return super.shouldParseAsyncArrow();
  }

  @Override
  protected boolean isClassProperty() {
    return flow() && this.type == TokenType.colon || super.isClassProperty();
  }

  @Override
  protected FieldDefinition parseFieldDefinition(PropertyInfo pi, boolean isStatic) {
    if (flow() && this.type == TokenType.colon) {
      this.flowParseTypeAnnotation();
    }
    return super.parseFieldDefinition(pi, isStatic);
  }

  // parse type parameters for object method shorthand
  @Override
  protected void parsePropertyValue(PropertyInfo pi, DestructuringErrors refDestructuringErrors) {
    // method shorthand
    if (flow() && this.isRelational("<")) {
      this.flowParseTypeParameterDeclaration();
      if (this.type != TokenType.parenL) this.unexpected();
    }

    super.parsePropertyValue(pi, refDestructuringErrors);
  }

  @Override
  protected void parsePropertyName(PropertyInfo result) {
    if (flow()) this.eat(TokenType.plusMin);
    super.parsePropertyName(result);
  }

  @Override
  protected boolean atGetterSetterName(PropertyInfo pi) {
    if (flow() && this.isRelational("<")) return false;
    return super.atGetterSetterName(pi);
  }

  @Override
  protected Pair<Expression, Boolean> parseSubscript(
      final Expression base, Position startLoc, boolean noCalls) {
    if (!noCalls) {
      maybeFlowParseTypeParameterInstantiation(base, true);
    }
    return super.parseSubscript(base, startLoc, noCalls);
  }

  private void maybeFlowParseTypeParameterInstantiation(Expression left, boolean requireParenL) {
    if (flow() && this.isRelational("<")) {
      // Ambiguous case: `e1<e2>(e3)` is parsed differently as JS and Flow code:
      // JS: two relational comparisons: `e1 < e2 > e3`
      // Flow: a call `e1(e3)` with explicit type parameter `e2`

      // Heuristic: if the left operand of the `<` token is a primitive from a literal or
      // unary/binary expression, then it probably isn't a call, as that would always crash
      left = left.stripParens();
      if (left instanceof Literal
          || left instanceof UnaryExpression
          || left instanceof BinaryExpression) return;

      // If it can be parsed as Flow, we use that, otherwise we parse it as JS
      State backup = new State();
      try {
        this.flowParseTypeParameterInstantiation();
        if (requireParenL && this.type != TokenType.parenL) {
          unexpected();
        }
        backup.commit();
      } catch (SyntaxError e) {
        Exceptions.ignore(e, "Backtracking parser.");
        backup.reset();
      }
    }
  }

  @Override
  protected Expression parseNewArguments(Position startLoc, Expression callee) {
    maybeFlowParseTypeParameterInstantiation(callee, false /* case: new e1<e2>e3 */);
    return super.parseNewArguments(startLoc, callee);
  }
}
