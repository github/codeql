package com.semmle.jcorn;

import com.semmle.jcorn.TokenType.Properties;
import com.semmle.jcorn.jsx.JSXParser;
import com.semmle.js.ast.BindExpression;
import com.semmle.js.ast.BlockStatement;
import com.semmle.js.ast.CatchClause;
import com.semmle.js.ast.ClassDeclaration;
import com.semmle.js.ast.ClassExpression;
import com.semmle.js.ast.DeclarationFlags;
import com.semmle.js.ast.Decorator;
import com.semmle.js.ast.DynamicImport;
import com.semmle.js.ast.ExportDeclaration;
import com.semmle.js.ast.ExportDefaultDeclaration;
import com.semmle.js.ast.ExportDefaultSpecifier;
import com.semmle.js.ast.ExportNamedDeclaration;
import com.semmle.js.ast.ExportNamespaceSpecifier;
import com.semmle.js.ast.ExportSpecifier;
import com.semmle.js.ast.Expression;
import com.semmle.js.ast.FieldDefinition;
import com.semmle.js.ast.ForOfStatement;
import com.semmle.js.ast.INode;
import com.semmle.js.ast.IPattern;
import com.semmle.js.ast.Identifier;
import com.semmle.js.ast.Literal;
import com.semmle.js.ast.MemberDefinition;
import com.semmle.js.ast.MemberExpression;
import com.semmle.js.ast.MetaProperty;
import com.semmle.js.ast.Node;
import com.semmle.js.ast.ObjectPattern;
import com.semmle.js.ast.Position;
import com.semmle.js.ast.Property;
import com.semmle.js.ast.RestElement;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.SpreadElement;
import com.semmle.js.ast.Statement;
import com.semmle.js.ast.Token;
import com.semmle.util.collections.CollectionUtil;
import com.semmle.util.data.Pair;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * An extension of the {@link JSXParser} with support for various unfinished ECMAScript proposals
 * that are not supported by Acorn/jcorn yet.
 *
 * <p>Once support becomes available, they should be removed from this class.
 */
public class ESNextParser extends JSXParser {
  public ESNextParser(Options options, String input, int startPos) {
    super(options.allowImportExportEverywhere(true), input, startPos);
  }

  /*
   * Support for proposed language feature "Object Rest/Spread Properties"
   * (http://sebmarkbage.github.io/ecmascript-rest-spread/).
   */

  @Override
  protected Property parseProperty(
      boolean isPattern,
      DestructuringErrors refDestructuringErrors,
      Map<String, PropInfo> propHash) {
    Position start = this.startLoc;

    List<Decorator> decorators = parseDecorators();

    Property prop = null;
    if (this.type == TokenType.ellipsis) {
      SpreadElement spread = this.parseSpread(null);
      Expression val;
      if (isPattern) val = new RestElement(spread.getLoc(), spread.getArgument());
      else val = spread;
      prop =
          this.finishNode(
              new Property(
                  new SourceLocation(start), null, val, Property.Kind.INIT.name(), false, false));
    }

    if (prop == null) prop = super.parseProperty(isPattern, refDestructuringErrors, propHash);

    prop.addDecorators(decorators);

    return prop;
  }

  @Override
  protected INode toAssignable(INode node, boolean isBinding) {
    if (node instanceof SpreadElement)
      return new RestElement(node.getLoc(), ((SpreadElement) node).getArgument());
    return super.toAssignable(node, isBinding);
  }

  @Override
  protected void checkLVal(INode expr, boolean isBinding, Set<String> checkClashes) {
    super.checkLVal(expr, isBinding, checkClashes);
    if (expr instanceof ObjectPattern) {
      ObjectPattern op = (ObjectPattern) expr;
      if (op.hasRest()) checkLVal(op.getRest(), isBinding, checkClashes);
    }
  }

  /*
   * Support for proposed language feature "Public Class Fields"
   * (http://jeffmo.github.io/es-class-public-fields/).
   */

  private boolean classProperties() {
    return options.esnext();
  }

  @Override
  protected MemberDefinition<?> parseClassPropertyBody(
      PropertyInfo pi, boolean hadConstructor, boolean isStatic) {
    if (classProperties() && !pi.isGenerator && this.isClassProperty())
      return this.parseFieldDefinition(pi, isStatic);
    return super.parseClassPropertyBody(pi, hadConstructor, isStatic);
  }

  protected boolean isClassProperty() {
    return this.type == TokenType.eq || this.type == TokenType.semi || this.canInsertSemicolon();
  }

