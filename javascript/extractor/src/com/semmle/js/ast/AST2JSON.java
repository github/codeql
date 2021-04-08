package com.semmle.js.ast;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonNull;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
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
import com.semmle.ts.ast.ExportWholeDeclaration;
import com.semmle.ts.ast.ExternalModuleReference;
import com.semmle.ts.ast.ImportWholeDeclaration;
import com.semmle.ts.ast.InterfaceDeclaration;
import com.semmle.ts.ast.NamespaceDeclaration;
import com.semmle.util.data.StringUtil;
import java.util.List;

/** Convert ASTs to their JSON representation. */
public class AST2JSON extends DefaultVisitor<Void, JsonElement> {
  public static JsonElement convert(INode nd) {
    return new AST2JSON().visit(nd);
  }

  private JsonElement visit(INode nd) {
    if (nd == null) return JsonNull.INSTANCE;
    return nd.accept(this, null);
  }

  private JsonArray visit(List<? extends INode> nds) {
    JsonArray result = new JsonArray();
    nds.stream()
        .forEach(
            (nd) -> {
              result.add(visit(nd));
            });
    return result;
  }

  private JsonElement visitPrimitive(Object o) {
    if (o == null) return JsonNull.INSTANCE;
    if (o instanceof Boolean) return new JsonPrimitive((Boolean) o);
    if (o instanceof Number) return new JsonPrimitive((Number) o);
    return new JsonPrimitive(String.valueOf(o));
  }

  private JsonObject mkNode(INode nd) {
    String type = nd.getType();
    return mkNode(nd, type);
  }

  private JsonObject mkNode(INode nd, String type) {
    JsonObject result = new JsonObject();
    result.add("type", new JsonPrimitive(type));
    if (nd.getLoc() != null) result.add("loc", visit(nd.getLoc()));
    return result;
  }

  private JsonObject visit(SourceLocation loc) {
    JsonObject result = new JsonObject();
    result.add("start", visit(loc.getStart()));
    result.add("end", visit(loc.getEnd()));
    return result;
  }

  private JsonObject visit(Position pos) {
    JsonObject result = new JsonObject();
    result.add("line", visitPrimitive(pos.getLine()));
    result.add("column", visitPrimitive(pos.getColumn()));
    result.add("offset", visitPrimitive(pos.getOffset()));
    return result;
  }

  @Override
  public JsonElement visit(ArrayExpression nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("elements", visit(nd.getElements()));
    return result;
  }

  @Override
  public JsonElement visit(AssignmentExpression nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("operator", visitPrimitive(nd.getOperator()));
    result.add("left", visit(nd.getLeft()));
    result.add("right", visit(nd.getRight()));
    return result;
  }

  @Override
  public JsonElement visit(AssignmentPattern nd, Void q) {
    JsonObject result = this.mkNode(nd);
    result.add("left", visit(nd.getLeft()));
    result.add("right", visit(nd.getRight()));
    return result;
  }

  @Override
  public JsonElement visit(BinaryExpression nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("left", visit(nd.getLeft()));
    result.add("operator", visitPrimitive(nd.getOperator()));
    result.add("right", visit(nd.getRight()));
    return result;
  }

  @Override
  public JsonElement visit(BlockStatement nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("body", visit(nd.getBody()));
    return result;
  }

  @Override
  public JsonElement visit(BreakStatement nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("label", visit(nd.getLabel()));
    return result;
  }

  @Override
  public JsonElement visit(ContinueStatement nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("label", visit(nd.getLabel()));
    return result;
  }

  @Override
  public JsonElement visit(CallExpression nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("callee", visit(nd.getCallee()));
    result.add("arguments", visit(nd.getArguments()));
    result.add("optional", new JsonPrimitive(nd.isOptional()));
    return result;
  }

  @Override
  public JsonElement visit(CatchClause nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("param", visit(nd.getParam()));
    result.add("body", visit(nd.getBody()));
    return result;
  }

