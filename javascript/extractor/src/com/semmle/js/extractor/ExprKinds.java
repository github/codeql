package com.semmle.js.extractor;

import java.util.EnumMap;
import java.util.LinkedHashMap;
import java.util.Map;

import com.semmle.jcorn.TokenType;
import com.semmle.jcorn.jsx.JSXParser;
import com.semmle.js.ast.AssignmentExpression;
import com.semmle.js.ast.BinaryExpression;
import com.semmle.js.ast.ComprehensionBlock;
import com.semmle.js.ast.ComprehensionExpression;
import com.semmle.js.ast.DefaultVisitor;
import com.semmle.js.ast.DynamicImport;
import com.semmle.js.ast.Expression;
import com.semmle.js.ast.Identifier;
import com.semmle.js.ast.Literal;
import com.semmle.js.ast.LogicalExpression;
import com.semmle.js.ast.MemberExpression;
import com.semmle.js.ast.MetaProperty;
import com.semmle.js.ast.ThisExpression;
import com.semmle.js.ast.UnaryExpression;
import com.semmle.js.ast.UpdateExpression;
import com.semmle.js.ast.XMLAnyName;
import com.semmle.js.ast.XMLAttributeSelector;
import com.semmle.js.ast.XMLDotDotExpression;
import com.semmle.js.ast.XMLFilterExpression;
import com.semmle.js.ast.XMLQualifiedIdentifier;
import com.semmle.js.ast.jsx.JSXIdentifier;
import com.semmle.js.ast.jsx.JSXMemberExpression;
import com.semmle.js.ast.jsx.JSXSpreadAttribute;
import com.semmle.js.ast.jsx.JSXThisExpr;
import com.semmle.js.extractor.ASTExtractor.IdContext;
import com.semmle.ts.ast.DecoratorList;
import com.semmle.ts.ast.ExpressionWithTypeArguments;
import com.semmle.ts.ast.TypeAssertion;
import com.semmle.util.exception.CatastrophicError;

/** Map from SpiderMonkey expression types to the numeric kinds used in the DB scheme. */
public class ExprKinds {
  private static final Map<String, Integer> binOpKinds = new LinkedHashMap<String, Integer>();

  static {
    binOpKinds.put("==", 23);
    binOpKinds.put("!=", 24);
    binOpKinds.put("===", 25);
    binOpKinds.put("!==", 26);
    binOpKinds.put("<", 27);
    binOpKinds.put("<=", 28);
    binOpKinds.put(">", 29);
    binOpKinds.put(">=", 30);
    binOpKinds.put("<<", 31);
    binOpKinds.put(">>", 32);
    binOpKinds.put(">>>", 33);
    binOpKinds.put("+", 34);
    binOpKinds.put("-", 35);
    binOpKinds.put("*", 36);
    binOpKinds.put("/", 37);
    binOpKinds.put("%", 38);
    binOpKinds.put("|", 39);
    binOpKinds.put("^", 40);
    binOpKinds.put("&", 41);
    binOpKinds.put("in", 42);
    binOpKinds.put("instanceof", 43);
    binOpKinds.put("&&", 44);
    binOpKinds.put("||", 45);
    binOpKinds.put("=", 47);
    binOpKinds.put("+=", 48);
    binOpKinds.put("-=", 49);
    binOpKinds.put("*=", 50);
    binOpKinds.put("/=", 51);
    binOpKinds.put("%=", 52);
    binOpKinds.put("<<=", 53);
    binOpKinds.put(">>=", 54);
    binOpKinds.put(">>>=", 55);
    binOpKinds.put("|=", 56);
    binOpKinds.put("^=", 57);
    binOpKinds.put("&=", 58);
    binOpKinds.put("**", 87);
    binOpKinds.put("**=", 88);
    binOpKinds.put("??", 107);
    binOpKinds.put("&&=", 116);
    binOpKinds.put("||=", 117);
    binOpKinds.put("??=", 118);
  }

  private static final Map<String, Integer> unOpKinds = new LinkedHashMap<String, Integer>();

