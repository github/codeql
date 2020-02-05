package com.semmle.jcorn;

import com.semmle.jcorn.Parser.TokContext;
import java.util.LinkedHashMap;
import java.util.Map;

/// tokentype.js

// ## Token types

// The assignment of fine-grained, information-carrying type objects
// allows the tokenizer to store the information it has about a
// token in a way that is very cheap for the parser to look up.

// All token type variables start with an underscore, to make them
// easy to recognize.

// The `beforeExpr` property is used to disambiguate between regular
// expressions and divisions. It is set on all token types that can
// be followed by an expression (thus, a slash after them would be a
// regular expression).
//
// The `startsExpr` property is used to check if the token ends a
// `yield` expression. It is set on all token types that either can
// directly start an expression (like a quotation mark) or can
// continue an expression (like the body of a string).
//
// `isLoop` marks a keyword as starting a loop, which is important
// to know when parsing a label, in order to allow or disallow
// continue jumps to that label.

public class TokenType {
  // Map keyword names to token types.
  public static final Map<String, TokenType> keywords = new LinkedHashMap<>();

  public static final TokenType num = new TokenType(new Properties("num").startsExpr()),
      bigint = new TokenType(new Properties("bigint").startsExpr()),
      regexp = new TokenType(new Properties("regexp").startsExpr()),
      string = new TokenType(new Properties("string").startsExpr()),
      name = new TokenType(new Properties("name").startsExpr()),
      eof = new TokenType(new Properties("eof")),

      // Punctuation token types.
      bracketL = new TokenType(new Properties("[").beforeExpr().startsExpr()),
      bracketR = new TokenType(new Properties("]")),
      braceL =
          new TokenType(new Properties("{").beforeExpr().startsExpr()) {
            @Override
            public void updateContext(Parser parser, TokenType prevType) {
              parser.context.push(
                  parser.braceIsBlock(prevType) ? TokContext.b_stat : TokContext.b_expr);
              parser.exprAllowed = true;
            }
          },
      braceR =
          new TokenType(new Properties("}")) {
            @Override
            public void updateContext(Parser parser, TokenType prevType) {
              updateParenBraceRContext(parser);
            }
          },
      parenL =
          new TokenType(new Properties("(").beforeExpr().startsExpr()) {
            @Override
            public void updateContext(Parser parser, TokenType prevType) {
              boolean statementParens =
                  prevType == TokenType._if
                      || prevType == TokenType._for
                      || prevType == TokenType._with
                      || prevType == TokenType._while;
              parser.context.push(statementParens ? TokContext.p_stat : TokContext.p_expr);
              parser.exprAllowed = true;
            }
          },
      parenR =
          new TokenType(new Properties(")")) {
            @Override
            public void updateContext(Parser parser, TokenType prevType) {
              updateParenBraceRContext(parser);
            }
          },
      comma = new TokenType(new Properties(",").beforeExpr()),
      semi = new TokenType(new Properties(";").beforeExpr()),
      colon = new TokenType(new Properties(":").beforeExpr()),
      dot = new TokenType(new Properties(".")),
      questiondot = new TokenType(new Properties("?.")),
      question = new TokenType(new Properties("?").beforeExpr()),
      pound = new TokenType(kw("#")),
      arrow = new TokenType(new Properties("=>").beforeExpr()),
      template = new TokenType(new Properties("template")),
      invalidTemplate = new TokenType(new Properties("invalidTemplate")),
      ellipsis = new TokenType(new Properties("...").beforeExpr()),
      backQuote =
          new TokenType(new Properties("`").startsExpr()) {
            @Override
            public void updateContext(Parser parser, TokenType prevType) {
              if (parser.curContext() == TokContext.q_tmpl) parser.context.pop();
              else parser.context.push(TokContext.q_tmpl);
              parser.exprAllowed = false;
            }
          },
      dollarBraceL =
          new TokenType(new Properties("${").beforeExpr().startsExpr()) {
            @Override
            public void updateContext(Parser parser, TokenType prevType) {
              parser.context.push(TokContext.b_tmpl);
              parser.exprAllowed = true;
            }
          },

      // Operators. These carry several kinds of properties to help the
      // parser use them properly (the presence of these properties is
      // what categorizes them as operators).
      //
      // `binop`, when present, specifies that this operator is a binary
      // operator, and will refer to its precedence.
      //
      // `prefix` and `postfix` mark the operator as a prefix or postfix
      // unary operator.
      //
      // `isAssign` marks all of `=`, `+=`, `-=` etcetera, which act as
      // binary operators with a very low precedence, that should result
      // in AssignmentExpression nodes.

