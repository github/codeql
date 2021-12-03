package com.semmle.js.ast;

import java.util.ArrayList;
import java.util.List;

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
import com.semmle.util.data.IntList;

/** Deep cloning of AST nodes. */
public class NodeCopier implements Visitor<Void, INode> {
  private Position visit(Position pos) {
    return new Position(pos.getLine(), pos.getColumn(), pos.getOffset());
  }

  private SourceLocation visit(SourceLocation loc) {
    return new SourceLocation(loc.getSource(), visit(loc.getStart()), visit(loc.getEnd()));
  }

  @SuppressWarnings("unchecked")
  public <T extends INode> T copy(T t) {
    if (t == null) return null;
    return (T) t.accept(this, null);
  }

  private <T extends INode> List<T> copy(List<T> ts) {
    List<T> result = new ArrayList<T>();
    for (T t : ts) result.add(copy(t));
    return result;
  }

  private IntList copy(IntList list) {
    return new IntList(list);
  }

  @Override
  public INode visit(AngularPipeRef nd, Void q) {
    return new AngularPipeRef(nd.getLoc(), copy(nd.getIdentifier()));
  }

  @Override
  public AssignmentExpression visit(AssignmentExpression nd, Void q) {
    return new AssignmentExpression(
        visit(nd.getLoc()), nd.getOperator(), copy(nd.getLeft()), copy(nd.getRight()));
  }

  @Override
  public AssignmentPattern visit(AssignmentPattern nd, Void q) {
    return new AssignmentPattern(
        visit(nd.getLoc()), nd.getOperator(), copy(nd.getLeft()), copy(nd.getRight()));
  }

  @Override
  public BinaryExpression visit(BinaryExpression nd, Void q) {
    return new BinaryExpression(
        visit(nd.getLoc()), nd.getOperator(), copy(nd.getLeft()), copy(nd.getRight()));
  }

  @Override
  public BlockStatement visit(BlockStatement nd, Void q) {
    return new BlockStatement(visit(nd.getLoc()), copy(nd.getBody()));
  }

  @Override
  public CallExpression visit(CallExpression nd, Void q) {
    return new CallExpression(
        visit(nd.getLoc()),
        copy(nd.getCallee()),
        copy(nd.getTypeArguments()),
        copy(nd.getArguments()),
        nd.isOptional(),
        nd.isOnOptionalChain());
  }

  @Override
  public ComprehensionBlock visit(ComprehensionBlock nd, Void q) {
    return new ComprehensionBlock(
        visit(nd.getLoc()), copy(nd.getLeft()), copy(nd.getRight()), nd.isOf());
  }

  @Override
  public ComprehensionExpression visit(ComprehensionExpression nd, Void q) {
    return new ComprehensionExpression(
        visit(nd.getLoc()),
        copy(nd.getBody()),
        copy(nd.getBlocks()),
        copy(nd.getFilter()),
        nd.isGenerator());
  }

  @Override
  public ExpressionStatement visit(ExpressionStatement nd, Void q) {
    return new ExpressionStatement(visit(nd.getLoc()), copy(nd.getExpression()));
  }

  @Override
  public FunctionDeclaration visit(FunctionDeclaration nd, Void q) {
    return new FunctionDeclaration(
        visit(nd.getLoc()),
        copy(nd.getId()),
        copy(nd.getRawParameters()),
        copy(nd.getBody()),
        nd.isGenerator(),
        nd.isAsync(),
        nd.hasDeclareKeyword(),
        copy(nd.getTypeParameters()),
        copy(nd.getParameterTypes()),
        copy(nd.getReturnType()),
        copy(nd.getThisParameterType()),
        copy(nd.getOptionalParameterIndices()));
  }

  @Override
  public Identifier visit(Identifier nd, Void q) {
    return new Identifier(visit(nd.getLoc()), nd.getName());
  }

  @Override
  public Literal visit(Literal nd, Void q) {
    return new Literal(visit(nd.getLoc()), nd.getTokenType(), nd.getValue());
  }

  @Override
  public LogicalExpression visit(LogicalExpression nd, Void q) {
    return new LogicalExpression(
        visit(nd.getLoc()), nd.getOperator(), copy(nd.getLeft()), copy(nd.getRight()));
  }

