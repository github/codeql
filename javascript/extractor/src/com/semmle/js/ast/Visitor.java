package com.semmle.js.ast;

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
import com.semmle.ts.ast.TypeParameter;
import com.semmle.ts.ast.TypeofTypeExpr;
import com.semmle.ts.ast.UnaryTypeExpr;
import com.semmle.ts.ast.UnionTypeExpr;

/**
 * Interface for visitors to implement.
 *
 * <p>Visit methods take a context argument of type {@link C} and return a result of type {@link R}.
 */
public interface Visitor<C, R> {
  public R visit(AngularPipeRef nd, C q);

  public R visit(AssignmentExpression nd, C q);

  public R visit(AssignmentPattern nd, C q);

  public R visit(BinaryExpression nd, C q);

  public R visit(BlockStatement nd, C q);

  public R visit(CallExpression nd, C q);

  public R visit(ComprehensionBlock nd, C q);

  public R visit(ComprehensionExpression nd, C q);

  public R visit(ExpressionStatement nd, C q);

  public R visit(FunctionDeclaration nd, C q);

  public R visit(Identifier nd, C q);

  public R visit(Literal nd, C q);

  public R visit(LogicalExpression nd, C q);

  public R visit(MemberExpression nd, C q);

  public R visit(Program nd, C q);

  public R visit(UnaryExpression nd, C q);

  public R visit(UpdateExpression nd, C q);

  public R visit(VariableDeclaration nd, C q);

  public R visit(VariableDeclarator nd, C q);

  public R visit(SwitchStatement nd, C q);

  public R visit(SwitchCase nd, C q);

  public R visit(ForStatement nd, C q);

  public R visit(ForInStatement nd, C q);

  public R visit(ForOfStatement nd, C q);

  public R visit(Property nd, C q);

  public R visit(ArrayPattern nd, C q);

  public R visit(ObjectPattern nd, C q);

  public R visit(IfStatement nd, C q);

  public R visit(LabeledStatement nd, C q);

  public R visit(WithStatement nd, C q);

  public R visit(DoWhileStatement nd, C q);

  public R visit(WhileStatement nd, C q);

  public R visit(CatchClause nd, C q);

  public R visit(TryStatement nd, C q);

  public R visit(NewExpression nd, C q);

  public R visit(ReturnStatement nd, C q);

  public R visit(ThrowStatement nd, C q);

  public R visit(SpreadElement nd, C q);

  public R visit(RestElement nd, C q);

  public R visit(YieldExpression nd, C q);

  public R visit(ParenthesizedExpression nd, C q);

  public R visit(EmptyStatement nd, C q);

  public R visit(BreakStatement nd, C q);

  public R visit(ContinueStatement nd, C q);

  public R visit(FunctionExpression nd, C q);

  public R visit(DebuggerStatement nd, C q);

  public R visit(ArrayExpression nd, C q);

  public R visit(ObjectExpression nd, C q);

  public R visit(ThisExpression nd, C q);

  public R visit(ConditionalExpression nd, C q);

  public R visit(SequenceExpression nd, C q);

  public R visit(TemplateElement nd, C q);

  public R visit(TemplateLiteral nd, C q);

  public R visit(TemplateLiteralTypeExpr nd, C q);

  public R visit(TaggedTemplateExpression nd, C q);

  public R visit(ArrowFunctionExpression nd, C q);

  public R visit(LetStatement nd, C q);

  public R visit(LetExpression nd, C c);

  public R visit(ClassDeclaration nd, C c);

  public R visit(ClassExpression nd, C c);

  public R visit(ClassBody nd, C c);

  public R visit(MethodDefinition nd, C c);

  public R visit(FieldDefinition nd, C c);

  public R visit(Super nd, C c);

  public R visit(MetaProperty nd, C c);

  public R visit(ExportAllDeclaration nd, C c);

  public R visit(ExportDefaultDeclaration nd, C c);

  public R visit(ExportNamedDeclaration nd, C c);

  public R visit(ExportDefaultSpecifier nd, C c);

  public R visit(ExportNamespaceSpecifier nd, C c);

  public R visit(ExportSpecifier nd, C c);

  public R visit(ImportDeclaration nd, C c);

  public R visit(ImportDefaultSpecifier nd, C c);

  public R visit(ImportNamespaceSpecifier nd, C c);

  public R visit(ImportSpecifier nd, C c);

  public R visit(JSXIdentifier nd, C c);

  public R visit(JSXThisExpr nd, C c);

  public R visit(JSXMemberExpression nd, C c);

  public R visit(JSXNamespacedName nd, C c);

  public R visit(JSXEmptyExpression nd, C c);

  public R visit(JSXExpressionContainer nd, C c);

  public R visit(JSXOpeningElement nd, C c);

  public R visit(JSXClosingElement nd, C c);

  public R visit(JSXAttribute nd, C c);

  public R visit(JSXSpreadAttribute nd, C c);

  public R visit(JSXElement nd, C c);

  public R visit(AwaitExpression nd, C c);

  public R visit(Decorator nd, C c);

  public R visit(BindExpression nd, C c);

  public R visit(NamespaceDeclaration nd, C c);

  public R visit(ImportWholeDeclaration nd, C c);

  public R visit(ExportWholeDeclaration nd, C c);

  public R visit(ExternalModuleReference nd, C c);

  public R visit(DynamicImport nd, C c);

  public R visit(InterfaceDeclaration nd, C c);

  public R visit(KeywordTypeExpr nd, C c);

  public R visit(ArrayTypeExpr nd, C c);

  public R visit(UnionTypeExpr nd, C c);

  public R visit(IndexedAccessTypeExpr nd, C c);

  public R visit(IntersectionTypeExpr nd, C c);

  public R visit(ParenthesizedTypeExpr nd, C c);

  public R visit(TupleTypeExpr nd, C c);

  public R visit(UnaryTypeExpr nd, C c);

  public R visit(GenericTypeExpr nd, C c);

  public R visit(TypeofTypeExpr nd, C c);

  public R visit(PredicateTypeExpr nd, C c);

  public R visit(InterfaceTypeExpr nd, C c);

  public R visit(ExpressionWithTypeArguments nd, C c);

  public R visit(TypeParameter nd, C c);

  public R visit(FunctionTypeExpr nd, C c);

  public R visit(TypeAssertion nd, C c);

  public R visit(MappedTypeExpr nd, C c);

  public R visit(TypeAliasDeclaration nd, C c);

  public R visit(EnumDeclaration nd, C c);

  public R visit(EnumMember nd, C c);

  public R visit(DecoratorList nd, C c);

  public R visit(ExternalModuleDeclaration nd, C c);

  public R visit(ExportAsNamespaceDeclaration nd, C c);

  public R visit(GlobalAugmentationDeclaration nd, C c);

  public R visit(NonNullAssertion nd, C c);

  public R visit(ConditionalTypeExpr nd, C q);

  public R visit(InferTypeExpr nd, C c);

  public R visit(ImportTypeExpr nd, C c);

  public R visit(OptionalTypeExpr nd, C c);

  public R visit(RestTypeExpr nd, C c);

  public R visit(XMLAnyName nd, C c);

  public R visit(XMLAttributeSelector nd, C c);

  public R visit(XMLFilterExpression nd, C c);

  public R visit(XMLQualifiedIdentifier nd, C c);

  public R visit(XMLDotDotExpression nd, C c);

  public R visit(GeneratedCodeExpr generatedCodeExpr, C c);

  public R visit(StaticInitializer nd, C c);
}
