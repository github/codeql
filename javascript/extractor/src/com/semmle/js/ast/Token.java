package com.semmle.js.ast;

import static com.semmle.js.ast.Token.Type.EOF;
import static com.semmle.js.ast.Token.Type.FALSE;
import static com.semmle.js.ast.Token.Type.KEYWORD;
import static com.semmle.js.ast.Token.Type.NAME;
import static com.semmle.js.ast.Token.Type.NULL;
import static com.semmle.js.ast.Token.Type.NUM;
import static com.semmle.js.ast.Token.Type.PUNCTUATOR;
import static com.semmle.js.ast.Token.Type.REGEXP;
import static com.semmle.js.ast.Token.Type.STRING;
import static com.semmle.js.ast.Token.Type.TRUE;

/**
 * A source code token.
 *
 * <p>This is not part of the SpiderMonkey AST format.
 */
public class Token extends SourceElement {
  /** The supported token types. */
  public static enum Type {
    EOF,
    NULL,
    TRUE,
    FALSE,
    NUM,
    STRING,
    REGEXP,
    NAME,
    KEYWORD,
    PUNCTUATOR
  };

  private final Type type;
  private final String value;

  public Token(SourceLocation loc, String typename, Object keyword) {
    this(loc, getType(typename, keyword));
  }

  public Token(SourceLocation loc, Type type) {
    super(loc);
    this.value = loc.getSource();
    this.type = type;
  }

  private static Type getType(String typename, Object keyword) {
    if ("eof".equals(typename)) {
      return EOF;
    } else if ("num".equals(typename)) {
      return NUM;
    } else if ("name".equals(typename) || "jsxName".equals(typename)) {
      return NAME;
    } else if ("string".equals(typename)
        || "template".equals(typename)
        || "jsxText".equals(typename)) {
      return STRING;
    } else if ("regexp".equals(typename)) {
      return REGEXP;
    } else if ("true".equals(keyword)) {
      return TRUE;
    } else if ("false".equals(keyword)) {
      return FALSE;
    } else if ("null".equals(keyword)) {
      return NULL;
    } else if (keyword instanceof String) {
      return KEYWORD;
    } else {
      return PUNCTUATOR;
    }
  }

  /** The type of this token. */
  public Type getType() {
    return type;
  }

  /** The source text of this token. */
  public String getValue() {
    return value;
  }
}
