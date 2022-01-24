package com.semmle.ts.extractor;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonNull;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import com.semmle.jcorn.TokenType;
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
import com.semmle.js.ast.Comment;
import com.semmle.js.ast.ConditionalExpression;
import com.semmle.js.ast.ContinueStatement;
import com.semmle.js.ast.DebuggerStatement;
import com.semmle.js.ast.DeclarationFlags;
import com.semmle.js.ast.Decorator;
import com.semmle.js.ast.DoWhileStatement;
import com.semmle.js.ast.DynamicImport;
import com.semmle.js.ast.EmptyStatement;
import com.semmle.js.ast.ExportAllDeclaration;
import com.semmle.js.ast.ExportDeclaration;
import com.semmle.js.ast.ExportDefaultDeclaration;
import com.semmle.js.ast.ExportNamedDeclaration;
import com.semmle.js.ast.ExportNamespaceSpecifier;
import com.semmle.js.ast.ExportSpecifier;
import com.semmle.js.ast.Expression;
import com.semmle.js.ast.ExpressionStatement;
import com.semmle.js.ast.FieldDefinition;
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
import com.semmle.js.ast.ImportDeclaration;
import com.semmle.js.ast.ImportDefaultSpecifier;
import com.semmle.js.ast.ImportNamespaceSpecifier;
import com.semmle.js.ast.ImportSpecifier;
import com.semmle.js.ast.InvokeExpression;
import com.semmle.js.ast.LabeledStatement;
import com.semmle.js.ast.Literal;
import com.semmle.js.ast.LogicalExpression;
import com.semmle.js.ast.MemberDefinition;
import com.semmle.js.ast.MemberExpression;
import com.semmle.js.ast.MetaProperty;
import com.semmle.js.ast.MethodDefinition;
import com.semmle.js.ast.MethodDefinition.Kind;
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
import com.semmle.js.ast.StaticInitializer;
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
import com.semmle.js.ast.jsx.IJSXAttribute;
import com.semmle.js.ast.jsx.IJSXName;
import com.semmle.js.ast.jsx.JSXAttribute;
import com.semmle.js.ast.jsx.JSXClosingElement;
import com.semmle.js.ast.jsx.JSXElement;
import com.semmle.js.ast.jsx.JSXEmptyExpression;
import com.semmle.js.ast.jsx.JSXExpressionContainer;
import com.semmle.js.ast.jsx.JSXIdentifier;
import com.semmle.js.ast.jsx.JSXMemberExpression;
import com.semmle.js.ast.jsx.JSXOpeningElement;
import com.semmle.js.ast.jsx.JSXSpreadAttribute;
import com.semmle.js.ast.jsx.JSXThisExpr;
import com.semmle.js.parser.JSParser.Result;
import com.semmle.js.parser.ParseError;
import com.semmle.ts.ast.ArrayTypeExpr;
import com.semmle.ts.ast.ConditionalTypeExpr;
import com.semmle.ts.ast.DecoratorList;
import com.semmle.ts.ast.EnumDeclaration;
import com.semmle.ts.ast.EnumMember;
import com.semmle.ts.ast.ExportAsNamespaceDeclaration;
import com.semmle.ts.ast.ExportWholeDeclaration;
import com.semmle.ts.ast.ExpressionWithTypeArguments;
import com.semmle.ts.ast.ExternalModuleDeclaration;
import com.semmle.ts.ast.ExternalModuleReference;
import com.semmle.ts.ast.FunctionTypeExpr;
import com.semmle.ts.ast.GenericTypeExpr;
import com.semmle.ts.ast.GlobalAugmentationDeclaration;
import com.semmle.ts.ast.INodeWithSymbol;
import com.semmle.ts.ast.ITypeExpression;
import com.semmle.ts.ast.ITypedAstNode;
import com.semmle.ts.ast.ImportTypeExpr;
import com.semmle.ts.ast.ImportWholeDeclaration;
import com.semmle.ts.ast.IndexedAccessTypeExpr;
import com.semmle.ts.ast.InferTypeExpr;
import com.semmle.ts.ast.InterfaceDeclaration;
import com.semmle.ts.ast.InterfaceTypeExpr;
import com.semmle.ts.ast.IntersectionTypeExpr;
import com.semmle.ts.ast.KeywordTypeExpr;
import com.semmle.ts.ast.MappedTypeExpr;
import com.semmle.ts.ast.NamespaceDeclaration;
import com.semmle.ts.ast.NonNullAssertion;
import com.semmle.ts.ast.OptionalTypeExpr;
import com.semmle.ts.ast.ParenthesizedTypeExpr;
import com.semmle.ts.ast.PredicateTypeExpr;
import com.semmle.ts.ast.RestTypeExpr;
import com.semmle.ts.ast.TemplateLiteralTypeExpr;
import com.semmle.ts.ast.TupleTypeExpr;
import com.semmle.ts.ast.TypeAliasDeclaration;
import com.semmle.ts.ast.TypeAssertion;
import com.semmle.ts.ast.TypeParameter;
import com.semmle.ts.ast.TypeofTypeExpr;
import com.semmle.ts.ast.UnaryTypeExpr;
import com.semmle.ts.ast.UnionTypeExpr;
import com.semmle.util.collections.CollectionUtil;
import com.semmle.util.data.IntList;

/**
 * Utility class for converting a <a
 * href="https://github.com/Microsoft/TypeScript/wiki/Using-the-Compiler-API">TypeScript AST
 * node</a> into a {@link Result}.
 *
 * <p>TypeScript AST nodes that have no JavaScript equivalent are omitted.
 */
public class TypeScriptASTConverter {
  private String source;
  private final TypeScriptParserMetadata metadata;
  private int[] lineStarts;

  private int syntaxKindExtends;

  private static final Pattern LINE_TERMINATOR = Pattern.compile("\\n|\\r\\n|\\r|\\u2028|\\u2029");
  private static final String WHITESPACE_CHAR = "(?:\\s|//.*|/\\*(?:[^*]|\\*(?!/))*\\*/)";
  private static final Pattern WHITESPACE = Pattern.compile("^" + WHITESPACE_CHAR + "*");
  private static final Pattern EXPORT_DECL_START =
      Pattern.compile("^export" + "(" + WHITESPACE_CHAR + "+default)?" + WHITESPACE_CHAR + "+");
  private static final Pattern TYPEOF_START = Pattern.compile("^typeof" + WHITESPACE_CHAR + "+");
  private static final Pattern WHITESPACE_END_PAREN =
      Pattern.compile("^" + WHITESPACE_CHAR + "*\\)");

  TypeScriptASTConverter(TypeScriptParserMetadata metadata) {
    this.metadata = metadata;
    this.syntaxKindExtends = metadata.getSyntaxKindId("ExtendsKeyword");
  }

  /**
   * Convert the given TypeScript AST (which was parsed from {@code source}) into a parser {@link
   * Result}.
   */
  public Result convertAST(JsonObject ast, String source) {
    this.lineStarts = toIntArray(ast.getAsJsonArray("$lineStarts"));

    List<ParseError> errors = new ArrayList<ParseError>();

    // process parse diagnostics (i.e., syntax errors) reported by the TypeScript compiler
    JsonArray parseDiagnostics = ast.get("parseDiagnostics").getAsJsonArray();
    if (parseDiagnostics.size() > 0) {
      for (JsonElement elt : parseDiagnostics) {
        JsonObject parseDiagnostic = elt.getAsJsonObject();
        String message = parseDiagnostic.get("messageText").getAsString();
        Position pos = getPosition(parseDiagnostic.get("$pos"));
        errors.add(new ParseError(message, pos.getLine(), pos.getColumn(), pos.getOffset()));
      }
      return new Result(source, null, new ArrayList<>(), new ArrayList<>(), errors);
    }

    this.source = source;

    List<Token> tokens = new ArrayList<>();
    List<Comment> comments = new ArrayList<>();
    extractTokensAndComments(ast, tokens, comments);
    Node converted;
    try {
      converted = convertNode(ast);
    } catch (ParseError e) {
      converted = null;
      errors.add(e);
    }
    return new Result(source, converted, tokens, comments, errors);
  }

  /** Converts a JSON array to an int array. The array is assumed to only contain integers. */
  private static int[] toIntArray(JsonArray array) {
    int[] result = new int[array.size()];
    for (int i = 0; i < array.size(); ++i) {
      result[i] = array.get(i).getAsInt();
    }
    return result;
  }

  private int getLineFromPos(int pos) {
    int low = 0, high = this.lineStarts.length - 1;
    while (low < high) {
      int mid = high - ((high - low) >> 1); // Get middle, rounding up.
      int startOfLine = lineStarts[mid];
      if (startOfLine <= pos) {
        low = mid;
      } else {
        high = mid - 1;
      }
    }
    return low;
  }

  private int getColumnFromLinePos(int line, int pos) {
    return pos - lineStarts[line];
  }

  /** Extract tokens and comments from the given TypeScript AST. */
  private void extractTokensAndComments(
      JsonObject ast, List<Token> tokens, List<Comment> comments) {
    for (JsonElement elt : ast.get("$tokens").getAsJsonArray()) {
      JsonObject token = elt.getAsJsonObject();
      String text = token.get("text").getAsString();
      Position start = getPosition(token.get("tokenPos"));
      Position end = advance(start, text);
      SourceLocation loc = new SourceLocation(text, start, end);
      String kind = getKind(token);
      switch (kind) {
        case "EndOfFileToken":
          tokens.add(new Token(loc, Token.Type.EOF));
          break;
        case "SingleLineCommentTrivia":
        case "MultiLineCommentTrivia":
          String cookedText;
          if (text.startsWith("//")) cookedText = text.substring(2);
          else cookedText = text.substring(2, text.length() - 2);
          comments.add(new Comment(loc, cookedText));
          break;
        case "TemplateHead":
        case "TemplateMiddle":
        case "TemplateTail":
        case "NoSubstitutionTemplateLiteral":
          tokens.add(new Token(loc, Token.Type.STRING));
          break;
        case "Identifier":
          tokens.add(new Token(loc, Token.Type.NAME));
          break;
        case "NumericLiteral":
          tokens.add(new Token(loc, Token.Type.NUM));
          break;
        case "StringLiteral":
          tokens.add(new Token(loc, Token.Type.STRING));
          break;
        case "RegularExpressionLiteral":
          tokens.add(new Token(loc, Token.Type.REGEXP));
          break;
        default:
          Token.Type tp;
          if (kind.endsWith("Token")) {
            tp = Token.Type.PUNCTUATOR;
          } else if (kind.endsWith("Keyword")) {
            if (text.equals("null")) tp = Token.Type.NULL;
            else if (text.equals("true")) tp = Token.Type.TRUE;
            else if (text.equals("false")) tp = Token.Type.FALSE;
            else tp = Token.Type.KEYWORD;
          } else {
            continue;
          }
          tokens.add(new Token(loc, tp));
      }
    }
  }

  /** Convert the given TypeScript node and its children into a JavaScript {@link Node}. */
  private Node convertNode(JsonObject node) throws ParseError {
    return convertNode(node, null);
  }

  /**
   * Convert the given TypeScript node and its children into a JavaScript {@link Node}. If the
   * TypesScript node has no explicit {@code kind}, it is assumed to be {@code defaultKind}.
   */
  private Node convertNode(JsonObject node, String defaultKind) throws ParseError {
    Node astNode = convertNodeUntyped(node, defaultKind);
    attachStaticType(astNode, node);
    return astNode;
  }

