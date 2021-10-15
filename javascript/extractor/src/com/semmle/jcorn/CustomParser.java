package com.semmle.jcorn;

import com.semmle.jcorn.TokenType.Properties;
import com.semmle.jcorn.flow.FlowParser;
import com.semmle.js.ast.ArrayExpression;
import com.semmle.js.ast.AssignmentExpression;
import com.semmle.js.ast.BlockStatement;
import com.semmle.js.ast.CallExpression;
import com.semmle.js.ast.CatchClause;
import com.semmle.js.ast.Chainable;
import com.semmle.js.ast.ClassExpression;
import com.semmle.js.ast.ComprehensionBlock;
import com.semmle.js.ast.ComprehensionExpression;
import com.semmle.js.ast.Decorator;
import com.semmle.js.ast.Expression;
import com.semmle.js.ast.ExpressionStatement;
import com.semmle.js.ast.ForInStatement;
import com.semmle.js.ast.FunctionDeclaration;
import com.semmle.js.ast.IFunction;
import com.semmle.js.ast.INode;
import com.semmle.js.ast.IPattern;
import com.semmle.js.ast.Identifier;
import com.semmle.js.ast.LetExpression;
import com.semmle.js.ast.LetStatement;
import com.semmle.js.ast.MemberExpression;
import com.semmle.js.ast.NewExpression;
import com.semmle.js.ast.Node;
import com.semmle.js.ast.ParenthesizedExpression;
import com.semmle.js.ast.Position;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Statement;
import com.semmle.js.ast.Token;
import com.semmle.js.ast.TryStatement;
import com.semmle.js.ast.VariableDeclaration;
import com.semmle.js.ast.XMLAnyName;
import com.semmle.js.ast.XMLAttributeSelector;
import com.semmle.js.ast.XMLDotDotExpression;
import com.semmle.js.ast.XMLFilterExpression;
import com.semmle.util.data.Either;
import com.semmle.util.data.Pair;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;

/**
 * An extension of the standard jcorn parser with support for Mozilla-specific language extension
 * (most of JavaScript 1.8.5 and E4X) and JScript language extensions.
 */
public class CustomParser extends FlowParser {
  public CustomParser(Options options, String input, int startPos) {
    super(options, input, startPos);

    // recognise `const` as a keyword, irrespective of options.ecmaVersion
    this.keywords.add("const");
  }

  // add parsing of guarded `catch` clauses
  @Override
  protected TryStatement parseTryStatement(Position startLoc) {
    if (!options.mozExtensions()) return super.parseTryStatement(startLoc);

    this.next();
    BlockStatement block = this.parseBlock(false);
    CatchClause handler = null;
    List<CatchClause> guardedHandlers = new ArrayList<CatchClause>();
    while (this.type == TokenType._catch) {
      Position catchStartLoc = this.startLoc;
      CatchClause katch = this.parseCatchClause(catchStartLoc);
      if (handler != null) this.raise(catchStartLoc, "Catch after unconditional catch");
      if (katch.getGuard() != null) guardedHandlers.add(katch);
      else handler = katch;
    }
    BlockStatement finalizer = this.eat(TokenType._finally) ? this.parseBlock(false) : null;
    if (handler == null && finalizer == null && guardedHandlers.isEmpty())
      this.raise(startLoc, "Missing catch or finally clause");
    return this.finishNode(
        new TryStatement(new SourceLocation(startLoc), block, handler, guardedHandlers, finalizer));
  }

  /*
   * Support for guarded `catch` clauses and omitted catch bindings.
   */
  @Override
  protected CatchClause parseCatchClause(Position startLoc) {
    if (!options.mozExtensions()) return super.parseCatchClause(startLoc);

    this.next();
    Expression param = null;
    Expression guard = null;
    if (this.eat(TokenType.parenL)) {
      param = this.parseBindingAtom();
      this.checkLVal(param, true, null);
      if (this.eat(TokenType._if)) guard = this.parseExpression(false, null);
      this.expect(TokenType.parenR);
    } else if (!options.esnext()) {
      this.unexpected();
    }
    BlockStatement catchBody = this.parseBlock(false);
    return this.finishNode(
        new CatchClause(new SourceLocation(startLoc), (IPattern) param, guard, catchBody));
  }