  protected FieldDefinition parseFieldDefinition(PropertyInfo pi, boolean isStatic) {
    Expression value = null;
    if (this.type == TokenType.eq) {
      this.next();
      boolean oldInFunc = this.inFunction;
      this.inFunction = true;
      value = parseMaybeAssign(false, null, null);
      this.inFunction = oldInFunc;
    }
    this.semicolon();
    int flags = DeclarationFlags.getStatic(isStatic) | DeclarationFlags.getComputed(pi.computed);
    return this.finishNode(
        new FieldDefinition(new SourceLocation(pi.startLoc), flags, pi.key, value));
  }

  /*
   * Support for proposed language feature "Generator function.sent Meta Property"
   * (https://github.com/allenwb/ESideas/blob/master/Generator%20metaproperty.md)
   */
  private boolean functionSent() {
    return options.esnext();
  }

  @Override
  protected INode parseFunction(
      Position startLoc, boolean isStatement, boolean allowExpressionBody, boolean isAsync) {
    if (isFunctionSent(isStatement)) {
      Identifier meta = this.finishNode(new Identifier(new SourceLocation(startLoc), "function"));
      this.next();
      Identifier property = parseIdent(true);
      if (!property.getName().equals("sent"))
        this.raiseRecoverable(
            property, "The only valid meta property for function is function.sent");
      return this.finishNode(new MetaProperty(new SourceLocation(startLoc), meta, property));
    }

    return super.parseFunction(startLoc, isStatement, allowExpressionBody, isAsync);
  }

  protected boolean isFunctionSent(boolean isStatement) {
    return functionSent() && !isStatement && inGenerator && !inAsync && this.type == TokenType.dot;
  }

  /*
   * Support for proposed language feature "Class and Property Decorators"
   * (https://github.com/wycats/javascript-decorators)
   */
  private boolean decorators() {
    return options.esnext();
  }

  protected TokenType at = new TokenType(new Properties("@").beforeExpr());

  @Override
  protected Token getTokenFromCode(int code) {
    if (decorators() && code == 64) {
      ++this.pos;
      return this.finishToken(at);
    }
    if (functionBind() && code == 58 && charAt(this.pos + 1) == 58) {
      this.pos += 2;
      return this.finishToken(doubleColon);
    }
    return super.getTokenFromCode(code);
  }

  @Override
  protected Statement parseStatement(boolean declaration, boolean topLevel, Set<String> exports) {
    List<Decorator> decorators = this.parseDecorators();
    Statement stmt = super.parseStatement(declaration, topLevel, exports);

    if (!decorators.isEmpty()) {
      if (stmt instanceof ExportDeclaration) {
        Node exported = null;
        if (stmt instanceof ExportDefaultDeclaration) {
          exported = ((ExportDefaultDeclaration) stmt).getDeclaration();
        } else if (stmt instanceof ExportNamedDeclaration) {
          exported = ((ExportNamedDeclaration) stmt).getDeclaration();
        }
        if (exported instanceof ClassDeclaration) {
          ((ClassDeclaration) exported).addDecorators(decorators);
        } else if (exported instanceof ClassExpression) {
          ((ClassExpression) exported).addDecorators(decorators);
        } else {
          this.raise(stmt, "Decorators can only be attached to class exports");
        }
      } else if (stmt instanceof ClassDeclaration) {
        ((ClassDeclaration) stmt).addDecorators(decorators);
      } else if (stmt != null) {
        this.raise(stmt, "Leading decorators must be attached to a class declaration");
      }
    }

    return stmt;
  }

  @Override
  protected Expression parseExprAtom(DestructuringErrors refDestructuringErrors) {
    if (this.type == at) {
      List<Decorator> decorators = parseDecorators();
      ClassExpression ce = (ClassExpression) this.parseClass(startLoc, false);
      ce.addDecorators(decorators);
      return ce;
    }
    if (this.type == doubleColon) {
      SourceLocation startLoc = new SourceLocation(this.startLoc);
      this.next();
      int innerStart = this.start;
      Position innerStartLoc = this.startLoc;
      Expression callee = parseSubscripts(parseExprAtom(null), innerStart, innerStartLoc, true);
      if (!(callee instanceof MemberExpression))
        this.raiseRecoverable(callee, "Binding should be performed on a member expression.");
      return this.finishNode(new BindExpression(startLoc, null, callee));
    }
    if (this.type == TokenType._import) {
      Position startLoc = this.startLoc;
      this.next();
      if (this.eat(TokenType.dot)) {
        return parseImportMeta(startLoc);
      }
      this.expect(TokenType.parenL);
      return parseDynamicImport(startLoc);
    }
    return super.parseExprAtom(refDestructuringErrors);
  }

  @Override
  protected MemberDefinition<?> parseClassMember(boolean hadConstructor) {
    List<Decorator> decorators = parseDecorators();
    MemberDefinition<?> member = super.parseClassMember(hadConstructor);
    if (!decorators.isEmpty() && member.isConstructor())
      this.raiseRecoverable(member, "Decorators cannot be attached to class constructors.");
    member.addDecorators(decorators);
    return member;
  }