  /** Helper method for `convertNode` that does everything except attaching type information. */
  private Node convertNodeUntyped(JsonObject node, String defaultKind) throws ParseError {
    String kind = getKind(node);
    if (kind == null) kind = defaultKind;
    if (kind == null) {
      // Identifiers and PrivateIdentifiers do not have a "kind" property like other nodes.
      // Since we encode identifiers and private identifiers the same, default to Identifier.
      kind = "Identifier";
    }
    SourceLocation loc = getSourceLocation(node);
    switch (kind) {
      case "AnyKeyword":
        return convertKeywordTypeExpr(node, loc, "any");
      case "ArrayBindingPattern":
        return convertArrayBindingPattern(node, loc);
      case "ArrayLiteralExpression":
        return convertArrayLiteralExpression(node, loc);
      case "ArrayType":
        return convertArrayType(node, loc);
      case "ArrowFunction":
        return convertArrowFunction(node, loc);
      case "AsExpression":
        return convertTypeAssertionExpression(node, loc);
      case "AwaitExpression":
        return convertAwaitExpression(node, loc);
      case "BigIntKeyword":
        return convertKeywordTypeExpr(node, loc, "bigint");
      case "BigIntLiteral":
        return convertBigIntLiteral(node, loc);
      case "BinaryExpression":
        return convertBinaryExpression(node, loc);
      case "Block":
        return convertBlock(node, loc);
      case "BooleanKeyword":
        return convertKeywordTypeExpr(node, loc, "boolean");
      case "BreakStatement":
        return convertBreakStatement(node, loc);
      case "CallExpression":
        return convertCallExpression(node, loc);
      case "CallSignature":
        return convertCallSignature(node, loc);
      case "CaseClause":
        return convertCaseClause(node, loc);
      case "CatchClause":
        return convertCatchClause(node, loc);
      case "ClassDeclaration":
      case "ClassExpression":
        return convertClass(node, kind, loc);
      case "CommaListExpression":
        return convertCommaListExpression(node, loc);
      case "ComputedPropertyName":
        return convertComputedPropertyName(node);
      case "ConditionalExpression":
        return convertConditionalExpression(node, loc);
      case "ConditionalType":
        return convertConditionalType(node, loc);
      case "Constructor":
        return convertConstructor(node, loc);
      case "ConstructSignature":
        return convertConstructSignature(node, loc);
      case "ConstructorType":
        return convertConstructorType(node, loc);
      case "ContinueStatement":
        return convertContinueStatement(node, loc);
      case "DebuggerStatement":
        return convertDebuggerStatement(loc);
      case "Decorator":
        return convertDecorator(node, loc);
      case "DefaultClause":
        return convertCaseClause(node, loc);
      case "DeleteExpression":
        return convertDeleteExpression(node, loc);
      case "DoStatement":
        return convertDoStatement(node, loc);
      case "ElementAccessExpression":
        return convertElementAccessExpression(node, loc);
      case "EmptyStatement":
        return convertEmptyStatement(loc);
      case "EnumDeclaration":
        return convertEnumDeclaration(node, loc);
      case "EnumMember":
        return convertEnumMember(node, loc);
      case "ExportAssignment":
        return convertExportAssignment(node, loc);
      case "ExportDeclaration":
        return convertExportDeclaration(node, loc);
      case "ExportSpecifier":
        return convertExportSpecifier(node, loc);
      case "ExpressionStatement":
        return convertExpressionStatement(node, loc);
      case "ExpressionWithTypeArguments":
        return convertExpressionWithTypeArguments(node, loc);
      case "ExternalModuleReference":
        return convertExternalModuleReference(node, loc);
      case "FalseKeyword":
        return convertFalseKeyword(loc);
      case "NeverKeyword":
        return convertKeywordTypeExpr(node, loc, "never");
      case "NumberKeyword":
        return convertKeywordTypeExpr(node, loc, "number");
      case "NumericLiteral":
        return convertNumericLiteral(node, loc);
      case "ForStatement":
        return convertForStatement(node, loc);
      case "ForInStatement":
        return convertForInStatement(node, loc);
      case "ForOfStatement":
        return convertForOfStatement(node, loc);
      case "FunctionDeclaration":
        return convertFunctionDeclaration(node, loc);
      case "FunctionExpression":
        return convertFunctionExpression(node, loc);
      case "FunctionType":
        return convertFunctionType(node, loc);
      case "Identifier":
      case "PrivateIdentifier":
        return convertIdentifier(node, loc);
      case "IfStatement":
        return convertIfStatement(node, loc);
      case "ImportClause":
        return convertImportClause(node, loc);
      case "ImportDeclaration":
        return convertImportDeclaration(node, loc);
      case "ImportEqualsDeclaration":
        return convertImportEqualsDeclaration(node, loc);
      case "ImportKeyword":
        return convertImportKeyword(loc);
      case "ImportSpecifier":
        return convertImportSpecifier(node, loc);
      case "ImportType":
        return convertImportType(node, loc);
      case "IndexSignature":
        return convertIndexSignature(node, loc);
      case "IndexedAccessType":
        return convertIndexedAccessType(node, loc);
      case "InferType":
        return convertInferType(node, loc);
      case "InterfaceDeclaration":
        return convertInterfaceDeclaration(node, loc);
      case "IntersectionType":
        return convertIntersectionType(node, loc);
      case "JsxAttribute":
        return convertJsxAttribute(node, loc);
      case "JsxClosingElement":
        return convertJsxClosingElement(node, loc);
      case "JsxElement":
        return convertJsxElement(node, loc);
      case "JsxExpression":
        return convertJsxExpression(node, loc);
      case "JsxFragment":
        return convertJsxFragment(node, loc);
      case "JsxOpeningElement":
        return convertJsxOpeningElement(node, loc);
      case "JsxOpeningFragment":
        return convertJsxOpeningFragment(node, loc);
      case "JsxSelfClosingElement":
        return convertJsxSelfClosingElement(node, loc);
      case "JsxClosingFragment":
        return convertJsxClosingFragment(node, loc);
      case "JsxSpreadAttribute":
        return convertJsxSpreadAttribute(node, loc);
      case "JsxText":
      case "JsxTextAllWhiteSpaces":
        return convertJsxText(node, loc);
      case "LabeledStatement":
        return convertLabeledStatement(node, loc);
      case "LiteralType":
        return convertLiteralType(node, loc);
      case "MappedType":
        return convertMappedType(node, loc);
      case "MetaProperty":
        return convertMetaProperty(node, loc);
      case "GetAccessor":
      case "SetAccessor":
      case "MethodDeclaration":
      case "MethodSignature":
        return convertMethodDeclaration(node, kind, loc);
      case "ModuleDeclaration":
      case "NamespaceDeclaration":
        return convertNamespaceDeclaration(node, loc);
      case "ModuleBlock":
        return convertModuleBlock(node, loc);
      case "NamespaceExport":
        return convertNamespaceExport(node, loc);
      case "NamespaceExportDeclaration":
        return convertNamespaceExportDeclaration(node, loc);
      case "NamespaceImport":
        return convertNamespaceImport(node, loc);
      case "NewExpression":
        return convertNewExpression(node, loc);
      case "NonNullExpression":
        return convertNonNullExpression(node, loc);
      case "NoSubstitutionTemplateLiteral":
        return convertNoSubstitutionTemplateLiteral(node, loc);
      case "NullKeyword":
        return convertNullKeyword(loc);
      case "ObjectBindingPattern":
        return convertObjectBindingPattern(node, loc);
      case "ObjectKeyword":
        return convertKeywordTypeExpr(node, loc, "object");
      case "ObjectLiteralExpression":
        return convertObjectLiteralExpression(node, loc);
      case "OmittedExpression":
        return convertOmittedExpression();
      case "OptionalType":
        return convertOptionalType(node, loc);
      case "Parameter":
        return convertParameter(node, loc);
      case "ParenthesizedExpression":
        return convertParenthesizedExpression(node, loc);
      case "ParenthesizedType":
        return convertParenthesizedType(node, loc);
      case "PostfixUnaryExpression":
        return convertPostfixUnaryExpression(node, loc);
      case "PrefixUnaryExpression":
        return convertPrefixUnaryExpression(node, loc);
      case "PropertyAccessExpression":
        return convertPropertyAccessExpression(node, loc);
      case "PropertyAssignment":
        return convertPropertyAssignment(node, loc);
      case "PropertyDeclaration":
      case "PropertySignature":
        return convertPropertyDeclaration(node, kind, loc);
      case "RegularExpressionLiteral":
        return convertRegularExpressionLiteral(loc);
      case "RestType":
        return convertRestType(node, loc);
      case "QualifiedName":
        return convertQualifiedName(node, loc);
      case "ReturnStatement":
        return convertReturnStatement(node, loc);
      case "SemicolonClassElement":
        return convertSemicolonClassElement();
      case "SourceFile":
        return convertSourceFile(node, loc);
      case "ShorthandPropertyAssignment":
        return convertShorthandPropertyAssignment(node, loc);
      case "SpreadAssignment":
      case "SpreadElement":
      case "SpreadElementExpression":
        return convertSpreadElement(node, loc);
      case "StringKeyword":
        return convertKeywordTypeExpr(node, loc, "string");
      case "StringLiteral":
        return convertStringLiteral(node, loc);
      case "SuperKeyword":
        return convertSuperKeyword(loc);
      case "SwitchStatement":
        return convertSwitchStatement(node, loc);
      case "SymbolKeyword":
        return convertKeywordTypeExpr(node, loc, "symbol");
      case "TaggedTemplateExpression":
        return convertTaggedTemplateExpression(node, loc);
      case "TemplateExpression":
        return convertTemplateExpression(node, loc);
      case "TemplateHead":
      case "TemplateMiddle":
      case "TemplateTail":
        return convertTemplateElement(node, kind, loc);
      case "TemplateLiteralType":
        return convertTemplateLiteralType(node, loc);
      case "ThisKeyword":
        return convertThisKeyword(loc);
      case "ThisType":
        return convertKeywordTypeExpr(node, loc, "this");
      case "ThrowStatement":
        return convertThrowStatement(node, loc);
      case "TrueKeyword":
        return convertTrueKeyword(loc);
      case "TryStatement":
        return convertTryStatement(node, loc);
      case "TupleType":
        return convertTupleType(node, loc);
      case "NamedTupleMember": 
        return convertNamedTupleMember(node, loc);
      case "TypeAliasDeclaration":
        return convertTypeAliasDeclaration(node, loc);
      case "TypeAssertionExpression":
        return convertTypeAssertionExpression(node, loc);
      case "TypeLiteral":
        return convertTypeLiteral(node, loc);
      case "TypeOfExpression":
        return convertTypeOfExpression(node, loc);
      case "TypeOperator":
        return convertTypeOperator(node, loc);
      case "TypeParameter":
        return convertTypeParameter(node, loc);
      case "TypePredicate":
        return convertTypePredicate(node, loc);
      case "TypeReference":
        return convertTypeReference(node, loc);
      case "TypeQuery":
        return convertTypeQuery(node, loc);
      case "UndefinedKeyword":
        return convertKeywordTypeExpr(node, loc, "undefined");
      case "UnionType":
        return convertUnionType(node, loc);
      case "UnknownKeyword":
        return convertKeywordTypeExpr(node, loc, "unknown");
      case "VariableDeclaration":
        return convertVariableDeclaration(node, loc);
      case "VariableDeclarationList":
        return convertVariableDeclarationList(node, loc);
      case "VariableStatement":
        return convertVariableStatement(node, loc);
      case "VoidExpression":
        return convertVoidExpression(node, loc);
      case "VoidKeyword":
        return convertKeywordTypeExpr(node, loc, "void");
      case "WhileStatement":
        return convertWhileStatement(node, loc);
      case "WithStatement":
        return convertWithStatement(node, loc);
      case "YieldExpression":
        return convertYieldExpression(node, loc);
      case "ClassStaticBlockDeclaration":
        return convertStaticInitializerBlock(node, loc);
      default:
        throw new ParseError(
            "Unsupported TypeScript syntax " + kind, getSourceLocation(node).getStart());
    }
  }

  /**
   * Attaches type information from the JSON object to the given AST node, if applicable. This is
   * called from {@link #convertNode}.
   */
  private void attachStaticType(Node astNode, JsonObject json) {
    if (astNode instanceof ITypedAstNode && json.has("$type")) {
      ITypedAstNode typedAstNode = (ITypedAstNode) astNode;
      int typeId = json.get("$type").getAsInt();
      typedAstNode.setStaticTypeId(typeId);
    }
  }

  /** Attaches a TypeScript compiler symbol to the given node, if any was provided. */
  private void attachSymbolInformation(INodeWithSymbol node, JsonObject json) {
    if (json.has("$symbol")) {
      int symbol = json.get("$symbol").getAsInt();
      node.setSymbol(symbol);
    }
  }

  /** Attaches call signatures and related symbol information to a call site. */
  private void attachResolvedSignature(InvokeExpression node, JsonObject json) {
    if (json.has("$resolvedSignature")) {
      int id = json.get("$resolvedSignature").getAsInt();
      node.setResolvedSignatureId(id);
    }
    if (json.has("$overloadIndex")) {
      int id = json.get("$overloadIndex").getAsInt();
      node.setOverloadIndex(id);
    }
    attachSymbolInformation(node, json);
  }

  /** Attached the declared call signature to a function. */
  private void attachDeclaredSignature(IFunction node, JsonObject json) {
    if (json.has("$declaredSignature")) {
      node.setDeclaredSignatureId(json.get("$declaredSignature").getAsInt());
    }
  }

  /**
   * Convert the given array of TypeScript AST nodes into a list of JavaScript AST nodes, skipping
   * any {@code null} elements.
   */
  private <T extends INode> List<T> convertNodes(Iterable<JsonElement> nodes) throws ParseError {
    return convertNodes(nodes, true);
  }

  /**
   * Convert the given array of TypeScript AST nodes into a list of JavaScript AST nodes, where
   * {@code skipNull} indicates whether {@code null} elements should be skipped or not.
   */
  @SuppressWarnings("unchecked")
  private <T extends INode> List<T> convertNodes(Iterable<JsonElement> nodes, boolean skipNull)
      throws ParseError {
    List<T> res = new ArrayList<T>();
    for (JsonElement elt : nodes) {
      T converted = (T) convertNode(elt.getAsJsonObject());
      if (!skipNull || converted != null) res.add(converted);
    }
    return res;
  }