  // add parsing of `let` statements and expressions
  @Override
  protected boolean mayFollowLet(int c) {
    return options.mozExtensions() && c == '(' || super.mayFollowLet(c);
  }

  @Override
  protected Statement parseVarStatement(Position startLoc, String kind) {
    if (!options.mozExtensions()) return super.parseVarStatement(startLoc, kind);

    this.next();

    if ("let".equals(kind) && this.eat(TokenType.parenL)) {
      // this is a `let` statement or expression
      return (LetStatement) this.parseLetExpression(startLoc, true);
    }

    VariableDeclaration node = this.parseVar(startLoc, false, kind);
    this.semicolon();
    return this.finishNode(node);
  }

  @Override
  protected Expression parseExprAtom(DestructuringErrors refDestructuringErrors) {
    Position startLoc = this.startLoc;
    if (options.mozExtensions() && this.isContextual("let")) {
      this.next();
      this.expect(TokenType.parenL);
      return (Expression) this.parseLetExpression(startLoc, false);
    } else if (options.mozExtensions() && this.type == TokenType.bracketL) {
      this.next();
      // check whether this is array comprehension or regular array
      if (this.type == TokenType._for) {
        ComprehensionExpression c = this.parseComprehension(startLoc, false, null);
        this.expect(TokenType.bracketR);
        return this.finishNode(c);
      }
      List<Expression> elements;
      if (this.type == TokenType.comma
          || this.type == TokenType.bracketR
          || this.type == TokenType.ellipsis) {
        elements = this.parseExprList(TokenType.bracketR, true, true, refDestructuringErrors);
      } else {
        Expression firstExpr = this.parseMaybeAssign(false, refDestructuringErrors, null);
        // check whether this is a postfix array comprehension
        if (this.type == TokenType._for || this.type == TokenType._if) {
          ComprehensionExpression c = this.parseComprehension(startLoc, false, firstExpr);
          this.expect(TokenType.bracketR);
          return this.finishNode(c);
        } else {
          this.eat(TokenType.comma);
          elements = new ArrayList<Expression>();
          elements.add(firstExpr);
          elements.addAll(
              this.parseExprList(TokenType.bracketR, true, true, refDestructuringErrors));
        }
      }
      return this.finishNode(new ArrayExpression(new SourceLocation(startLoc), elements));
    } else if (options.v8Extensions() && this.type == TokenType.modulo) {
      // parse V8 native
      this.next();
      Identifier buildinName = this.parseIdent(true);
      Identifier name = this.finishNode(new Identifier(new SourceLocation(startLoc), "%" + buildinName.getName()));
      this.expect(TokenType.parenL);
      List<Expression> args = this.parseExprList(TokenType.parenR, false, false, null);
      CallExpression node =
          new CallExpression(
              new SourceLocation(startLoc), name, new ArrayList<>(), args, false, false);
      return this.finishNode(node);
    } else if (options.e4x() && this.type == at) {
      // this could be either a decorator or an attribute selector; we first
      // try parsing it as a decorator, and then convert it to an attribute selector
      // if the next token turns out not to be `class`
      List<Decorator> decorators = parseDecorators();
      Expression attr = null;
      if (decorators.size() > 1
          || this.type == TokenType._class
          || ((attr = decoratorToAttributeSelector(decorators.get(0))) == null)) {
        ClassExpression ce = (ClassExpression) this.parseClass(startLoc, false);
        ce.addDecorators(decorators);
        return ce;
      }
      return attr;
    } else {
      return super.parseExprAtom(refDestructuringErrors);
    }
  }