      eq = new TokenType(new Properties("=").beforeExpr().isAssign()),
      assign = new TokenType(new Properties("_=").beforeExpr().isAssign()),
      incDec =
          new TokenType(new Properties("++/--").prefix().postfix().startsExpr()) {
            @Override
            public void updateContext(Parser parser, TokenType prevType) {
              // exprAllowed stays unchanged
            }
          },
      prefix = new TokenType(new Properties("prefix").beforeExpr().prefix().startsExpr()),
      questionquestion = new TokenType(binop("??", 1)),
      logicalOR = new TokenType(binop("||", 1)),
      logicalAND = new TokenType(binop("&&", 2)),
      bitwiseOR = new TokenType(binop("|", 3)),
      bitwiseXOR = new TokenType(binop("^", 4)),
      bitwiseAND = new TokenType(binop("&", 5)),
      equality = new TokenType(binop("==/!=", 6)),
      relational = new TokenType(binop("</>", 7)),
      bitShift = new TokenType(binop("<</>>", 8)),
      plusMin = new TokenType(new Properties("+/-").beforeExpr().binop(9).prefix().startsExpr()),
      modulo = new TokenType(binop("%", 10)),
      star = new TokenType(binop("*", 10)),
      slash = new TokenType(binop("/", 10)),
      starstar = new TokenType(new Properties("**").beforeExpr()),
      _break = new TokenType(kw("break")),
      _case = new TokenType(kw("case").beforeExpr()),
      _catch = new TokenType(kw("catch")),
      _continue = new TokenType(kw("continue")),
      _debugger = new TokenType(kw("debugger")),
      _default = new TokenType(kw("default").beforeExpr()),
      _do = new TokenType(kw("do").isLoop().beforeExpr()),
      _else = new TokenType(kw("else").beforeExpr()),
      _finally = new TokenType(kw("finally")),
      _for = new TokenType(kw("for").isLoop()),
      _function =
          new TokenType(kw("function").startsExpr()) {
            @Override
            public void updateContext(Parser parser, TokenType prevType) {
              if (prevType.beforeExpr
                  && prevType != TokenType.semi
                  && prevType != TokenType._else
                  && !((prevType == TokenType.colon || prevType == TokenType.braceL)
                      && parser.curContext() == TokContext.b_stat))
                parser.context.push(TokContext.f_expr);
              parser.exprAllowed = false;
            }
          },
      _if = new TokenType(kw("if")),
      _return = new TokenType(kw("return").beforeExpr()),
      _switch = new TokenType(kw("switch")),
      _throw = new TokenType(kw("throw").beforeExpr()),
      _try = new TokenType(kw("try")),
      _var = new TokenType(kw("var")),
      _const = new TokenType(kw("const")),
      _while = new TokenType(kw("while").isLoop()),
      _with = new TokenType(kw("with")),
      _new = new TokenType(kw("new").beforeExpr().startsExpr()),
      _this = new TokenType(kw("this").startsExpr()),
      _super = new TokenType(kw("super").startsExpr()),
      _class = new TokenType(kw("class")),
      _extends = new TokenType(kw("extends").beforeExpr()),
      _export = new TokenType(kw("export")),
      _import = new TokenType(kw("import").startsExpr()),
      _null = new TokenType(kw("null").startsExpr()),
      _true = new TokenType(kw("true").startsExpr()),
      _false = new TokenType(kw("false").startsExpr()),
      _in = new TokenType(kw("in").beforeExpr().binop(7)),
      _instanceof = new TokenType(kw("instanceof").beforeExpr().binop(7)),
      _typeof = new TokenType(kw("typeof").beforeExpr().prefix().startsExpr()),
      _void = new TokenType(kw("void").beforeExpr().prefix().startsExpr()),
      _delete = new TokenType(kw("delete").beforeExpr().prefix().startsExpr());
  public final String label, keyword;
  public final boolean beforeExpr, startsExpr, isLoop, isAssign, isPrefix, isPostfix;
  public final int binop;

  public void updateContext(Parser parser, TokenType prevType) {
    parser.exprAllowed = this.beforeExpr;
  }

  // Token-specific context update code
  protected void updateParenBraceRContext(Parser parser) {
    if (parser.context.size() == 1) {
      parser.exprAllowed = true;
      return;
    }
    TokContext out = parser.context.pop();
    if (out == TokContext.b_stat && parser.curContext() == TokContext.f_expr) {
      parser.context.pop();
      parser.exprAllowed = false;
    } else if (out == TokContext.b_tmpl) {
      parser.exprAllowed = true;
    } else {
      parser.exprAllowed = !out.isExpr;
    }
  }

  public TokenType(Properties prop) {
    this.label = prop.label;
    this.keyword = prop.keyword;
    this.beforeExpr = prop.beforeExpr;
    this.startsExpr = prop.startsExpr;
    this.isLoop = prop.isLoop;
    this.isAssign = prop.isAssign;
    this.isPrefix = prop.prefix;
    this.isPostfix = prop.postfix;
    this.binop = prop.binop;
    if (this.keyword != null) keywords.put(this.keyword, this);
  }

  public static class Properties {
    public String label, keyword;
    public boolean beforeExpr, startsExpr, isLoop, isAssign, prefix, postfix;
    public int binop;

    public Properties(String label, String keyword) {
      this.label = label;
      this.keyword = keyword;
    }

    public Properties(String label) {
      this(label, null);
    }

    public Properties beforeExpr() {
      this.beforeExpr = true;
      return this;
    }

    public Properties startsExpr() {
      this.startsExpr = true;
      return this;
    }

    public Properties isLoop() {
      this.isLoop = true;
      return this;
    }

    public Properties isAssign() {
      this.isAssign = true;
      return this;
    }

    public Properties prefix() {
      this.prefix = true;
      return this;
    }

    public Properties postfix() {
      this.postfix = true;
      return this;
    }

    public Properties binop(int prec) {
      this.binop = prec;
      return this;
    }
  }

  private static Properties binop(String name, int prec) {
    return new Properties(name, null).binop(prec).beforeExpr();
  }

  // Succinct definitions of keyword token types
  private static Properties kw(String name) {
    return new Properties(name, name);
  }
}