  @Override
  public MemberExpression visit(MemberExpression nd, Void q) {
    return new MemberExpression(
        visit(nd.getLoc()),
        copy(nd.getObject()),
        copy(nd.getProperty()),
        nd.isComputed(),
        nd.isOptional(),
        nd.isOnOptionalChain());
  }

  @Override
  public Program visit(Program nd, Void q) {
    return new Program(visit(nd.getLoc()), copy(nd.getBody()), nd.getSourceType());
  }

  @Override
  public UnaryExpression visit(UnaryExpression nd, Void q) {
    return new UnaryExpression(
        visit(nd.getLoc()), nd.getOperator(), copy(nd.getArgument()), nd.isPrefix());
  }

  @Override
  public UpdateExpression visit(UpdateExpression nd, Void q) {
    return new UpdateExpression(
        visit(nd.getLoc()), nd.getOperator(), copy(nd.getArgument()), nd.isPrefix());
  }

  @Override
  public VariableDeclaration visit(VariableDeclaration nd, Void q) {
    return new VariableDeclaration(
        visit(nd.getLoc()), nd.getKind(), copy(nd.getDeclarations()), nd.hasDeclareKeyword());
  }

  @Override
  public VariableDeclarator visit(VariableDeclarator nd, Void q) {
    return new VariableDeclarator(
        visit(nd.getLoc()),
        copy(nd.getId()),
        copy(nd.getInit()),
        copy(nd.getTypeAnnotation()),
        nd.getFlags());
  }

  @Override
  public SwitchStatement visit(SwitchStatement nd, Void q) {
    return new SwitchStatement(visit(nd.getLoc()), copy(nd.getDiscriminant()), copy(nd.getCases()));
  }

  @Override
  public SwitchCase visit(SwitchCase nd, Void q) {
    return new SwitchCase(visit(nd.getLoc()), copy(nd.getTest()), copy(nd.getConsequent()));
  }

  @Override
  public ForStatement visit(ForStatement nd, Void q) {
    return new ForStatement(
        visit(nd.getLoc()),
        copy(nd.getInit()),
        copy(nd.getTest()),
        copy(nd.getUpdate()),
        copy(nd.getBody()));
  }

  @Override
  public ForInStatement visit(ForInStatement nd, Void q) {
    return new ForInStatement(
        visit(nd.getLoc()),
        copy(nd.getLeft()),
        copy(nd.getRight()),
        copy(nd.getBody()),
        nd.isEach());
  }

  @Override
  public ForOfStatement visit(ForOfStatement nd, Void q) {
    return new ForOfStatement(
        visit(nd.getLoc()), copy(nd.getLeft()), copy(nd.getRight()), copy(nd.getBody()));
  }

  @Override
  public Property visit(Property nd, Void q) {
    return new Property(
        visit(nd.getLoc()),
        copy(nd.getKey()),
        copy(nd.getRawValue()),
        nd.getKind().name(),
        nd.isComputed(),
        nd.isMethod());
  }

  @Override
  public ArrayPattern visit(ArrayPattern nd, Void q) {
    return new ArrayPattern(visit(nd.getLoc()), copy(nd.getElements()));
  }

  @Override
  public ObjectPattern visit(ObjectPattern nd, Void q) {
    return new ObjectPattern(visit(nd.getLoc()), copy(nd.getRawProperties()));
  }

  @Override
  public IfStatement visit(IfStatement nd, Void q) {
    return new IfStatement(
        visit(nd.getLoc()), copy(nd.getTest()), copy(nd.getConsequent()), copy(nd.getAlternate()));
  }

  @Override
  public LabeledStatement visit(LabeledStatement nd, Void q) {
    return new LabeledStatement(visit(nd.getLoc()), copy(nd.getLabel()), copy(nd.getBody()));
  }

  @Override
  public WithStatement visit(WithStatement nd, Void q) {
    return new WithStatement(visit(nd.getLoc()), copy(nd.getObject()), copy(nd.getBody()));
  }

  @Override
  public DoWhileStatement visit(DoWhileStatement nd, Void q) {
    return new DoWhileStatement(visit(nd.getLoc()), copy(nd.getTest()), copy(nd.getBody()));
  }

  @Override
  public WhileStatement visit(WhileStatement nd, Void q) {
    return new WhileStatement(visit(nd.getLoc()), copy(nd.getTest()), copy(nd.getBody()));
  }