  protected Node parseLetExpression(Position startLoc, boolean maybeStatement) {
    // this method assumes that the keyword `let` and the opening parenthesis have already been
    // consumed
    VariableDeclaration decl = this.parseVar(startLoc, false, "let");
    this.expect(TokenType.parenR);

    if (this.type == TokenType.braceL) {
      if (!maybeStatement) {
        // must be the start of an object literal
        Expression body = this.parseObj(false, null);
        return this.finishNode(
            new LetExpression(new SourceLocation(startLoc), decl.getDeclarations(), body));
      }

      BlockStatement body = this.parseBlock(false);
      return this.finishNode(
          new LetStatement(new SourceLocation(startLoc), decl.getDeclarations(), body));
    } else if (maybeStatement) {
      Position pos = startLoc;
      Statement body = this.parseStatement(true, false);
      if (body == null) this.unexpected(pos);
      return this.finishNode(
          new LetStatement(new SourceLocation(startLoc), decl.getDeclarations(), body));
    } else {
      Expression body = this.parseExpression(false, null);
      return this.finishNode(
          new LetExpression(new SourceLocation(startLoc), decl.getDeclarations(), body));
    }
  }

  // add parsing of expression closures and JScript methods
  @Override
  protected INode parseFunction(
      Position startLoc, boolean isStatement, boolean allowExpressionBody, boolean isAsync) {
    if (isFunctionSent(isStatement))
      return super.parseFunction(startLoc, isStatement, allowExpressionBody, isAsync);
    allowExpressionBody = allowExpressionBody || options.mozExtensions();
    boolean oldInGen = this.inGenerator, oldInAsync = this.inAsync;
    int oldYieldPos = this.yieldPos, oldAwaitPos = this.awaitPos;
    Pair<Boolean, Identifier> p = parseFunctionName(isStatement, isAsync);
    boolean generator = p.fst();
    Identifier id = p.snd(), iface = null;
    if (options.jscript()) {
      if (isStatement && this.eatDoubleColon()) {
        iface = p.snd();
        id = this.parseIdent(false);
      }
    }
    IFunction result =
        parseFunctionRest(
            startLoc,
            isStatement,
            allowExpressionBody,
            oldInGen,
            oldInAsync,
            oldYieldPos,
            oldAwaitPos,
            generator,
            id);
    if (iface != null) {
      /* Translate JScript double colon method declarations into normal method definitions:
       *
       *   function A::f(...) { ... }
       *
       * becomes
       *
       *   A.f = function f(...) { ... };
       */
      SourceLocation memloc =
          new SourceLocation(
              iface.getName() + "::" + id.getName(),
              iface.getLoc().getStart(),
              id.getLoc().getEnd());
      MemberExpression mem =
          new MemberExpression(
              memloc, iface, new Identifier(id.getLoc(), id.getName()), false, false, false);
      AssignmentExpression assgn =
          new AssignmentExpression(
              result.getLoc(), "=", mem, ((FunctionDeclaration) result).asFunctionExpression());
      return new ExpressionStatement(result.getLoc(), assgn);
    }
    return result;
  }

  private boolean eatDoubleColon() {
    if (this.eat(TokenType.colon)) {
      this.expect(TokenType.colon);
      return true;
    } else {
      return this.eat(doubleColon);
    }
  }

  // accept `yield` in non-generator functions
  @Override
  protected Expression parseMaybeAssign(
      boolean noIn, DestructuringErrors refDestructuringErrors, AfterLeftParse afterLeftParse) {
    if (options.mozExtensions() && isContextual("yield")) {
      if (!this.inFunction) this.raise(this.startLoc, "Yield not in function");
      return this.parseYield();
    }
    return super.parseMaybeAssign(noIn, refDestructuringErrors, afterLeftParse);
  }