  public List<Decorator> parseDecorators() {
    List<Decorator> result = new ArrayList<Decorator>();
    while (this.type == at) result.add(this.parseDecorator());
    return result;
  }

  private Decorator parseDecorator() {
    Position start = startLoc;
    this.next();
    Expression body = parseDecoratorBody();
    Decorator decorator = new Decorator(new SourceLocation(start), body);
    return this.finishNode(decorator);
  }

  protected Expression parseDecoratorBody() {
    Expression base;
    int startPos = this.start;
    Position startLoc = this.startLoc;
    if (this.type == TokenType.parenL) {
      base = parseParenExpression();
    } else {
      base = parseIdent(true);
    }
    return parseSubscripts(base, startPos, startLoc, false);
  }

  /*
   * Support for proposed extensions to `export`
   * (http://leebyron.com/ecmascript-export-ns-from and http://leebyron.com/ecmascript-export-default-from)
   */
  private boolean exportExtensions() {
    return options.esnext();
  }

  @Override
  protected ExportDeclaration parseExportRest(SourceLocation exportStart, Set<String> exports) {
    if (exportExtensions() && this.isExportDefaultSpecifier()) {
      Position specStart = this.startLoc;
      Identifier exported = this.parseIdent(true);
      ExportDefaultSpecifier defaultSpec =
          this.finishNode(new ExportDefaultSpecifier(new SourceLocation(specStart), exported));
      List<ExportSpecifier> specifiers = CollectionUtil.makeList(defaultSpec);
      if (this.type == TokenType.comma && this.lookahead(1, true).equals("*")) {
        this.next();
        specStart = this.startLoc;
        this.expect(TokenType.star);
        this.expectContextual("as");
        exported = this.parseIdent(false);
        ExportNamespaceSpecifier nsSpec =
            this.finishNode(new ExportNamespaceSpecifier(new SourceLocation(specStart), exported));
        specifiers.add(nsSpec);
      } else {
        this.parseExportSpecifiersMaybe(specifiers, exports);
      }
      Literal source = (Literal) this.parseExportFrom(specifiers, null, true);
      Expression attributes = this.parseImportOrExportAttributesAndSemicolon();
      return this.finishNode(
          new ExportNamedDeclaration(exportStart, null, specifiers, source, attributes));
    }

    return super.parseExportRest(exportStart, exports);
  }

  @Override
  protected ExportDeclaration parseExportAll(
      SourceLocation exportStart, Position starLoc, Set<String> exports) {
    if (exportExtensions() && this.eatContextual("as")) {
      Identifier exported = this.parseIdent(false);
      ExportNamespaceSpecifier nsSpec =
          this.finishNode(new ExportNamespaceSpecifier(new SourceLocation(starLoc), exported));
      List<ExportSpecifier> specifiers = CollectionUtil.makeList(nsSpec);
      this.parseExportSpecifiersMaybe(specifiers, exports);
      Literal source = (Literal) this.parseExportFrom(specifiers, null, true);
      Expression attributes = this.parseImportOrExportAttributesAndSemicolon();
      return this.finishNode(
          new ExportNamedDeclaration(exportStart, null, specifiers, source, attributes));
    }

    return super.parseExportAll(exportStart, starLoc, exports);
  }

  private boolean isExportDefaultSpecifier() {
    if (this.type == TokenType.name) {
      return !this.value.equals("type")
          && !this.value.equals("async")
          && !this.value.equals("interface")
          && !this.value.equals("let");
    }

    if (this.type != TokenType._default) return false;

    return this.lookahead(1, true).equals(",") || this.lookaheadIsIdent("from", true);
  }

  private void parseExportSpecifiersMaybe(List<ExportSpecifier> specifiers, Set<String> exports) {
    if (this.eat(TokenType.comma)) {
      specifiers.addAll(this.parseExportSpecifiers(exports));
    }
  }

  /*
   * Support for proposed language feature "Function Bind Syntax"
   * (https://github.com/tc39/proposal-bind-operator)
   */
  private boolean functionBind() {
    return options.esnext();
  }

  protected TokenType doubleColon = new TokenType(new Properties("::").beforeExpr());

  @Override
  protected Pair<Expression, Boolean> parseSubscript(
      Expression base, Position startLoc, boolean noCalls) {
    if (!noCalls && this.eat(doubleColon)) {
      Expression callee = parseSubscripts(parseExprAtom(null), this.start, this.startLoc, true);
      BindExpression bind = new BindExpression(new SourceLocation(startLoc), base, callee);
      return Pair.make(this.finishNode(bind), true);
    }
    return super.parseSubscript(base, startLoc, noCalls);
  }