  @Override
  public CatchClause visit(CatchClause nd, Void q) {
    return new CatchClause(
        visit(nd.getLoc()), copy(nd.getParam()), copy(nd.getGuard()), copy(nd.getBody()));
  }

  @Override
  public TryStatement visit(TryStatement nd, Void q) {
    return new TryStatement(
        visit(nd.getLoc()),
        copy(nd.getBlock()),
        copy(nd.getHandler()),
        copy(nd.getGuardedHandlers()),
        copy(nd.getFinalizer()));
  }

  @Override
  public NewExpression visit(NewExpression nd, Void q) {
    return new NewExpression(
        visit(nd.getLoc()),
        copy(nd.getCallee()),
        copy(nd.getTypeArguments()),
        copy(nd.getArguments()));
  }

  @Override
  public ReturnStatement visit(ReturnStatement nd, Void q) {
    return new ReturnStatement(visit(nd.getLoc()), copy(nd.getArgument()));
  }

  @Override
  public ThrowStatement visit(ThrowStatement nd, Void q) {
    return new ThrowStatement(visit(nd.getLoc()), copy(nd.getArgument()));
  }

  @Override
  public SpreadElement visit(SpreadElement nd, Void q) {
    return new SpreadElement(visit(nd.getLoc()), copy(nd.getArgument()));
  }

  @Override
  public RestElement visit(RestElement nd, Void q) {
    return new RestElement(visit(nd.getLoc()), copy(nd.getArgument()));
  }

  @Override
  public YieldExpression visit(YieldExpression nd, Void q) {
    return new YieldExpression(visit(nd.getLoc()), copy(nd.getArgument()), nd.isDelegating());
  }

  @Override
  public ParenthesizedExpression visit(ParenthesizedExpression nd, Void q) {
    return new ParenthesizedExpression(visit(nd.getLoc()), copy(nd.getExpression()));
  }

  @Override
  public EmptyStatement visit(EmptyStatement nd, Void q) {
    return new EmptyStatement(visit(nd.getLoc()));
  }

  @Override
  public BreakStatement visit(BreakStatement nd, Void q) {
    return new BreakStatement(visit(nd.getLoc()), copy(nd.getLabel()));
  }

  @Override
  public ContinueStatement visit(ContinueStatement nd, Void q) {
    return new ContinueStatement(visit(nd.getLoc()), copy(nd.getLabel()));
  }

  @Override
  public FunctionExpression visit(FunctionExpression nd, Void q) {
    return new FunctionExpression(
        visit(nd.getLoc()),
        copy(nd.getId()),
        copy(nd.getRawParameters()),
        copy(nd.getBody()),
        nd.isGenerator(),
        nd.isAsync(),
        copy(nd.getTypeParameters()),
        copy(nd.getParameterTypes()),
        copy(nd.getParameterDecorators()),
        copy(nd.getReturnType()),
        copy(nd.getThisParameterType()),
        copy(nd.getOptionalParameterIndices()));
  }

  @Override
  public DebuggerStatement visit(DebuggerStatement nd, Void q) {
    return new DebuggerStatement(visit(nd.getLoc()));
  }

  @Override
  public ArrayExpression visit(ArrayExpression nd, Void q) {
    return new ArrayExpression(visit(nd.getLoc()), copy(nd.getElements()));
  }

  @Override
  public ObjectExpression visit(ObjectExpression nd, Void q) {
    return new ObjectExpression(visit(nd.getLoc()), copy(nd.getProperties()));
  }

  @Override
  public ThisExpression visit(ThisExpression nd, Void q) {
    return new ThisExpression(visit(nd.getLoc()));
  }

  @Override
  public ConditionalExpression visit(ConditionalExpression nd, Void q) {
    return new ConditionalExpression(
        visit(nd.getLoc()), copy(nd.getTest()), copy(nd.getConsequent()), copy(nd.getAlternate()));
  }

  @Override
  public SequenceExpression visit(SequenceExpression nd, Void q) {
    return new SequenceExpression(visit(nd.getLoc()), copy(nd.getExpressions()));
  }

  @Override
  public TemplateElement visit(TemplateElement nd, Void q) {
    return new TemplateElement(visit(nd.getLoc()), nd.getCooked(), nd.getRaw(), nd.isTail());
  }

  @Override
  public TemplateLiteral visit(TemplateLiteral nd, Void q) {
    return new TemplateLiteral(visit(nd.getLoc()), copy(nd.getExpressions()), copy(nd.getQuasis()));
  }