  /**
   * Converts the given child to an AST node of the given type or <code>null</code>. A ParseError is
   * thrown if a different type of node was found.
   *
   * <p>This is used to detect syntax errors that are not reported as syntax errors by the
   * TypeScript parser. Usually they are reported as errors in a later compiler stage, which the
   * extractor does not run.
   *
   * <p>Returns <code>null</code> if the child is absent.
   */
  @SuppressWarnings("unchecked")
  private <T extends Node> T tryConvertChild(JsonObject node, String prop, Class<T> expectedType)
      throws ParseError {
    Node child = convertChild(node, prop);
    if (child == null || expectedType.isInstance(child)) {
      return (T) child;
    } else {
      throw new ParseError("Unsupported TypeScript syntax", getSourceLocation(node).getStart());
    }
  }

  /** Convert the child node named {@code prop} of AST node {@code node}. */
  private <T extends Node> T convertChild(JsonObject node, String prop) throws ParseError {
    return convertChild(node, prop, null);
  }

  /**
   * Convert the child node named {@code prop} of AST node {@code node}, with {@code kind} as its
   * default kind.
   */
  @SuppressWarnings("unchecked")
  private <T extends INode> T convertChild(JsonObject node, String prop, String kind)
      throws ParseError {
    JsonElement child = node.get(prop);
    if (child == null) return null;
    return (T) convertNode(child.getAsJsonObject(), kind);
  }

  /** Convert the child nodes named {@code prop} of AST node {@code node}. */
  private <T extends INode> List<T> convertChildren(JsonObject node, String prop)
      throws ParseError {
    return convertChildren(node, prop, true);
  }

  /** Like convertChildren but returns an empty list if the property is missing. */
  private <T extends INode> List<T> convertChildrenNotNull(JsonObject node, String prop)
      throws ParseError {
    List<T> nodes = convertChildren(node, prop, true);
    if (nodes == null) {
      return Collections.emptyList();
    }
    return nodes;
  }

  /**
   * Convert the child nodes named {@code prop} of AST node {@code node}, where {@code skipNull}
   * indicates whether or not to skip null children.
   */
  private <T extends INode> List<T> convertChildren(JsonObject node, String prop, boolean skipNull)
      throws ParseError {
    JsonElement child = node.get(prop);
    if (child == null) return null;
    return convertNodes(child.getAsJsonArray(), skipNull);
  }

  /* Converter methods for the individual TypeScript AST node types. */

  private Node convertArrayBindingPattern(JsonObject array, SourceLocation loc) throws ParseError {
    List<Expression> elements = new ArrayList<>();
    for (JsonElement elt : array.get("elements").getAsJsonArray()) {
      JsonObject element = (JsonObject) elt;
      SourceLocation eltLoc = getSourceLocation(element);
      Expression convertedElt = convertChild(element, "name");
      if (hasChild(element, "initializer"))
        convertedElt =
            new AssignmentPattern(eltLoc, "=", convertedElt, convertChild(element, "initializer"));
      else if (hasChild(element, "dotDotDotToken"))
        convertedElt = new RestElement(eltLoc, convertedElt);
      elements.add(convertedElt);
    }
    return new ArrayPattern(loc, elements);
  }

  private Node convertArrayLiteralExpression(JsonObject node, SourceLocation loc)
      throws ParseError {
    return new ArrayExpression(loc, convertChildren(node, "elements", false));
  }

  private Node convertArrayType(JsonObject node, SourceLocation loc) throws ParseError {
    return new ArrayTypeExpr(loc, convertChildAsType(node, "elementType"));
  }

  private Node convertArrowFunction(JsonObject node, SourceLocation loc) throws ParseError {
    ArrowFunctionExpression function =
        new ArrowFunctionExpression(
            loc,
            convertParameters(node),
            convertChild(node, "body"),
            false,
            hasModifier(node, "AsyncKeyword"),
            convertChildrenNotNull(node, "typeParameters"),
            convertParameterTypes(node),
            convertChildAsType(node, "type"),
            getOptionalParameterIndices(node));
    attachDeclaredSignature(function, node);
    return function;
  }

  private Node convertAwaitExpression(JsonObject node, SourceLocation loc) throws ParseError {
    return new AwaitExpression(loc, convertChild(node, "expression"));
  }

  private Node convertBigIntLiteral(JsonObject node, SourceLocation loc) throws ParseError {
    String text = node.get("text").getAsString();
    String value = text.substring(0, text.length() - 1); // Remove the 'n' suffix.
    return new Literal(loc, TokenType.bigint, value);
  }

  private Node convertBinaryExpression(JsonObject node, SourceLocation loc) throws ParseError {
    Expression left = convertChild(node, "left");
    Expression right = convertChild(node, "right");
    JsonObject operatorToken = node.get("operatorToken").getAsJsonObject();
    String operator = getSourceLocation(operatorToken).getSource();
    switch (operator) {
      case ",":
        List<Expression> expressions = new ArrayList<Expression>();
        if (left instanceof SequenceExpression)
          expressions.addAll(((SequenceExpression) left).getExpressions());
        else expressions.add(left);
        if (right instanceof SequenceExpression)
          expressions.addAll(((SequenceExpression) right).getExpressions());
        else expressions.add(right);
        return new SequenceExpression(loc, expressions);

      case "||":
      case "&&":
        return new LogicalExpression(loc, operator, left, right);

      case "=":
        left =
            convertLValue(left); // For plain assignments, the lhs can be a destructuring pattern.
        return new AssignmentExpression(loc, operator, left, right);

      case "+=":
      case "-=":
      case "*=":
      case "**=":
      case "/=":
      case "%=":
      case "^=":
      case "&=":
      case "|=":
      case ">>=":
      case "<<=":
      case ">>>=":
      case "??=":
      case "&&=":
      case "||=":
        return new AssignmentExpression(loc, operator, convertLValue(left), right);

      default:
        return new BinaryExpression(loc, operator, left, right);
    }
  }

  private Node convertStaticInitializerBlock(JsonObject node, SourceLocation loc) throws ParseError {
    BlockStatement body = new BlockStatement(loc, convertChildren(node.get("body").getAsJsonObject(), "statements"));
    return new StaticInitializer(loc, body);
  }

  private Node convertBlock(JsonObject node, SourceLocation loc) throws ParseError {
    return new BlockStatement(loc, convertChildren(node, "statements"));
  }

  private Node convertBreakStatement(JsonObject node, SourceLocation loc) throws ParseError {
    return new BreakStatement(loc, convertChild(node, "label"));
  }

  private Node convertCallExpression(JsonObject node, SourceLocation loc) throws ParseError {
    List<Expression> arguments = convertChildren(node, "arguments");
    if (arguments.size() == 1 && hasKind(node.get("expression"), "ImportKeyword")) {
      return new DynamicImport(loc, arguments.get(0));
    }
    Expression callee = convertChild(node, "expression");
    List<ITypeExpression> typeArguments = convertChildrenAsTypes(node, "typeArguments");
    boolean optional = node.has("questionDotToken");
    boolean onOptionalChain = Chainable.isOnOptionalChain(optional, callee);
    CallExpression call =
        new CallExpression(loc, callee, typeArguments, arguments, optional, onOptionalChain);
    attachResolvedSignature(call, node);
    return call;
  }

  private MethodDefinition convertCallSignature(JsonObject node, SourceLocation loc)
      throws ParseError {
    FunctionExpression function = convertImplicitFunction(node, loc);
    int flags = getMemberModifierKeywords(node) | DeclarationFlags.abstract_;
    return new MethodDefinition(loc, flags, Kind.FUNCTION_CALL_SIGNATURE, null, function);
  }

  private Node convertCaseClause(JsonObject node, SourceLocation loc) throws ParseError {
    return convertDefaultClause(node, loc);
  }

  private Node convertCatchClause(JsonObject node, SourceLocation loc) throws ParseError {
    IPattern pattern = null;
    JsonElement variableDecl = node.get("variableDeclaration");
    if (variableDecl != null) pattern = convertChild(variableDecl.getAsJsonObject(), "name");
    return new CatchClause(loc, pattern, null, convertChild(node, "block"));
  }

  private List<ITypeExpression> convertSuperInterfaceClause(JsonArray supers) throws ParseError {
    List<ITypeExpression> result = new ArrayList<>();
    for (JsonElement elt : supers) {
      JsonObject superType = elt.getAsJsonObject();
      ITypeExpression objectType = convertChildAsType(superType, "expression");
      if (objectType == null) continue;
      List<ITypeExpression> typeArguments = convertChildrenAsTypes(superType, "typeArguments");
      if (typeArguments.isEmpty()) {
        result.add(objectType);
      } else {
        result.add(new GenericTypeExpr(getSourceLocation(superType), objectType, typeArguments));
      }
    }
    return result;
  }

  private Node convertClass(JsonObject node, String kind, SourceLocation loc) throws ParseError {
    Identifier id = convertChild(node, "name");
    List<TypeParameter> typeParameters = convertChildrenNotNull(node, "typeParameters");
    Expression superClass = null;
    List<ITypeExpression> superInterfaces = null;
    int afterHead = id == null ? loc.getStart().getOffset() + 5 : id.getLoc().getEnd().getOffset();
    for (JsonElement elt : getChildIterable(node, "heritageClauses")) {
      JsonObject heritageClause = elt.getAsJsonObject();
      JsonArray supers = heritageClause.get("types").getAsJsonArray();
      if (heritageClause.get("token").getAsInt() == syntaxKindExtends) {
        if (supers.size() > 0) {
          superClass = (Expression) convertNode(supers.get(0).getAsJsonObject());
        }
      } else {
        superInterfaces = convertSuperInterfaceClause(supers);
      }
      afterHead = heritageClause.get("$end").getAsInt();
    }
    if (superInterfaces == null) {
      superInterfaces = new ArrayList<>();
    }
    String skip =
        source.substring(loc.getStart().getOffset(), afterHead) + matchWhitespace(afterHead);
    SourceLocation bodyLoc = new SourceLocation(loc.getSource(), loc.getStart(), loc.getEnd());
    advance(bodyLoc, skip);
    ClassBody body = new ClassBody(bodyLoc, convertChildren(node, "members"));
    if ("ClassExpression".equals(kind)) {
      ClassExpression classExpr =
          new ClassExpression(loc, id, typeParameters, superClass, superInterfaces, body);
      attachSymbolInformation(classExpr.getClassDef(), node);
      return fixExports(loc, classExpr);
    }
    boolean hasDeclareKeyword = hasModifier(node, "DeclareKeyword");
    boolean hasAbstractKeyword = hasModifier(node, "AbstractKeyword");
    ClassDeclaration classDecl =
        new ClassDeclaration(
            loc,
            id,
            typeParameters,
            superClass,
            superInterfaces,
            body,
            hasDeclareKeyword,
            hasAbstractKeyword);
    attachSymbolInformation(classDecl.getClassDef(), node);
    if (node.has("decorators")) {
      classDecl.addDecorators(convertChildren(node, "decorators"));
      advanceUntilAfter(loc, classDecl.getDecorators());
    }
    Node exportedDecl = fixExports(loc, classDecl);
    // Convert default-exported anonymous class declarations to class expressions.
    if (exportedDecl instanceof ExportDefaultDeclaration && !classDecl.getClassDef().hasId()) {
      return new ExportDefaultDeclaration(
          exportedDecl.getLoc(), new ClassExpression(classDecl.getLoc(), classDecl.getClassDef()));
    }
    return exportedDecl;
  }

  private Node convertCommaListExpression(JsonObject node, SourceLocation loc) throws ParseError {
    return new SequenceExpression(loc, convertChildren(node, "elements"));
  }

  private Node convertComputedPropertyName(JsonObject node) throws ParseError {
    return convertChild(node, "expression");
  }

  private Node convertConditionalExpression(JsonObject node, SourceLocation loc) throws ParseError {
    return new ConditionalExpression(
        loc,
        convertChild(node, "condition"),
        convertChild(node, "whenTrue"),
        convertChild(node, "whenFalse"));
  }

  private Node convertConditionalType(JsonObject node, SourceLocation loc) throws ParseError {
    return new ConditionalTypeExpr(
        loc,
        convertChildAsType(node, "checkType"),
        convertChildAsType(node, "extendsType"),
        convertChildAsType(node, "trueType"),
        convertChildAsType(node, "falseType"));
  }

  private SourceLocation getSourceRange(Position from, Position to) {
    return new SourceLocation(source.substring(from.getOffset(), to.getOffset()), from, to);
  }