  @Override
  public JsonElement visit(ClassBody nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("body", visit(nd.getBody()));
    return result;
  }

  @Override
  public JsonElement visit(ClassDeclaration nd, Void c) {
    JsonObject result = this.mkNode(nd);
    visit(nd.getClassDef(), result);
    return result;
  }

  @Override
  public JsonElement visit(ClassExpression nd, Void c) {
    JsonObject result = this.mkNode(nd);
    visit(nd.getClassDef(), result);
    return result;
  }

  private void visit(AClass classDef, JsonObject result) {
    result.add("id", visit(classDef.getId()));
    result.add("superClass", visit(classDef.getSuperClass()));
    result.add("body", visit(classDef.getBody()));
    if (!classDef.getDecorators().isEmpty())
      result.add("decorators", visit(classDef.getDecorators()));
  }

  @Override
  public JsonElement visit(ComprehensionBlock nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("left", visit(nd.getLeft()));
    result.add("right", visit(nd.getRight()));
    result.add("each", visitPrimitive(nd.isOf()));
    return result;
  }

  @Override
  public JsonElement visit(ComprehensionExpression nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("body", visit(nd.getBody()));
    result.add("blocks", visit(nd.getBlocks()));
    result.add("filter", visit(nd.getFilter()));
    return result;
  }

  @Override
  public JsonElement visit(ConditionalExpression nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("test", visit(nd.getTest()));
    result.add("consequent", visit(nd.getConsequent()));
    result.add("alternate", visit(nd.getAlternate()));
    return result;
  }

  @Override
  public JsonElement visit(DoWhileStatement nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("body", visit(nd.getBody()));
    result.add("test", visit(nd.getTest()));
    return result;
  }

  @Override
  public JsonElement visit(EmptyStatement nd, Void c) {
    return this.mkNode(nd);
  }

  @Override
  public JsonElement visit(ExportNamedDeclaration nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("declaration", visit(nd.getDeclaration()));
    result.add("specifiers", visit(nd.getSpecifiers()));
    result.add("source", visit(nd.getSource()));
    return result;
  }

  @Override
  public JsonElement visit(ExportSpecifier nd, Void c) {
    JsonObject result = this.mkNode(nd);
    if (nd.getLocal() != null) result.add("local", visit(nd.getLocal()));
    result.add("exported", visit(nd.getExported()));
    return result;
  }

  @Override
  public JsonElement visit(ExpressionStatement nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("expression", visit(nd.getExpression()));
    return result;
  }

  @Override
  public JsonElement visit(EnhancedForStatement nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("left", visit(nd.getLeft()));
    result.add("right", visit(nd.getRight()));
    result.add("body", visit(nd.getBody()));
    return result;
  }

  @Override
  public JsonElement visit(ForStatement nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("init", visit(nd.getInit()));
    result.add("test", visit(nd.getTest()));
    result.add("update", visit(nd.getUpdate()));
    result.add("body", visit(nd.getBody()));
    return result;
  }

  @Override
  public JsonElement visit(IFunction nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("id", visit(nd.getId()));
    result.add("generator", new JsonPrimitive(nd.isGenerator()));
    result.add("expression", new JsonPrimitive(nd.getBody() instanceof Expression));
    result.add("async", new JsonPrimitive(nd.isAsync()));
    result.add("params", visit(nd.getRawParameters()));
    result.add("body", visit(nd.getBody()));
    return result;
  }

  @Override
  public JsonElement visit(Identifier nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("name", new JsonPrimitive(nd.getName()));
    return result;
  }

  @Override
  public JsonElement visit(IfStatement nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("test", visit(nd.getTest()));
    result.add("consequent", visit(nd.getConsequent()));
    result.add("alternate", visit(nd.getAlternate()));
    return result;
  }

  @Override
  public JsonElement visit(ImportDeclaration nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("specifiers", visit(nd.getSpecifiers()));
    result.add("source", visit(nd.getSource()));
    return result;
  }

  @Override
  public JsonElement visit(ImportSpecifier nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("imported", visit(nd.getImported()));
    result.add("local", visit(nd.getLocal()));
    return result;
  }