  // add parsing of comprehensions
  protected ComprehensionExpression parseComprehension(
      Position startLoc, boolean isGenerator, Expression body) {
    List<ComprehensionBlock> blocks = new ArrayList<ComprehensionBlock>();
    while (this.type == TokenType._for) {
      SourceLocation blockStart = new SourceLocation(this.startLoc);
      boolean of = false;
      this.next();
      if (this.eatContextual("each")) of = true;
      this.expect(TokenType.parenL);
      Expression left = this.parseBindingAtom();
      this.checkLVal(left, true, null);
      if (this.eatContextual("of")) {
        of = true;
      } else {
        this.expect(TokenType._in);
      }
      Expression right = this.parseExpression(false, null);
      this.expect(TokenType.parenR);
      blocks.add(this.finishNode(new ComprehensionBlock(blockStart, (IPattern) left, right, of)));
    }
    Expression filter = this.eat(TokenType._if) ? this.parseParenExpression() : null;
    if (body == null) body = this.parseExpression(false, null);

    return new ComprehensionExpression(
        new SourceLocation(startLoc), body, blocks, filter, isGenerator);
  }

  @Override
  protected Expression parseParenAndDistinguishExpression(boolean canBeArrow) {
    if (options.mozExtensions()) {
      // check whether next token is `for`, suggesting a generator comprehension
      Position startLoc = this.startLoc;
      Matcher m = Whitespace.skipWhiteSpace.matcher(this.input);
      if (m.find(this.pos)) {
        if (m.end() + 3 < input.length()
            && "for".equals(input.substring(m.end(), m.end() + 3))
            && !Identifiers.isIdentifierChar(input.charAt(m.end() + 3), true)) {
          next();
          ComprehensionExpression c = parseComprehension(startLoc, true, null);
          this.expect(TokenType.parenR);
          return this.finishNode(c);
        }
      }
    }

    Expression res = super.parseParenAndDistinguishExpression(canBeArrow);
    if (res instanceof ParenthesizedExpression) {
      ParenthesizedExpression p = (ParenthesizedExpression) res;
      if (p.getExpression() instanceof ComprehensionExpression) {
        ComprehensionExpression c = (ComprehensionExpression) p.getExpression();
        if (c.isGenerator())
          return new ComprehensionExpression(
              p.getLoc(), c.getBody(), c.getBlocks(), c.getFilter(), c.isGenerator());
      }
    }
    return res;
  }

  @Override
  protected boolean parseParenthesisedExpression(
      DestructuringErrors refDestructuringErrors,
      boolean allowTrailingComma,
      ParenthesisedExpressions parenExprs,
      boolean first) {
    boolean cont =
        super.parseParenthesisedExpression(
            refDestructuringErrors, allowTrailingComma, parenExprs, first);
    if (options.mozExtensions() && parenExprs.exprList.size() == 1 && this.type == TokenType._for) {
      Expression body = parenExprs.exprList.remove(0);
      ComprehensionExpression c = parseComprehension(body.getLoc().getStart(), true, body);
      parenExprs.exprList.add(this.finishNode(c));
      return false;
    }
    return cont;
  }

  // add parsing of for-each loops
  @Override
  protected Statement parseForStatement(Position startLoc) {
    boolean each = false;
    if (options.mozExtensions() && this.isContextual("each")) {
      this.next();
      each = true;
    }
    Position afterEach = this.startLoc;
    Statement result = super.parseForStatement(startLoc);
    if (each) {
      if (result instanceof ForInStatement) {
        ForInStatement fis = (ForInStatement) result;
        result =
            new ForInStatement(fis.getLoc(), fis.getLeft(), fis.getRight(), fis.getBody(), true);
      } else {
        raise(afterEach, "Bad for-each statement.");
      }
    }
    return result;
  }

  // add parsing of Rhino/Nashorn-style `new` expressions with last argument after `)`
  @Override
  protected Expression parseNew() {
    Expression res = super.parseNew();
    if (res instanceof NewExpression
        && options.mozExtensions()
        && !canInsertSemicolon()
        && this.type == TokenType.braceL) {
      ((NewExpression) res).getArguments().add(this.parseObj(false, null));
      res = this.finishNode(res);
    }
    return res;
  }

