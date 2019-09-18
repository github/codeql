package com.semmle.js.parser;

import com.semmle.js.ast.Comment;
import com.semmle.js.ast.Position;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.jsdoc.AllLiteral;
import com.semmle.js.ast.jsdoc.ArrayType;
import com.semmle.js.ast.jsdoc.FieldType;
import com.semmle.js.ast.jsdoc.FunctionType;
import com.semmle.js.ast.jsdoc.JSDocComment;
import com.semmle.js.ast.jsdoc.JSDocTag;
import com.semmle.js.ast.jsdoc.JSDocTypeExpression;
import com.semmle.js.ast.jsdoc.NameExpression;
import com.semmle.js.ast.jsdoc.NonNullableType;
import com.semmle.js.ast.jsdoc.NullLiteral;
import com.semmle.js.ast.jsdoc.NullableLiteral;
import com.semmle.js.ast.jsdoc.NullableType;
import com.semmle.js.ast.jsdoc.OptionalType;
import com.semmle.js.ast.jsdoc.ParameterType;
import com.semmle.js.ast.jsdoc.RecordType;
import com.semmle.js.ast.jsdoc.RestType;
import com.semmle.js.ast.jsdoc.TypeApplication;
import com.semmle.js.ast.jsdoc.UndefinedLiteral;
import com.semmle.js.ast.jsdoc.UnionType;
import com.semmle.js.ast.jsdoc.VoidLiteral;
import com.semmle.util.data.Pair;
import com.semmle.util.exception.Exceptions;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/** A Java port of <a href="https://github.com/Constellation/doctrine">doctrine</a>. */
public class JSDocParser {
  private String source;
  private int absoluteOffset;

  /** Parse the given string as a JSDoc comment. */
  public JSDocComment parse(Comment comment) {
    source = comment.getText();
    JSDocTagParser p = new JSDocTagParser();
    Position startPos = comment.getLoc().getStart();
    // Get the start of the first line relative to the 'source' string.
    // This occurs before the start of 'source', so the lineStart is negative.
    int firstLineStart = -(startPos.getColumn() + "/**".length() - 1);
    this.absoluteOffset = startPos.getOffset();
    Pair<String, List<JSDocTagParser.Tag>> r =
        p.new TagParser(null).parseComment(startPos.getLine() - 1, firstLineStart);
    List<JSDocTag> tags = new ArrayList<>();
    for (JSDocTagParser.Tag tag : r.snd()) {
      String title = tag.title;
      String description = tag.description;
      String name = tag.name;
      int startLine = tag.startLine;
      int startColumn = tag.startColumn;

      JSDocTypeExpression jsdocType = tag.type;

      int lineNumber = startLine + 1; // convert to 1-based
      SourceLocation loc =
          new SourceLocation(
              source,
              new Position(lineNumber, startColumn, -1),
              new Position(lineNumber, startColumn + 1 + title.length(), -1));
      tags.add(new JSDocTag(loc, title, description, name, jsdocType, tag.errors));
    }
    return new JSDocComment(comment, r.fst(), tags);
  }

  /** Specification of Doctrine AST types for JSDoc type expressions. */
  private static final Map<Class<? extends JSDocTypeExpression>, List<String>> spec =
      new LinkedHashMap<Class<? extends JSDocTypeExpression>, List<String>>();

  static {
    spec.put(AllLiteral.class, Arrays.<String>asList());
    spec.put(ArrayType.class, Arrays.asList("elements"));
    spec.put(FieldType.class, Arrays.asList("key", "value"));
    spec.put(FunctionType.class, Arrays.asList("this", "new", "params", "result"));
    spec.put(NameExpression.class, Arrays.asList("name"));
    spec.put(NonNullableType.class, Arrays.asList("expression", "prefix"));
    spec.put(NullableLiteral.class, Arrays.<String>asList());
    spec.put(NullLiteral.class, Arrays.<String>asList());
    spec.put(NullableType.class, Arrays.asList("expression", "prefix"));
    spec.put(OptionalType.class, Arrays.asList("expression"));
    spec.put(ParameterType.class, Arrays.asList("name", "expression"));
    spec.put(RecordType.class, Arrays.asList("fields"));
    spec.put(RestType.class, Arrays.asList("expression"));
    spec.put(TypeApplication.class, Arrays.asList("expression", "applications"));
    spec.put(UndefinedLiteral.class, Arrays.<String>asList());
    spec.put(UnionType.class, Arrays.asList("elements"));
    spec.put(VoidLiteral.class, Arrays.<String>asList());
  }

  private static String sliceSource(String source, int index, int last) {
    if (index >= source.length()) return "";
    if (last > source.length()) last = source.length();
    return source.substring(index, last);
  }

  private static boolean isLineTerminator(int ch) {
    return ch == '\n' || ch == '\r' || ch == '\u2028' || ch == '\u2029';
  }

  private static boolean isWhiteSpace(char ch) {
    return Character.isWhitespace(ch) && !isLineTerminator(ch) || ch == '\u00a0';
  }

  private static boolean isWhiteSpaceOrLineTerminator(char ch) {
    return Character.isWhitespace(ch) || ch == '\u00a0';
  }

  private static boolean isDecimalDigit(char ch) {
    return "0123456789".indexOf(ch) >= 0;
  }

  private static boolean isHexDigit(char ch) {
    return "0123456789abcdefABCDEF".indexOf(ch) >= 0;
  }

  private static boolean isOctalDigit(char ch) {
    return "01234567".indexOf(ch) >= 0;
  }