  @Override
  public JsonElement visit(ImportNamespaceSpecifier nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("local", visit(nd.getLocal()));
    return result;
  }

  @Override
  public JsonElement visit(LabeledStatement nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("body", visit(nd.getBody()));
    result.add("label", visit(nd.getLabel()));
    return result;
  }

  @Override
  public JsonElement visit(Literal nd, Void c) {
    JsonObject result = this.mkNode(nd);
    if (nd.isRegExp()) result.add("value", new JsonObject());
    else result.add("value", visitPrimitive(nd.getValue()));
    result.add("raw", new JsonPrimitive(nd.getRaw()));
    return result;
  }

  @Override
  public JsonElement visit(LogicalExpression nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("left", visit(nd.getLeft()));
    result.add("operator", visitPrimitive(nd.getOperator()));
    result.add("right", visit(nd.getRight()));
    return result;
  }

  @Override
  public JsonElement visit(MemberExpression nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("object", visit(nd.getObject()));
    result.add("property", visit(nd.getProperty()));
    result.add("computed", new JsonPrimitive(nd.isComputed()));
    result.add("optional", new JsonPrimitive(nd.isOptional()));
    return result;
  }

  @Override
  public JsonElement visit(MemberDefinition<?> nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("computed", visitPrimitive(nd.isComputed()));
    result.add("key", visit(nd.getKey()));
    result.add("static", visitPrimitive(nd.isStatic()));
    result.add("value", visit(nd.getValue()));
    if (!nd.getDecorators().isEmpty()) result.add("decorators", visit(nd.getDecorators()));
    return result;
  }

  @Override
  public JsonElement visit(MethodDefinition nd, Void c) {
    JsonObject result = (JsonObject) super.visit(nd, c);
    result.add("kind", visitPrimitive(StringUtil.lc(nd.getKind().toString())));
    return result;
  }

  @Override
  public JsonElement visit(NewExpression nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("callee", visit(nd.getCallee()));
    result.add("arguments", visit(nd.getArguments()));
    return result;
  }

  @Override
  public JsonObject visit(Node nd, Void c) {
    throw new UnsupportedOperationException(nd.getType());
  }

  @Override
  public JsonElement visit(ObjectExpression nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("properties", visit(nd.getProperties()));
    return result;
  }

  @Override
  public JsonElement visit(ObjectPattern nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("properties", visit(nd.getRawProperties()));
    return result;
  }

  @Override
  public JsonElement visit(ParenthesizedExpression nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("expression", visit(nd.getExpression()));
    return result;
  }

  @Override
  public JsonElement visit(Program nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("body", visit(nd.getBody()));
    result.add("sourceType", visitPrimitive(nd.getSourceType()));
    return result;
  }

  @Override
  public JsonElement visit(Property nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("method", new JsonPrimitive(nd.isMethod()));
    result.add("shorthand", new JsonPrimitive(nd.isShorthand()));
    result.add("computed", new JsonPrimitive(nd.isComputed()));
    result.add("key", visit(nd.getKey()));
    result.add("kind", new JsonPrimitive(StringUtil.lc(nd.getKind().name())));
    result.add("value", visit(nd.getRawValue()));
    if (!nd.getDecorators().isEmpty()) result.add("decorators", visit(nd.getDecorators()));
    return result;
  }

  @Override
  public JsonElement visit(RestElement nd, Void q) {
    JsonObject result = this.mkNode(nd);
    result.add("argument", visit(nd.getArgument()));
    return result;
  }

  @Override
  public JsonElement visit(ReturnStatement nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("argument", visit(nd.getArgument()));
    return result;
  }

  @Override
  public JsonElement visit(SequenceExpression nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("expressions", visit(nd.getExpressions()));
    return result;
  }

  @Override
  public JsonElement visit(SwitchCase nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("consequent", visit(nd.getConsequent()));
    result.add("test", visit(nd.getTest()));
    return result;
  }

