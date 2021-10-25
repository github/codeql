package com.semmle.js.ast;

import com.semmle.js.ast.jsx.IJSXAttribute;
import com.semmle.js.ast.jsx.IJSXExpression;
import com.semmle.js.ast.jsx.IJSXName;
import com.semmle.js.ast.jsx.JSXAttribute;
import com.semmle.js.ast.jsx.JSXBoundaryElement;
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
import com.semmle.ts.ast.TypeExpression;
import com.semmle.ts.ast.TypeParameter;
import com.semmle.ts.ast.TypeofTypeExpr;
import com.semmle.ts.ast.UnaryTypeExpr;
import com.semmle.ts.ast.UnionTypeExpr;
import com.semmle.util.exception.CatastrophicError;

/**
 * A convenience implementation of {@link Visitor} that provides default implementations of all
 * visitor methods, and catch-all methods for treating similar classes of AST nodes.
 */
public class DefaultVisitor<C, R> implements Visitor<C, R> {
  public R visit(Node nd, C c) {
    return null;
  }

  public R visit(Expression nd, C c) {
    return visit((Node) nd, c);
  }

  public R visit(Statement nd, C c) {
    return visit((Node) nd, c);
  }

  /** Default visitor for type expressions that are not also expressions. */
  public R visit(TypeExpression nd, C c) {
    return visit((Node) nd, c);
  }

  public R visit(EnhancedForStatement nd, C c) {
    return visit((Loop) nd, c);
  }

  public R visit(InvokeExpression nd, C c) {
    return visit((Expression) nd, c);
  }

  public R visit(Loop nd, C c) {
    return visit((Statement) nd, c);
  }

  public R visit(IFunction nd, C c) {
    if (nd instanceof Statement) return visit((Statement) nd, c);
    else return visit((Expression) nd, c);
  }

