package com.semmle.jcorn.jsx;

import static com.semmle.jcorn.Parser.TokContext.b_expr;
import static com.semmle.jcorn.Parser.TokContext.b_tmpl;
import static com.semmle.jcorn.TokenType.braceL;
import static com.semmle.jcorn.TokenType.braceR;
import static com.semmle.jcorn.TokenType.colon;
import static com.semmle.jcorn.TokenType.dot;
import static com.semmle.jcorn.TokenType.ellipsis;
import static com.semmle.jcorn.TokenType.eq;
import static com.semmle.jcorn.TokenType.relational;
import static com.semmle.jcorn.TokenType.slash;
import static com.semmle.jcorn.TokenType.string;
import static com.semmle.jcorn.Whitespace.isNewLine;

import com.semmle.jcorn.Identifiers;
import com.semmle.jcorn.Options;
import com.semmle.jcorn.Parser;
import com.semmle.jcorn.TokenType;
import com.semmle.jcorn.TokenType.Properties;
import com.semmle.js.ast.Expression;
import com.semmle.js.ast.INode;
import com.semmle.js.ast.Position;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Token;
import com.semmle.js.ast.jsx.IJSXAttribute;
import com.semmle.js.ast.jsx.IJSXName;
import com.semmle.js.ast.jsx.JSXAttribute;
import com.semmle.js.ast.jsx.JSXClosingElement;
import com.semmle.js.ast.jsx.JSXElement;
import com.semmle.js.ast.jsx.JSXEmptyExpression;
import com.semmle.js.ast.jsx.JSXExpressionContainer;
import com.semmle.js.ast.jsx.JSXIdentifier;
import com.semmle.js.ast.jsx.JSXMemberExpression;
import com.semmle.js.ast.jsx.JSXNamespacedName;
import com.semmle.js.ast.jsx.JSXOpeningElement;
import com.semmle.js.ast.jsx.JSXSpreadAttribute;
import com.semmle.js.ast.jsx.JSXThisExpr;
import com.semmle.util.data.Either;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.regex.Pattern;

/**
 * Java port of <a href="https://github.com/RReverser/acorn-jsx">Acorn-JSX</a> as of version <a
 * href="https://github.com/RReverser/acorn-jsx/commit/05852d8ae9476b7f8a25e417665e2265528d5fb9">3.0.1</a>.
 *
 * <p>Like the plain JavaScript {@link Parser}, the JSX parser is parameterized by an {@link
 * Options} object. To enable JSX parsing, pass in a {@link JSXOptions} object.
 */
public class JSXParser extends Parser {
  private static final Pattern hexNumber = Pattern.compile("^[\\da-fA-F]+$");
  private static final Pattern decimalNumber = Pattern.compile("^\\d+$");

  public JSXParser(Options options, String input, int startPos) {
    super(options, input, startPos);
  }

  private static final TokContext j_oTag = new TokContext("<tag", false);
  private static final TokContext j_cTag = new TokContext("</tag", false);
  private static final TokContext j_expr = new TokContext("<tag>..</tag>", true, true, null);

  private static final TokenType jsxName = new TokenType(new Properties("jsxName"));
  public static final TokenType jsxText = new TokenType(new Properties("jsxText").beforeExpr());
  protected static final TokenType jsxTagStart =
      new TokenType(new Properties("jsxTagStart")) {
        @Override
        public void updateContext(Parser parser, TokenType prevType) {
          parser.pushTokenContext(j_expr); // treat as beginning of JSX expression
          parser.pushTokenContext(j_oTag); // start opening tag context
          parser.exprAllowed(false);
        }
      };
  private static final TokenType jsxTagEnd =
      new TokenType(new Properties("jsxTagEnd")) {
        @Override
        public void updateContext(Parser parser, TokenType prevType) {
          TokContext out = parser.popTokenContext();
          if (out == j_oTag && prevType == slash || out == j_cTag) {
            parser.popTokenContext();
            parser.exprAllowed(parser.curContext() == j_expr);
          } else {
            parser.exprAllowed(true);
          }
        }
      };

  /** Reads inline JSX contents token. */
  private Token jsx_readToken() {
    StringBuilder out = new StringBuilder();
    int chunkStart = this.pos;
    for (; ; ) {
      if (this.pos >= this.input.length()) this.raise(this.start, "Unterminated JSX contents");
      Either<Integer, Token> chunk = jsx_readChunk(out, chunkStart, this.charAt(this.pos));
      if (chunk.isRight()) return chunk.getRight();
      chunkStart = chunk.getLeft();
    }
  }