  @Override
  public JsonElement visit(SwitchStatement nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("discriminant", visit(nd.getDiscriminant()));
    result.add("cases", visit(nd.getCases()));
    return result;
  }

  @Override
  public JsonElement visit(ThisExpression nd, Void c) {
    return this.mkNode(nd);
  }

  @Override
  public JsonElement visit(ThrowStatement nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("argument", visit(nd.getArgument()));
    return result;
  }

  @Override
  public JsonElement visit(TryStatement nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("block", visit(nd.getBlock()));
    result.add("handler", visit(nd.getHandler()));
    result.add("finalizer", visit(nd.getFinalizer()));
    return result;
  }

  @Override
  public JsonElement visit(UnaryExpression nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("operator", visitPrimitive(nd.getOperator()));
    result.add("prefix", new JsonPrimitive(nd.isPrefix()));
    result.add("argument", visit(nd.getArgument()));
    return result;
  }

  @Override
  public JsonElement visit(UpdateExpression nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("operator", visitPrimitive(nd.getOperator()));
    result.add("prefix", new JsonPrimitive(nd.isPrefix()));
    result.add("argument", visit(nd.getArgument()));
    return result;
  }

  @Override
  public JsonElement visit(VariableDeclaration nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("declarations", visit(nd.getDeclarations()));
    result.add("kind", new JsonPrimitive(nd.getKind()));
    return result;
  }

  @Override
  public JsonElement visit(VariableDeclarator nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("id", visit(nd.getId()));
    result.add("init", visit(nd.getInit()));
    return result;
  }

  @Override
  public JsonElement visit(WhileStatement nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("test", visit(nd.getTest()));
    result.add("body", visit(nd.getBody()));
    return result;
  }

  @Override
  public JsonElement visit(ArrayPattern nd, Void q) {
    JsonObject result = this.mkNode(nd);
    result.add("elements", visit(nd.getRawElements()));
    return result;
  }

  @Override
  public JsonElement visit(WithStatement nd, Void q) {
    JsonObject result = this.mkNode(nd);
    result.add("object", visit(nd.getObject()));
    result.add("body", visit(nd.getBody()));
    return result;
  }

  @Override
  public JsonElement visit(SpreadElement nd, Void q) {
    JsonObject result = this.mkNode(nd);
    result.add("argument", visit(nd.getArgument()));
    return result;
  }

  @Override
  public JsonElement visit(YieldExpression nd, Void q) {
    JsonObject result = this.mkNode(nd);
    result.add("argument", visit(nd.getArgument()));
    result.add("delegate", visitPrimitive(nd.isDelegating()));
    return result;
  }

  @Override
  public JsonElement visit(DebuggerStatement nd, Void q) {
    JsonObject result = this.mkNode(nd);
    return result;
  }

  @Override
  public JsonElement visit(TemplateElement nd, Void q) {
    JsonObject result = this.mkNode(nd);
    JsonObject value = new JsonObject();
    value.add("cooked", visitPrimitive(nd.getCooked()));
    value.add("raw", visitPrimitive(nd.getRaw()));
    result.add("value", value);
    result.add("tail", visitPrimitive(nd.isTail()));
    return result;
  }

  @Override
  public JsonElement visit(TemplateLiteral nd, Void q) {
    JsonObject result = this.mkNode(nd);
    result.add("quasis", visit(nd.getQuasis()));
    result.add("expressions", visit(nd.getExpressions()));
    return result;
  }

  @Override
  public JsonElement visit(TaggedTemplateExpression nd, Void q) {
    JsonObject result = this.mkNode(nd);
    result.add("tag", visit(nd.getTag()));
    result.add("quasi", visit(nd.getQuasi()));
    return result;
  }

  @Override
  public JsonElement visit(LetStatement nd, Void q) {
    JsonObject result = this.mkNode(nd);
    result.add("head", visit(nd.getHead()));
    result.add("body", visit(nd.getBody()));
    return result;
  }