  /*
   * E4X
   *
   * PrimaryExpression :
   *     PropertyIdentifier
   *     XMLInitialiser
   *     XMLListInitialiser
   *
   * PropertyIdentifier :
   *     AttributeIdentifier
   *     QualifiedIdentifier
   *     WildcardIdent
   *
   * AttributeIdentifier :
   *     @ PropertySelector
   *     @ QualifiedIdentifier
   *     @ [ Expression ]
   *
   * PropertySelector :
   *     Identifier
   *     WildcardIdentifier
   *
   * QualifiedIdentifier :
   *     PropertySelector :: PropertySelector
   *     PropertySelector :: [ Expression ]
   *
   * WildcardIdentifier :
   *     *
   *
   * MemberExpression :
   *     MemberExpression . PropertyIdentifier
   *     MemberExpression .. Identifier
   *     MemberExpression .. PropertyIdentifier
   *     MemberExpression . ( Expression )
   *
   * DefaultXMLNamespaceStatement :
   *     default xml namespace = Expression
   */

  protected TokenType doubleDot = new TokenType(new Properties(":").beforeExpr());

  @Override
  protected Token getTokenFromCode(int code) {
    if (options.e4x()
        && code == '.'
        && charAt(this.pos + 1) == '.'
        && charAt(this.pos + 2) != '.') {
      this.pos += 2;
      return this.finishToken(doubleDot);
    }
    return super.getTokenFromCode(code);
  }

  // add parsing of E4X property, attribute and descendant accesses, as well as filter expressions
  @Override
  protected Pair<Expression, Boolean> parseSubscript(
      Expression base, Position startLoc, boolean noCalls) {
    if (options.e4x() && this.eat(TokenType.dot)) {
      SourceLocation start = new SourceLocation(startLoc);
      if (this.eat(TokenType.parenL)) {
        Expression filter = parseExpression(false, null);
        this.expect(TokenType.parenR);
        return Pair.make(this.finishNode(new XMLFilterExpression(start, base, filter)), true);
      }

      Expression property = this.parsePropertyIdentifierOrIdentifier();
      MemberExpression node =
          new MemberExpression(
              start, base, property, false, false, Chainable.isOnOptionalChain(false, base));
      return Pair.make(this.finishNode(node), true);
    } else if (this.eat(doubleDot)) {
      SourceLocation start = new SourceLocation(startLoc);
      Expression property = this.parsePropertyIdentifierOrIdentifier();
      return Pair.make(this.finishNode(new XMLDotDotExpression(start, base, property)), true);
    }
    return super.parseSubscript(base, startLoc, noCalls);
  }

  /**
   * Parse a an attribute identifier, a wildcard identifier, a qualified identifier, or a plain
   * identifier.
   */
  protected Expression parsePropertyIdentifierOrIdentifier() {
    Position start = this.startLoc;
    if (this.eat(at)) {
      // attribute identifier
      return parseAttributeIdentifier(new SourceLocation(start));
    } else {
      return parsePropertySelector(new SourceLocation(startLoc));
    }
  }

  /** Parse a property selector, that is, either a wildcard identifier or a plain identifier. */
  protected Expression parsePropertySelector(SourceLocation start) {
    Expression res;
    if (this.eat(TokenType.star)) {
      // wildcard identifier
      res = this.finishNode(new XMLAnyName(start));
    } else {
      res = this.parseIdent(true);
    }
    return res;
  }

  /**
   * Parse an attribute identifier, either computed ({@code [ Expr ]}) or a possibly qualified
   * identifier.
   */
  protected Expression parseAttributeIdentifier(SourceLocation start) {
    if (this.eat(TokenType.bracketL)) {
      Expression idx = parseExpression(false, null);
      this.expect(TokenType.bracketR);
      return this.finishNode(new XMLAttributeSelector(start, idx, true));
    } else {
      return this.finishNode(
          new XMLAttributeSelector(
              start, parsePropertySelector(new SourceLocation(startLoc)), false));
    }
  }