  /**
   * Reads a chunk of inline JSX content, returning either the start of the next chunk or the
   * completed content token.
   */
  protected Either<Integer, Token> jsx_readChunk(StringBuilder out, int chunkStart, int ch) {
    switch (ch) {
      case 60: // '<'
      case 123: // '{'
        if (this.pos == this.start) {
          if (ch == 60 && this.exprAllowed) {
            ++this.pos;
            return Either.right(this.finishToken(jsxTagStart));
          }
          return Either.right(this.getTokenFromCode(ch));
        }
        out.append(inputSubstring(chunkStart, this.pos));
        return Either.right(this.finishToken(jsxText, out.toString()));

      case 38: // '&'
        out.append(inputSubstring(chunkStart, this.pos));
        out.append(this.jsx_readEntity());
        chunkStart = this.pos;
        break;

      default:
        if (isNewLine(ch)) {
          out.append(inputSubstring(chunkStart, this.pos));
          out.append(this.jsx_readNewLine(true));
          chunkStart = this.pos;
        } else {
          ++this.pos;
        }
    }
    return Either.left(chunkStart);
  }

  private String jsx_readNewLine(boolean normalizeCRLF) {
    int ch = this.charAt(this.pos);
    String out;
    ++this.pos;
    if (ch == 13 && this.charAt(this.pos) == 10) {
      ++this.pos;
      out = normalizeCRLF ? "\n" : "\r\n";
    } else {
      out = String.valueOf((char) ch);
    }
    ++this.curLine;
    this.lineStart = this.pos;

    return out;
  }

  private Token jsx_readString(char quote) {
    StringBuilder out = new StringBuilder();
    int chunkStart = ++this.pos;
    for (; ; ) {
      if (this.pos >= this.input.length()) this.raise(this.start, "Unterminated string constant");
      int ch = this.charAt(this.pos);
      if (ch == quote) break;
      if (ch == 38) { // '&'
        out.append(inputSubstring(chunkStart, this.pos));
        out.append(this.jsx_readEntity());
        chunkStart = this.pos;
      } else if (isNewLine(ch)) {
        out.append(inputSubstring(chunkStart, this.pos));
        out.append(this.jsx_readNewLine(false));
        chunkStart = this.pos;
      } else {
        ++this.pos;
      }
    }
    out.append(inputSubstring(chunkStart, this.pos++));
    return this.finishToken(string, out.toString());
  }

  private String jsx_readEntity() {
    int ch = this.charAt(this.pos);
    if (ch != '&') this.raise(this.pos, "Entity must start with an ampersand");
    int startPos = ++this.pos;
    String entity = null;
    int semi = this.input.indexOf(';', startPos);
    if (semi != -1) {
      String entityName = inputSubstring(startPos, semi);
      if (entityName.startsWith("#x")) {
        entityName = entityName.substring(2);
        if (hexNumber.matcher(entityName).matches())
          entity = codePointToString(parseInt(entityName, 16).intValue());
      } else if (entityName.startsWith("#")) {
        entityName = entityName.substring(1);
        if (decimalNumber.matcher(entityName).matches())
          entity = codePointToString(parseInt(entityName, 10).intValue());
      } else {
        Character entityChar = XHTMLEntities.ENTITIES.get(entityName);
        if (entityChar != null) entity = String.valueOf(entityChar);
      }
    }

    if (entity == null) {
      this.pos = startPos;
      return "&";
    } else {
      this.pos = semi + 1;
      return entity;
    }
  }

  /**
   * Read a JSX identifier (valid tag or attribute name).
   *
   * <p>Optimized version since JSX identifiers can't contain escape characters and so can be read
   * as single slice. Also assumes that first character was already checked by isIdentifierStart in
   * readToken.
   */
  private Token jsx_readWord() {
    int ch, start = this.pos;
    do {
      ch = this.charAt(++this.pos);
    } while (Identifiers.isIdentifierChar(ch, true) || ch == 45); // '-'
    return this.finishToken(jsxName, inputSubstring(start, this.pos));
  }

  /** Transforms JSX element name to string; {@code null} is transformed to {@code null}. */
  private String getQualifiedJSXName(Object object) {
    if (object == null) return null;
    return ((IJSXName) object).getQualifiedName();
  }