  private DecoratorList makeDecoratorList(JsonElement decorators) throws ParseError {
    if (!(decorators instanceof JsonArray)) return null;
    JsonArray array = decorators.getAsJsonArray();
    SourceLocation firstLoc = null, lastLoc = null;
    List<Decorator> list = new ArrayList<>();
    for (JsonElement decoratorElm : array) {
      JsonObject decorator = decoratorElm.getAsJsonObject();
      if (hasKind(decorator, "Decorator")) {
        SourceLocation location = getSourceLocation(decorator);
        list.add(convertDecorator(decorator, location));
        if (firstLoc == null) {
          firstLoc = location;
        }
        lastLoc = location;
      }
    }
    if (firstLoc == null) return null;
    return new DecoratorList(getSourceRange(firstLoc.getStart(), lastLoc.getEnd()), list);
  }

  private List<DecoratorList> convertParameterDecorators(JsonObject function) throws ParseError {
    List<DecoratorList> decoratorLists = new ArrayList<>();
    for (JsonElement parameter : getProperParameters(function)) {
      decoratorLists.add(makeDecoratorList(parameter.getAsJsonObject().get("decorators")));
    }
    return decoratorLists;
  }

  private Node convertConstructor(JsonObject node, SourceLocation loc) throws ParseError {
    int flags = getMemberModifierKeywords(node);
    boolean isComputed = hasComputedName(node);
    boolean isStatic = DeclarationFlags.isStatic(flags);
    if (isComputed) {
      flags |= DeclarationFlags.computed;
    }
    // for some reason, the TypeScript compiler treats static methods named "constructor"
    // and methods with computed name "constructor" as constructors, even though they aren't
    MethodDefinition.Kind methodKind = isStatic || isComputed ? Kind.METHOD : Kind.CONSTRUCTOR;
    Expression key;
    if (isComputed) key = convertChild((JsonObject) node.get("name"), "expression");
    else key = new Identifier(loc, "constructor");
    List<Expression> params = convertParameters(node);
    List<ITypeExpression> paramTypes = convertParameterTypes(node);
    List<DecoratorList> paramDecorators = convertParameterDecorators(node);
    FunctionExpression value =
        new FunctionExpression(
            loc,
            null,
            params,
            convertChild(node, "body"),
            false,
            false,
            Collections.emptyList(),
            paramTypes,
            paramDecorators,
            null,
            null,
            getOptionalParameterIndices(node));
    attachSymbolInformation(value, node);
    attachStaticType(value, node);
    attachDeclaredSignature(value, node);
    List<FieldDefinition> parameterFields = convertParameterFields(node);
    return new MethodDefinition(loc, flags, methodKind, key, value, parameterFields);
  }

  private MethodDefinition convertConstructSignature(JsonObject node, SourceLocation loc)
      throws ParseError {
    FunctionExpression function = convertImplicitFunction(node, loc);
    int flags = getMemberModifierKeywords(node) | DeclarationFlags.abstract_;
    return new MethodDefinition(loc, flags, Kind.CONSTRUCTOR_CALL_SIGNATURE, null, function);
  }

  private Node convertConstructorType(JsonObject node, SourceLocation loc) throws ParseError {
    return new FunctionTypeExpr(loc, convertImplicitFunction(node, loc), true);
  }

  private Node convertContinueStatement(JsonObject node, SourceLocation loc) throws ParseError {
    return new ContinueStatement(loc, convertChild(node, "label"));
  }

  private Node convertDebuggerStatement(SourceLocation loc) {
    return new DebuggerStatement(loc);
  }

  private Decorator convertDecorator(JsonObject node, SourceLocation loc) throws ParseError {
    return new Decorator(loc, convertChild(node, "expression"));
  }

  private Node convertDefaultClause(JsonObject node, SourceLocation loc) throws ParseError {
    return new SwitchCase(
        loc, convertChild(node, "expression"), convertChildren(node, "statements"));
  }

  private Node convertDeleteExpression(JsonObject node, SourceLocation loc) throws ParseError {
    return new UnaryExpression(loc, "delete", convertChild(node, "expression"), true);
  }

  private Node convertDoStatement(JsonObject node, SourceLocation loc) throws ParseError {
    return new DoWhileStatement(
        loc, convertChild(node, "expression"), convertChild(node, "statement"));
  }

  private Node convertElementAccessExpression(JsonObject node, SourceLocation loc)
      throws ParseError {
    Expression object = convertChild(node, "expression");
    Expression property = convertChild(node, "argumentExpression");
    boolean optional = node.has("questionDotToken");
    boolean onOptionalChain = Chainable.isOnOptionalChain(optional, object);
    return new MemberExpression(loc, object, property, true, optional, onOptionalChain);
  }

  private Node convertEmptyStatement(SourceLocation loc) {
    return new EmptyStatement(loc);
  }

  private Node convertEnumDeclaration(JsonObject node, SourceLocation loc) throws ParseError {
    EnumDeclaration enumDeclaration =
        new EnumDeclaration(
            loc,
            hasModifier(node, "ConstKeyword"),
            hasModifier(node, "DeclareKeyword"),
            convertChildrenNotNull(node, "decorators"),
            convertChild(node, "name"),
            convertChildren(node, "members"));
    attachSymbolInformation(enumDeclaration, node);
    advanceUntilAfter(loc, enumDeclaration.getDecorators());
    return fixExports(loc, enumDeclaration);
  }

  /**
   * Converts a TypeScript Identifier or StringLiteral node to an Identifier AST node, or {@code
   * null} if the given node is not of the expected kind.
   */
  private Identifier convertNodeAsIdentifier(JsonObject node) throws ParseError {
    SourceLocation loc = getSourceLocation(node);
    if (isIdentifier(node)) {
      return convertIdentifier(node, loc);
    } else if (hasKind(node, "StringLiteral")) {
      return new Identifier(loc, node.get("text").getAsString());
    } else {
      return null;
    }
  }

  private Node convertEnumMember(JsonObject node, SourceLocation loc) throws ParseError {
    Identifier name = convertNodeAsIdentifier(node.get("name").getAsJsonObject());
    if (name == null) return null;
    EnumMember member = new EnumMember(loc, name, convertChild(node, "initializer"));
    attachSymbolInformation(member, node);
    return member;
  }

  private Node convertExportAssignment(JsonObject node, SourceLocation loc) throws ParseError {
    if (hasChild(node, "isExportEquals") && node.get("isExportEquals").getAsBoolean())
      return new ExportWholeDeclaration(loc, convertChild(node, "expression"));
    return new ExportDefaultDeclaration(loc, convertChild(node, "expression"));
  }

  private Node convertExportDeclaration(JsonObject node, SourceLocation loc) throws ParseError {
    Literal source = tryConvertChild(node, "moduleSpecifier", Literal.class);
    if (hasChild(node, "exportClause")) {
      boolean hasTypeKeyword = node.get("isTypeOnly").getAsBoolean();
      List<ExportSpecifier> specifiers =
          hasKind(node.get("exportClause"), "NamespaceExport")
              ? Collections.singletonList(convertChild(node, "exportClause"))
              : convertChildren(node.get("exportClause").getAsJsonObject(), "elements");
      return new ExportNamedDeclaration(loc, null, specifiers, source, hasTypeKeyword);
    } else {
      return new ExportAllDeclaration(loc, source);
    }
  }

  private Node convertExportSpecifier(JsonObject node, SourceLocation loc) throws ParseError {
    return new ExportSpecifier(
        loc,
        convertChild(node, hasChild(node, "propertyName") ? "propertyName" : "name"),
        convertChild(node, "name"));
  }

  private Node convertNamespaceExport(JsonObject node, SourceLocation loc) throws ParseError {
    // Convert the "* as ns" from an export declaration.
    return new ExportNamespaceSpecifier(loc, convertChild(node, "name"));
  }

  private Node convertExpressionStatement(JsonObject node, SourceLocation loc) throws ParseError {
    Expression expression = convertChild(node, "expression");
    return new ExpressionStatement(loc, expression);
  }

  private Node convertExpressionWithTypeArguments(JsonObject node, SourceLocation loc)
      throws ParseError {
    Expression expression = convertChild(node, "expression");
    List<ITypeExpression> typeArguments = convertChildrenAsTypes(node, "typeArguments");
    if (typeArguments.isEmpty()) return expression;
    return new ExpressionWithTypeArguments(loc, expression, typeArguments);
  }

  private Node convertExternalModuleReference(JsonObject node, SourceLocation loc)
      throws ParseError {
    ExternalModuleReference moduleRef = new ExternalModuleReference(loc, convertChild(node, "expression"));
    attachSymbolInformation(moduleRef, node);
    return moduleRef;
  }

  private Node convertFalseKeyword(SourceLocation loc) {
    return new Literal(loc, TokenType._false, false);
  }

  private Node convertNumericLiteral(JsonObject node, SourceLocation loc)
      throws NumberFormatException {
    return new Literal(loc, TokenType.num, Double.valueOf(node.get("text").getAsString()));
  }

  private Node convertForStatement(JsonObject node, SourceLocation loc) throws ParseError {
    return new ForStatement(
        loc,
        convertChild(node, "initializer"),
        convertChild(node, "condition"),
        convertChild(node, "incrementor"),
        convertChild(node, "statement"));
  }

  private Node convertForInStatement(JsonObject node, SourceLocation loc) throws ParseError {
    Node initializer = convertChild(node, "initializer");
    if (initializer instanceof Expression) initializer = convertLValue((Expression) initializer);
    return new ForInStatement(
        loc, initializer, convertChild(node, "expression"), convertChild(node, "statement"), false);
  }

  private Node convertForOfStatement(JsonObject node, SourceLocation loc) throws ParseError {
    Node initializer = convertChild(node, "initializer");
    if (initializer instanceof Expression) initializer = convertLValue((Expression) initializer);
    return new ForOfStatement(
        loc, initializer, convertChild(node, "expression"), convertChild(node, "statement"));
  }

  private Node convertFunctionDeclaration(JsonObject node, SourceLocation loc) throws ParseError {
    List<Expression> params = convertParameters(node);
    Identifier fnId = convertChild(node, "name", "Identifier");
    if (fnId == null) {
      // Anonymous function declarations may occur as part of default exported functions.
      // We represent these as function expressions.
      return fixExports(loc, convertFunctionExpression(node, loc));
    }
    BlockStatement fnbody = convertChild(node, "body");
    boolean generator = hasChild(node, "asteriskToken");
    boolean async = hasModifier(node, "AsyncKeyword");
    boolean hasDeclareKeyword = hasModifier(node, "DeclareKeyword");
    List<ITypeExpression> paramTypes = convertParameterTypes(node);
    List<TypeParameter> typeParameters = convertChildrenNotNull(node, "typeParameters");
    ITypeExpression returnType = convertChildAsType(node, "type");
    ITypeExpression thisParam = convertThisParameterType(node);
    FunctionDeclaration function =
        new FunctionDeclaration(
            loc,
            fnId,
            params,
            fnbody,
            generator,
            async,
            hasDeclareKeyword,
            typeParameters,
            paramTypes,
            returnType,
            thisParam,
            getOptionalParameterIndices(node));
    attachSymbolInformation(function, node);
    attachStaticType(function, node);
    attachDeclaredSignature(function, node);
    return fixExports(loc, function);
  }

  private Node convertFunctionExpression(JsonObject node, SourceLocation loc) throws ParseError {
    Identifier fnId = convertChild(node, "name", "Identifier");
    List<Expression> params = convertParameters(node);
    BlockStatement fnbody = convertChild(node, "body");
    boolean generator = hasChild(node, "asteriskToken");
    boolean async = hasModifier(node, "AsyncKeyword");
    List<ITypeExpression> paramTypes = convertParameterTypes(node);
    List<DecoratorList> paramDecorators = convertParameterDecorators(node);
    ITypeExpression returnType = convertChildAsType(node, "type");
    ITypeExpression thisParam = convertThisParameterType(node);
    FunctionExpression function =
        new FunctionExpression(
            loc,
            fnId,
            params,
            fnbody,
            generator,
            async,
            convertChildrenNotNull(node, "typeParameters"),
            paramTypes,
            paramDecorators,
            returnType,
            thisParam,
            getOptionalParameterIndices(node));
    attachStaticType(function, node);
    attachDeclaredSignature(function, node);
    return function;
  }

  private Node convertFunctionType(JsonObject node, SourceLocation loc) throws ParseError {
    return new FunctionTypeExpr(loc, convertImplicitFunction(node, loc), false);
  }

  /** Gets the original text out of an Identifier's "escapedText" field. */
  private String unescapeLeadingUnderscores(String text) {
    // The TypeScript compiler inserts an additional underscore in front of
    // identifiers that begin with two underscores.
    if (text.startsWith("___")) {
      return text.substring(1);
    } else {
      return text;
    }
  }