  @Override
  public TemplateLiteralTypeExpr visit(TemplateLiteralTypeExpr nd, Void q) {
    return new TemplateLiteralTypeExpr(visit(nd.getLoc()), copy(nd.getExpressions()), copy(nd.getQuasis()));
  }

  @Override
  public TaggedTemplateExpression visit(TaggedTemplateExpression nd, Void q) {
    return new TaggedTemplateExpression(
        visit(nd.getLoc()), copy(nd.getTag()), copy(nd.getQuasi()), copy(nd.getTypeArguments()));
  }

  @Override
  public ArrowFunctionExpression visit(ArrowFunctionExpression nd, Void q) {
    return new ArrowFunctionExpression(
        visit(nd.getLoc()),
        copy(nd.getRawParameters()),
        copy(nd.getBody()),
        nd.isGenerator(),
        nd.isAsync(),
        copy(nd.getTypeParameters()),
        copy(nd.getParameterTypes()),
        copy(nd.getReturnType()),
        copy(nd.getOptionalParameterIndices()));
  }

  @Override
  public LetStatement visit(LetStatement nd, Void q) {
    return new LetStatement(visit(nd.getLoc()), copy(nd.getHead()), copy(nd.getBody()));
  }

  @Override
  public LetExpression visit(LetExpression nd, Void c) {
    return new LetExpression(visit(nd.getLoc()), copy(nd.getHead()), copy(nd.getBody()));
  }

  @Override
  public ClassDeclaration visit(ClassDeclaration nd, Void c) {
    return new ClassDeclaration(
        visit(nd.getLoc()),
        visit(nd.getClassDef()),
        nd.hasDeclareKeyword(),
        nd.hasAbstractKeyword());
  }

  @Override
  public ClassExpression visit(ClassExpression nd, Void c) {
    return new ClassExpression(visit(nd.getLoc()), visit(nd.getClassDef()));
  }

  private AClass visit(AClass nd) {
    return new AClass(
        copy(nd.getId()),
        copy(nd.getTypeParameters()),
        copy(nd.getSuperClass()),
        copy(nd.getSuperInterfaces()),
        copy(nd.getBody()));
  }

  @Override
  public ClassBody visit(ClassBody nd, Void c) {
    return new ClassBody(visit(nd.getLoc()), copy(nd.getBody()));
  }

  @Override
  public MethodDefinition visit(MethodDefinition nd, Void c) {
    return new MethodDefinition(
        visit(nd.getLoc()),
        nd.getFlags(),
        nd.getKind(),
        copy(nd.getKey()),
        copy(nd.getValue()),
        copy(nd.getParameterFields()));
  }

  @Override
  public FieldDefinition visit(FieldDefinition nd, Void c) {
    return new FieldDefinition(
        visit(nd.getLoc()),
        nd.getFlags(),
        copy(nd.getKey()),
        copy(nd.getValue()),
        copy(nd.getTypeAnnotation()));
  }

  @Override
  public Super visit(Super nd, Void c) {
    return new Super(visit(nd.getLoc()));
  }

  @Override
  public MetaProperty visit(MetaProperty nd, Void c) {
    return new MetaProperty(visit(nd.getLoc()), copy(nd.getMeta()), copy(nd.getProperty()));
  }

  @Override
  public ExportAllDeclaration visit(ExportAllDeclaration nd, Void c) {
    return new ExportAllDeclaration(visit(nd.getLoc()), copy(nd.getSource()));
  }

  @Override
  public ExportDefaultDeclaration visit(ExportDefaultDeclaration nd, Void c) {
    return new ExportDefaultDeclaration(visit(nd.getLoc()), copy(nd.getDeclaration()));
  }

  @Override
  public ExportNamedDeclaration visit(ExportNamedDeclaration nd, Void c) {
    return new ExportNamedDeclaration(
        visit(nd.getLoc()),
        copy(nd.getDeclaration()),
        copy(nd.getSpecifiers()),
        copy(nd.getSource()));
  }

  @Override
  public ExportDefaultSpecifier visit(ExportDefaultSpecifier nd, Void c) {
    return new ExportDefaultSpecifier(visit(nd.getLoc()), copy(nd.getExported()));
  }