  private static boolean isASCIIAlphanumeric(char ch) {
    return (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || (ch >= '0' && ch <= '9');
  }

  private static boolean isIdentifierStart(char ch) {
    return (ch == '\\') || Character.isJavaIdentifierStart(ch);
  }

  private static boolean isIdentifierPart(char ch) {
    return (ch == '\\') || Character.isJavaIdentifierPart(ch);
  }

  private static boolean isTypeName(char ch) {
    return "><(){}[],:*|?!=".indexOf(ch) == -1 && !isWhiteSpace(ch) && !isLineTerminator(ch);
  }

  private static boolean isParamTitle(String title) {
    return title.equals("param") || title.equals("argument") || title.equals("arg");
  }

  private static boolean isProperty(String title) {
    return title.equals("property") || title.equals("prop");
  }

  private static boolean isNameParameterRequired(String title) {
    return isParamTitle(title)
        || isProperty(title)
        || title.equals("alias")
        || title.equals("this")
        || title.equals("mixes")
        || title.equals("requires");
  }

  private static boolean isAllowedName(String title) {
    return isNameParameterRequired(title) || title.equals("const") || title.equals("constant");
  }

  private static boolean isAllowedNested(String title) {
    return isProperty(title) || isParamTitle(title);
  }

  private static boolean isTypeParameterRequired(String title) {
    return isParamTitle(title)
        || title.equals("define")
        || title.equals("enum")
        || title.equals("implements")
        || title.equals("return")
        || title.equals("this")
        || title.equals("type")
        || title.equals("typedef")
        || title.equals("returns")
        || isProperty(title);
  }

  // Consider deprecation instead using 'isTypeParameterRequired' and 'Rules' declaration to pick
  // when a type is optional/required
  // This would require changes to 'parseType'
  private static boolean isAllowedType(String title) {
    return isTypeParameterRequired(title)
        || title.equals("throws")
        || title.equals("const")
        || title.equals("constant")
        || title.equals("namespace")
        || title.equals("member")
        || title.equals("var")
        || title.equals("module")
        || title.equals("constructor")
        || title.equals("class")
        || title.equals("extends")
        || title.equals("augments")
        || title.equals("public")
        || title.equals("private")
        || title.equals("protected");
  }

  private static <T> T throwError(String message) throws ParseError {
    throw new ParseError(message, null);
  }

  private enum Token {
    ILLEGAL, // ILLEGAL
    DOT, // .
    DOT_LT, // .<
    REST, // ...
    LT, // <
    GT, // >
    LPAREN, // (
    RPAREN, // )
    LBRACE, // {
    RBRACE, // }
    LBRACK, // [
    RBRACK, // ]
    COMMA, // ,
    COLON, // :
    STAR, // *
    PIPE, // |
    QUESTION, // ?
    BANG, // !
    EQUAL, // =
    NAME, // name token
    STRING, // string
    NUMBER, // number
    EOF
  };

  private class TypeExpressionParser {
    int startIndex;
    int endIndex;
    int startOfCurToken, endOfPrevToken, index;
    Token token;
    Object value;
    int lineStart;
    int lineNumber;

    private class Context {
      int _startOfCurToken, _endOfPrevToken, _index;
      Token _token;
      Object _value;

      Context(int startOfCurToken, int endOfPrevToken, int index, Token token, Object value) {
        this._startOfCurToken = startOfCurToken;
        this._endOfPrevToken = endOfPrevToken;
        this._index = index;
        this._token = token;
        this._value = value;
      }

      void restore() {
        startOfCurToken = this._startOfCurToken;
        endOfPrevToken = this._endOfPrevToken;
        index = this._index;
        token = this._token;
        value = this._value;
      }
    }

    Context save() {
      return new Context(startOfCurToken, endOfPrevToken, index, token, value);
    }

    private SourceLocation loc() {
      return new SourceLocation(pos());
    }

    /** Returns the absolute position of the start of the current token. */
    private Position pos() {
      return new Position(
          this.lineNumber + 1, startOfCurToken - lineStart, startOfCurToken + absoluteOffset);
    }

    /**
     * Returns the absolute position of the end of the previous token.
     *
     * <p>This can differ from the start of the current token in case the two tokens are separated
     * by whitespace.
     */
    private Position endPos() {
      return new Position(
          this.lineNumber + 1, endOfPrevToken - lineStart, endOfPrevToken + absoluteOffset);
    }

    private <T extends JSDocTypeExpression> T finishNode(T node) {
      SourceLocation loc = node.getLoc();
      Position end = endPos();
      int relativeStartOffset = loc.getStart().getOffset() - absoluteOffset;
      int relativeEndOffset = end.getOffset() - absoluteOffset;
      loc.setSource(inputSubstring(relativeStartOffset, relativeEndOffset));
      loc.setEnd(end);
      return node;
    }

    private String inputSubstring(int start, int end) {
      if (start >= source.length()) return "";
      if (end > source.length()) end = source.length();
      return source.substring(start, end);
    }

    private int advance() {
      if (index >= source.length()) return -1;
      int ch = source.charAt(index);
      ++index;
      if (isLineTerminator(ch)
          && !(ch == '\r' && index < endIndex && source.charAt(index) == '\n')) {
        lineNumber += 1;
        lineStart = index;
        index = skipStars(index, endIndex);
      }
      return ch;
    }

    private String scanHexEscape(char prefix) {
      int i, len, ch, code = 0;

      len = (prefix == 'u') ? 4 : 2;
      for (i = 0; i < len; ++i) {
        if (index < endIndex && isHexDigit(source.charAt(index))) {
          ch = advance();
          code = code * 16 + "0123456789abcdef".indexOf(Character.toLowerCase(ch));
        } else {
          return "";
        }
      }
      return new String(Character.toChars(code));
    }

    private Token scanString() throws ParseError {
      StringBuilder str = new StringBuilder();
      int quote, ch, code, restore; // TODO review removal octal = false
      String unescaped;
      quote = source.charAt(index);
      ++index;

      while (index < endIndex) {
        ch = advance();

        if (ch == quote) {
          quote = -1;
          break;
        } else if (ch == '\\') {
          ch = advance();
          if (!isLineTerminator(ch)) {
            switch (ch) {
              case 'n':
                str.append('\n');
                break;
              case 'r':
                str.append('\r');
                break;
              case 't':
                str.append('\t');
                break;
              case 'u':
              case 'x':
                restore = index;
                unescaped = scanHexEscape((char) ch);
                if (!unescaped.isEmpty()) {
                  str.append(unescaped);
                } else {
                  index = restore;
                  str.append((char) ch);
                }
                break;
              case 'b':
                str.append('\b');
                break;
              case 'f':
                str.append('\f');
                break;
              case 'v':
                str.append('\u000b');
                break;

              default:
                if (isOctalDigit((char) ch)) {
                  code = "01234567".indexOf(ch);

                  // \0 is not octal escape sequence
                  // Deprecating unused code. TODO review removal
                  // if (code != 0) {
                  //    octal = true;
                  // }

                  if (index < endIndex && isOctalDigit(source.charAt(index))) {
                    // TODO Review Removal octal = true;
                    code = code * 8 + "01234567".indexOf(advance());

                    // 3 digits are only allowed when string starts
                    // with 0, 1, 2, 3
                    if ("0123".indexOf(ch) >= 0
                        && index < endIndex
                        && isOctalDigit(source.charAt(index))) {
                      code = code * 8 + "01234567".indexOf(advance());
                    }
                  }
                  str.append(Character.toChars(code));
                } else {
                  str.append((char) ch);
                }
                break;
            }
          } else {
            if (ch == '\r' && index < endIndex && source.charAt(index) == '\n') {
              ++index;
            }
          }
        } else if (isLineTerminator(ch)) {
          break;
        } else {
          str.append((char) ch);
        }
      }

      if (quote != -1) {
        throwError("unexpected quote");
      }

      value = str.toString();
      return Token.STRING;
    }

    private Token scanNumber() throws ParseError {
      StringBuilder number = new StringBuilder();
      boolean isFloat = false;
      char ch = '\0';

      if (ch != '.') {
        int next = advance();
        number.append((char) next);
        ch = index < endIndex ? source.charAt(index) : '\0';

        if (next == '0') {
          if (ch == 'x' || ch == 'X') {
            number.append((char) advance());
            while (index < endIndex) {
              ch = source.charAt(index);
              if (!isHexDigit(ch)) {
                break;
              }
              number.append((char) advance());
            }

            if (number.length() <= 2) {
              // only 0x
              throwError("unexpected token");
            }

            if (index < endIndex) {
              ch = source.charAt(index);
              if (isIdentifierStart(ch)) {
                throwError("unexpected token");
              }
            }
            try {
              value = Integer.parseInt(number.toString(), 16);
            } catch (NumberFormatException nfe) {
              Exceptions.ignore(nfe, "Precise exception content is unimportant");
              throwError("Invalid hexadecimal constant " + number);
            }
            return Token.NUMBER;
          }

          if (isOctalDigit(ch)) {
            number.append((char) advance());
            while (index < endIndex) {
              ch = source.charAt(index);
              if (!isOctalDigit(ch)) {
                break;
              }
              number.append((char) advance());
            }

            if (index < endIndex) {
              ch = source.charAt(index);
              if (isIdentifierStart(ch) || isDecimalDigit(ch)) {
                throwError("unexpected token");
              }
            }
            try {
              value = Integer.parseInt(number.toString(), 8);
            } catch (NumberFormatException nfe) {
              Exceptions.ignore(nfe, "Precise exception content is unimportant");
              throwError("Invalid octal constant " + number);
            }
            return Token.NUMBER;
          }

          if (isDecimalDigit(ch)) {
            throwError("unexpected token");
          }
        }

        while (index < endIndex) {
          ch = source.charAt(index);
          if (!isDecimalDigit(ch)) {
            break;
          }
          number.append((char) advance());
        }
      }

      if (ch == '.') {
        isFloat = true;
        number.append((char) advance());
        while (index < endIndex) {
          ch = source.charAt(index);
          if (!isDecimalDigit(ch)) {
            break;
          }
          number.append((char) advance());
        }
      }

      if (ch == 'e' || ch == 'E') {
        isFloat = true;
        number.append((char) advance());

        ch = index < endIndex ? source.charAt(index) : '\0';
        if (ch == '+' || ch == '-') {
          number.append((char) advance());
        }

        ch = index < endIndex ? source.charAt(index) : '\0';
        if (isDecimalDigit(ch)) {
          number.append((char) advance());
          while (index < endIndex) {
            ch = source.charAt(index);
            if (!isDecimalDigit(ch)) {
              break;
            }
            number.append((char) advance());
          }
        } else {
          throwError("unexpected token");
        }
      }

      if (index < endIndex) {
        ch = source.charAt(index);
        if (isIdentifierStart(ch)) {
          throwError("unexpected token");
        }
      }

      String num = number.toString();
      try {
        if (isFloat) value = Double.parseDouble(num);
        else value = Integer.parseInt(num);
      } catch (NumberFormatException nfe) {
        Exceptions.ignore(nfe, "Precise exception content is unimportant");
        throwError("Invalid numeric literal " + num);
      }
      return Token.NUMBER;
    }

    private Token scanTypeName() {
      char ch, ch2;

      value = new String(Character.toChars(advance()));
      while (index < endIndex && isTypeName(source.charAt(index))) {
        ch = source.charAt(index);
        if (ch == '.') {
          if ((index + 1) < endIndex) {
            ch2 = source.charAt(index + 1);
            if (ch2 == '<') {
              break;
            }
          }
        }
        value += new String(Character.toChars(advance()));
      }
      return Token.NAME;
    }

    private Token next() throws ParseError {
      char ch;

      endOfPrevToken = index;

      while (index < endIndex && isWhiteSpaceOrLineTerminator(source.charAt(index))) {
        advance();
      }
      if (index >= endIndex) {
        token = Token.EOF;
        return token;
      }

      startOfCurToken = index;

      ch = source.charAt(index);
      switch (ch) {
        case '"':
          token = scanString();
          return token;

        case ':':
          advance();
          token = Token.COLON;
          return token;

        case ',':
          advance();
          token = Token.COMMA;
          return token;

        case '(':
          advance();
          token = Token.LPAREN;
          return token;

        case ')':
          advance();
          token = Token.RPAREN;
          return token;

        case '[':
          advance();
          token = Token.LBRACK;
          return token;

        case ']':
          advance();
          token = Token.RBRACK;
          return token;

        case '{':
          advance();
          token = Token.LBRACE;
          return token;

        case '}':
          advance();
          token = Token.RBRACE;
          return token;

        case '.':
          advance();
          if (index < endIndex) {
            ch = source.charAt(index);
            if (ch == '<') {
              advance();
              token = Token.DOT_LT;
              return token;
            }

            if (ch == '.' && index + 1 < endIndex && source.charAt(index + 1) == '.') {
              advance();
              advance();
              token = Token.REST;
              return token;
            }

            if (isDecimalDigit(ch)) {
              token = scanNumber();
              return token;
            }
          }
          token = Token.DOT;
          return token;

        case '<':
          advance();
          token = Token.LT;
          return token;

        case '>':
          advance();
          token = Token.GT;
          return token;

        case '*':
          advance();
          token = Token.STAR;
          return token;

        case '|':
          advance();
          token = Token.PIPE;
          return token;

        case '?':
          advance();
          token = Token.QUESTION;
          return token;

        case '!':
          advance();
          token = Token.BANG;
          return token;

        case '=':
          advance();
          token = Token.EQUAL;
          return token;

        default:
          if (isDecimalDigit(ch)) {
            token = scanNumber();
            return token;
          }

          // type string permits following case,
          //
          // namespace.module.MyClass
          //
          // this reduced 1 token TK_NAME
          if (isTypeName(ch)) {
            token = scanTypeName();
            return token;
          }

          token = Token.ILLEGAL;
          return token;
      }
    }

    private void consume(Token target, String text) throws ParseError {
      if (token != target) throwError(text == null ? "consumed token not matched" : text);
      next();
    }

    private void consume(Token target) throws ParseError {
      consume(target, null);
    }

    private void expect(Token target) throws ParseError {
      if (token != target) {
        throwError("unexpected token");
      }
      next();
    }

    // UnionType := '(' TypeUnionList ')'
    //
    // TypeUnionList :=
    //     <<empty>>
    //   | NonemptyTypeUnionList
    //
    // NonemptyTypeUnionList :=
    //     TypeExpression
    //   | TypeExpression '|' NonemptyTypeUnionList
    private JSDocTypeExpression parseUnionType() throws ParseError {
      SourceLocation loc = loc();
      List<JSDocTypeExpression> elements = new ArrayList<>();
      consume(Token.LPAREN, "UnionType should start with (");
      if (token != Token.RPAREN) {
        while (true) {
          elements.add(parseTypeExpression());
          if (token == Token.RPAREN) {
            break;
          }
          expect(Token.PIPE);
        }
      }
      consume(Token.RPAREN, "UnionType should end with )");
      return finishNode(new UnionType(loc, elements));
    }

    // ArrayType := '[' ElementTypeList ']'
    //
    // ElementTypeList :=
    //     <<empty>>
    //  | TypeExpression
    //  | '...' TypeExpression
    //  | TypeExpression ',' ElementTypeList
    private JSDocTypeExpression parseArrayType() throws ParseError {
      SourceLocation loc = loc();
      List<JSDocTypeExpression> elements = new ArrayList<>();
      consume(Token.LBRACK, "ArrayType should start with [");
      while (token != Token.RBRACK) {
        if (token == Token.REST) {
          SourceLocation restLoc = loc();
          consume(Token.REST);
          elements.add(finishNode(new RestType(restLoc, parseTypeExpression())));
          break;
        } else {
          elements.add(parseTypeExpression());
        }
        if (token != Token.RBRACK) {
          expect(Token.COMMA);
        }
      }
      expect(Token.RBRACK);
      return finishNode(new ArrayType(loc, elements));
    }

    private String parseFieldName() throws ParseError {
      Object v = value;
      if (token == Token.NAME || token == Token.STRING) {
        next();
        return v.toString();
      }

      if (token == Token.NUMBER) {
        consume(Token.NUMBER);
        return v.toString();
      }

      return throwError("unexpected token");
    }

    // FieldType :=
    //     FieldName
    //   | FieldName ':' TypeExpression
    //
    // FieldName :=
    //     NameExpression
    //   | StringLiteral
    //   | NumberLiteral
    //   | ReservedIdentifier
    private FieldType parseFieldType() throws ParseError {
      String key;
      SourceLocation loc = loc();
      key = parseFieldName();
      if (token == Token.COLON) {
        consume(Token.COLON);
        return finishNode(new FieldType(loc, key, parseTypeExpression()));
      }
      return finishNode(new FieldType(loc, key, null));
    }

    // RecordType := '{' FieldTypeList '}'
    //
    // FieldTypeList :=
    //     <<empty>>
    //   | FieldType
    //   | FieldType ',' FieldTypeList
    private JSDocTypeExpression parseRecordType() throws ParseError {
      List<FieldType> fields = new ArrayList<>();
      SourceLocation loc = loc();
      consume(Token.LBRACE, "RecordType should start with {");
      if (token == Token.COMMA) {
        consume(Token.COMMA);
      } else {
        while (token != Token.RBRACE) {
          fields.add(parseFieldType());
          if (token != Token.RBRACE) {
            expect(Token.COMMA);
          }
        }
      }
      expect(Token.RBRACE);
      return finishNode(new RecordType(loc, fields));
    }

    private JSDocTypeExpression parseNameExpression() throws ParseError {
      Object name = value;
      SourceLocation loc = loc();
      expect(Token.NAME);
      return finishNode(new NameExpression(loc, name.toString()));
    }

    // TypeExpressionList :=
    //     TopLevelTypeExpression
    //   | TopLevelTypeExpression ',' TypeExpressionList
    private List<JSDocTypeExpression> parseTypeExpressionList() throws ParseError {
      List<JSDocTypeExpression> elements = new ArrayList<>();

      elements.add(parseTop());
      while (token == Token.COMMA) {
        consume(Token.COMMA);
        elements.add(parseTop());
      }
      return elements;
    }

    // TypeName :=
    //     NameExpression
    //   | NameExpression TypeApplication
    //
    // TypeApplication :=
    //     '.<' TypeExpressionList '>'
    //   | '<' TypeExpressionList '>'   // this is extension of doctrine
    private JSDocTypeExpression parseTypeName() throws ParseError {
      JSDocTypeExpression expr;
      List<JSDocTypeExpression> applications;
      SourceLocation loc = loc();
      expr = parseNameExpression();
      if (token == Token.DOT_LT || token == Token.LT) {
        next();
        applications = parseTypeExpressionList();
        expect(Token.GT);
        return finishNode(new TypeApplication(loc, expr, applications));
      }
      return expr;
    }

    // ResultType :=
    //     <<empty>>
    //   | ':' void
    //   | ':' TypeExpression
    //
    // BNF is above
    // but, we remove <<empty>> pattern, so token is always TypeToken::COLON
    private JSDocTypeExpression parseResultType() throws ParseError {
      consume(Token.COLON, "ResultType should start with :");
      SourceLocation loc = loc();
      if (token == Token.NAME && value.equals("void")) {
        consume(Token.NAME);
        return finishNode(new VoidLiteral(loc));
      }
      return parseTypeExpression();
    }

    // ParametersType :=
    //     RestParameterType
    //   | NonRestParametersType
    //   | NonRestParametersType ',' RestParameterType
    //
    // RestParameterType :=
    //     '...'
    //     '...' Identifier
    //
    // NonRestParametersType :=
    //     ParameterType ',' NonRestParametersType
    //   | ParameterType
    //   | OptionalParametersType
    //
    // OptionalParametersType :=
    //     OptionalParameterType
    //   | OptionalParameterType, OptionalParametersType
    //
    // OptionalParameterType := ParameterType=
    //
    // ParameterType := TypeExpression | Identifier ':' TypeExpression
    //
    // Identifier is "new" or "this"
    private List<JSDocTypeExpression> parseParametersType() throws ParseError {
      List<JSDocTypeExpression> params = new ArrayList<>();
      boolean normal = true;
      JSDocTypeExpression expr;
      boolean rest = false;

      while (token != Token.RPAREN) {
        if (token == Token.REST) {
          // RestParameterType
          consume(Token.REST);
          rest = true;
        }

        SourceLocation loc = loc();
        expr = parseTypeExpression();
        if (expr instanceof NameExpression && token == Token.COLON) {
          // Identifier ':' TypeExpression
          consume(Token.COLON);
          expr =
              finishNode(
                  new ParameterType(
                      new SourceLocation(loc),
                      ((NameExpression) expr).getName(),
                      parseTypeExpression()));
        }
        if (token == Token.EQUAL) {
          consume(Token.EQUAL);
          expr = finishNode(new OptionalType(new SourceLocation(loc), expr));
          normal = false;
        } else {
          if (!normal) {
            throwError("unexpected token");
          }
        }
        if (rest) {
          expr = finishNode(new RestType(new SourceLocation(loc), expr));
        }
        params.add(expr);
        if (token != Token.RPAREN) {
          expect(Token.COMMA);
        }
      }
      return params;
    }

    // FunctionType := 'function' FunctionSignatureType
    //
    // FunctionSignatureType :=
    //   | TypeParameters '(' ')' ResultType
    //   | TypeParameters '(' ParametersType ')' ResultType
    //   | TypeParameters '(' 'this' ':' TypeName ')' ResultType
    //   | TypeParameters '(' 'this' ':' TypeName ',' ParametersType ')' ResultType
    private JSDocTypeExpression parseFunctionType() throws ParseError {
      SourceLocation loc = loc();
      boolean isNew;
      JSDocTypeExpression thisBinding;
      List<JSDocTypeExpression> params;
      JSDocTypeExpression result;
      consume(Token.NAME);

      // Google Closure Compiler is not implementing TypeParameters.
      // So we do not. if we don't get '(', we see it as error.
      expect(Token.LPAREN);

      isNew = false;
      params = new ArrayList<JSDocTypeExpression>();
      thisBinding = null;
      if (token != Token.RPAREN) {
        // ParametersType or 'this'
        if (token == Token.NAME && (value.equals("this") || value.equals("new"))) {
          // 'this' or 'new'
          // 'new' is Closure Compiler extension
          isNew = value.equals("new");
          consume(Token.NAME);
          expect(Token.COLON);
          thisBinding = parseTypeName();
          if (token == Token.COMMA) {
            consume(Token.COMMA);
            params = parseParametersType();
          }
        } else {
          params = parseParametersType();
        }
      }

      expect(Token.RPAREN);

      result = null;
      if (token == Token.COLON) {
        result = parseResultType();
      }

      return finishNode(new FunctionType(loc, thisBinding, isNew, params, result));
    }

    // BasicTypeExpression :=
    //     '*'
    //   | 'null'
    //   | 'undefined'
    //   | TypeName
    //   | FunctionType
    //   | UnionType
    //   | RecordType
    //   | ArrayType
    private JSDocTypeExpression parseBasicTypeExpression() throws ParseError {
      Context context;
      SourceLocation loc;
      switch (token) {
        case STAR:
          loc = loc();
          consume(Token.STAR);
          return finishNode(new AllLiteral(loc));

        case LPAREN:
          return parseUnionType();

        case LBRACK:
          return parseArrayType();

        case LBRACE:
          return parseRecordType();

        case NAME:
          if (value.equals("null")) {
            loc = loc();
            consume(Token.NAME);
            return finishNode(new NullLiteral(loc));
          }

          if (value.equals("undefined")) {
            loc = loc();
            consume(Token.NAME);
            return finishNode(new UndefinedLiteral(loc));
          }

          context = save();
          if (value.equals("function")) {
            try {
              return parseFunctionType();
            } catch (ParseError e) {
              context.restore();
            }
          }

          return parseTypeName();

        default:
          return throwError("unexpected token");
      }
    }

    // TypeExpression :=
    //     BasicTypeExpression
    //   | '?' BasicTypeExpression
    //   | '!' BasicTypeExpression
    //   | BasicTypeExpression '?'
    //   | BasicTypeExpression '!'
    //   | '?'
    //   | BasicTypeExpression '[]'
    private JSDocTypeExpression parseTypeExpression() throws ParseError {
      JSDocTypeExpression expr;
      SourceLocation loc = loc();

      if (token == Token.QUESTION) {
        consume(Token.QUESTION);
        if (token == Token.COMMA
            || token == Token.EQUAL
            || token == Token.RBRACE
            || token == Token.RPAREN
            || token == Token.PIPE
            || token == Token.EOF
            || token == Token.RBRACK) {
          return finishNode(new NullableLiteral(loc));
        }
        return finishNode(new NullableType(loc, parseBasicTypeExpression(), true));
      }

      if (token == Token.BANG) {
        consume(Token.BANG);
        return finishNode(new NonNullableType(loc, parseBasicTypeExpression(), true));
      }

      expr = parseBasicTypeExpression();
      if (token == Token.BANG) {
        consume(Token.BANG);
        return finishNode(new NonNullableType(loc, expr, false));
      }

      if (token == Token.QUESTION) {
        consume(Token.QUESTION);
        return finishNode(new NullableType(loc, expr, false));
      }

      if (token == Token.LBRACK) {
        consume(Token.LBRACK);
        consume(Token.RBRACK, "expected an array-style type declaration (' + value + '[])");
        List<JSDocTypeExpression> expressions = new ArrayList<>();
        expressions.add(expr);
        NameExpression nameExpr = finishNode(new NameExpression(new SourceLocation(loc), "Array"));
        return finishNode(new TypeApplication(loc, nameExpr, expressions));
      }

      return expr;
    }

    // TopLevelTypeExpression :=
    //      TypeExpression
    //    | TypeUnionList
    //
    // This rule is Google Closure Compiler extension, not ES4
    // like,
    //   { number | string }
    // If strict to ES4, we should write it as
    //   { (number|string) }
    private JSDocTypeExpression parseTop() throws ParseError {
      JSDocTypeExpression expr;
      List<JSDocTypeExpression> elements = new ArrayList<JSDocTypeExpression>();
      SourceLocation loc = loc();

      expr = parseTypeExpression();
      if (token != Token.PIPE) {
        return expr;
      }

      elements.add(expr);
      consume(Token.PIPE);
      while (true) {
        elements.add(parseTypeExpression());
        if (token != Token.PIPE) {
          break;
        }
        consume(Token.PIPE);
      }

      return finishNode(new UnionType(loc, elements));
    }

    private JSDocTypeExpression parseTopParamType() throws ParseError {
      JSDocTypeExpression expr;
      SourceLocation loc = loc();

      if (token == Token.REST) {
        consume(Token.REST);
        return finishNode(new RestType(loc, parseTop()));
      }

      expr = parseTop();
      if (token == Token.EQUAL) {
        consume(Token.EQUAL);
        return finishNode(new OptionalType(loc, expr));
      }

      return expr;
    }

    private JSDocTypeExpression parseType(
        int startIndex, int endIndex, int lineStart, int lineNumber) throws ParseError {
      JSDocTypeExpression expr;

      this.lineNumber = lineNumber;
      this.lineStart = lineStart;
      this.startIndex = startIndex;
      this.endIndex = endIndex;
      index = startIndex;

      next();
      expr = parseTop();

      if (token != Token.EOF) {
        throwError("not reach to EOF");
      }

      return expr;
    }

    private JSDocTypeExpression parseParamType(
        int startIndex, int endIndex, int lineStart, int lineNumber) throws ParseError {
      JSDocTypeExpression expr;

      this.lineNumber = lineNumber;
      this.lineStart = lineStart;
      this.startIndex = startIndex;
      this.endIndex = endIndex;
      index = startIndex;

      next();
      expr = parseTopParamType();

      if (token != Token.EOF) {
        throwError("not reach to EOF");
      }

      return expr;
    }
  }

  /** Skips the leading indentation and '*' at the beginning of a line. */
  private int skipStars(int index, int end) {
    while (index < end
        && isWhiteSpace(source.charAt(index))
        && !isLineTerminator(source.charAt(index))) {
      index += 1;
    }
    while (index < end && source.charAt(index) == '*') {
      index += 1;
    }
    while (index < end
        && isWhiteSpace(source.charAt(index))
        && !isLineTerminator(source.charAt(index))) {
      index += 1;
    }
    return index;
  }

  private TypeExpressionParser typed = new TypeExpressionParser();

  private class JSDocTagParser {
    int index, lineNumber, lineStart, length;
    boolean recoverable = true, sloppy = false;

    private char advance() {
      char ch = source.charAt(index);
      index += 1;
      if (isLineTerminator(ch) && !(ch == '\r' && index < length && source.charAt(index) == '\n')) {
        lineNumber += 1;
        lineStart = index;
        index = skipStars(index, length);
      }
      return ch;
    }

    private String scanTitle() {
      StringBuilder title = new StringBuilder();
      // waste '@'
      advance();

      while (index < length && isASCIIAlphanumeric(source.charAt(index))) {
        title.append(advance());
      }

      return title.toString();
    }

    private int seekContent() {
      char ch;
      boolean waiting = false;
      int last = index;

      while (last < length) {
        ch = source.charAt(last);
        if (isLineTerminator(ch)
            && !(ch == '\r' && last + 1 < length && source.charAt(last + 1) == '\n')) {
          lineNumber += 1;
          lineStart = last + 1;
          last = skipStars(last + 1, length) - 1;
          waiting = true;
        } else if (waiting) {
          if (ch == '@') {
            break;
          }
          if (!isWhiteSpace(ch)) {
            waiting = false;
          }
        }
        last += 1;
      }
      return last;
    }

    // type expression may have nest brace, such as,
    // { { ok: string } }
    //
    // therefore, scanning type expression with balancing braces.
    private JSDocTypeExpression parseType(String title, int last) throws ParseError {
      char ch;
      int brace;
      boolean direct = false;

      // search '{'
      while (index < last) {
        ch = source.charAt(index);
        if (isWhiteSpace(ch)) {
          advance();
        } else if (ch == '{') {
          advance();
          break;
        } else {
          // this is direct pattern
          direct = true;
          break;
        }
      }

      if (!direct) {
        // type expression { is found
        brace = 1;
        int firstLineStart = this.lineStart;
        int firstLineNumber = this.lineNumber;
        int startIndex = index;
        while (index < last) {
          ch = source.charAt(index);
          if (ch == '}') {
            brace -= 1;
            if (brace == 0) {
              advance();
              break;
            }
          } else if (ch == '{') {
            brace += 1;
          }
          advance();
        }

        if (brace != 0) {
          // braces is not balanced
          return throwError("Braces are not balanced");
        }

        try {
          if (isParamTitle(title)) {
            return typed.parseParamType(startIndex, index - 1, firstLineStart, firstLineNumber);
          }
          return typed.parseType(startIndex, index - 1, firstLineStart, firstLineNumber);
        } catch (ParseError e) {
          // parse failed
          return null;
        }
      } else {
        return null;
      }
    }

    private String scanIdentifier(int last) {
      StringBuilder identifier = new StringBuilder();
      if (!(index < length && isIdentifierStart(source.charAt(index)))) {
        return null;
      }
      identifier.append(advance());
      while (index < last && isIdentifierPart(source.charAt(index))) {
        identifier.append(advance());
      }
      return identifier.toString();
    }

    private void skipWhiteSpace(int last) {
      while (index < last
          && (isWhiteSpace(source.charAt(index)) || isLineTerminator(source.charAt(index)))) {
        advance();
      }
    }

    private String parseName(int last, boolean allowBrackets, boolean allowNestedParams) {
      StringBuilder name = new StringBuilder();
      boolean useBrackets = false;

      skipWhiteSpace(last);

      if (index >= last) {
        return null;
      }

      if (allowBrackets && source.charAt(index) == '[') {
        useBrackets = true;
        name.append(advance());
      }

      if (!isIdentifierStart(source.charAt(index))) {
        return null;
      }

      name.append(scanIdentifier(last));

      if (allowNestedParams) {
        while (index < last
            && (source.charAt(index) == '.'
                || source.charAt(index) == '#'
                || source.charAt(index) == '~')) {
          name.append(source.charAt(index));
          index += 1;
          name.append(scanIdentifier(last));
        }
      }

      if (useBrackets) {
        // do we have a default value for this?
        if (index < last && source.charAt(index) == '=') {

          // consume the '='' symbol
          name.append(advance());
          // scan in the default value
          while (index < last && source.charAt(index) != ']') {
            name.append(advance());
          }
        }

        if (index >= last || source.charAt(index) != ']') {
          // we never found a closing ']'
          return null;
        }

        // collect the last ']'
        name.append(advance());
      }

      return name.toString();
    }

    boolean skipToTag() {
      while (index < length && source.charAt(index) != '@') {
        advance();
      }
      if (index >= length) {
        return false;
      }
      return true;
    }

    private class Tag {
      public String description;
      public String title;
      List<String> errors = new ArrayList<>();
      JSDocTypeExpression type;
      String name;
      public int startLine;
      public int startColumn;
    }

    private class TagParser {
      String _title;
      Tag _tag;
      int _last;
      String _extra_name;

      TagParser(String title) {
        this._title = title;
        this._tag = new Tag();
        this._tag.description = null;
        this._tag.title = title;
        this._last = 0;
        // space to save special information for title parsers.
        this._extra_name = null;
      }

      // addError(err, ...)
      public boolean addError(String errorText, Object... args) {
        this._tag.errors.add(String.format(errorText, args));
        return recoverable;
      }

      public boolean parseType() {
        // type required titles
        if (isTypeParameterRequired(this._title)) {
          try {
            this._tag.type = JSDocTagParser.this.parseType(this._title, this._last);
            if (this._tag.type == null) {
              if (!isParamTitle(this._title)) {
                if (!this.addError("Missing or invalid tag type")) {
                  return false;
                }
              }
            }
          } catch (ParseError error) {
            this._tag.type = null;
            if (!this.addError(error.getMessage())) {
              return false;
            }
          }
        } else if (isAllowedType(this._title)) {
          // optional types
          try {
            this._tag.type = JSDocTagParser.this.parseType(this._title, this._last);
          } catch (ParseError e) {
            // For optional types, lets drop the thrown error when we hit the end of the file
          }
        }
        return true;
      }

      private boolean _parseNamePath(boolean optional) {
        String name =
            JSDocTagParser.this.parseName(this._last, sloppy && isParamTitle(this._title), true);
        if (name == null) {
          if (!optional) {
            if (!this.addError("Missing or invalid tag name")) {
              return false;
            }
          }
        }
        this._tag.name = name;
        return true;
      }

      public boolean parseNamePath() {
        return _parseNamePath(false);
      }

      public boolean parseNamePathOptional() {
        return this._parseNamePath(true);
      }

      public boolean parseName() {
        String[] assign;
        String name;

        // param, property requires name
        if (isAllowedName(this._title)) {
          this._tag.name =
              JSDocTagParser.this.parseName(
                  this._last, sloppy && isParamTitle(this._title), isAllowedNested(this._title));
          if (this._tag.name == null) {
            if (!isNameParameterRequired(this._title)) {
              return true;
            }

            // it's possible the name has already been parsed but interpreted as a type
            // it's also possible this is a sloppy declaration, in which case it will be
            // fixed at the end
            if (isParamTitle(this._title)
                && this._tag.type != null
                && this._tag.type instanceof NameExpression) {
              this._extra_name = ((NameExpression) this._tag.type).getName();
              this._tag.name = ((NameExpression) this._tag.type).getName();
              this._tag.type = null;
            } else {
              if (!this.addError("Missing or invalid tag name")) {
                return false;
              }
            }
          } else {
            name = this._tag.name;
            if (name.charAt(0) == '[' && name.charAt(name.length() - 1) == ']') {
              // extract the default value if there is one
              // example: @param {string} [somebody=John Doe] description
              assign = name.substring(1, name.length() - 1).split("=");
              this._tag.name = assign[0];

              // convert to an optional type
              if (this._tag.type != null && !(this._tag.type instanceof OptionalType)) {
                Position start = new Position(_tag.startLine, _tag.startColumn, _tag.startColumn);
                Position end = new Position(_tag.startLine, _tag.startColumn, _tag.startColumn);
                SourceLocation loc = new SourceLocation(_extra_name, start, end);
                this._tag.type = new OptionalType(loc, this._tag.type);
              }
            }
          }
        }

        return true;
      }

      private boolean parseDescription() {
        String description = sliceSource(source, index, this._last).trim();
        if (!description.isEmpty()) {
          if (description.matches("(?s)^-\\s+.*")) {
            description = description.substring(2);
          }
          description = description.replaceAll("(?m)^\\s*\\*+\\s*", "");
          this._tag.description = description;
        }
        return true;
      }

      private final Set<String> kinds = new LinkedHashSet<>();

      {
        kinds.add("class");
        kinds.add("constant");
        kinds.add("event");
        kinds.add("external");
        kinds.add("file");
        kinds.add("function");
        kinds.add("member");
        kinds.add("mixin");
        kinds.add("module");
        kinds.add("namespace");
        kinds.add("typedef");
      }

      private boolean parseKind() {
        String kind = sliceSource(source, index, this._last).trim();
        if (!kinds.contains(kind)) {
          if (!this.addError("Invalid kind name \'%s\'", kind)) {
            return false;
          }
        }
        return true;
      }

      private boolean parseAccess() {
        String access = sliceSource(source, index, this._last).trim();
        if (!access.equals("private") && !access.equals("protected") && !access.equals("public")) {
          if (!this.addError("Invalid access name \'%s\'", access)) {
            return false;
          }
        }
        return true;
      }

      private boolean parseVariation() {
        double variation;
        String text = sliceSource(source, index, this._last).trim();
        try {
          variation = Double.parseDouble(text);
        } catch (NumberFormatException nfe) {
          variation = Double.NaN;
        }
        if (Double.isNaN(variation)) {
          if (!this.addError("Invalid variation \'%s\'", text)) {
            return false;
          }
        }
        return true;
      }

      private boolean ensureEnd() {
        String shouldBeEmpty = sliceSource(source, index, this._last).trim();
        if (!shouldBeEmpty.matches("^[\\s*]*$")) {
          if (!this.addError("Unknown content \'%s\'", shouldBeEmpty)) {
            return false;
          }
        }
        return true;
      }

      private boolean epilogue() {
        String description;

        description = this._tag.description;
        // un-fix potentially sloppy declaration
        if (isParamTitle(this._title)
            && this._tag.type == null
            && description != null
            && description.startsWith("[")) {
          if (_extra_name != null) {
            Position start = new Position(_tag.startLine, _tag.startColumn, _tag.startColumn);
            Position end = new Position(_tag.startLine, _tag.startColumn, _tag.startColumn);
            SourceLocation loc = new SourceLocation(_extra_name, start, end);
            this._tag.type = new NameExpression(loc, _extra_name);
          }
          this._tag.name = null;

          if (!sloppy) {
            if (!this.addError("Missing or invalid tag name")) {
              return false;
            }
          }
        }

        return true;
      }

      private Tag parse() {
        int oldLineNumber, oldLineStart, newLineNumber, newLineStart;

        // empty title
        if (this._title == null || this._title.isEmpty()) {
          if (!this.addError("Missing or invalid title")) {
            return null;
          }
        }

        // Seek to content last index.
        oldLineNumber = lineNumber;
        oldLineStart = lineStart;
        this._last = seekContent();
        newLineNumber = lineNumber;
        newLineStart = lineStart;
        lineNumber = oldLineNumber;
        lineStart = oldLineStart;

        switch (this._title) {
            // http://usejsdoc.org/tags-access.html
          case "access":
            if (!parseAccess()) return null;
            break;
            // http://usejsdoc.org/tags-alias.html
          case "alias":
            if (!parseNamePath() || !ensureEnd()) return null;
            break;
            // http://usejsdoc.org/tags-augments.html
          case "augments":
            if (!parseType() || !parseNamePathOptional() || !ensureEnd()) return null;
            break;
            // http://usejsdoc.org/tags-constructor.html
          case "constructor":
            if (!parseType() || !parseNamePathOptional() || !ensureEnd()) return null;
            break;
            // Synonym: http://usejsdoc.org/tags-constructor.html
          case "class":
            if (!parseType() || !parseNamePathOptional() || !ensureEnd()) return null;
            break;
            // Synonym: http://usejsdoc.org/tags-extends.html
          case "extends":
            if (!parseType() || !parseNamePathOptional() || !ensureEnd()) return null;
            break;
            // http://usejsdoc.org/tags-deprecated.html
          case "deprecated":
            if (!parseDescription()) return null;
            break;
            // http://usejsdoc.org/tags-global.html
          case "global":
            if (!ensureEnd()) return null;
            break;
            // http://usejsdoc.org/tags-inner.html
          case "inner":
            if (!ensureEnd()) return null;
            break;
            // http://usejsdoc.org/tags-instance.html
          case "instance":
            if (!ensureEnd()) return null;
            break;
            // http://usejsdoc.org/tags-kind.html
          case "kind":
            if (!parseKind()) return null;
            break;
            // http://usejsdoc.org/tags-mixes.html
          case "mixes":
            if (!parseNamePath() || !ensureEnd()) return null;
            break;
            // http://usejsdoc.org/tags-mixin.html
          case "mixin":
            if (!parseNamePathOptional() || !ensureEnd()) return null;
            break;
            // http://usejsdoc.org/tags-member.html
          case "member":
            if (!parseType() || !parseNamePathOptional() || !ensureEnd()) return null;
            break;
            // http://usejsdoc.org/tags-method.html
          case "method":
            if (!parseNamePathOptional() || !ensureEnd()) return null;
            break;
            // http://usejsdoc.org/tags-module.html
          case "module":
            if (!parseType() || !parseNamePathOptional() || !ensureEnd()) return null;
            break;
            // Synonym: http://usejsdoc.org/tags-method.html
          case "func":
            if (!parseNamePathOptional() || !ensureEnd()) return null;
            break;
            // Synonym: http://usejsdoc.org/tags-method.html
          case "function":
            if (!parseNamePathOptional() || !ensureEnd()) return null;
            break;
            // Synonym: http://usejsdoc.org/tags-member.html
          case "var":
            if (!parseType() || !parseNamePathOptional() || !ensureEnd()) return null;
            break;
            // http://usejsdoc.org/tags-name.html
          case "name":
            if (!parseNamePath() || !ensureEnd()) return null;
            break;
            // http://usejsdoc.org/tags-namespace.html
          case "namespace":
            if (!parseType() || !parseNamePathOptional() || !ensureEnd()) return null;
            break;
            // http://usejsdoc.org/tags-private.html
          case "private":
            if (!parseType() || !parseDescription()) return null;
            break;
            // http://usejsdoc.org/tags-protected.html
          case "protected":
            if (!parseType() || !parseDescription()) return null;
            break;
            // http://usejsdoc.org/tags-public.html
          case "public":
            if (!parseType() || !parseDescription()) return null;
            break;
            // http://usejsdoc.org/tags-readonly.html
          case "readonly":
            if (!ensureEnd()) return null;
            break;
            // http://usejsdoc.org/tags-requires.html
          case "requires":
            if (!parseNamePath() || !ensureEnd()) return null;
            break;
            // http://usejsdoc.org/tags-since.html
          case "since":
            if (!parseDescription()) return null;
            break;
            // http://usejsdoc.org/tags-static.html
          case "static":
            if (!ensureEnd()) return null;
            break;
            // http://usejsdoc.org/tags-summary.html
          case "summary":
            if (!parseDescription()) return null;
            break;
            // http://usejsdoc.org/tags-this.html
          case "this":
            if (!parseNamePath() || !ensureEnd()) return null;
            break;
            // http://usejsdoc.org/tags-todo.html
          case "todo":
            if (!parseDescription()) return null;
            break;
            // http://usejsdoc.org/tags-variation.html
          case "variation":
            if (!parseVariation()) return null;
            break;
            // http://usejsdoc.org/tags-version.html
          case "version":
            if (!parseDescription()) return null;
            break;
            // default sequences
          default:
            if (!parseType() || !parseName() || !parseDescription() || !epilogue()) return null;
            break;
        }

        // Seek global index to end of this tag.
        index = this._last;
        lineNumber = newLineNumber;
        lineStart = newLineStart;
        return this._tag;
      }

      private Tag parseTag() {
        String title;
        Tag res;
        TagParser parser;
        int startColumn;
        int startLine;

        // skip to tag
        if (!skipToTag()) {
          return null;
        }

        startLine = lineNumber;
        startColumn = index - lineStart;

        // scan title
        title = scanTitle();

        // construct tag parser
        parser = new TagParser(title);
        res = parser.parse();

        if (res != null) {
          res.startLine = startLine;
          res.startColumn = startColumn;
        }

        return res;
      }

      //
      // Parse JSDoc
      //

      String scanJSDocDescription() {
        StringBuilder description = new StringBuilder();
        char ch;
        boolean atAllowed;

        atAllowed = true;
        while (index < length) {
          ch = source.charAt(index);

          if (atAllowed && ch == '@') {
            break;
          }

          if (isLineTerminator(ch)) {
            atAllowed = true;
          } else if (atAllowed && !isWhiteSpace(ch)) {
            atAllowed = false;
          }

          description.append(advance());
        }
        return description.toString().trim();
      }

      public Pair<String, List<Tag>> parseComment(int lineNumber_, int lineStart_) {
        List<Tag> tags = new ArrayList<>();
        Tag tag;
        String description;

        length = source.length();
        index = 1; // Skip initial "*"
        lineNumber = lineNumber_;
        lineStart = lineStart_;
        recoverable = true;
        sloppy = true;

        description = scanJSDocDescription();

        while (true) {
          tag = parseTag();
          if (tag == null) {
            break;
          }
          tags.add(tag);
        }

        return Pair.make(description, tags);
      }
    }
  }
}