  @Override
  protected Expression parseDecoratorBody() {
    SourceLocation start = new SourceLocation(startLoc);
    if (options.e4x() && this.eat(TokenType.bracketL)) {
      // this must be an attribute selector, so only allow a single expression
      // followed by a right bracket, which will later be converted by
      // `decoratorToAttributeSelector` below
      List<Expression> elements = new ArrayList<>();
      elements.add(parseExpression(false, null));
      this.expect(TokenType.bracketR);
      return this.finishNode(new ArrayExpression(start, elements));
    }

    return super.parseDecoratorBody();
  }

  /**
   * Convert a decorator that resulted from mis-parsing an attribute selector into an attribute
   * selector.
   */
  protected XMLAttributeSelector decoratorToAttributeSelector(Decorator d) {
    Expression e = d.getExpression();
    if (e instanceof ArrayExpression) {
      ArrayExpression ae = (ArrayExpression) e;
      if (ae.getElements().size() == 1)
        return new XMLAttributeSelector(d.getLoc(), ae.getElements().get(0), true);
    } else if (e instanceof Identifier) {
      return new XMLAttributeSelector(d.getLoc(), e, false);
    }
    return null;
  }

  @Override
  protected Token readToken(int code) {
    // skip XML processing instructions (which are allowed in E4X, but not in JSX);
    // there is a lexical ambiguity between an XML processing instruction starting a
    // chunk of E4X content and a Flow type annotation (both can start with `<?`)
    // hence if we can't find the closing `?>` of a putative XML processing instruction
    // we backtrack and try lexing as something else
    // to avoid frequent backtracking, we only consider `<?xml ...?>` processing instructions;
    // while other processing instructions are technically possible, they are unlikely in practice
    if (this.options.e4x()) {
      while (code == '<') {
        if (inputSubstring(this.pos + 1, this.pos + 5).equals("?xml")) {
          int oldPos = this.pos;
          this.pos += 5;
          if (!jsx_readUntil("?>")) {
            // didn't find a closing `?>`, so backtrack
            this.pos = oldPos;
            break;
          }
        } else {
          break;
        }
        this.skipSpace();
        code = this.fullCharCodeAtPos();
      }
    }
    return super.readToken(code);
  }

  @Override
  protected Either<Integer, Token> jsx_readChunk(StringBuilder out, int chunkStart, int ch) {
    // skip XML comments, processing instructions and CDATA (which are allowed in E4X,
    // but not in JSX)
    // unlike in `readToken` above, we know that we're inside JSX/E4X code, so there is
    // no ambiguity with Flow type annotations
    if (this.options.e4x() && ch == '<') {
      if (inputSubstring(this.pos + 1, this.pos + 4).equals("!--")) {
        out.append(inputSubstring(chunkStart, this.pos));
        this.pos += 4;
        jsx_readUntil("-->");
        return Either.left(this.pos);
      } else if (charAt(this.pos + 1) == '?') {
        out.append(inputSubstring(chunkStart, this.pos));
        this.pos += 2;
        jsx_readUntil("?>");
        return Either.left(this.pos);
      } else if (inputSubstring(this.pos + 1, this.pos + 9).equals("![CDATA[")) {
        out.append(inputSubstring(chunkStart, this.pos));
        this.pos += 9;
        int cdataStart = this.pos;
        jsx_readUntil("]]>");
        out.append(inputSubstring(cdataStart, this.pos - 3));
        return Either.left(this.pos);
      }
    }

    return super.jsx_readChunk(out, chunkStart, ch);
  }

  private boolean jsx_readUntil(String terminator) {
    char fst = terminator.charAt(0);
    while (this.pos + terminator.length() <= this.input.length()) {
      if (charAt(this.pos) == fst
          && inputSubstring(this.pos, this.pos + terminator.length()).equals(terminator)) {
        this.pos += terminator.length();
        return true;
      }
      ++this.pos;
    }
    return false;
  }
}