  @Override
  public ExportNamespaceSpecifier visit(ExportNamespaceSpecifier nd, Void c) {
    return new ExportNamespaceSpecifier(visit(nd.getLoc()), copy(nd.getExported()));
  }

  @Override
  public ExportSpecifier visit(ExportSpecifier nd, Void c) {
    return new ExportSpecifier(visit(nd.getLoc()), copy(nd.getLocal()), copy(nd.getExported()));
  }

  @Override
  public ImportDeclaration visit(ImportDeclaration nd, Void c) {
    return new ImportDeclaration(
        visit(nd.getLoc()), copy(nd.getSpecifiers()), copy(nd.getSource()));
  }

  @Override
  public ImportDefaultSpecifier visit(ImportDefaultSpecifier nd, Void c) {
    return new ImportDefaultSpecifier(visit(nd.getLoc()), copy(nd.getLocal()));
  }

  @Override
  public ImportNamespaceSpecifier visit(ImportNamespaceSpecifier nd, Void c) {
    return new ImportNamespaceSpecifier(visit(nd.getLoc()), copy(nd.getLocal()));
  }

  @Override
  public ImportSpecifier visit(ImportSpecifier nd, Void c) {
    return new ImportSpecifier(visit(nd.getLoc()), copy(nd.getImported()), copy(nd.getLocal()));
  }

  @Override
  public INode visit(JSXIdentifier nd, Void c) {
    return new JSXIdentifier(visit(nd.getLoc()), nd.getName());
  }

  @Override
  public INode visit(JSXThisExpr nd, Void c) {
    return new JSXThisExpr(visit(nd.getLoc()));
  }

  @Override
  public INode visit(JSXMemberExpression nd, Void c) {
    return new JSXMemberExpression(visit(nd.getLoc()), copy(nd.getObject()), copy(nd.getName()));
  }

  @Override
  public INode visit(JSXNamespacedName nd, Void c) {
    return new JSXNamespacedName(visit(nd.getLoc()), copy(nd.getNamespace()), copy(nd.getName()));
  }

  @Override
  public INode visit(JSXEmptyExpression nd, Void c) {
    return new JSXEmptyExpression(visit(nd.getLoc()));
  }

  @Override
  public INode visit(JSXExpressionContainer nd, Void c) {
    return new JSXExpressionContainer(visit(nd.getLoc()), copy(nd.getExpression()));
  }

  @Override
  public INode visit(JSXOpeningElement nd, Void c) {
    return new JSXOpeningElement(
        visit(nd.getLoc()), copy(nd.getName()), copy(nd.getAttributes()), nd.isSelfClosing());
  }

  @Override
  public INode visit(JSXClosingElement nd, Void c) {
    return new JSXClosingElement(visit(nd.getLoc()), copy(nd.getName()));
  }

  @Override
  public INode visit(JSXAttribute nd, Void c) {
    return new JSXAttribute(visit(nd.getLoc()), copy(nd.getName()), copy(nd.getValue()));
  }

  @Override
  public INode visit(JSXSpreadAttribute nd, Void c) {
    return new JSXSpreadAttribute(visit(nd.getLoc()), copy(nd.getArgument()));
  }

  @Override
  public INode visit(JSXElement nd, Void c) {
    return new JSXElement(
        visit(nd.getLoc()),
        copy(nd.getOpeningElement()),
        copy(nd.getChildren()),
        copy(nd.getClosingElement()));
  }

  @Override
  public INode visit(AwaitExpression nd, Void c) {
    return new AwaitExpression(visit(nd.getLoc()), copy(nd.getArgument()));
  }

  @Override
  public INode visit(Decorator nd, Void c) {
    return new Decorator(visit(nd.getLoc()), copy(nd.getExpression()));
  }

  @Override
  public INode visit(BindExpression nd, Void c) {
    return new BindExpression(visit(nd.getLoc()), copy(nd.getObject()), copy(nd.getCallee()));
  }

  @Override
  public INode visit(NamespaceDeclaration nd, Void c) {
    return new NamespaceDeclaration(
        visit(nd.getLoc()),
        copy(nd.getName()),
        copy(nd.getBody()),
        nd.isInstantiated(),
        nd.hasDeclareKeyword());
  }

  @Override
  public INode visit(ImportWholeDeclaration nd, Void c) {
    return new ImportWholeDeclaration(visit(nd.getLoc()), copy(nd.getLhs()), copy(nd.getRhs()));
  }