  /** Parse next token as JSX identifier */
  private IJSXName jsx_parseIdentifier(boolean expectThisExpr) {
    SourceLocation loc = new SourceLocation(this.startLoc);
    String name = null;
    if (this.type == jsxName) name = String.valueOf(this.value);
    else if (this.type.keyword != null) name = this.type.keyword;
    else this.unexpected();
    this.next();
    if (expectThisExpr && name.equals("this")) {
      return this.finishNode(new JSXThisExpr(loc));
    } else {
      return this.finishNode(new JSXIdentifier(loc, name));
    }
  }

  /** Parse namespaced identifier. */
  private IJSXName jsx_parseNamespacedName() {
    SourceLocation loc = new SourceLocation(this.startLoc);
    IJSXName namespace = this.jsx_parseIdentifier(true);
    if (namespace instanceof JSXThisExpr || (!((JSXOptions) options).allowNamespaces || !this.eat(colon))) return namespace;
    return this.finishNode(new JSXNamespacedName(loc, (JSXIdentifier)namespace, (JSXIdentifier)this.jsx_parseIdentifier(false)));
  }

  /**
   * Parses element name in any form - namespaced, member or single identifier. If the next token is
   * a tag-end token, {@code null} is returned; this happens with fragments.
   */
  private IJSXName jsx_parseElementName() {
    if (this.type == jsxTagEnd) return null;
    Position startPos = this.startLoc;
    IJSXName node = this.jsx_parseNamespacedName();
    if (this.type == dot
        && node instanceof JSXNamespacedName
        && !((JSXOptions) options).allowNamespacedObjects) {
      this.unexpected();
    }
    while (this.eat(dot)) {
      SourceLocation loc = new SourceLocation(startPos);
      node = this.finishNode(new JSXMemberExpression(loc, node, (JSXIdentifier)this.jsx_parseIdentifier(false)));
    }
    return node;
  }

  /** Parses any type of JSX attribute value. */
  private INode jsx_parseAttributeValue() {
    if (type == braceL) {
      JSXExpressionContainer node = this.jsx_parseExpressionContainer();
      if (node.getExpression() instanceof JSXEmptyExpression)
        this.raise(node, "JSX attributes must only be assigned a non-empty expression");
      return node;
    } else if (type == jsxTagStart || type == string) {
      return this.parseExprAtom(null);
    } else {
      this.raise(this.start, "JSX value should be either an expression or a quoted JSX text");
      return null;
    }
  }

  /**
   * JSXEmptyExpression is unique type since it doesn't actually parse anything, and so it should
   * start at the end of last read token (left brace) and finish at the beginning of the next one
   * (right brace).
   */
  private JSXEmptyExpression jsx_parseEmptyExpression() {
    return new JSXEmptyExpression(new SourceLocation("", lastTokEndLoc, startLoc));
  }

  /** Parses JSX expression enclosed into curly brackets. */
  private JSXExpressionContainer jsx_parseExpressionContainer() {
    SourceLocation loc = new SourceLocation(this.startLoc);
    this.next();
    INode expression;
    if (this.type == braceR) expression = this.jsx_parseEmptyExpression();
    else expression = this.parseExpression(false, null);
    this.expect(braceR);
    return this.finishNode(new JSXExpressionContainer(loc, expression));
  }

  /** Parses following JSX attribute name-value pair. */
  private IJSXAttribute jsx_parseAttribute() {
    SourceLocation loc = new SourceLocation(this.startLoc);
    if (this.eat(braceL)) {
      this.expect(ellipsis);
      Expression argument = this.parseMaybeAssign(false, null, null);
      this.expect(braceR);
      return this.finishNode(new JSXSpreadAttribute(loc, argument));
    }
    IJSXName name = this.jsx_parseNamespacedName();
    INode value = this.eat(eq) ? this.jsx_parseAttributeValue() : null;
    return this.finishNode(new JSXAttribute(loc, name, value));
  }

  /** Parses JSX opening tag starting after '&lt;'. */
  private JSXOpeningElement jsx_parseOpeningElementAt(Position startLoc) {
    SourceLocation loc = new SourceLocation(startLoc);
    List<IJSXAttribute> attributes = new ArrayList<>();
    IJSXName name = this.jsx_parseElementName();
    while (this.type != slash && this.type != jsxTagEnd) attributes.add(this.jsx_parseAttribute());
    boolean selfClosing = this.eat(slash);
    this.expect(jsxTagEnd);
    return this.finishNode(new JSXOpeningElement(loc, name, attributes, selfClosing));
  }