  /*
   * Support for proposed language feature "Optional Catch Binding"
   * (https://github.com/tc39/proposal-optional-catch-binding)
   */
  @Override
  protected CatchClause parseCatchClause(Position startLoc) {
    this.next();
    Expression param = null;
    if (this.eat(TokenType.parenL)) {
      param = this.parseBindingAtom();
      this.checkLVal(param, true, null);
      this.expect(TokenType.parenR);
    } else if (options.ecmaVersion() < 10) {
      this.unexpected();
    }
    BlockStatement catchBody = this.parseBlock(false);
    return this.finishNode(
        new CatchClause(new SourceLocation(startLoc), (IPattern) param, null, catchBody));
  }

  /*
   * Support for proposed language feature "Dynamic import"
   * (https://github.com/tc39/proposal-dynamic-import).
   */
  @Override
  protected Statement parseImport(Position startLoc) {
    if (!options.esnext()) return super.parseImport(startLoc);

    int startPos = this.start;
    SourceLocation loc = new SourceLocation(startLoc);
    this.next();
    if (this.eat(TokenType.parenL)) {
      DynamicImport di = parseDynamicImport(startLoc);
      Expression expr = parseSubscripts(di, startPos, startLoc, false);
      return parseExpressionStatement(false, startLoc, expr);
    } else {
      return super.parseImportRest(loc);
    }
  }

  /**
   * Parses an import.meta expression, assuming that the initial "import" and "." has been consumed.
   */
  private MetaProperty parseImportMeta(Position loc) {
    Position propertyLoc = this.startLoc;
    Identifier property = this.parseIdent(true);
    if (!property.getName().equals("meta")) {
      this.unexpected(propertyLoc);
    }
    return this.finishNode(
      new MetaProperty(new SourceLocation(loc), new Identifier(new SourceLocation(loc), "import"), property));
  }

  /**
   * Parses a dynamic import, assuming that the keyword `import` and the opening parenthesis have
   * already been consumed.
   */
  private DynamicImport parseDynamicImport(Position startLoc) {
    Expression source = parseMaybeAssign(false, null, null);
    Expression attributes = null;
    if (this.eat(TokenType.comma)) {
      if (this.type != TokenType.parenR) { // Skip if the comma was a trailing comma
        attributes = this.parseMaybeAssign(false, null, null);
        this.eat(TokenType.comma); // Allow trailing comma
      }
    }
    this.expect(TokenType.parenR);
    DynamicImport di = this.finishNode(new DynamicImport(new SourceLocation(startLoc), source, attributes));
    return di;
  }

  /*
   * Support for proposed language feature "Asynchronous iteration"
   * (https://github.com/tc39/proposal-async-iteration)
   */
  @Override
  protected Statement parseForStatement(Position startLoc) {
    int startPos = this.start;
    boolean isAwait = false;
    if (this.inAsync || (options.esnext() && !this.inFunction)) {
        if (this.eatContextual("await")) {
          isAwait = true;
        }
    }
    Statement forStmt = super.parseForStatement(startLoc);
    if (isAwait) {
      if (forStmt instanceof ForOfStatement) ((ForOfStatement) forStmt).setAwait(true);
      else this.raiseRecoverable(startPos, "Only for-of statements can be annotated with 'await'.");
    }
    return forStmt;
  }

  @Override
  protected boolean parseGeneratorMarker(boolean isAsync) {
    // always allow `*`, even if `isAsync` is true
    return this.eat(TokenType.star);
  }

  /*
   * Support for proposed language feature "Numeric separators"
   * (https://github.com/tc39/proposal-numeric-separator)
   */

  @Override
  protected Number readInt(int radix, Integer len) {
    // implementation mostly copied from super class
    int start = this.pos, code = -1;
    double total = 0;
    // no leading underscore
    boolean underscoreAllowed = false;

    for (int i = 0, e = len == null ? Integer.MAX_VALUE : len; i < e; ++i) {
      if (this.pos >= this.input.length()) break;
      code = this.input.charAt(this.pos);

      if (code == '_') {
        if (underscoreAllowed) {
          seenUnderscoreNumericSeparator = true;
          // no adjacent underscores
          underscoreAllowed = false;
          ++this.pos;
          continue;
        }
      } else {
        underscoreAllowed = true;
      }

      int val;
      if (code >= 97) val = code - 97 + 10; // a
      else if (code >= 65) val = code - 65 + 10; // A
      else if (code >= 48 && code <= 57) val = code - 48; // 0-9
      else val = Integer.MAX_VALUE;
      if (val >= radix) break;

      ++this.pos;
      total = total * radix + val;
    }
    if (this.pos == start || len != null && this.pos - start != len) return null;

    if (code == '_')
      // no trailing underscore
      return null;

    return total;
  }
}