  static {
    unOpKinds.put("-", 16);
    unOpKinds.put("+", 17);
    unOpKinds.put("!", 18);
    unOpKinds.put("~", 19);
    unOpKinds.put("typeof", 20);
    unOpKinds.put("void", 21);
    unOpKinds.put("delete", 22);
  }

  private static final Map<String, Integer> prefixOpKinds = new LinkedHashMap<String, Integer>();

  static {
    prefixOpKinds.put("++", 59);
    prefixOpKinds.put("--", 61);
  }

  private static final Map<String, Integer> postfixOpKinds = new LinkedHashMap<String, Integer>();

  static {
    postfixOpKinds.put("++", 60);
    postfixOpKinds.put("--", 62);
  }

  private static final Map<String, Integer> exprKinds = new LinkedHashMap<String, Integer>();

  static {
    exprKinds.put("ArrayExpression", 7);
    exprKinds.put("CallExpression", 13);
    exprKinds.put("ConditionalExpression", 11);
    exprKinds.put("FunctionExpression", 9);
    exprKinds.put("NewExpression", 12);
    exprKinds.put("ObjectExpression", 8);
    exprKinds.put("SequenceExpression", 10);
    exprKinds.put("ThisExpression", 6);
    exprKinds.put("ParenthesizedExpression", 63);
    exprKinds.put("VariableDeclarator", 64);
    exprKinds.put("ArrowFunctionExpression", 65);
    exprKinds.put("SpreadElement", 66);
    exprKinds.put("ArrayPattern", 67);
    exprKinds.put("ObjectPattern", 68);
    exprKinds.put("YieldExpression", 69);
    exprKinds.put("TaggedTemplateExpression", 70);
    exprKinds.put("TemplateLiteral", 71);
    exprKinds.put("TemplateElement", 72);
    exprKinds.put("LetExpression", 77);
    exprKinds.put("ClassExpression", 80);
    exprKinds.put("Super", 81);
    exprKinds.put("ImportSpecifier", 83);
    exprKinds.put("ImportDefaultSpecifier", 84);
    exprKinds.put("ImportNamespaceSpecifier", 85);
    exprKinds.put("ExportSpecifier", 86);
    exprKinds.put("JSXElement", 89);
    exprKinds.put("JSXNamespacedName", 90);
    exprKinds.put("JSXEmptyExpression", 91);
    exprKinds.put("AwaitExpression", 92);
    exprKinds.put("Decorator", 94);
    exprKinds.put("ExportDefaultSpecifier", 95);
    exprKinds.put("ExportNamespaceSpecifier", 96);
    exprKinds.put("BindExpression", 97);
    exprKinds.put("ExternalModuleReference", 98);
    exprKinds.put("NonNullAssertion", 105);
    exprKinds.put("AngularPipeRef", 119);
    exprKinds.put("GeneratedCodeExpr", 120);
  }

  private static final Map<IdContext, Integer> idKinds =
      new EnumMap<IdContext, Integer>(IdContext.class);

  static {
    idKinds.put(IdContext.LABEL, 0);
    idKinds.put(IdContext.VAR_DECL, 78);
    idKinds.put(IdContext.VAR_AND_TYPE_DECL, 78);
    idKinds.put(IdContext.NAMESPACE_DECL, 78);
    idKinds.put(IdContext.VAR_AND_NAMESPACE_DECL, 78);
    idKinds.put(IdContext.VAR_AND_TYPE_AND_NAMESPACE_DECL, 78);
    idKinds.put(IdContext.TYPE_ONLY_IMPORT, 78);
    idKinds.put(IdContext.TYPE_ONLY_EXPORT, 103);
    idKinds.put(IdContext.VAR_BIND, 79);
    idKinds.put(IdContext.EXPORT, 103);
    idKinds.put(IdContext.EXPORT_BASE, 103);
  }