  /** Returns the contents of the given identifier as a string. */
  private String getIdentifierText(JsonObject identifierNode) {
    if (identifierNode.has("text")) return identifierNode.get("text").getAsString();
    else return unescapeLeadingUnderscores(identifierNode.get("escapedText").getAsString());
  }

  private Identifier convertIdentifier(JsonObject node, SourceLocation loc) {
    Identifier id = new Identifier(loc, getIdentifierText(node));
    attachSymbolInformation(id, node);
    return id;
  }

  private Node convertKeywordTypeExpr(JsonObject node, SourceLocation loc, String text) {
    return new KeywordTypeExpr(loc, text);
  }

  private Node convertUnionType(JsonObject node, SourceLocation loc) throws ParseError {
    return new UnionTypeExpr(loc, convertChildrenAsTypes(node, "types"));
  }

  private Node convertIfStatement(JsonObject node, SourceLocation loc) throws ParseError {
    return new IfStatement(
        loc,
        convertChild(node, "expression"),
        convertChild(node, "thenStatement"),
        convertChild(node, "elseStatement"));
  }

  private Node convertImportClause(JsonObject node, SourceLocation loc) throws ParseError {
    return new ImportDefaultSpecifier(loc, convertChild(node, "name"));
  }

  private Node convertImportDeclaration(JsonObject node, SourceLocation loc) throws ParseError {
    Literal src = tryConvertChild(node, "moduleSpecifier", Literal.class);
    List<ImportSpecifier> specifiers = new ArrayList<>();
    boolean hasTypeKeyword = false;
    if (hasChild(node, "importClause")) {
      JsonObject importClause = node.get("importClause").getAsJsonObject();
      if (hasChild(importClause, "name")) {
        specifiers.add(convertChild(node, "importClause"));
      }
      if (hasChild(importClause, "namedBindings")) {
        JsonObject namedBindings = importClause.get("namedBindings").getAsJsonObject();
        if (hasKind(namedBindings, "NamespaceImport")) {
          specifiers.add(convertChild(importClause, "namedBindings"));
        } else {
          specifiers.addAll(convertChildren(namedBindings, "elements"));
        }
      }
      hasTypeKeyword = importClause.get("isTypeOnly").getAsBoolean();
    }
    ImportDeclaration importDecl = new ImportDeclaration(loc, specifiers, src, hasTypeKeyword);
    attachSymbolInformation(importDecl, node);
    return importDecl;
  }

  private Node convertImportEqualsDeclaration(JsonObject node, SourceLocation loc)
      throws ParseError {
    return fixExports(
        loc,
        new ImportWholeDeclaration(
            loc, convertChild(node, "name"), convertChild(node, "moduleReference")));
  }

  private Node convertImportKeyword(SourceLocation loc) {
    return new Identifier(loc, "import");
  }

  private Node convertImportSpecifier(JsonObject node, SourceLocation loc) throws ParseError {
    boolean hasImported = hasChild(node, "propertyName");
    Identifier imported = convertChild(node, hasImported ? "propertyName" : "name");
    Identifier local = convertChild(node, "name");
    boolean isTypeOnly = node.get("isTypeOnly").getAsBoolean() == true;
    return new ImportSpecifier(loc, imported, local, isTypeOnly);
  }

  private Node convertImportType(JsonObject node, SourceLocation loc) throws ParseError {
    // This is a type such as `import("./foo").bar.Baz`.
    //
    // The TypeScript AST represents import types as the root of a qualified name,
    // whereas we represent them as the leftmost qualifier.
    //
    // So in our AST, ImportTypeExpr just represents `import("./foo")`, and `.bar.Baz`
    // is represented by nested MemberExpr nodes.
    //
    // Additionally, an import type can be prefixed by `typeof`, such as `typeof import("foo")`.
    // We convert these to TypeofTypeExpr.

    // Get the source range of the `import(path)` part.
    Position importStart = loc.getStart();
    Position importEnd = loc.getEnd();
    boolean isTypeof = false;
    if (node.has("isTypeOf") && node.get("isTypeOf").getAsBoolean() == true) {
      isTypeof = true;
      Matcher m = TYPEOF_START.matcher(loc.getSource());
      if (m.find()) {
        importStart = advance(importStart, m.group(0));
      }
    }

    ITypeExpression path = convertChildAsType(node, "argument");
    if (path == null) {
      throw new ParseError("Unsupported syntax in import", getSourceLocation(node).getStart());
    }

    // Find the ending parenthesis in `import(path)` by skipping whitespace after `path`.
    String endSrc =
        loc.getSource().substring(path.getLoc().getEnd().getOffset() - loc.getStart().getOffset());
    Matcher m = WHITESPACE_END_PAREN.matcher(endSrc);
    if (m.find()) {
      importEnd = advance(path.getLoc().getEnd(), m.group(0));
    }
    SourceLocation importLoc = getSourceRange(importStart, importEnd);
    ImportTypeExpr imprt = new ImportTypeExpr(importLoc, path);

    ITypeExpression typeName = buildQualifiedTypeAccess(imprt, (JsonObject) node.get("qualifier"));
    if (isTypeof) {
      return new TypeofTypeExpr(loc, typeName);
    }

    List<ITypeExpression> typeArguments = convertChildrenAsTypes(node, "typeArguments");
    if (!typeArguments.isEmpty()) {
      return new GenericTypeExpr(loc, typeName, typeArguments);
    }
    return (Node) typeName;
  }

  /**
   * Converts the given JSON to a qualified name with `root` as the base.
   *
   * <p>For example, `a.b.c` is converted to the AST corresponding to `root.a.b.c`.
   */
  private ITypeExpression buildQualifiedTypeAccess(ITypeExpression root, JsonObject node)
      throws ParseError {
    if (node == null) {
      return root;
    }
    String kind = getKind(node);
    ITypeExpression base;
    Expression name;
    if (kind == null || kind.equals("Identifier")) {
      base = root;
      name = convertIdentifier(node, getSourceLocation(node));
    } else if (kind.equals("QualifiedName")) {
      base = buildQualifiedTypeAccess(root, (JsonObject) node.get("left"));
      name = convertChild(node, "right");
    } else {
      throw new ParseError("Unsupported syntax in import type", getSourceLocation(node).getStart());
    }
    MemberExpression member =
        new MemberExpression(getSourceLocation(node), (Expression) base, name, false, false, false);
    attachSymbolInformation(member, node);
    return member;
  }

  private Node convertIndexSignature(JsonObject node, SourceLocation loc) throws ParseError {
    FunctionExpression function = convertImplicitFunction(node, loc);
    int flags = getMemberModifierKeywords(node) | DeclarationFlags.abstract_;
    return new MethodDefinition(loc, flags, Kind.INDEX_SIGNATURE, null, function);
  }

  private Node convertIndexedAccessType(JsonObject node, SourceLocation loc) throws ParseError {
    return new IndexedAccessTypeExpr(
        loc, convertChildAsType(node, "objectType"), convertChildAsType(node, "indexType"));
  }

  private Node convertInferType(JsonObject node, SourceLocation loc) throws ParseError {
    return new InferTypeExpr(loc, convertChild(node, "typeParameter"));
  }

  private Node convertInterfaceDeclaration(JsonObject node, SourceLocation loc) throws ParseError {
    Identifier name = convertChild(node, "name");
    List<TypeParameter> typeParameters = convertChildrenNotNull(node, "typeParameters");
    List<MemberDefinition<?>> members = convertChildren(node, "members");
    List<ITypeExpression> superInterfaces = null;
    for (JsonElement elt : getChildIterable(node, "heritageClauses")) {
      JsonObject heritageClause = elt.getAsJsonObject();
      if (heritageClause.get("token").getAsInt() == syntaxKindExtends) {
        superInterfaces = convertSuperInterfaceClause(heritageClause.get("types").getAsJsonArray());
        break;
      }
    }
    if (superInterfaces == null) {
      superInterfaces = new ArrayList<>();
    }
    InterfaceDeclaration iface =
        new InterfaceDeclaration(loc, name, typeParameters, superInterfaces, members);
    attachSymbolInformation(iface, node);
    return fixExports(loc, iface);
  }

  private Node convertIntersectionType(JsonObject node, SourceLocation loc) throws ParseError {
    return new IntersectionTypeExpr(loc, convertChildrenAsTypes(node, "types"));
  }

  private Node convertJsxAttribute(JsonObject node, SourceLocation loc) throws ParseError {
    return new JSXAttribute(
        loc, convertJSXName(convertChild(node, "name")), convertChild(node, "initializer"));
  }

  private Node convertJsxClosingElement(JsonObject node, SourceLocation loc) throws ParseError {
    return new JSXClosingElement(loc, convertJSXName(convertChild(node, "tagName")));
  }

  private Node convertJsxElement(JsonObject node, SourceLocation loc) throws ParseError {
    return new JSXElement(
        loc,
        convertChild(node, "openingElement"),
        convertChildren(node, "children"),
        convertChild(node, "closingElement"));
  }

  private Node convertJsxExpression(JsonObject node, SourceLocation loc) throws ParseError {
    if (hasChild(node, "expression"))
      return new JSXExpressionContainer(loc, convertChild(node, "expression"));
    return new JSXExpressionContainer(loc, new JSXEmptyExpression(loc));
  }

  private Node convertJsxFragment(JsonObject node, SourceLocation loc) throws ParseError {
    return new JSXElement(
        loc,
        convertChild(node, "openingFragment"),
        convertChildren(node, "children"),
        convertChild(node, "closingFragment"));
  }

  private Node convertJsxOpeningFragment(JsonObject node, SourceLocation loc) {
    return new JSXOpeningElement(loc, null, Collections.emptyList(), false);
  }

  private Node convertJsxClosingFragment(JsonObject node, SourceLocation loc) {
    return new JSXClosingElement(loc, null);
  }

  private List<IJSXAttribute> convertJsxAttributes(JsonObject node) throws ParseError {
    JsonElement attributes = node.get("attributes");
    List<IJSXAttribute> convertedAttributes;
    if (attributes.isJsonArray()) {
      convertedAttributes = convertNodes(attributes.getAsJsonArray());
    } else {
      convertedAttributes = convertChildren(attributes.getAsJsonObject(), "properties");
    }
    return convertedAttributes;
  }

  private Node convertJsxOpeningElement(JsonObject node, SourceLocation loc) throws ParseError {
    List<IJSXAttribute> convertedAttributes = convertJsxAttributes(node);
    return new JSXOpeningElement(
        loc,
        convertJSXName(convertChild(node, "tagName")),
        convertedAttributes,
        hasChild(node, "selfClosing"));
  }

  private Node convertJsxSelfClosingElement(JsonObject node, SourceLocation loc) throws ParseError {
    List<IJSXAttribute> convertedAttributes = convertJsxAttributes(node);
    JSXOpeningElement opening =
        new JSXOpeningElement(
            loc, convertJSXName(convertChild(node, "tagName")), convertedAttributes, true);
    return new JSXElement(loc, opening, new ArrayList<>(), null);
  }

  private Node convertJsxSpreadAttribute(JsonObject node, SourceLocation loc) throws ParseError {
    return new JSXSpreadAttribute(loc, convertChild(node, "expression"));
  }

  private Node convertJsxText(JsonObject node, SourceLocation loc) {
    String text;
    if (hasChild(node, "text")) text = node.get("text").getAsString();
    else text = "";
    return new Literal(loc, TokenType.string, text);
  }

  private Node convertLabeledStatement(JsonObject node, SourceLocation loc) throws ParseError {
    return new LabeledStatement(loc, convertChild(node, "label"), convertChild(node, "statement"));
  }

  private Node convertLiteralType(JsonObject node, SourceLocation loc) throws ParseError {
    Node literal = convertChild(node, "literal");
    // Convert a negated literal to a negative number
    if (literal instanceof UnaryExpression) {
      UnaryExpression unary = (UnaryExpression) literal;
      if (unary.getOperator().equals("-") && unary.getArgument() instanceof Literal) {
        Literal arg = (Literal) unary.getArgument();
        literal = new Literal(loc, arg.getTokenType(), "-" + arg.getValue());
      }
    }
    if (literal instanceof TemplateLiteral) {
      // A LiteralType containing a NoSubstitutionTemplateLiteral must produce a TemplateLiteralTypeExpr
      return new TemplateLiteralTypeExpr(literal.getLoc(), new ArrayList<>(), ((TemplateLiteral)literal).getQuasis());
    }
    return literal;
  }

  private Node convertMappedType(JsonObject node, SourceLocation loc) throws ParseError {
    return new MappedTypeExpr(
        loc, convertChild(node, "typeParameter"), convertChildAsType(node, "type"));
  }