  @Override
  public INode visit(ExportWholeDeclaration nd, Void c) {
    return new ExportWholeDeclaration(visit(nd.getLoc()), copy(nd.getRhs()));
  }

  @Override
  public INode visit(ExternalModuleReference nd, Void c) {
    return new ExternalModuleReference(visit(nd.getLoc()), copy(nd.getExpression()));
  }

  @Override
  public INode visit(DynamicImport nd, Void c) {
    return new DynamicImport(visit(nd.getLoc()), copy(nd.getSource()));
  }

  @Override
  public INode visit(InterfaceDeclaration nd, Void c) {
    return new InterfaceDeclaration(
        visit(nd.getLoc()),
        copy(nd.getName()),
        copy(nd.getTypeParameters()),
        copy(nd.getSuperInterfaces()),
        copy(nd.getBody()));
  }

  @Override
  public INode visit(KeywordTypeExpr nd, Void c) {
    return new KeywordTypeExpr(visit(nd.getLoc()), nd.getKeyword());
  }

  @Override
  public INode visit(ArrayTypeExpr nd, Void c) {
    return new ArrayTypeExpr(visit(nd.getLoc()), copy(nd.getElementType()));
  }

  @Override
  public INode visit(UnionTypeExpr nd, Void c) {
    return new UnionTypeExpr(visit(nd.getLoc()), copy(nd.getElementTypes()));
  }

  @Override
  public INode visit(IndexedAccessTypeExpr nd, Void c) {
    return new IndexedAccessTypeExpr(
        visit(nd.getLoc()), copy(nd.getObjectType()), copy(nd.getIndexType()));
  }

  @Override
  public INode visit(IntersectionTypeExpr nd, Void c) {
    return new IntersectionTypeExpr(visit(nd.getLoc()), copy(nd.getElementTypes()));
  }

  @Override
  public INode visit(ParenthesizedTypeExpr nd, Void c) {
    return new ParenthesizedTypeExpr(visit(nd.getLoc()), copy(nd.getElementType()));
  }

  @Override
  public INode visit(TupleTypeExpr nd, Void c) {
    return new TupleTypeExpr(visit(nd.getLoc()), copy(nd.getElementTypes()), copy(nd.getElementNames()));
  }

  @Override
  public INode visit(UnaryTypeExpr nd, Void c) {
    return new UnaryTypeExpr(visit(nd.getLoc()), nd.getKind(), copy(nd.getElementType()));
  }

  @Override
  public INode visit(GenericTypeExpr nd, Void c) {
    return new GenericTypeExpr(
        visit(nd.getLoc()), copy(nd.getTypeName()), copy(nd.getTypeArguments()));
  }

  @Override
  public INode visit(TypeofTypeExpr nd, Void c) {
    return new TypeofTypeExpr(visit(nd.getLoc()), copy(nd.getExpression()));
  }

  @Override
  public INode visit(PredicateTypeExpr nd, Void c) {
    return new PredicateTypeExpr(
        visit(nd.getLoc()),
        copy(nd.getExpression()),
        copy(nd.getTypeExpr()),
        nd.hasAssertsKeyword());
  }

  @Override
  public INode visit(InterfaceTypeExpr nd, Void c) {
    return new InterfaceTypeExpr(visit(nd.getLoc()), copy(nd.getBody()));
  }

  @Override
  public INode visit(ExpressionWithTypeArguments nd, Void c) {
    return new ExpressionWithTypeArguments(
        visit(nd.getLoc()), copy(nd.getExpression()), copy(nd.getTypeArguments()));
  }

  @Override
  public INode visit(TypeParameter nd, Void c) {
    return new TypeParameter(
        visit(nd.getLoc()), copy(nd.getId()), copy(nd.getBound()), copy(nd.getDefault()));
  }

  @Override
  public INode visit(FunctionTypeExpr nd, Void c) {
    return new FunctionTypeExpr(visit(nd.getLoc()), copy(nd.getFunction()), nd.isConstructor());
  }

  @Override
  public INode visit(TypeAssertion nd, Void c) {
    return new TypeAssertion(
        visit(nd.getLoc()),
        copy(nd.getExpression()),
        copy(nd.getTypeAnnotation()),
        nd.isAsExpression());
  }