  @Override
  public R visit(AngularPipeRef nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(AssignmentExpression nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(AssignmentPattern nd, C c) {
    // assignment patterns should not appear in the AST, but can do for malformed
    // programs; the ASTExtractor raises a ParseError in this case, other visitors
    // should just ignore them
    return visit(nd.getLeft(), c);
  }

  @Override
  public R visit(BinaryExpression nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(BlockStatement nd, C c) {
    return visit((Statement) nd, c);
  }

  @Override
  public R visit(CallExpression nd, C c) {
    return visit((InvokeExpression) nd, c);
  }

  @Override
  public R visit(ComprehensionBlock nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(ComprehensionExpression nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(ExpressionStatement nd, C c) {
    return visit((Statement) nd, c);
  }

  @Override
  public R visit(FunctionDeclaration nd, C c) {
    return visit((IFunction) nd, c);
  }

  @Override
  public R visit(Identifier nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(Literal nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(LogicalExpression nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(MemberExpression nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(Program nd, C c) {
    return visit((Node) nd, c);
  }

  @Override
  public R visit(RestElement nd, C q) {
    throw new CatastrophicError("Rest elements should not appear in the AST.");
  }

  @Override
  public R visit(UnaryExpression nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(UpdateExpression nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(VariableDeclaration nd, C c) {
    return visit((Statement) nd, c);
  }

  @Override
  public R visit(VariableDeclarator nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(SwitchStatement nd, C c) {
    return visit((Statement) nd, c);
  }

  @Override
  public R visit(SwitchCase nd, C c) {
    return visit((Statement) nd, c);
  }

  @Override
  public R visit(ForStatement nd, C c) {
    return visit((Loop) nd, c);
  }

  @Override
  public R visit(ForInStatement nd, C c) {
    return visit((EnhancedForStatement) nd, c);
  }

  @Override
  public R visit(ForOfStatement nd, C c) {
    return visit((EnhancedForStatement) nd, c);
  }

  @Override
  public R visit(Property nd, C c) {
    return visit((Node) nd, c);
  }

  @Override
  public R visit(ArrayPattern nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(IfStatement nd, C c) {
    return visit((Statement) nd, c);
  }

  @Override
  public R visit(LabeledStatement nd, C c) {
    return visit((Statement) nd, c);
  }

  @Override
  public R visit(ObjectPattern nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(WithStatement nd, C c) {
    return visit((Statement) nd, c);
  }

  @Override
  public R visit(DoWhileStatement nd, C c) {
    return visit((Loop) nd, c);
  }

  @Override
  public R visit(WhileStatement nd, C c) {
    return visit((Loop) nd, c);
  }

  @Override
  public R visit(CatchClause nd, C c) {
    return visit((Statement) nd, c);
  }

  @Override
  public R visit(TryStatement nd, C c) {
    return visit((Statement) nd, c);
  }

  @Override
  public R visit(NewExpression nd, C c) {
    return visit((InvokeExpression) nd, c);
  }

  @Override
  public R visit(ReturnStatement nd, C c) {
    return visit((Statement) nd, c);
  }

  @Override
  public R visit(ThrowStatement nd, C c) {
    return visit((Statement) nd, c);
  }

  @Override
  public R visit(SpreadElement nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(YieldExpression nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(ParenthesizedExpression nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(EmptyStatement nd, C c) {
    return visit((Statement) nd, c);
  }

  public R visit(JumpStatement nd, C c) {
    return visit((Statement) nd, c);
  }

  @Override
  public R visit(BreakStatement nd, C c) {
    return visit((JumpStatement) nd, c);
  }

  @Override
  public R visit(ContinueStatement nd, C c) {
    return visit((JumpStatement) nd, c);
  }

  public R visit(AFunctionExpression nd, C c) {
    return visit((IFunction) nd, c);
  }

  @Override
  public R visit(FunctionExpression nd, C c) {
    return visit((AFunctionExpression) nd, c);
  }

  @Override
  public R visit(ArrowFunctionExpression nd, C c) {
    return visit((AFunctionExpression) nd, c);
  }

  @Override
  public R visit(DebuggerStatement nd, C c) {
    return visit((Statement) nd, c);
  }

  @Override
  public R visit(ArrayExpression nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(ObjectExpression nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(ThisExpression nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(ConditionalExpression nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(SequenceExpression nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(TemplateElement nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(TemplateLiteral nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(TemplateLiteralTypeExpr nd, C c) {
    return visit((TypeExpression) nd, c);
  }

  @Override
  public R visit(TaggedTemplateExpression nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(LetStatement nd, C c) {
    return visit((Statement) nd, c);
  }

  @Override
  public R visit(LetExpression nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(ClassDeclaration nd, C c) {
    return visit((Statement) nd, c);
  }

  @Override
  public R visit(ClassExpression nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(ClassBody nd, C c) {
    return visit((Node) nd, c);
  }

  public R visit(MemberDefinition<?> nd, C c) {
    return visit((Node) nd, c);
  }

  @Override
  public R visit(MethodDefinition nd, C c) {
    return visit((MemberDefinition<FunctionExpression>) nd, c);
  }

  @Override
  public R visit(FieldDefinition nd, C c) {
    return visit((MemberDefinition<Expression>) nd, c);
  }

  @Override
  public R visit(Super nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(MetaProperty nd, C c) {
    return visit((Expression) nd, c);
  }

  public R visit(ExportDeclaration nd, C c) {
    return visit((Statement) nd, c);
  }

  @Override
  public R visit(ExportAllDeclaration nd, C c) {
    return visit((ExportDeclaration) nd, c);
  }

  @Override
  public R visit(ExportDefaultDeclaration nd, C c) {
    return visit((ExportDeclaration) nd, c);
  }

  @Override
  public R visit(ExportNamedDeclaration nd, C c) {
    return visit((ExportDeclaration) nd, c);
  }

  @Override
  public R visit(ExportSpecifier nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(ExportDefaultSpecifier nd, C c) {
    return visit((ExportSpecifier) nd, c);
  }

  @Override
  public R visit(ExportNamespaceSpecifier nd, C c) {
    return visit((ExportSpecifier) nd, c);
  }

  @Override
  public R visit(ImportDeclaration nd, C c) {
    return visit((Statement) nd, c);
  }

  @Override
  public R visit(ImportDefaultSpecifier nd, C c) {
    return visit((ImportSpecifier) nd, c);
  }

  @Override
  public R visit(ImportNamespaceSpecifier nd, C c) {
    return visit((ImportSpecifier) nd, c);
  }

  @Override
  public R visit(ImportSpecifier nd, C c) {
    return visit((Expression) nd, c);
  }

  public R visit(IJSXAttribute nd, C c) {
    return visit((Node) nd, c);
  }

  @Override
  public R visit(JSXAttribute nd, C c) {
    return visit((IJSXAttribute) nd, c);
  }

  @Override
  public R visit(JSXSpreadAttribute nd, C c) {
    return visit((IJSXAttribute) nd, c);
  }

  public R visit(IJSXName nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(JSXIdentifier nd, C c) {
    return visit((IJSXName) nd, c);
  }

  @Override
  public R visit(JSXThisExpr nd, C c) {
    return visit((IJSXName) nd, c);
  }

  @Override
  public R visit(JSXMemberExpression nd, C c) {
    return visit((IJSXName) nd, c);
  }

  @Override
  public R visit(JSXNamespacedName nd, C c) {
    return visit((IJSXName) nd, c);
  }

  public R visit(IJSXExpression nd, C c) {
    return visit((Node) nd, c);
  }

  @Override
  public R visit(JSXEmptyExpression nd, C c) {
    return visit((IJSXExpression) nd, c);
  }

  @Override
  public R visit(JSXExpressionContainer nd, C c) {
    return visit((IJSXExpression) nd, c);
  }

  public R visit(JSXBoundaryElement nd, C c) {
    return visit((Node) nd, c);
  }

  @Override
  public R visit(JSXOpeningElement nd, C c) {
    return visit((JSXBoundaryElement) nd, c);
  }

  @Override
  public R visit(JSXClosingElement nd, C c) {
    return visit((JSXBoundaryElement) nd, c);
  }

  @Override
  public R visit(JSXElement nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(AwaitExpression nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(Decorator nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(BindExpression nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(NamespaceDeclaration nd, C c) {
    return visit((Statement) nd, c);
  }

  @Override
  public R visit(ImportWholeDeclaration nd, C c) {
    return visit((Statement) nd, c);
  }

  @Override
  public R visit(ExportWholeDeclaration nd, C c) {
    return visit((Statement) nd, c);
  }

  @Override
  public R visit(ExternalModuleReference nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(DynamicImport nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(InterfaceDeclaration nd, C c) {
    return visit((Statement) nd, c);
  }

  @Override
  public R visit(KeywordTypeExpr nd, C c) {
    return visit((TypeExpression) nd, c);
  }

  @Override
  public R visit(ArrayTypeExpr nd, C c) {
    return visit((TypeExpression) nd, c);
  }

  @Override
  public R visit(UnionTypeExpr nd, C c) {
    return visit((TypeExpression) nd, c);
  }

  @Override
  public R visit(IndexedAccessTypeExpr nd, C c) {
    return visit((TypeExpression) nd, c);
  }

  @Override
  public R visit(IntersectionTypeExpr nd, C c) {
    return visit((TypeExpression) nd, c);
  }

  @Override
  public R visit(ParenthesizedTypeExpr nd, C c) {
    return visit((TypeExpression) nd, c);
  }

  @Override
  public R visit(TupleTypeExpr nd, C c) {
    return visit((TypeExpression) nd, c);
  }

  @Override
  public R visit(UnaryTypeExpr nd, C c) {
    return visit((TypeExpression) nd, c);
  }

  @Override
  public R visit(GenericTypeExpr nd, C c) {
    return visit((TypeExpression) nd, c);
  }

  @Override
  public R visit(TypeofTypeExpr nd, C c) {
    return visit((TypeExpression) nd, c);
  }

  @Override
  public R visit(PredicateTypeExpr nd, C c) {
    return visit((TypeExpression) nd, c);
  }

  @Override
  public R visit(InterfaceTypeExpr nd, C c) {
    return visit((TypeExpression) nd, c);
  }

  @Override
  public R visit(ExpressionWithTypeArguments nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(TypeParameter nd, C c) {
    return visit((TypeExpression) nd, c);
  }

  @Override
  public R visit(FunctionTypeExpr nd, C c) {
    return visit((TypeExpression) nd, c);
  }

  @Override
  public R visit(TypeAssertion nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(MappedTypeExpr nd, C c) {
    return visit((TypeExpression) nd, c);
  }

  @Override
  public R visit(TypeAliasDeclaration nd, C c) {
    return visit((Statement) nd, c);
  }

  @Override
  public R visit(EnumDeclaration nd, C c) {
    return visit((Statement) nd, c);
  }

  @Override
  public R visit(EnumMember nd, C c) {
    return visit((Node) nd, c);
  }

  @Override
  public R visit(DecoratorList nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(ExternalModuleDeclaration nd, C c) {
    return visit((Statement) nd, c);
  }

  @Override
  public R visit(ExportAsNamespaceDeclaration nd, C c) {
    return visit((Statement) nd, c);
  }

  @Override
  public R visit(GlobalAugmentationDeclaration nd, C c) {
    return visit((Statement) nd, c);
  }

  @Override
  public R visit(NonNullAssertion nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(ConditionalTypeExpr nd, C c) {
    return visit((TypeExpression) nd, c);
  }

  @Override
  public R visit(InferTypeExpr nd, C c) {
    return visit((TypeExpression) nd, c);
  }

  @Override
  public R visit(ImportTypeExpr nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(OptionalTypeExpr nd, C c) {
    return visit((TypeExpression) nd, c);
  }

  @Override
  public R visit(RestTypeExpr nd, C c) {
    return visit((TypeExpression) nd, c);
  }

  @Override
  public R visit(XMLAnyName nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(XMLAttributeSelector nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(XMLFilterExpression nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(XMLQualifiedIdentifier nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(XMLDotDotExpression nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(GeneratedCodeExpr nd, C c) {
    return visit((Expression) nd, c);
  }

  @Override
  public R visit(StaticInitializer nd, C c) {
    return visit((MemberDefinition<BlockStatement>) nd, c);
  }
}