  private Node convertMetaProperty(JsonObject node, SourceLocation loc) throws ParseError {
    Position metaStart = loc.getStart();
    String keywordKind =
        metadata.getSyntaxKindName(node.getAsJsonPrimitive("keywordToken").getAsInt());
    String identifier = keywordKind.equals("ImportKeyword") ? "import" : "new";
    Position metaEnd =
        new Position(
            metaStart.getLine(),
            metaStart.getColumn() + identifier.length(),
            metaStart.getOffset() + identifier.length());
    SourceLocation metaLoc = new SourceLocation(identifier, metaStart, metaEnd);
    Identifier meta = new Identifier(metaLoc, identifier);
    return new MetaProperty(loc, meta, convertChild(node, "name"));
  }

  private Node convertMethodDeclaration(JsonObject node, String kind, SourceLocation loc)
      throws ParseError {
    int flags = getMemberModifierKeywords(node);
    if (hasComputedName(node)) {
      flags |= DeclarationFlags.computed;
    }
    if (kind.equals("MethodSignature")) {
      flags |= DeclarationFlags.abstract_;
    }
    MethodDefinition.Kind methodKind;
    if ("GetAccessor".equals(kind)) methodKind = Kind.GET;
    else if ("SetAccessor".equals(kind)) methodKind = Kind.SET;
    else methodKind = Kind.METHOD;
    FunctionExpression method = convertImplicitFunction(node, loc);
    MethodDefinition methodDefinition =
        new MethodDefinition(loc, flags, methodKind, convertChild(node, "name"), method);
    if (node.has("decorators")) {
      methodDefinition.addDecorators(convertChildren(node, "decorators"));
      advanceUntilAfter(loc, methodDefinition.getDecorators());
    }
    return methodDefinition;
  }

  private FunctionExpression convertImplicitFunction(JsonObject node, SourceLocation loc)
      throws ParseError {
    ITypeExpression returnType = convertChildAsType(node, "type");
    List<ITypeExpression> paramTypes = convertParameterTypes(node);
    List<DecoratorList> paramDecorators = convertParameterDecorators(node);
    List<TypeParameter> typeParameters = convertChildrenNotNull(node, "typeParameters");
    ITypeExpression thisType = convertThisParameterType(node);
    FunctionExpression function =
        new FunctionExpression(
            loc,
            null,
            convertParameters(node),
            convertChild(node, "body"),
            hasChild(node, "asteriskToken"),
            hasModifier(node, "AsyncKeyword"),
            typeParameters,
            paramTypes,
            paramDecorators,
            returnType,
            thisType,
            getOptionalParameterIndices(node));
    attachSymbolInformation(function, node);
    attachStaticType(function, node);
    attachDeclaredSignature(function, node);
    return function;
  }

  private Node convertNamespaceDeclaration(JsonObject node, SourceLocation loc) throws ParseError {
    Node nameNode = convertChild(node, "name");
    List<Statement> body;
    Statement b = convertChild(node, "body");
    if (b instanceof BlockStatement) {
      body = ((BlockStatement) b).getBody();
    } else {
      body = new ArrayList<>();
      body.add(b);
    }
    if (nameNode instanceof Literal) {
      // Declaration of form: declare module "X" {...}
      return new ExternalModuleDeclaration(loc, (Literal) nameNode, body);
    }
    if (hasFlag(node, "GlobalAugmentation")) {
      // Declaration of form: declare global {...}
      return new GlobalAugmentationDeclaration(loc, body);
    }
    Identifier name = (Identifier) nameNode;
    boolean isInstantiated = false;
    for (Statement stmt : body) {
      isInstantiated = isInstantiated || isInstantiatingNamespaceMember(stmt);
    }
    boolean hasDeclareKeyword = hasModifier(node, "DeclareKeyword");
    NamespaceDeclaration decl =
        new NamespaceDeclaration(loc, name, body, isInstantiated, hasDeclareKeyword);
    attachSymbolInformation(decl, node);
    if (hasFlag(node, "NestedNamespace")) {
      // In a nested namespace declaration `namespace A.B`, the nested namespace `B`
      // is implicitly exported.
      return new ExportNamedDeclaration(loc, decl, new ArrayList<>(), null);
    } else {
      return fixExports(loc, decl);
    }
  }

  private boolean isInstantiatingNamespaceMember(Statement node) {
    if (node instanceof ExportNamedDeclaration) {
      // Ignore 'export' modifiers.
      return isInstantiatingNamespaceMember(((ExportNamedDeclaration) node).getDeclaration());
    }
    if (node instanceof NamespaceDeclaration) {
      return ((NamespaceDeclaration) node).isInstantiated();
    }
    if (node instanceof InterfaceDeclaration) {
      return false;
    }
    if (node instanceof TypeAliasDeclaration) {
      return false;
    }
    return true;
  }

  private Node convertModuleBlock(JsonObject node, SourceLocation loc) throws ParseError {
    return convertBlock(node, loc);
  }

  private Node convertNamespaceExportDeclaration(JsonObject node, SourceLocation loc)
      throws ParseError {
    return new ExportAsNamespaceDeclaration(loc, convertChild(node, "name"));
  }

  private Node convertNamespaceImport(JsonObject node, SourceLocation loc) throws ParseError {
    return new ImportNamespaceSpecifier(loc, convertChild(node, "name"));
  }

  private Node convertNewExpression(JsonObject node, SourceLocation loc) throws ParseError {
    List<Expression> arguments;
    if (hasChild(node, "arguments")) arguments = convertChildren(node, "arguments");
    else arguments = new ArrayList<>();
    List<ITypeExpression> typeArguments = convertChildrenAsTypes(node, "typeArguments");
    NewExpression result =
        new NewExpression(loc, convertChild(node, "expression"), typeArguments, arguments);
    attachResolvedSignature(result, node);
    return result;
  }

  private Node convertNonNullExpression(JsonObject node, SourceLocation loc) throws ParseError {
    return new NonNullAssertion(loc, convertChild(node, "expression"));
  }

  private Node convertNoSubstitutionTemplateLiteral(JsonObject node, SourceLocation loc) {
    List<TemplateElement> quasis = new ArrayList<>();
    TemplateElement elm =
        new TemplateElement(
            loc,
            node.get("text").getAsString(),
            loc.getSource().substring(1, loc.getSource().length() - 1),
            true);
    quasis.add(elm);
    attachStaticType(elm, node);
    return new TemplateLiteral(loc, new ArrayList<>(), quasis);
  }

  private Node convertNullKeyword(SourceLocation loc) {
    return new Literal(loc, TokenType._null, null);
  }

  private Node convertObjectBindingPattern(JsonObject node, SourceLocation loc) throws ParseError {
    List<Property> properties = new ArrayList<>();
    for (JsonElement elt : node.get("elements").getAsJsonArray()) {
      JsonObject element = elt.getAsJsonObject();
      SourceLocation eltLoc = getSourceLocation(element);
      Expression propKey =
          hasChild(element, "propertyName")
              ? convertChild(element, "propertyName")
              : convertChild(element, "name");
      Expression propVal;
      if (hasChild(element, "dotDotDotToken")) {
        propVal = new RestElement(eltLoc, propKey);
      } else if (hasChild(element, "initializer")) {
        propVal =
            new AssignmentPattern(
                eltLoc, "=", convertChild(element, "name"), convertChild(element, "initializer"));
      } else {
        propVal = convertChild(element, "name");
      }
      properties.add(
          new Property(
              eltLoc, propKey, propVal, "init", hasComputedName(element, "propertyName"), false));
    }
    return new ObjectPattern(loc, properties);
  }

  private Node convertObjectLiteralExpression(JsonObject node, SourceLocation loc)
      throws ParseError {
    List<Property> properties;
    properties = new ArrayList<Property>();
    for (INode e : convertChildren(node, "properties")) {
      if (e instanceof SpreadElement) {
        properties.add(
            new Property(
                e.getLoc(), null, (Expression) e, Property.Kind.INIT.name(), false, false));
      } else if (e instanceof MethodDefinition) {
        MethodDefinition md = (MethodDefinition) e;
        Property.Kind kind = Property.Kind.INIT;
        if (md.getKind() == Kind.GET) {
          kind = Property.Kind.GET;
        } else if (md.getKind() == Kind.SET) {
          kind = Property.Kind.SET;
        }
        properties.add(
            new Property(
                e.getLoc(), md.getKey(), md.getValue(), kind.name(), md.isComputed(), true));
      } else {
        properties.add((Property) e);
      }
    }
    return new ObjectExpression(loc, properties);
  }

  private Node convertOmittedExpression() {
    return null;
  }

  private Node convertOptionalType(JsonObject node, SourceLocation loc) throws ParseError {
    return new OptionalTypeExpr(loc, convertChildAsType(node, "type"));
  }

  private ITypeExpression asType(Node node) {
    return node instanceof ITypeExpression ? (ITypeExpression) node : null;
  }

  private List<ITypeExpression> convertChildrenAsTypes(JsonObject node, String child)
      throws ParseError {
    List<ITypeExpression> result = new ArrayList<>();
    JsonElement children = node.get(child);
    if (!(children instanceof JsonArray)) return result;
    for (JsonElement childNode : children.getAsJsonArray()) {
      ITypeExpression type = asType(convertNode(childNode.getAsJsonObject()));
      if (type != null) result.add(type);
    }
    return result;
  }

  private ITypeExpression convertChildAsType(JsonObject node, String child) throws ParseError {
    return asType(convertChild(node, child));
  }

  /** True if the given node is an Identifier node. */
  private boolean isIdentifier(JsonElement node) {
    if (node == null) return false;
    JsonObject object = node.getAsJsonObject();
    if (object == null) return false;
    String kind = getKind(object);
    return kind == null || kind.equals("Identifier");
  }

  /**
   * Returns true if this is the JSON object for the special "this" parameter.
   *
   * <p>It should be given the JSON object of kind "Parameter".
   */
  private boolean isThisParameter(JsonElement parameter) {
    JsonObject name = parameter.getAsJsonObject().get("name").getAsJsonObject();
    return isIdentifier(name) && getIdentifierText(name).equals("this");
  }

  /**
   * Returns the parameters of the given function, omitting the special "this" parameter, which we
   * do not consider to be a proper parameter.
   */
  private Iterable<JsonElement> getProperParameters(JsonObject function) {
    if (!function.has("parameters")) return Collections.emptyList();
    JsonArray parameters = function.get("parameters").getAsJsonArray();
    if (parameters.size() > 0 && isThisParameter(parameters.get(0))) {
      return CollectionUtil.skipIterable(parameters, 1);
    } else {
      return parameters;
    }
  }

  /**
   * Returns the special "this" parameter of the given function, or {@code null} if the function
   * does not declare a "this" parameter.
   */
  private ITypeExpression convertThisParameterType(JsonObject function) throws ParseError {
    if (!function.has("parameters")) return null;
    JsonArray parameters = function.get("parameters").getAsJsonArray();
    if (parameters.size() > 0 && isThisParameter(parameters.get(0))) {
      return convertChildAsType(parameters.get(0).getAsJsonObject(), "type");
    } else {
      return null;
    }
  }

  private List<Expression> convertParameters(JsonObject function) throws ParseError {
    return convertNodes(getProperParameters(function), true);
  }

  private List<ITypeExpression> convertParameterTypes(JsonObject function) throws ParseError {
    List<ITypeExpression> result = new ArrayList<>();
    for (JsonElement param : getProperParameters(function)) {
      result.add(convertChildAsType(param.getAsJsonObject(), "type"));
    }
    return result;
  }

  private IntList getOptionalParameterIndices(JsonObject function) throws ParseError {
    IntList list = IntList.create(0);
    int index = -1;
    for (JsonElement param : getProperParameters(function)) {
      ++index;
      if (param.getAsJsonObject().has("questionToken")) {
        list.add(index);
      }
    }
    return list;
  }

  private List<FieldDefinition> convertParameterFields(JsonObject function) throws ParseError {
    List<FieldDefinition> result = new ArrayList<>();
    int index = -1;
    for (JsonElement paramElm : getProperParameters(function)) {
      ++index;
      JsonObject param = paramElm.getAsJsonObject();
      int flags = getMemberModifierKeywords(param);
      if (flags == DeclarationFlags.none) {
        // If there are no flags, this is not a field parameter.
        continue;
      }
      // We generate a synthetic field node, but do not copy any of the AST nodes from
      // the parameter. The QL library overrides accessors to the name and type
      // annotation to return those from the corresponding parameter.
      SourceLocation loc = getSourceLocation(param);
      if (param.has("initializer")) {
        // Do not include the default parameter value in the source range for the field.
        SourceLocation endLoc;
        if (param.has("type")) {
          endLoc = getSourceLocation(param.get("type").getAsJsonObject());
        } else {
          endLoc = getSourceLocation(param.get("name").getAsJsonObject());
        }
        loc.setEnd(endLoc.getEnd());
        loc.setSource(source.substring(loc.getStart().getOffset(), loc.getEnd().getOffset()));
      }
      FieldDefinition field = new FieldDefinition(loc, flags, null, null, null, index);
      result.add(field);
    }
    return result;
  }