  @Override
  public JsonElement visit(LetExpression nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("head", visit(nd.getHead()));
    result.add("body", visit(nd.getBody()));
    return result;
  }

  @Override
  public JsonElement visit(Super nd, Void c) {
    JsonObject result = this.mkNode(nd);
    return result;
  }

  @Override
  public JsonElement visit(MetaProperty nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("meta", visit(nd.getMeta()));
    result.add("property", visit(nd.getProperty()));
    return result;
  }

  @Override
  public JsonElement visit(ExportAllDeclaration nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("source", visit(nd.getSource()));
    return result;
  }

  @Override
  public JsonElement visit(ExportDefaultDeclaration nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("declaration", visit(nd.getDeclaration()));
    return result;
  }

  @Override
  public JsonElement visit(JSXIdentifier nd, Void c) {
    JsonObject result = this.mkNode(nd, "JSXIdentifier");
    result.add("name", visitPrimitive(nd.getName()));
    return result;
  }

  @Override
  public JsonElement visit(JSXThisExpr nd, Void c) {
    return this.mkNode(nd, "JSXThisExpr");
  }

  @Override
  public JsonElement visit(JSXMemberExpression nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("object", visit(nd.getObject()));
    result.add("property", visit(nd.getName()));
    return result;
  }

  @Override
  public JsonElement visit(JSXNamespacedName nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("namespace", visit(nd.getNamespace()));
    result.add("name", visit(nd.getName()));
    return result;
  }

  @Override
  public JsonElement visit(JSXEmptyExpression nd, Void c) {
    JsonObject result = this.mkNode(nd);
    return result;
  }

  @Override
  public JsonElement visit(JSXExpressionContainer nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("expression", visit(nd.getExpression()));
    return result;
  }

  @Override
  public JsonElement visit(JSXOpeningElement nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("name", visit(nd.getName()));
    result.add("attributes", visit(nd.getAttributes()));
    result.add("selfClosing", visitPrimitive(nd.isSelfClosing()));
    return result;
  }

  @Override
  public JsonElement visit(JSXClosingElement nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("name", visit(nd.getName()));
    return result;
  }

  @Override
  public JsonElement visit(JSXAttribute nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("name", visit(nd.getName()));
    result.add("value", visit(nd.getValue()));
    return result;
  }

  @Override
  public JsonElement visit(JSXSpreadAttribute nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("argument", visit(nd.getArgument()));
    return result;
  }

  @Override
  public JsonElement visit(JSXElement nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("openingElement", visit(nd.getOpeningElement()));
    result.add("children", visit(nd.getChildren()));
    result.add("closingElement", visit(nd.getClosingElement()));
    return result;
  }

  @Override
  public JsonElement visit(AwaitExpression nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("argument", visit(nd.getArgument()));
    return result;
  }

  @Override
  public JsonElement visit(Decorator nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("expression", visit(nd.getExpression()));
    return result;
  }

  @Override
  public JsonElement visit(BindExpression nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("object", visit(nd.getObject()));
    result.add("callee", visit(nd.getCallee()));
    return result;
  }

  @Override
  public JsonElement visit(NamespaceDeclaration nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("name", visit(nd.getName()));
    result.add("body", visit(nd.getBody()));
    return result;
  }

  @Override
  public JsonElement visit(ImportWholeDeclaration nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("name", visit(nd.getLhs()));
    result.add("moduleReference", visit(nd.getRhs()));
    return result;
  }

  @Override
  public JsonElement visit(ExportWholeDeclaration nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("expression", visit(nd.getRhs()));
    return result;
  }

  @Override
  public JsonElement visit(ExternalModuleReference nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("expression", visit(nd.getExpression()));
    return result;
  }

  @Override
  public JsonElement visit(DynamicImport nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("source", visit(nd.getSource()));
    return result;
  }

  @Override
  public JsonElement visit(InterfaceDeclaration nd, Void c) {
    JsonObject result = this.mkNode(nd);
    result.add("body", visit(nd.getBody()));
    return result;
  }
}