  /** Parses JSX closing tag starting after '&lt;/'. */
  private JSXClosingElement jsx_parseClosingElementAt(Position startLoc) {
    SourceLocation loc = new SourceLocation(startLoc);
    IJSXName name = this.jsx_parseElementName();
    this.expect(jsxTagEnd);
    return this.finishNode(new JSXClosingElement(loc, name));
  }

  /**
   * Parses entire JSX element, including its opening tag (starting after '&lt;'), attributes,
   * contents and closing tag.
   */
  private JSXElement jsx_parseElementAt(Position startLoc) {
    SourceLocation loc = new SourceLocation(startLoc);
    List<INode> children = new ArrayList<INode>();
    JSXOpeningElement openingElement = this.jsx_parseOpeningElementAt(startLoc);
    JSXClosingElement closingElement = null;

    if (!openingElement.isSelfClosing()) {
      contents:
      for (; ; ) {
        if (type == jsxTagStart) {
          startLoc = this.startLoc;
          this.next();
          if (this.eat(slash)) {
            closingElement = this.jsx_parseClosingElementAt(startLoc);
            break contents;
          }
          children.add(this.jsx_parseElementAt(startLoc));
        } else if (type == jsxText) {
          children.add(this.parseExprAtom(null));
        } else if (type == braceL) {
          children.add(this.jsx_parseExpressionContainer());
        } else {
          this.unexpected();
        }
      }

      String closingQualName = getQualifiedJSXName(openingElement.getName());
      if (!Objects.equals(getQualifiedJSXName(closingElement.getName()), closingQualName)) {
        // prettify for error message
        if (closingQualName == null) closingQualName = "";
        this.raise(
            closingElement, "Expected corresponding JSX closing tag for <" + closingQualName + ">");
      }
    }

    if (this.type == relational && "<".equals(this.value)) {
      this.raise(this.start, "Adjacent JSX elements must be wrapped in an enclosing tag");
    }
    return this.finishNode(new JSXElement(loc, openingElement, children, closingElement));
  }

  /** Parses entire JSX element from current position. */
  private JSXElement jsx_parseElement() {
    Position startLoc = this.startLoc;
    this.next();
    return this.jsx_parseElementAt(startLoc);
  }

  @Override
  protected Expression parseExprAtom(DestructuringErrors refDestructuringErrors) {
    if (this.type == jsxText) {
      return this.parseLiteral(this.type, this.value);
    } else if (this.type == jsxTagStart) {
      return this.jsx_parseElement();
    } else {
      return super.parseExprAtom(refDestructuringErrors);
    }
  }

  @Override
  protected Token readToken(int code) {
    TokContext context = this.curContext();

    if (context == j_expr) return this.jsx_readToken();

    if (context == j_oTag || context == j_cTag) {
      if (Identifiers.isIdentifierStart(code, true)) return this.jsx_readWord();

      if (code == 62) {
        ++this.pos;
        return this.finishToken(jsxTagEnd);
      }

      if ((code == 34 || code == 39) && context == j_oTag) return this.jsx_readString((char) code);
    }

    if (options instanceof JSXOptions
        && code == 60
        && this.exprAllowed
        &&
        // avoid getting confused on HTML comments or EJS-style template tags
        this.charAt(this.pos + 1) != '!' &&
        this.charAt(this.pos + 1) != '%') {
      ++this.pos;
      return this.finishToken(jsxTagStart);
    }

    return super.readToken(code);
  }

  @Override
  protected void updateContext(TokenType prevType) {
    if (options instanceof JSXOptions) {
      if (type == braceL) {
        TokContext curContext = this.curContext();
        if (curContext == j_oTag) {
          this.context.push(b_expr);
        } else if (curContext == j_expr) {
          this.context.push(b_tmpl);
        } else {
          type.updateContext(this, prevType);
        }
        this.exprAllowed = true;
        return;
      } else if (type == slash && prevType == jsxTagStart) {
        this.context.pop();
        this.context.pop(); // do not consider JSX expr -> JSX open tag -> ... anymore
        this.context.push(j_cTag);
        this.exprAllowed = false;
        return;
      }
    }
    super.updateContext(prevType);
  }
}