  private Node convertParameter(JsonObject node, SourceLocation loc) throws ParseError {
    // Note that type annotations are not extracted in this function, but in a
    // separate pass in convertParameterTypes above.
    Expression name = convertChild(node, "name", "Identifier");
    if (hasChild(node, "dotDotDotToken")) return new RestElement(loc, name);
    if (hasChild(node, "initializer"))
      return new AssignmentPattern(loc, "=", name, convertChild(node, "initializer"));
    return name;
  }

  private Node convertParenthesizedExpression(JsonObject node, SourceLocation loc)
      throws ParseError {
    return new ParenthesizedExpression(loc, convertChild(node, "expression"));
  }

  private Node convertParenthesizedType(JsonObject node, SourceLocation loc) throws ParseError {
    return new ParenthesizedTypeExpr(loc, convertChildAsType(node, "type"));
  }

  private Node convertPostfixUnaryExpression(JsonObject node, SourceLocation loc)
      throws ParseError {
    String operator = getOperator(node);
    return new UpdateExpression(loc, operator, convertChild(node, "operand"), false);
  }

  private Node convertPrefixUnaryExpression(JsonObject node, SourceLocation loc) throws ParseError {
    String operator = getOperator(node);
    if ("++".equals(operator) || "--".equals(operator))
      return new UpdateExpression(loc, operator, convertChild(node, "operand"), true);
    else return new UnaryExpression(loc, operator, convertChild(node, "operand"), true);
  }

  private String getOperator(JsonObject node) throws ParseError {
    int operatorId = node.get("operator").getAsInt();
    switch (metadata.getSyntaxKindName(operatorId)) {
      case "PlusPlusToken":
        return "++";
      case "MinusMinusToken":
        return "--";
      case "PlusToken":
        return "+";
      case "MinusToken":
        return "-";
      case "TildeToken":
        return "~";
      case "ExclamationToken":
        return "!";
      default:
        throw new ParseError(
            "Unsupported TypeScript operator " + operatorId, getSourceLocation(node).getStart());
    }
  }

  private Node convertPropertyAccessExpression(JsonObject node, SourceLocation loc)
      throws ParseError {
    Expression base = convertChild(node, "expression");
    boolean optional = node.has("questionDotToken");
    boolean onOptionalChain = Chainable.isOnOptionalChain(optional, base);
    return new MemberExpression(
        loc, base, convertChild(node, "name"), false, optional, onOptionalChain);
  }

  private Node convertPropertyAssignment(JsonObject node, SourceLocation loc) throws ParseError {
    return new Property(
        loc,
        convertChild(node, "name"),
        convertChild(node, "initializer"),
        "init",
        hasComputedName(node),
        false);
  }

  private Node convertPropertyDeclaration(JsonObject node, String kind, SourceLocation loc)
      throws ParseError {
    int flags = getMemberModifierKeywords(node);
    if (hasComputedName(node)) {
      flags |= DeclarationFlags.computed;
    }
    if (kind.equals("PropertySignature")) {
      flags |= DeclarationFlags.abstract_;
    }
    if (node.get("questionToken") != null) {
      flags |= DeclarationFlags.optional;
    }
    if (node.get("exclamationToken") != null) {
      flags |= DeclarationFlags.definiteAssignmentAssertion;
    }
    if (hasModifier(node, "DeclareKeyword")) {
      flags |= DeclarationFlags.declareKeyword;
    }
    FieldDefinition fieldDefinition =
        new FieldDefinition(
            loc,
            flags,
            convertChild(node, "name"),
            convertChild(node, "initializer"),
            convertChildAsType(node, "type"));
    if (node.has("decorators")) {
      fieldDefinition.addDecorators(convertChildren(node, "decorators"));
      advanceUntilAfter(loc, fieldDefinition.getDecorators());
    }
    return fieldDefinition;
  }

  private Node convertRegularExpressionLiteral(SourceLocation loc) {
    return new Literal(loc, TokenType.regexp, null);
  }

  private Node convertRestType(JsonObject node, SourceLocation loc) throws ParseError {
    return new RestTypeExpr(loc, convertChild(node, "type"));
  }

  private Node convertQualifiedName(JsonObject node, SourceLocation loc) throws ParseError {
    MemberExpression expr =
        new MemberExpression(
            loc, convertChild(node, "left"), convertChild(node, "right"), false, false, false);
    attachSymbolInformation(expr, node);
    return expr;
  }

  private Node convertReturnStatement(JsonObject node, SourceLocation loc) throws ParseError {
    return new ReturnStatement(loc, convertChild(node, "expression"));
  }

  private Node convertSemicolonClassElement() {
    return null;
  }

  private Node convertSourceFile(JsonObject node, SourceLocation loc) throws ParseError {
    List<Statement> statements = convertNodes(node.get("statements").getAsJsonArray());
    Program program = new Program(loc, statements, "module");
    attachSymbolInformation(program, node);
    return program;
  }

  private Node convertShorthandPropertyAssignment(JsonObject node, SourceLocation loc)
      throws ParseError {
    return new Property(
        loc, convertChild(node, "name"), convertChild(node, "name"), "init", false, false);
  }

  private Node convertSpreadElement(JsonObject node, SourceLocation loc) throws ParseError {
    return new SpreadElement(loc, convertChild(node, "expression"));
  }

  private Node convertStringLiteral(JsonObject node, SourceLocation loc) {
    return new Literal(loc, TokenType.string, node.get("text").getAsString());
  }

  private Node convertSuperKeyword(SourceLocation loc) {
    return new Super(loc);
  }

  private Node convertSwitchStatement(JsonObject node, SourceLocation loc) throws ParseError {
    JsonObject caseBlock = node.get("caseBlock").getAsJsonObject();
    return new SwitchStatement(
        loc, convertChild(node, "expression"), convertChildren(caseBlock, "clauses"));
  }

  private Node convertTaggedTemplateExpression(JsonObject node, SourceLocation loc)
      throws ParseError {
    return new TaggedTemplateExpression(
        loc,
        convertChild(node, "tag"),
        convertChild(node, "template"),
        convertChildrenAsTypes(node, "typeArguments"));
  }

  private Node convertTemplateExpression(JsonObject node, SourceLocation loc) throws ParseError {
    List<TemplateElement> quasis;
    List<Expression> expressions = new ArrayList<>();
    quasis = new ArrayList<>();
    quasis.add(convertChild(node, "head"));
    for (JsonElement elt : node.get("templateSpans").getAsJsonArray()) {
      JsonObject templateSpan = (JsonObject) elt;
      expressions.add(convertChild(templateSpan, "expression"));
      quasis.add(convertChild(templateSpan, "literal"));
    }
    return new TemplateLiteral(loc, expressions, quasis);
  }

  private Node convertTemplateLiteralType(JsonObject node, SourceLocation loc) throws ParseError {
    List<TemplateElement> quasis;
    List<ITypeExpression> expressions = new ArrayList<>();
    quasis = new ArrayList<>();
    quasis.add(convertChild(node, "head"));
    for (JsonElement elt : node.get("templateSpans").getAsJsonArray()) {
      JsonObject templateSpan = (JsonObject) elt;
      expressions.add(convertChildAsType(templateSpan, "type"));
      quasis.add(convertChild(templateSpan, "literal"));
    }
    return new TemplateLiteralTypeExpr(loc, expressions, quasis);
  }

  private Node convertTemplateElement(JsonObject node, String kind, SourceLocation loc) {
    boolean tail = "TemplateTail".equals(kind);
    if (loc.getSource().startsWith("`") || loc.getSource().startsWith("}")) {
      loc.setSource(loc.getSource().substring(1));
      Position start = loc.getStart();
      loc.setStart(new Position(start.getLine(), start.getColumn() + 1, start.getColumn() + 1));
    }
    if (loc.getSource().endsWith("${")) {
      loc.setSource(loc.getSource().substring(0, loc.getSource().length() - 2));
      Position end = loc.getEnd();
      loc.setEnd(new Position(end.getLine(), end.getColumn() - 2, end.getColumn() - 2));
    }
    if (loc.getSource().endsWith("`")) {
      loc.setSource(loc.getSource().substring(0, loc.getSource().length() - 1));
      Position end = loc.getEnd();
      loc.setEnd(new Position(end.getLine(), end.getColumn() - 1, end.getColumn() - 1));
    }
    return new TemplateElement(loc, node.get("text").getAsString(), loc.getSource(), tail);
  }

  private Node convertThisKeyword(SourceLocation loc) {
    return new ThisExpression(loc);
  }

  private Node convertThrowStatement(JsonObject node, SourceLocation loc) throws ParseError {
    Expression expr = convertChild(node, "expression");
    if (expr == null) return convertEmptyStatement(loc);
    return new ThrowStatement(loc, expr);
  }

  private Node convertTrueKeyword(SourceLocation loc) {
    return new Literal(loc, TokenType._true, true);
  }

  private Node convertTryStatement(JsonObject node, SourceLocation loc) throws ParseError {
    return new TryStatement(
        loc,
        convertChild(node, "tryBlock"),
        convertChild(node, "catchClause"),
        null,
        convertChild(node, "finallyBlock"));
  }

  private Node convertTupleType(JsonObject node, SourceLocation loc) throws ParseError {
    List<Identifier> names = new ArrayList<>();

    for (JsonElement element : node.get("elements").getAsJsonArray()) {
      Identifier id = null;
      if (getKind(element).equals("NamedTupleMember")) {
        id = (Identifier)convertNode(element.getAsJsonObject().get("name").getAsJsonObject());
      }
      names.add(id);
    }

    return new TupleTypeExpr(loc, convertChildrenAsTypes(node, "elements"), names);
  }

  // This method just does a trivial forward to the type. The names have already been extracted in `convertTupleType`.
  private Node convertNamedTupleMember(JsonObject node, SourceLocation loc) throws ParseError {
    return convertChild(node, "type");
  }

  private Node convertTypeAliasDeclaration(JsonObject node, SourceLocation loc) throws ParseError {
    TypeAliasDeclaration typeAlias =
        new TypeAliasDeclaration(
            loc,
            convertChild(node, "name"),
            convertChildrenNotNull(node, "typeParameters"),
            convertChildAsType(node, "type"));
    attachSymbolInformation(typeAlias, node);
    return fixExports(loc, typeAlias);
  }

  private Node convertTypeAssertionExpression(JsonObject node, SourceLocation loc)
      throws ParseError {
    ITypeExpression type = convertChildAsType(node, "type");
    // `T as const` is extracted as a cast to the keyword type `const`.
    if (type instanceof Identifier && ((Identifier) type).getName().equals("const")) {
      type = new KeywordTypeExpr(type.getLoc(), "const");
    }
    return new TypeAssertion(loc, convertChild(node, "expression"), type, false);
  }

  private Node convertTypeLiteral(JsonObject obj, SourceLocation loc) throws ParseError {
    return new InterfaceTypeExpr(loc, convertChildren(obj, "members"));
  }

  private Node convertTypeOfExpression(JsonObject node, SourceLocation loc) throws ParseError {
    return new UnaryExpression(loc, "typeof", convertChild(node, "expression"), true);
  }

  private Node convertTypeOperator(JsonObject node, SourceLocation loc) throws ParseError {
    String operator = metadata.getSyntaxKindName(node.get("operator").getAsInt());
    if (operator.equals("KeyOfKeyword")) {
      return new UnaryTypeExpr(loc, UnaryTypeExpr.Kind.KEYOF, convertChildAsType(node, "type"));
    }
    if (operator.equals("ReadonlyKeyword")) {
      return new UnaryTypeExpr(loc, UnaryTypeExpr.Kind.READONLY, convertChildAsType(node, "type"));
    }
    if (operator.equals("UniqueKeyword")) {
      return new KeywordTypeExpr(loc, "unique symbol");
    }
    throw new ParseError("Unsupported TypeScript syntax", loc.getStart());
  }

  private Node convertTypeParameter(JsonObject node, SourceLocation loc) throws ParseError {
    return new TypeParameter(
        loc,
        convertChild(node, "name"),
        convertChildAsType(node, "constraint"),
        convertChildAsType(node, "default"));
  }

  private Node convertTypePredicate(JsonObject node, SourceLocation loc) throws ParseError {
    return new PredicateTypeExpr(
        loc,
        convertChildAsType(node, "parameterName"),
        convertChildAsType(node, "type"),
        node.has("assertsModifier"));
  }

  private Node convertTypeReference(JsonObject node, SourceLocation loc) throws ParseError {
    ITypeExpression typeName = convertChild(node, "typeName");
    List<ITypeExpression> typeArguments = convertChildrenAsTypes(node, "typeArguments");
    if (typeArguments.isEmpty()) return (Node) typeName;
    return new GenericTypeExpr(loc, typeName, typeArguments);
  }