  public static int getExprKind(final Expression expr, final IdContext idContext) {
    Integer kind =
        expr.accept(
            new DefaultVisitor<Void, Integer>() {
              @Override
              public Integer visit(Expression nd, Void q) {
                return exprKinds.get(nd.getType());
              }

              @Override
              public Integer visit(AssignmentExpression nd, Void q) {
                return binOpKinds.get(nd.getOperator());
              }

              @Override
              public Integer visit(BinaryExpression nd, Void q) {
                return binOpKinds.get(nd.getOperator());
              }

              @Override
              public Integer visit(Identifier nd, Void c) {
                return idKinds.get(idContext);
              }

              @Override
              public Integer visit(JSXIdentifier nd, Void c) {
                return visit((Identifier) nd, c);
              }

              @Override
              public Integer visit(JSXThisExpr nd, Void c) {
                return visit((ThisExpression) nd, c);
              }

              @Override
              public Integer visit(LogicalExpression nd, Void q) {
                return binOpKinds.get(nd.getOperator());
              }

              @Override
              public Integer visit(Literal nd, Void q) {
                TokenType tp = nd.getTokenType();

                if (tp == TokenType._null) return 1;
                if (tp == TokenType._true || tp == TokenType._false) return 2;
                if (tp == TokenType.num) return 3;
                if (tp == TokenType.string || tp == JSXParser.jsxText) return 4;
                if (tp == TokenType.regexp) return 5;
                if (tp == TokenType.bigint) return 106;

                throw new CatastrophicError("Unexpected literal with token type " + tp.label);
              }

              @Override
              public Integer visit(MemberExpression nd, Void q) {
                return nd.isComputed() ? 15 : 14;
              }

              @Override
              public Integer visit(JSXMemberExpression nd, Void c) {
                // treat JSX member expressions as dot expressions
                return 14;
              }

              @Override
              public Integer visit(JSXSpreadAttribute nd, Void c) {
                // treat JSX spread attributes as spread elements
                return exprKinds.get("SpreadElement");
              }

              @Override
              public Integer visit(UnaryExpression nd, Void q) {
                return unOpKinds.get(nd.getOperator());
              }

              @Override
              public Integer visit(UpdateExpression nd, Void q) {
                return nd.isPrefix()
                    ? prefixOpKinds.get(nd.getOperator())
                    : postfixOpKinds.get(nd.getOperator());
              }

              @Override
              public Integer visit(ComprehensionExpression nd, Void q) {
                return nd.isGenerator() ? 74 : 73;
              }

              @Override
              public Integer visit(ComprehensionBlock nd, Void q) {
                return nd.isOf() ? 76 : 75;
              }

              @Override
              public Integer visit(MetaProperty nd, Void c) {
                if (nd.getMeta().getName().equals("new")) return 82; // @newtarget_expr
                if (nd.getMeta().getName().equals("import")) return 115; // @import_meta_expr
                return 93; // @function_sent_expr
              }

              @Override
              public Integer visit(DynamicImport nd, Void c) {
                return 99;
              }

              @Override
              public Integer visit(ExpressionWithTypeArguments nd, Void c) {
                return 100;
              }

              @Override
              public Integer visit(TypeAssertion nd, Void c) {
                return nd.isAsExpression() ? 102 : 101;
              }

              @Override
              public Integer visit(DecoratorList nd, Void c) {
                return 104;
              }

              @Override
              public Integer visit(XMLAnyName nd, Void c) {
                return 108;
              }

              @Override
              public Integer visit(XMLAttributeSelector nd, Void c) {
                return nd.isComputed() ? 110 : 109;
              }

              @Override
              public Integer visit(XMLFilterExpression nd, Void c) {
                return 111;
              }

              @Override
              public Integer visit(XMLQualifiedIdentifier nd, Void c) {
                return nd.isComputed() ? 113 : 112;
              }

              @Override
              public Integer visit(XMLDotDotExpression nd, Void c) {
                return 114;
              }
            },
            null);
    if (kind == null)
      throw new CatastrophicError("Unsupported expression kind: " + expr.getClass());
    return kind;
  }
}