  @Override
  public INode visit(MappedTypeExpr nd, Void c) {
    return new MappedTypeExpr(
        visit(nd.getLoc()), copy(nd.getTypeParameter()), copy(nd.getElementType()));
  }

  @Override
  public INode visit(TypeAliasDeclaration nd, Void c) {
    return new TypeAliasDeclaration(
        visit(nd.getLoc()),
        copy(nd.getId()),
        copy(nd.getTypeParameters()),
        copy(nd.getDefinition()));
  }

  @Override
  public INode visit(EnumDeclaration nd, Void c) {
    return new EnumDeclaration(
        visit(nd.getLoc()),
        nd.isConst(),
        nd.hasDeclareKeyword(),
        copy(nd.getDecorators()),
        copy(nd.getId()),
        copy(nd.getMembers()));
  }

  @Override
  public INode visit(EnumMember nd, Void c) {
    return new EnumMember(visit(nd.getLoc()), copy(nd.getId()), copy(nd.getInitializer()));
  }

  @Override
  public INode visit(DecoratorList nd, Void c) {
    return new DecoratorList(visit(nd.getLoc()), copy(nd.getDecorators()));
  }

  @Override
  public INode visit(ExternalModuleDeclaration nd, Void c) {
    return new ExternalModuleDeclaration(
        visit(nd.getLoc()), copy(nd.getName()), copy(nd.getBody()));
  }

  @Override
  public INode visit(ExportAsNamespaceDeclaration nd, Void c) {
    return new ExportAsNamespaceDeclaration(visit(nd.getLoc()), copy(nd.getId()));
  }

  @Override
  public INode visit(GlobalAugmentationDeclaration nd, Void c) {
    return new GlobalAugmentationDeclaration(visit(nd.getLoc()), copy(nd.getBody()));
  }

  @Override
  public INode visit(NonNullAssertion nd, Void c) {
    return new NonNullAssertion(visit(nd.getLoc()), copy(nd.getExpression()));
  }

  @Override
  public INode visit(ConditionalTypeExpr nd, Void q) {
    return new ConditionalTypeExpr(
        visit(nd.getLoc()),
        copy(nd.getCheckType()),
        copy(nd.getExtendsType()),
        copy(nd.getTrueType()),
        copy(nd.getFalseType()));
  }

  @Override
  public INode visit(InferTypeExpr nd, Void c) {
    return new InferTypeExpr(visit(nd.getLoc()), copy(nd.getTypeParameter()));
  }

  @Override
  public INode visit(ImportTypeExpr nd, Void c) {
    return new ImportTypeExpr(visit(nd.getLoc()), copy(nd.getPath()));
  }

  @Override
  public INode visit(OptionalTypeExpr nd, Void c) {
    return new OptionalTypeExpr(visit(nd.getLoc()), copy(nd.getElementType()));
  }

  @Override
  public INode visit(RestTypeExpr nd, Void c) {
    return new RestTypeExpr(visit(nd.getLoc()), copy(nd.getArrayType()));
  }

  @Override
  public INode visit(XMLAnyName nd, Void c) {
    return new XMLAnyName(visit(nd.getLoc()));
  }

  @Override
  public INode visit(XMLAttributeSelector nd, Void c) {
    return new XMLAttributeSelector(visit(nd.getLoc()), copy(nd.getAttribute()), nd.isComputed());
  }

  @Override
  public INode visit(XMLFilterExpression nd, Void c) {
    return new XMLFilterExpression(visit(nd.getLoc()), copy(nd.getLeft()), copy(nd.getRight()));
  }

  @Override
  public INode visit(XMLQualifiedIdentifier nd, Void c) {
    return new XMLQualifiedIdentifier(
        visit(nd.getLoc()), copy(nd.getLeft()), copy(nd.getRight()), nd.isComputed());
  }

  @Override
  public INode visit(XMLDotDotExpression nd, Void c) {
    return new XMLDotDotExpression(visit(nd.getLoc()), copy(nd.getLeft()), copy(nd.getRight()));
  }

  @Override
  public INode visit(GeneratedCodeExpr nd, Void c) {
    return new GeneratedCodeExpr(visit(nd.getLoc()), nd.getOpeningDelimiter(), nd.getClosingDelimiter(), nd.getBody());
  }

  @Override
  public INode visit(StaticInitializer nd, Void c) {
    return new StaticInitializer(visit(nd.getLoc()), copy(nd.getValue()));
  }
}