  private Node convertTypeQuery(JsonObject node, SourceLocation loc) throws ParseError {
    return new TypeofTypeExpr(loc, convertChildAsType(node, "exprName"));
  }

  private Node convertVariableDeclaration(JsonObject node, SourceLocation loc) throws ParseError {
    return new VariableDeclarator(
        loc,
        convertChild(node, "name"),
        convertChild(node, "initializer"),
        convertChildAsType(node, "type"),
        DeclarationFlags.getDefiniteAssignmentAssertion(node.get("exclamationToken") != null));
  }

  private Node convertVariableDeclarationList(JsonObject node, SourceLocation loc)
      throws ParseError {
    return new VariableDeclaration(
        loc, getDeclarationKind(node), convertVariableDeclarations(node), false);
  }

  private List<VariableDeclarator> convertVariableDeclarations(JsonObject node) throws ParseError {
    if (node.get("declarations").getAsJsonArray().size() == 0)
      throw new ParseError("Unexpected token", getSourceLocation(node).getEnd());
    return convertChildren(node, "declarations");
  }

  private Node convertVariableStatement(JsonObject node, SourceLocation loc) throws ParseError {
    JsonObject declarationList = node.get("declarationList").getAsJsonObject();
    String declarationKind = getDeclarationKind(declarationList);
    List<VariableDeclarator> declarations = convertVariableDeclarations(declarationList);
    boolean hasDeclareKeyword = hasModifier(node, "DeclareKeyword");
    VariableDeclaration vd =
        new VariableDeclaration(loc, declarationKind, declarations, hasDeclareKeyword);
    return fixExports(loc, vd);
  }

  private Node convertVoidExpression(JsonObject node, SourceLocation loc) throws ParseError {
    return new UnaryExpression(loc, "void", convertChild(node, "expression"), true);
  }

  private Node convertWhileStatement(JsonObject node, SourceLocation loc) throws ParseError {
    return new WhileStatement(
        loc, convertChild(node, "expression"), convertChild(node, "statement"));
  }

  private Node convertWithStatement(JsonObject node, SourceLocation loc) throws ParseError {
    return new WithStatement(
        loc, convertChild(node, "expression"), convertChild(node, "statement"));
  }

  private Node convertYieldExpression(JsonObject node, SourceLocation loc) throws ParseError {
    return new YieldExpression(
        loc, convertChild(node, "expression"), hasChild(node, "asteriskToken"));
  }

  /**
   * Convert {@code e} to an lvalue expression, replacing {@link ArrayExpression} with {@link
   * ArrayPattern}, {@link AssignmentExpression} with {@link AssignmentPattern}, {@link
   * ObjectExpression} with {@link ObjectPattern} and {@link SpreadElement} with {@link
   * RestElement}.
   */
  private Expression convertLValue(Expression e) throws ParseError {
    if (e == null) return null;

    SourceLocation loc = e.getLoc();
    if (e instanceof ArrayExpression) {
      List<Expression> elts = new ArrayList<Expression>();
      for (Expression elt : ((ArrayExpression) e).getElements()) elts.add(convertLValue(elt));
      return new ArrayPattern(loc, elts);
    }
    if (e instanceof AssignmentExpression) {
      AssignmentExpression a = (AssignmentExpression) e;
      return new AssignmentPattern(loc, a.getOperator(), convertLValue(a.getLeft()), a.getRight());
    }
    if (e instanceof ObjectExpression) {
      List<Property> props = new ArrayList<Property>();
      for (Property prop : ((ObjectExpression) e).getProperties()) {
        Expression key = prop.getKey();
        Expression rawValue = prop.getRawValue();
        String kind = prop.getKind().name();
        boolean isComputed = prop.isComputed();
        boolean isMethod = prop.isMethod();
        props.add(
            new Property(prop.getLoc(), key, convertLValue(rawValue), kind, isComputed, isMethod));
      }
      return new ObjectPattern(loc, props);
    }
    if (e instanceof ParenthesizedExpression)
      return new ParenthesizedExpression(
          loc, convertLValue(((ParenthesizedExpression) e).getExpression()));
    if (e instanceof SpreadElement) {
      Expression argument = convertLValue(((SpreadElement) e).getArgument());
      if (argument instanceof AssignmentPattern) {
        throw new ParseError(
            "Rest patterns cannot have a default value", argument.getLoc().getStart());
      }
      return new RestElement(e.getLoc(), argument);
    }
    return e;
  }

  /** Convert {@code e} to an {@link IJSXName}. */
  private IJSXName convertJSXName(Expression e) {
    if (e instanceof Identifier) return new JSXIdentifier(e.getLoc(), ((Identifier) e).getName());
    if (e instanceof MemberExpression) {
      MemberExpression me = (MemberExpression) e;
      return new JSXMemberExpression(
          e.getLoc(),
          convertJSXName(me.getObject()),
          (JSXIdentifier) convertJSXName(me.getProperty()));
    }
    if (e instanceof ThisExpression) return new JSXThisExpr(e.getLoc());
    return (IJSXName) e;
  }

  /**
   * Check whether {@code decl} has an {@code export} annotation, and if so wrap it inside an {@link
   * ExportDeclaration}.
   *
   * <p>If the declared statement has decorators, the {@code loc} should first be advanced past
   * these using {@link #advanceUntilAfter}.
   */
  private Node fixExports(SourceLocation loc, Node decl) {
    Matcher m = EXPORT_DECL_START.matcher(loc.getSource());
    if (m.find()) {
      String skipped = m.group(0);
      SourceLocation outerLoc = new SourceLocation(loc.getSource(), loc.getStart(), loc.getEnd());
      advance(loc, skipped);
      // capture group 1 is `default`, if present
      if (m.group(1) == null)
        return new ExportNamedDeclaration(outerLoc, (Statement) decl, new ArrayList<>(), null);
      return new ExportDefaultDeclaration(outerLoc, decl);
    }
    return decl;
  }

  /** Holds if the {@code name} property of the given AST node is a computed property name. */
  private boolean hasComputedName(JsonObject node) {
    return hasComputedName(node, "name");
  }

  /** Holds if the given property of the given AST node is a computed property name. */
  private boolean hasComputedName(JsonObject node, String propName) {
    return hasKind(node.get(propName), "ComputedPropertyName");
  }

  /**
   * Update the start position and source text of {@code loc} by skipping over the string {@code
   * skipped}.
   */
  private void advance(SourceLocation loc, String skipped) {
    loc.setStart(advance(loc.getStart(), skipped));
    loc.setSource(loc.getSource().substring(skipped.length()));
  }

  /**
   * Update the start position of @{code loc} by skipping over the given children and any following
   * whitespace and comments, provided they are contained in the source location.
   */
  private void advanceUntilAfter(SourceLocation loc, List<? extends INode> nodes) {
    if (nodes.isEmpty()) return;
    INode last = nodes.get(nodes.size() - 1);
    int offset = last.getLoc().getEnd().getOffset() - loc.getStart().getOffset();
    if (offset <= 0) return;
    offset += matchWhitespace(last.getLoc().getEnd().getOffset()).length();
    if (offset >= loc.getSource().length()) return;
    loc.setStart(advance(loc.getStart(), loc.getSource().substring(0, offset)));
    loc.setSource(loc.getSource().substring(offset));
  }

  /** Get the longest sequence of whitespace or comment characters starting at the given offset. */
  private String matchWhitespace(int offset) {
    Matcher m = WHITESPACE.matcher(source.substring(offset));
    m.find();
    return m.group(0);
  }

  /**
   * Create a position corresponding to {@code pos}, but updated by skipping over the string {@code
   * skipped}.
   */
  private Position advance(Position pos, String skipped) {
    int innerStartOffset = pos.getOffset() + skipped.length();
    int innerStartLine = pos.getLine(), innerStartColumn = pos.getColumn();
    Matcher m = LINE_TERMINATOR.matcher(skipped);
    int lastEnd = 0;
    while (m.find()) {
      ++innerStartLine;
      innerStartColumn = 1;
      lastEnd = m.end();
    }
    innerStartColumn += skipped.length() - lastEnd;
    if (lastEnd > 0) --innerStartColumn;
    Position innerStart = new Position(innerStartLine, innerStartColumn, innerStartOffset);
    return innerStart;
  }

  /** Get the source location of the given AST node. */
  private SourceLocation getSourceLocation(JsonObject node) {
    Position start = getPosition(node.get("$pos"));
    Position end = getPosition(node.get("$end"));
    int startOffset = start.getOffset();
    int endOffset = end.getOffset();
    if (startOffset > endOffset) startOffset = endOffset;
    if (endOffset > source.length()) endOffset = source.length();
    return new SourceLocation(source.substring(startOffset, endOffset), start, end);
  }

  /**
   * Convert the given position object into a {@link Position}. For start positions, we need to skip
   * over whitespace, which is included in the positions reported by the TypeScript compiler.
   */
  private Position getPosition(JsonElement elm) {
    int offset = elm.getAsInt();
    int line = getLineFromPos(offset);
    int column = getColumnFromLinePos(line, offset);
    return new Position(line + 1, column, offset);
  }

  private Iterable<JsonElement> getModifiers(JsonObject node) {
    JsonElement mods = node.get("modifiers");
    if (!(mods instanceof JsonArray)) return Collections.emptyList();
    return (JsonArray) mods;
  }

  /**
   * Returns a specific modifier from the given node (or <code>null</code> if absent), as defined by its
   * <code>modifiers</code> property and the <code>kind</code> property of the modifier AST node.
   */
  private JsonObject getModifier(JsonObject node, String modKind) {
    for (JsonElement mod : getModifiers(node))
      if (mod instanceof JsonObject)
        if (hasKind((JsonObject) mod, modKind)) return (JsonObject) mod;
    return null;
  }

  /**
   * Check whether a node has a particular modifier, as defined by its <code>modifiers</code> property
   * and the <code>kind</code> property of the modifier AST node.
   */
  private boolean hasModifier(JsonObject node, String modKind) {
    return getModifier(node, modKind) != null;
  }

  private int getDeclarationModifierFromKeyword(String kind) {
    switch (kind) {
      case "AbstractKeyword":
        return DeclarationFlags.abstract_;
      case "StaticKeyword":
        return DeclarationFlags.static_;
      case "ReadonlyKeyword":
        return DeclarationFlags.readonly;
      case "PublicKeyword":
        return DeclarationFlags.public_;
      case "PrivateKeyword":
        return DeclarationFlags.private_;
      case "ProtectedKeyword":
        return DeclarationFlags.protected_;
      default:
        return DeclarationFlags.none;
    }
  }

  /**
   * Returns the set of member flags corresponding to the modifier keywords present on the given
   * node.
   */
  private int getMemberModifierKeywords(JsonObject node) {
    int flags = DeclarationFlags.none;
    for (JsonElement mod : getModifiers(node)) {
      if (mod instanceof JsonObject) {
        JsonObject modObject = (JsonObject) mod;
        flags |= getDeclarationModifierFromKeyword(getKind(modObject));
      }
    }
    return flags;
  }

  /**
   * Check whether a node has a particular flag, as defined by its <code>flags</code> property and the
   * <code>ts.NodeFlags</code> in enum.
   */
  private boolean hasFlag(JsonObject node, String flagName) {
    int flagId = metadata.getNodeFlagId(flagName);
    JsonElement flags = node.get("flags");
    if (flags instanceof JsonPrimitive) {
      return (flags.getAsInt() & flagId) != 0;
    }
    return false;
  }

  /** Check whether a node has a child with a given name. */
  private boolean hasChild(JsonObject node, String prop) {
    if (!node.has(prop)) return false;
    return !(node.get(prop) instanceof JsonNull);
  }

  /**
   * Returns an iterator over the elements of the given child array, or an empty iterator if the
   * given child is not an array.
   */
  private Iterable<JsonElement> getChildIterable(JsonObject node, String child) {
    JsonElement elt = node.get(child);
    if (!(elt instanceof JsonArray)) return Collections.emptyList();
    return (JsonArray) elt;
  }

  /** Gets the kind of the given node. */
  private String getKind(JsonElement node) {
    if (node instanceof JsonObject) {
      JsonElement kind = ((JsonObject) node).get("kind");
      if (kind instanceof JsonPrimitive && ((JsonPrimitive) kind).isNumber())
        return metadata.getSyntaxKindName(kind.getAsInt());
    }
    return null;
  }

  /** Holds if the given node has the given kind. */
  private boolean hasKind(JsonElement node, String kind) {
    return kind.equals(getKind(node));
  }

  /**
   * Gets the declaration kind of the given node, which is one of {@code "var"}, {@code "let"} or
   * {@code "const"}.
   */
  private String getDeclarationKind(JsonObject declarationList) {
    return declarationList.get("$declarationKind").getAsString();
  }
}
