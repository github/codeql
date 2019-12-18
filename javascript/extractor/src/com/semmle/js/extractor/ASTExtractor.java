package com.semmle.js.extractor;

import com.semmle.js.ast.AClass;
import com.semmle.js.ast.AFunction;
import com.semmle.js.ast.AFunctionExpression;
import com.semmle.js.ast.ArrayExpression;
import com.semmle.js.ast.ArrayPattern;
import com.semmle.js.ast.ArrowFunctionExpression;
import com.semmle.js.ast.AssignmentExpression;
import com.semmle.js.ast.AwaitExpression;
import com.semmle.js.ast.BinaryExpression;
import com.semmle.js.ast.BindExpression;
import com.semmle.js.ast.BlockStatement;
import com.semmle.js.ast.CallExpression;
import com.semmle.js.ast.CatchClause;
import com.semmle.js.ast.ClassBody;
import com.semmle.js.ast.ClassDeclaration;
import com.semmle.js.ast.ClassExpression;
import com.semmle.js.ast.ComprehensionBlock;
import com.semmle.js.ast.ComprehensionExpression;
import com.semmle.js.ast.ConditionalExpression;
import com.semmle.js.ast.DeclarationFlags;
import com.semmle.js.ast.Decorator;
import com.semmle.js.ast.DefaultVisitor;
import com.semmle.js.ast.DoWhileStatement;
import com.semmle.js.ast.DynamicImport;
import com.semmle.js.ast.EnhancedForStatement;
import com.semmle.js.ast.ExportAllDeclaration;
import com.semmle.js.ast.ExportDefaultDeclaration;
import com.semmle.js.ast.ExportNamedDeclaration;
import com.semmle.js.ast.ExportSpecifier;
import com.semmle.js.ast.Expression;
import com.semmle.js.ast.ExpressionStatement;
import com.semmle.js.ast.FieldDefinition;
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
import com.semmle.js.ast.ImportSpecifier;
import com.semmle.js.ast.InvokeExpression;
import com.semmle.js.ast.JumpStatement;
import com.semmle.js.ast.LabeledStatement;
import com.semmle.js.ast.LetExpression;
import com.semmle.js.ast.LetStatement;
import com.semmle.js.ast.Literal;
import com.semmle.js.ast.LogicalExpression;
import com.semmle.js.ast.MemberDefinition;
import com.semmle.js.ast.MemberExpression;
import com.semmle.js.ast.MetaProperty;
import com.semmle.js.ast.MethodDefinition;
import com.semmle.js.ast.MethodDefinition.Kind;
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
import com.semmle.js.ast.SourceElement;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.SpreadElement;
import com.semmle.js.ast.Statement;
import com.semmle.js.ast.Super;
import com.semmle.js.ast.SwitchCase;
import com.semmle.js.ast.SwitchStatement;
import com.semmle.js.ast.TaggedTemplateExpression;
import com.semmle.js.ast.TemplateElement;
import com.semmle.js.ast.TemplateLiteral;
import com.semmle.js.ast.ThrowStatement;
import com.semmle.js.ast.TryStatement;
import com.semmle.js.ast.UnaryExpression;
import com.semmle.js.ast.UpdateExpression;
import com.semmle.js.ast.VariableDeclaration;
import com.semmle.js.ast.VariableDeclarator;
import com.semmle.js.ast.WhileStatement;
import com.semmle.js.ast.WithStatement;
import com.semmle.js.ast.XMLAttributeSelector;
import com.semmle.js.ast.XMLDotDotExpression;
import com.semmle.js.ast.XMLFilterExpression;
import com.semmle.js.ast.XMLQualifiedIdentifier;
import com.semmle.js.ast.YieldExpression;
import com.semmle.js.ast.jsx.IJSXName;
import com.semmle.js.ast.jsx.JSXAttribute;
import com.semmle.js.ast.jsx.JSXElement;
import com.semmle.js.ast.jsx.JSXEmptyExpression;
import com.semmle.js.ast.jsx.JSXExpressionContainer;
import com.semmle.js.ast.jsx.JSXIdentifier;
import com.semmle.js.ast.jsx.JSXMemberExpression;
import com.semmle.js.ast.jsx.JSXNamespacedName;
import com.semmle.js.ast.jsx.JSXOpeningElement;
import com.semmle.js.ast.jsx.JSXSpreadAttribute;
import com.semmle.js.extractor.ExtractionMetrics.ExtractionPhase;
import com.semmle.js.extractor.ExtractorConfig.Platform;
import com.semmle.js.extractor.ExtractorConfig.SourceType;
import com.semmle.js.extractor.ScopeManager.DeclKind;
import com.semmle.js.extractor.ScopeManager.Scope;
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
import com.semmle.ts.ast.TupleTypeExpr;
import com.semmle.ts.ast.TypeAliasDeclaration;
import com.semmle.ts.ast.TypeAssertion;
import com.semmle.ts.ast.TypeExpression;
import com.semmle.ts.ast.TypeParameter;
import com.semmle.ts.ast.TypeofTypeExpr;
import com.semmle.ts.ast.UnaryTypeExpr;
import com.semmle.ts.ast.UnionTypeExpr;
import com.semmle.util.collections.CollectionUtil;
import com.semmle.util.trap.TrapWriter;
import com.semmle.util.trap.TrapWriter.Label;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.Stack;

/** Extractor for AST-based information; invoked by the {@link JSExtractor}. */
public class ASTExtractor {
  private final TrapWriter trapwriter;
  private final LocationManager locationManager;
  private final SyntacticContextManager contextManager;
  private final ScopeManager scopeManager;
  private final Label toplevelLabel;
  private final LexicalExtractor lexicalExtractor;
  private final RegExpExtractor regexpExtractor;

  public ASTExtractor(LexicalExtractor lexicalExtractor, ScopeManager scopeManager) {
    this.trapwriter = lexicalExtractor.getTrapwriter();
    this.locationManager = lexicalExtractor.getLocationManager();
    this.contextManager = new SyntacticContextManager();
    this.scopeManager = scopeManager;
    this.lexicalExtractor = lexicalExtractor;
    this.regexpExtractor = new RegExpExtractor(trapwriter, locationManager);
    this.toplevelLabel =
        trapwriter.globalID(
            "script;{"
                + locationManager.getFileLabel()
                + "},"
                + locationManager.getStartLine()
                + ','
                + locationManager.getStartColumn());
  }

  public TrapWriter getTrapwriter() {
    return trapwriter;
  }

  public LocationManager getLocationManager() {
    return locationManager;
  }

  public Label getToplevelLabel() {
    return toplevelLabel;
  }

  public ScopeManager getScopeManager() {
    return scopeManager;
  }

  public ExtractionMetrics getMetrics() {
    return lexicalExtractor.getMetrics();
  }

  /**
   * The binding semantics for an identifier.
   *
   * <p>An identifier is either a label, or declares or binds to a variable or type.
   */
  public enum IdContext {
    /** An identifier that binds to a variable. */
    varBind,

    /** An identifier that declares a variable. */
    varDecl,

    /** An identifier that declares both a variable and a type. */
    varAndTypeDecl,

    /**
     * An identifier that is not associated with variables or types, such as a property name and
     * statement label.
     */
    label,

    /** An identifier that binds to a type (and not a variable). */
    typeBind,

    /** An identifier that declares a type (and not a variable). */
    typeDecl,

    /**
     * An identifier that is part of a type, but should not bind to a type name. Unlike {@link
     * #label}, this will not result in an expression.
     */
    typeLabel,

    /**
     * An identifier that refers to a variable from inside a type, i.e. the operand to a
     * <tt>typeof</tt> type or left operand to an <tt>is</tt> type.
     *
     * <p>This is generally treated as a type, except a variable binding will be emitted for it.
     */
    varInTypeBind,

    /** An identifier that refers to a namespace from inside a type. */
    namespaceBind,

    /** An identifier that declares a namespace. */
    namespaceDecl,

    /** An identifier that declares a variable and a namespace. */
    varAndNamespaceDecl,

    /** An identifier that declares a variable, type, and namepsace. */
    varAndTypeAndNamespaceDecl,

    /**
     * An identifier that occurs as part of a named export, such as <tt>export { A }</tt>.
     *
     * <p>This may refer to a variable, type, and/or a namespace, and will export exactly those that
     * can be resolved.
     *
     * <p>In this case, the identifier is not implicitly resolved to a global unless the global is
     * explicitly declared, since TypeScript only emits the export code when it refers to a declared
     * variable.
     */
    export,

    /**
     * An identifier that occurs as a qualified name in a default export expression, such as
     * <tt>A</tt> in <tt>export default A.B</tt>.
     *
     * <p>This acts like {@link #export}, except it cannot refer to a type (i.e. it must be a
     * variable and/or a namespace).
     */
    exportBase;

    /**
     * True if this occurs as part of a type annotation, i.e. it is {@link #typeBind} or {@link
     * #typeDecl}, {@link #typeLabel}, {@link #varInTypeBind}, or {@link #namespaceBind}.
     *
     * <p>Does not hold for {@link #varAndTypeDecl}.
     */
    public boolean isInsideType() {
      return this == typeBind
          || this == typeDecl
          || this == typeLabel
          || this == varInTypeBind
          || this == namespaceBind;
    }
  };

  private static class Context {
    private final Label parent;
    private final int childIndex;
    private final IdContext idcontext;

    public Context(Label parent, int childIndex, IdContext idcontext) {
      this.parent = parent;
      this.childIndex = childIndex;
      this.idcontext = idcontext;
    }

    /** True if the visited AST node occurs as part of a type annotation. */
    public boolean isInsideType() {
      return idcontext.isInsideType();
    }
  }

  private class V extends DefaultVisitor<Context, Label> {
    private final Platform platform;
    private final SourceType sourceType;
    private boolean isStrict;

    public V(Platform platform, SourceType sourceType) {
      this.platform = platform;
      this.sourceType = sourceType;
      this.isStrict = sourceType.isStrictMode();
    }

    private Label visit(INode child, Label parent, int childIndex) {
      return visit(child, parent, childIndex, IdContext.varBind);
    }

    private Label visitAll(List<? extends INode> children, Label parent) {
      return visitAll(children, parent, IdContext.varBind, 0);
    }

    private Label visit(INode child, Label parent, int childIndex, IdContext idContext) {
      if (child == null) return null;
      return child.accept(this, new Context(parent, childIndex, idContext));
    }

    private Label visitAll(
        List<? extends INode> children, Label parent, IdContext idContext, int index) {
      return visitAll(children, parent, idContext, index, 1);
    }

    private Label visitAll(
        List<? extends INode> children, Label parent, IdContext idContext, int index, int step) {
      Label res = null;
      for (INode child : children) {
        res = visit(child, parent, index, idContext);
        index += step;
      }
      return res;
    }

    @Override
    public Label visit(Expression nd, Context c) {
      int kind =
          c.isInsideType()
              ? TypeExprKinds.getTypeExprKind(nd, c.idcontext)
              : ExprKinds.getExprKind(nd, c.idcontext);
      Label lbl = visit(nd, kind, c);
      emitStaticType(nd, lbl);
      return lbl;
    }

    @Override
    public Label visit(TypeExpression nd, Context c) {
      Label lbl = visit(nd, TypeExprKinds.getTypeExprKind(nd, c.idcontext), c);
      emitStaticType(nd, lbl);
      return lbl;
    }

    private void emitStaticType(ITypedAstNode nd, Label lbl) {
      if (nd.getStaticTypeId() != -1) {
        trapwriter.addTuple(
            "ast_node_type", lbl, trapwriter.globalID("type;" + nd.getStaticTypeId()));
      }
    }

    private Label visit(SourceElement nd, int kind, Context c) {
      return visit(nd, kind, lexicalExtractor.mkToString(nd), c);
    }

    protected Label visit(SourceElement nd, int kind, String tostring, Context c) {
      Label lbl = trapwriter.localID(nd);
      if (c.isInsideType()) {
        trapwriter.addTuple("typeexprs", lbl, kind, c.parent, c.childIndex, tostring);
      } else {
        trapwriter.addTuple("exprs", lbl, kind, c.parent, c.childIndex, tostring);
      }
      if (nd.hasLoc()) locationManager.emitNodeLocation(nd, lbl);
      Statement enclosingStmt = contextManager.getCurrentStatement();
      if (enclosingStmt != null)
        trapwriter.addTuple("enclosingStmt", lbl, trapwriter.localID(enclosingStmt));
      trapwriter.addTuple("exprContainers", lbl, contextManager.getCurrentContainerKey());
      return lbl;
    }

    @Override
    public Label visit(Statement nd, Context c) {
      Label lbl = trapwriter.localID(nd);
      int kind = StmtKinds.getStmtKind(nd);
      String tostring = lexicalExtractor.mkToString(nd);
      trapwriter.addTuple("stmts", lbl, kind, c.parent, c.childIndex, tostring);
      locationManager.emitNodeLocation(nd, lbl);
      trapwriter.addTuple("stmtContainers", lbl, contextManager.getCurrentContainerKey());
      contextManager.setCurrentStatement(nd);
      return lbl;
    }

    @Override
    public Label visit(InvokeExpression nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getCallee(), key, -1);
      visitAll(nd.getTypeArguments(), key, IdContext.typeBind, -2, -1);
      visitAll(nd.getArguments(), key);
      if (nd.getResolvedSignatureId() != -1) {
        Label signature = trapwriter.globalID("signature;" + nd.getResolvedSignatureId());
        trapwriter.addTuple("invoke_expr_signature", key, signature);
      }
      if (nd.getOverloadIndex() != -1) {
        trapwriter.addTuple("invoke_expr_overload_index", key, nd.getOverloadIndex());
      }
      if (nd.isOptional()) {
        trapwriter.addTuple("isOptionalChaining", key);
      }
      emitNodeSymbol(nd, key);
      return key;
    }

    @Override
    public Label visit(ExpressionStatement nd, Context c) {
      Label key = super.visit(nd, c);
      return visit(nd.getExpression(), key, 0);
    }

    private void addVariableBinding(String relation, Label key, String name) {
      Label variableKey = scopeManager.getVarKey(name);
      trapwriter.addTuple(relation, key, variableKey);
    }

    private boolean addTypeBinding(String relation, Label key, String name) {
      // Type bindings do not implicitly resolve to a global - they are null if unresolved.
      Label typenameKey = scopeManager.getTypeKey(name);
      if (typenameKey != null) {
        trapwriter.addTuple(relation, key, typenameKey);
        return true;
      }
      return false;
    }

    private boolean addNamespaceBinding(String relation, Label key, String name) {
      // Namespace bindings do not implicitly resolve to a global - they are null if
      // unresolved.
      Label typenameKey = scopeManager.getNamespaceKey(name);
      if (typenameKey != null) {
        trapwriter.addTuple(relation, key, typenameKey);
        return true;
      }
      return false;
    }

    @Override
    public Label visit(Identifier nd, Context c) {
      Label key = super.visit(nd, c);
      String name = nd.getName();
      emitNodeSymbol(nd, key);
      trapwriter.addTuple("literals", name, name, key);
      switch (c.idcontext) {
        case varBind:
        case varInTypeBind:
          addVariableBinding("bind", key, name);
          break;
        case varDecl:
          addVariableBinding("decl", key, name);
          break;
        case varAndTypeDecl:
          addVariableBinding("decl", key, name);
          addTypeBinding("typedecl", key, name);
          break;
        case typeBind:
          addTypeBinding("typebind", key, name);
          break;
        case typeDecl:
          addTypeBinding("typedecl", key, name);
          break;
        case namespaceBind:
          addNamespaceBinding("namespacebind", key, name);
          break;
        case namespaceDecl:
          addNamespaceBinding("namespacedecl", key, name);
          break;
        case varAndNamespaceDecl:
          addVariableBinding("decl", key, name);
          addNamespaceBinding("namespacedecl", key, name);
          break;
        case varAndTypeAndNamespaceDecl:
          addVariableBinding("decl", key, name);
          addTypeBinding("typedecl", key, name);
          addNamespaceBinding("namespacedecl", key, name);
          break;
        case export:
        case exportBase:
          // At the time of writing, this kind of export is only allowed at the top-level.
          boolean resolved = false;
          if (c.idcontext != IdContext.exportBase) {
            resolved |= addTypeBinding("typebind", key, name);
          }
          resolved |= addNamespaceBinding("namespacebind", key, name);
          if (scopeManager.isStrictlyInScope(name) || !resolved) {
            // Do not reference implicit globals, unless nothing else is in scope.
            addVariableBinding("bind", key, name);
          }
          break;
        case label:
        case typeLabel:
          break;
      }
      return key;
    }

    @Override
    public Label visit(Literal nd, Context c) {
      Label key = super.visit(nd, c);
      String source = nd.getLoc().getSource();
      String valueString = nd.getStringValue();

      trapwriter.addTuple("literals", valueString, source, key);
      if (nd.isRegExp()) {
        OffsetTranslation offsets = new OffsetTranslation();
        offsets.set(0, 1); // skip the initial '/'
        regexpExtractor.extract(source.substring(1, source.lastIndexOf('/')), offsets, nd, false);
      } else if (nd.isStringLiteral() && !c.isInsideType() && nd.getRaw().length() < 1000) {
        regexpExtractor.extract(valueString, makeStringLiteralOffsets(nd.getRaw()), nd, true);
      }
      return key;
    }

    private boolean isOctalDigit(char ch) {
      return '0' <= ch && ch <= '7';
    }

    /**
     * Builds a translation from offsets in a string value back to its original raw literal text
     * (including quotes).
     *
     * <p>This is not a 1:1 mapping since escape sequences take up more characters in the raw
     * literal than in the resulting string value. This mapping includes the surrounding quotes.
     *
     * <p>For example: for the raw literal value <code>'x\.y'</code> (quotes included), the <code>y
     * </code> at index 2 in <code>x.y</code> maps to index 4 in the raw literal.
     */
    public OffsetTranslation makeStringLiteralOffsets(String rawLiteral) {
      OffsetTranslation offsets = new OffsetTranslation();
      offsets.set(0, 1); // Skip the initial quote
      // Invariant: raw character at 'pos' corresponds to decoded character at 'pos - delta'
      int pos = 1;
      int delta = 1;
      while (pos < rawLiteral.length() - 1) {
        if (rawLiteral.charAt(pos) != '\\') {
          ++pos;
          continue;
        }
        final int length; // Length of the escape sequence, including slash.
        int outputLength = 1; // Number characters the sequence expands to.
        char ch = rawLiteral.charAt(pos + 1);
        if ('0' <= ch && ch <= '7') {
          // Octal escape: \N, \NN, or \NNN
          int firstDigit = pos + 1;
          int end = firstDigit;
          int maxEnd = Math.min(firstDigit + (ch <= '3' ? 3 : 2), rawLiteral.length());
          while (end < maxEnd && isOctalDigit(rawLiteral.charAt(end))) {
            ++end;
          }
          length = end - pos;
        } else if (ch == 'x') {
          // Hex escape: \xNN
          length = 4;
        } else if (ch == 'u' && pos + 2 < rawLiteral.length()) {
          if (rawLiteral.charAt(pos + 2) == '{') {
            // Variable-length unicode escape: \U{N...}
            // Scan for the ending '}'
            int firstDigit = pos + 3;
            int end = firstDigit;
            int leadingZeros = 0;
            while (end < rawLiteral.length() && rawLiteral.charAt(end) == '0') {
              ++end;
              ++leadingZeros;
            }
            while (end < rawLiteral.length() && rawLiteral.charAt(end) != '}') {
              ++end;
            }
            int numDigits = end - firstDigit;
            if (numDigits - leadingZeros > 4) {
              outputLength = 2; // Encoded as a surrogate pair
            }
            ++end; // Include '}' character
            length = end - pos;
          } else {
            // Fixed-length unicode escape: \UNNNN
            length = 6;
          }
        } else {
          // Simple escape: \n or similar.
          length = 2;
        }
        int end = pos + length;
        if (end > rawLiteral.length()) {
          end = rawLiteral.length();
        }
        int outputPos = pos - delta;
        // Map the next character to the adjusted offset.
        offsets.set(outputPos + outputLength, end);
        delta += length - outputLength;
        pos = end;
      }
      return offsets;
    }

    @Override
    public Label visit(MemberExpression nd, Context c) {
      Label key = super.visit(nd, c);
      if (c.isInsideType()) {
        emitNodeSymbol(nd, key);

        // The context can either be typeBind, namespaceBind, or varInTypeBind.
        IdContext baseIdContext =
            c.idcontext == IdContext.varInTypeBind
                ? IdContext.varInTypeBind
                : IdContext.namespaceBind;
        visit(nd.getObject(), key, 0, baseIdContext);

        // Ensure the property name is not a TypeAccess, since this would create two
        // TypeAccesses from the same type usage, easily leading to duplicate query
        // results. The qualified access is the one we prefer to select.
        visit(nd.getProperty(), key, 1, IdContext.typeLabel);
      } else {
        IdContext baseIdContext =
            c.idcontext == IdContext.export ? IdContext.exportBase : IdContext.varBind;
        visit(nd.getObject(), key, 0, baseIdContext);
        visit(nd.getProperty(), key, 1, nd.isComputed() ? IdContext.varBind : IdContext.label);
      }
      if (nd.isOptional()) {
        trapwriter.addTuple("isOptionalChaining", key);
      }
      return key;
    }

    @Override
    public Label visit(Program nd, Context c) {
      contextManager.enterContainer(toplevelLabel);

      isStrict = hasUseStrict(nd.getBody());

      // Add platform-specific globals.
      scopeManager.addVariables(platform.getPredefinedGlobals());

      // Introduce local scope if there is one.
      if (sourceType.hasLocalScope()) {
        Label moduleScopeKey =
            trapwriter.globalID(
                "module;{"
                    + locationManager.getFileLabel()
                    + "},"
                    + locationManager.getStartLine()
                    + ","
                    + locationManager.getStartColumn());
        scopeManager.enterScope(3, moduleScopeKey, toplevelLabel);
        scopeManager.addVariables(
            sourceType.getPredefinedLocals(platform, locationManager.getSourceFileExtension()));
        trapwriter.addTuple("isModule", toplevelLabel);
      }

      // Emit the specific source type.
      switch (sourceType) {
        case CLOSURE_MODULE:
          trapwriter.addTuple("isClosureModule", toplevelLabel);
          break;
        case MODULE:
          trapwriter.addTuple("isES2015Module", toplevelLabel);
          break;
        default:
          break;
      }

      // add all declared global (or module-scoped) names, both non-lexical and lexical
      scopeManager.addNames(scopeManager.collectDeclaredNames(nd, isStrict, false, DeclKind.none));
      scopeManager.addNames(scopeManager.collectDeclaredNames(nd, isStrict, true, DeclKind.none));

      visitAll(nd.getBody(), toplevelLabel);

      // Leave the local scope again.
      if (sourceType.hasLocalScope()) scopeManager.leaveScope();

      contextManager.leaveContainer();

      emitNodeSymbol(nd, toplevelLabel);

      return toplevelLabel;
    }

    /** Is the first statement of {@code body} a strict mode declaration? */
    private boolean hasUseStrict(List<Statement> body) {
      if (!body.isEmpty()) {
        Statement firstStmt = body.get(0);
        if (firstStmt instanceof ExpressionStatement) {
          Expression e = ((ExpressionStatement) firstStmt).getExpression();
          if (e instanceof Literal) {
            String r = ((Literal) e).getRaw();
            return "'use strict'".equals(r) || "\"use strict\"".equals(r);
          }
        }
      }
      return false;
    }

    @Override
    public Label visit(AssignmentExpression nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getLeft(), key, 0);
      visit(nd.getRight(), key, 1);
      return key;
    }

    @Override
    public Label visit(BinaryExpression nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getLeft(), key, 0);
      visit(nd.getRight(), key, 1);
      return key;
    }

    @Override
    public Label visit(ComprehensionBlock nd, Context c) {
      Label key = super.visit(nd, c);
      DeclaredNames lexicals =
          scopeManager.collectDeclaredNames(nd.getLeft(), isStrict, true, DeclKind.var);
      scopeManager.enterScope(nd);
      scopeManager.addNames(lexicals);
      visit(nd.getLeft(), key, 0, IdContext.varDecl);
      visit(nd.getRight(), key, 1);
      return key;
    }

    @Override
    public Label visit(ComprehensionExpression nd, Context c) {
      Label key = super.visit(nd, c);
      visitAll(nd.getBlocks(), key, IdContext.varBind, 1);
      visit(nd.getFilter(), key, -1);
      visit(nd.getBody(), key, 0);
      for (int i = nd.getBlocks().size(); i > 0; --i) scopeManager.leaveScope();
      return key;
    }

    @Override
    public Label visit(LogicalExpression nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getLeft(), key, 0);
      visit(nd.getRight(), key, 1);
      return key;
    }

    @Override
    public Label visit(UnaryExpression nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getArgument(), key, 0);
      return key;
    }

    @Override
    public Label visit(SpreadElement nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getArgument(), key, 0);
      return key;
    }

    @Override
    public Label visit(UpdateExpression nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getArgument(), key, 0);
      return key;
    }

    @Override
    public Label visit(YieldExpression nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getArgument(), key, 0);
      if (nd.isDelegating()) trapwriter.addTuple("isDelegating", key);
      return key;
    }

    /*
     * Caveat: If you change this method, check whether you also need to change the
     * handling of for loops with let-bound loop variables above.
     */
    @Override
    public Label visit(VariableDeclaration nd, Context c) {
      Label key = super.visit(nd, c);
      if (nd.hasDeclareKeyword()) {
        trapwriter.addTuple("hasDeclareKeyword", key);
      }
      visitAll(nd.getDeclarations(), key);
      return key;
    }

    @Override
    public Label visit(LetStatement nd, Context c) {
      return extractLet(nd, super.visit(nd, c), nd.getHead(), nd.getBody());
    }

    @Override
    public Label visit(LetExpression nd, Context c) {
      return extractLet(nd, super.visit(nd, c), nd.getHead(), nd.getBody());
    }

    private Label extractLet(Node nd, Label key, List<VariableDeclarator> head, Node body) {
      DeclaredNames lexicals =
          scopeManager.collectDeclaredNames(head, isStrict, true, DeclKind.var);
      scopeManager.enterScope(nd);
      scopeManager.addNames(lexicals);
      visitAll(head, key);
      visit(body, key, -1, IdContext.varBind);
      scopeManager.leaveScope();
      return key;
    }

    @Override
    public Label visit(VariableDeclarator nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getId(), key, 0, IdContext.varDecl);
      visit(nd.getInit(), key, 1);
      visit(nd.getTypeAnnotation(), key, 2, IdContext.typeBind);
      for (int i = 0; i < DeclarationFlags.numberOfFlags; ++i) {
        if (DeclarationFlags.hasNthFlag(nd.getFlags(), i)) {
          trapwriter.addTuple(DeclarationFlags.relationNames.get(i), key);
        }
      }
      return key;
    }

    @Override
    public Label visit(BlockStatement nd, Context c) {
      Label key = super.visit(nd, c);
      DeclaredNames lexicals =
          scopeManager.collectDeclaredNames(nd.getBody(), isStrict, true, DeclKind.none);
      if (!lexicals.isEmpty()) {
        scopeManager.enterScope(nd);
        scopeManager.addNames(lexicals);
      }
      visitAll(nd.getBody(), key);
      if (!lexicals.isEmpty()) scopeManager.leaveScope();
      return key;
    }

    @Override
    public Label visit(FunctionDeclaration nd, Context c) {
      Label key = super.visit(nd, c);
      if (nd.hasDeclareKeyword()) {
        trapwriter.addTuple("hasDeclareKeyword", key);
      }
      extractFunction(nd, key);
      emitStaticType(nd, key);
      return key;
    }

    private void extractFunctionAttributes(IFunction nd, Label key) {
      if (nd.isGenerator()) trapwriter.addTuple("isGenerator", key);
      if (nd.hasRest()) trapwriter.addTuple("hasRestParameter", key);
      if (nd.isAsync()) trapwriter.addTuple("isAsync", key);
    }

    @Override
    public Label visit(AFunctionExpression nd, Context c) {
      Label key = super.visit(nd, c);
      extractFunction(nd, key);
      return key;
    }

    private void extractFunction(IFunction nd, Label key) {
      // If the function has no body we process it like any other function, it
      // just won't contain any statements.
      contextManager.enterContainer(key);

      boolean bodyIsStrict = isStrict;
      if (!isStrict && nd.getBody() instanceof BlockStatement)
        bodyIsStrict = hasUseStrict(((BlockStatement) nd.getBody()).getBody());

      // The name of a function declaration binds to the outer scope.
      if (nd instanceof FunctionDeclaration) {
        visit(nd.getId(), key, -1, IdContext.varDecl);
      }

      DeclaredNames locals =
          scopeManager.collectDeclaredNames(nd.getBody(), bodyIsStrict, false, DeclKind.none);

      scopeManager.enterScope((Node) nd);
      scopeManager.addNames(locals);

      // The name of a function expression binds to its own scope.
      if (nd.getId() != null && nd instanceof AFunctionExpression) {
        scopeManager.addVariables(nd.getId().getName());
        visit(nd.getId(), key, -1, IdContext.varDecl);
      }

      for (TypeParameter tp : nd.getTypeParameters()) {
        scopeManager.addTypeName(tp.getId().getName());
      }

      int i = 0;
      for (IPattern param : nd.getAllParams()) {
        scopeManager.addNames(
            scopeManager.collectDeclaredNames(param, isStrict, false, DeclKind.var));
        Label paramKey = visit(param, key, i, IdContext.varDecl);

        // Extract optional parameters
        if (nd.getOptionalParameterIndices().contains(i)) {
          trapwriter.addTuple("isOptionalParameterDeclaration", paramKey);
        }
        ++i;
      }

      // add 'arguments' object unless this is an arrow function
      if (!(nd instanceof ArrowFunctionExpression)) {
        if (!scopeManager.declaredInCurrentScope("arguments"))
          scopeManager.addVariables("arguments");
        trapwriter.addTuple("isArgumentsObject", scopeManager.getVarKey("arguments"));
      }

      // add return type at index -3
      visit(nd.getReturnType(), key, -3, IdContext.typeBind);

      // add 'this' type at index -4
      visit(nd.getThisParameterType(), key, -4, IdContext.typeBind);

      // add parameter stuff at index -5 and down
      extractParameterDefaultsAndTypes(nd, key, i);

      extractFunctionAttributes(nd, key);

      // Extract associated symbol and signature
      emitNodeSymbol(nd, key);
      if (nd.getDeclaredSignatureId() != -1) {
        Label signatureKey = trapwriter.globalID("signature;" + nd.getDeclaredSignatureId());
        trapwriter.addTuple("declared_function_signature", key, signatureKey);
      }

      boolean oldIsStrict = isStrict;
      isStrict = bodyIsStrict;
      this.visit(nd.getBody(), key, -2);
      isStrict = oldIsStrict;

      contextManager.leaveContainer();
      scopeManager.leaveScope();
    }

    private void extractParameterDefaultsAndTypes(IFunction nd, Label key, int paramCount) {
      for (int j = 0; j < paramCount; ++j) {
        // parameter defaults are populated at indices -5, -9, ...
        if (nd.hasDefault(j)) this.visit(nd.getDefault(j), key, -(4 * j + 5));
        // parameter type annotations are populated at indices -6, -10, ...
        if (nd.hasParameterType(j))
          this.visit(nd.getParameterType(j), key, -(4 * j + 6), IdContext.typeBind);
      }
      // type parameters are at indices -7, -11, -15, ...
      visitAll(nd.getTypeParameters(), key, IdContext.typeDecl, -7, -4);
      // parameter decorators are at indices -8, -12, -16, ...
      visitAll(nd.getParameterDecorators(), key, IdContext.varBind, -8, -4);
    }

    @Override
    public Label visit(SwitchStatement nd, Context c) {
      Label key = super.visit(nd, c);
      DeclaredNames lexicals =
          scopeManager.collectDeclaredNames(nd.getCases(), isStrict, true, DeclKind.none);

      visit(nd.getDiscriminant(), key, -1);

      if (!lexicals.isEmpty()) {
        scopeManager.enterScope(nd);
        scopeManager.addNames(lexicals);
      }
      contextManager.enterSwitchStatement(nd);
      visitAll(nd.getCases(), key);
      contextManager.leaveSwitchStatement();
      if (!lexicals.isEmpty()) scopeManager.leaveScope();
      return key;
    }

    @Override
    public Label visit(SwitchCase nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getTest(), key, -1);
      visitAll(nd.getConsequent(), key);
      return key;
    }

    @Override
    public Label visit(ForStatement nd, Context c) {
      Label key = super.visit(nd, c);
      DeclaredNames lexicals =
          scopeManager.collectDeclaredNames(nd.getInit(), isStrict, true, DeclKind.none);
      Scope scope = null;
      if (!lexicals.isEmpty()) {
        scope = scopeManager.enterScope(nd);
        scopeManager.addNames(lexicals);
      }

      visit(nd.getTest(), key, 1);
      visit(nd.getUpdate(), key, 2);

      /**
       * If the 'for' statement declares lexical variables in its init, we have to handle it
       * specially: while the variables are declared in the newly introduced scope, the initialiser
       * expressions are evaluated in the outer scope. Since this differs from our normal handling
       * of variable declarations, we have to treat the entire declaration inline instead of
       * delegating to the normal visitor methods.
       */
      if (!lexicals.isEmpty()) {
        VariableDeclaration decl = (VariableDeclaration) nd.getInit();
        Label declkey = visit((Statement) decl, new Context(key, 0, IdContext.varBind));
        int idx = 0;
        for (VariableDeclarator declarator : decl.getDeclarations()) {
          Label declaratorKey =
              visit((Expression) declarator, new Context(declkey, idx++, IdContext.varBind));

          // the 'let' bound variable lives in the new scope
          visit(declarator.getId(), declaratorKey, 0, IdContext.varDecl);

          // but its initialiser does not
          scopeManager.leaveScope();
          visit(declarator.getInit(), declaratorKey, 1);
          scopeManager.reenterScope(scope);
        }
      } else {
        visit(nd.getInit(), key, 0);
      }

      contextManager.enterLoopStmt(nd);
      visit(nd.getBody(), key, 3);
      contextManager.leaveLoopStmt();
      if (!lexicals.isEmpty()) scopeManager.leaveScope();
      return key;
    }

    @Override
    public Label visit(EnhancedForStatement nd, Context c) {
      Label key = super.visit(nd, c);
      DeclaredNames lexicals =
          scopeManager.collectDeclaredNames(nd.getLeft(), isStrict, true, DeclKind.none);
      visit(nd.getRight(), key, 1);
      if (!lexicals.isEmpty()) {
        scopeManager.enterScope(nd);
        scopeManager.addNames(lexicals);
      }
      visit(nd.getLeft(), key, 0);
      visit(nd.getDefaultValue(), key, -1);
      contextManager.enterLoopStmt(nd);
      visit(nd.getBody(), key, 2);
      contextManager.leaveLoopStmt();
      if (!lexicals.isEmpty()) scopeManager.leaveScope();
      if (nd instanceof ForOfStatement && ((ForOfStatement) nd).isAwait())
        trapwriter.addTuple("isForAwaitOf", key);
      return key;
    }

    @Override
    public Label visit(ArrayExpression nd, Context c) {
      Label key = super.visit(nd, c);
      visitAll(nd.getElements(), key, IdContext.varBind, 0);
      trapwriter.addTuple("arraySize", key, nd.getElements().size());
      return key;
    }

    @Override
    public Label visit(ArrayPattern nd, Context c) {
      Label key = super.visit(nd, c);
      visitAll(nd.getElements(), key, c.idcontext, 0);
      visit(nd.getRest(), key, -1, c.idcontext);
      visitAll(nd.getDefaults(), key, IdContext.varBind, -2, -1);
      trapwriter.addTuple("arraySize", key, nd.getElements().size());
      return key;
    }

    @Override
    public Label visit(ObjectPattern nd, Context c) {
      Label key = super.visit(nd, c);
      visitAll(nd.getProperties(), key, c.idcontext, 0);
      visit(nd.getRest(), key, -1, c.idcontext);
      return key;
    }

    @Override
    public Label visit(ObjectExpression nd, Context c) {
      Label key = super.visit(nd, c);
      visitAll(nd.getProperties(), key, IdContext.varBind, 0);
      return key;
    }

    @Override
    public Label visit(Property nd, Context c) {
      Label propkey = trapwriter.localID(nd);
      int kind = nd.getKind().ordinal();
      String tostring = lexicalExtractor.mkToString(nd);
      trapwriter.addTuple("properties", propkey, c.parent, c.childIndex, kind, tostring);
      locationManager.emitNodeLocation(nd, propkey);
      visitAll(nd.getDecorators(), propkey, IdContext.varBind, -1, -1);
      visit(nd.getKey(), propkey, 0, nd.isComputed() ? IdContext.varBind : IdContext.label);
      visit(nd.getValue(), propkey, 1, c.idcontext);
      visit(nd.getDefaultValue(), propkey, 2, IdContext.varBind);
      if (nd.isComputed()) trapwriter.addTuple("isComputed", propkey);
      if (nd.isMethod()) trapwriter.addTuple("isMethod", propkey);
      return propkey;
    }

    @Override
    public Label visit(IfStatement nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getTest(), key, 0);
      visit(nd.getConsequent(), key, 1);
      visit(nd.getAlternate(), key, 2);
      return key;
    }

    @Override
    public Label visit(ConditionalExpression nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getTest(), key, 0);
      visit(nd.getConsequent(), key, 1);
      visit(nd.getAlternate(), key, 2);
      return key;
    }

    @Override
    public Label visit(LabeledStatement nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getLabel(), key, 0, IdContext.label);
      contextManager.enterLabeledStatement(nd);
      visit(nd.getBody(), key, 1);
      contextManager.leaveLabeledStatement(nd);
      return key;
    }

    @Override
    public Label visit(WithStatement nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getObject(), key, 0);
      visit(nd.getBody(), key, 1);
      return key;
    }

    @Override
    public Label visit(DoWhileStatement nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getTest(), key, 1);
      contextManager.enterLoopStmt(nd);
      visit(nd.getBody(), key, 0);
      contextManager.leaveLoopStmt();
      return key;
    }

    @Override
    public Label visit(WhileStatement nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getTest(), key, 0);
      contextManager.enterLoopStmt(nd);
      visit(nd.getBody(), key, 1);
      contextManager.leaveLoopStmt();
      return key;
    }

    @Override
    public Label visit(CatchClause nd, Context c) {
      Label key = super.visit(nd, c);
      scopeManager.enterScope(nd);
      if (nd.getParam() != null) {
        scopeManager.addNames(
            scopeManager.collectDeclaredNames(nd.getParam(), isStrict, false, DeclKind.var));
        visit(nd.getParam(), key, 0, IdContext.varDecl);
      }
      visit(nd.getGuard(), key, 2);
      visit(nd.getBody(), key, 1);
      scopeManager.leaveScope();
      return key;
    }

    @Override
    public Label visit(TryStatement nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getBlock(), key, 0);
      visitAll(nd.getAllHandlers(), key, IdContext.varBind, 1);
      visit(nd.getFinalizer(), key, -1);
      return key;
    }

    @Override
    public Label visit(JumpStatement nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getLabel(), key, 0, IdContext.label);
      Label targetKey = trapwriter.localID(contextManager.getTarget(nd));
      trapwriter.addTuple("jumpTargets", key, targetKey);
      return key;
    }

    @Override
    public Label visit(ReturnStatement nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getArgument(), key, 0, IdContext.varBind);
      return key;
    }

    @Override
    public Label visit(ThrowStatement nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getArgument(), key, 0, IdContext.varBind);
      return key;
    }

    @Override
    public Label visit(SequenceExpression nd, Context c) {
      Label key = super.visit(nd, c);
      visitAll(nd.getExpressions(), key, IdContext.varBind, 0);
      return key;
    }

    @Override
    public Label visit(ParenthesizedExpression nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getExpression(), key, 0, IdContext.varBind);
      return key;
    }

    @Override
    public Label visit(TaggedTemplateExpression nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getTag(), key, 0);
      visit(nd.getQuasi(), key, 1);
      visitAll(nd.getTypeArguments(), key, IdContext.typeBind, 2);
      return key;
    }

    @Override
    public Label visit(TemplateLiteral nd, Context c) {
      Label key = super.visit(nd, c);
      visitAll(nd.getChildren(), key, IdContext.varBind, 0);
      return key;
    }

    @Override
    public Label visit(TemplateElement nd, Context c) {
      Label key = super.visit(nd, c);
      String cooked;
      if (nd.getCooked() == null) cooked = "";
      else cooked = String.valueOf(nd.getCooked());
      trapwriter.addTuple("literals", cooked, nd.getRaw(), key);
      return key;
    }

    @Override
    public Label visit(ClassDeclaration nd, Context c) {
      Label lbl = super.visit(nd, c);
      if (nd.hasDeclareKeyword()) {
        trapwriter.addTuple("hasDeclareKeyword", lbl);
      }
      if (nd.hasAbstractKeyword()) {
        trapwriter.addTuple("isAbstractClass", lbl);
      }
      return visit(nd.getClassDef(), lbl, nd, false);
    }

    @Override
    public Label visit(ClassExpression nd, Context c) {
      Label lbl = super.visit(nd, c);
      return visit(nd.getClassDef(), lbl, nd, true);
    }

    @Override
    public Label visit(TypeParameter nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getId(), key, 0, IdContext.typeDecl);
      visit(nd.getBound(), key, 1, IdContext.typeBind);
      visit(nd.getDefault(), key, 2, IdContext.typeBind);
      return key;
    }

    private Label visit(AClass ac, Label key, Node scopeNode, boolean isClassExpression) {
      visitAll(ac.getDecorators(), key, IdContext.varBind, -2, -3);
      // The identifier of a class declaration is visited before entering the
      // class scope, since it must resolve to the enclosing block, not its own scope.
      if (!isClassExpression) {
        visit(ac.getId(), key, 0, IdContext.varAndTypeDecl);
      }
      if (ac.hasId() || ac.hasTypeParameters()) {
        scopeManager.enterScope(scopeNode);
        if (isClassExpression && ac.hasId()) {
          scopeManager.addVariables(ac.getId().getName());
          scopeManager.addTypeName(ac.getId().getName());
          // Caveat: if the class name equals a type parameter name, the class name
          // is shadowed. We don't model that; instead it will be seen as a type name
          // that has two declarations (the class name and the type parameter).
        }
        for (TypeParameter tp : ac.getTypeParameters()) {
          scopeManager.addTypeName(tp.getId().getName());
        }
      }
      if (isClassExpression) {
        visit(ac.getId(), key, 0, IdContext.varAndTypeDecl);
      }
      visitAll(ac.getTypeParameters(), key, IdContext.typeDecl, -3, -3);
      visitAll(ac.getSuperInterfaces(), key, IdContext.typeBind, -1, -3);
      visit(ac.getSuperClass(), key, 1);
      MethodDefinition constructor = ac.getBody().getConstructor();
      if (constructor == null) {
        addDefaultConstructor(ac);
      }
      visit(ac.getBody(), key, 2);
      if (ac.hasId() || ac.hasTypeParameters()) {
        scopeManager.leaveScope();
      }
      emitNodeSymbol(ac, key);
      return key;
    }

    private void emitNodeSymbol(INodeWithSymbol def, Label key) {
      int symbol = def.getSymbol();
      if (symbol != -1) {
        Label symbolLabel = trapwriter.globalID("symbol;" + symbol);
        trapwriter.addTuple("ast_node_symbol", key, symbolLabel);
      }
    }

    @Override
    public Label visit(NamespaceDeclaration nd, Context c) {
      Label lbl = super.visit(nd, c);
      emitNodeSymbol(nd, lbl);
      IdContext context =
          nd.isInstantiated() ? IdContext.varAndNamespaceDecl : IdContext.namespaceDecl;
      visit(nd.getName(), lbl, -1, context);
      if (nd.hasDeclareKeyword()) {
        trapwriter.addTuple("hasDeclareKeyword", lbl);
      }
      DeclaredNames hoistedVars =
          scopeManager.collectDeclaredNames(nd.getBody(), isStrict, false, DeclKind.none);
      DeclaredNames lexicalVars =
          scopeManager.collectDeclaredNames(nd.getBody(), isStrict, true, DeclKind.none);
      scopeManager.enterScope(nd);
      scopeManager.addNames(hoistedVars);
      scopeManager.addNames(lexicalVars);
      contextManager.enterContainer(lbl);
      visitAll(nd.getBody(), lbl);
      contextManager.leaveContainer();
      scopeManager.leaveScope();
      if (nd.isInstantiated()) {
        trapwriter.addTuple("isInstantiated", lbl);
      }
      return lbl;
    }

    /**
     * Add a synthetic default constructor to {@code ac}: for classes without a superclass, the
     * default constructor is {@code constructor() {}}, for those with a superclass, it is {@code
     * constructor(...args) { super(...args); }}.
     */
    private void addDefaultConstructor(AClass ac) {
      ClassBody classBody = ac.getBody();

      Position loc = classBody.getLoc().getStart();

      // fake identifier `constructor`
      SourceLocation idLoc = fakeLoc("constructor", loc);
      Identifier id = new Identifier(idLoc, "constructor");

      // fake body `{}` or `{ super(...args); }`
      boolean hasSuperClass = ac.hasSuperClass();
      SourceLocation bodyLoc = fakeLoc(hasSuperClass ? "{ super(...args); }" : "{}", loc);
      BlockStatement body = new BlockStatement(bodyLoc, new ArrayList<Statement>());
      if (hasSuperClass) {
        Identifier argsRef = new Identifier(fakeLoc("args", loc), "args");
        SpreadElement spreadArgs = new SpreadElement(fakeLoc("...args", loc), argsRef);
        Super superExpr = new Super(fakeLoc("super", loc));
        CallExpression superCall =
            new CallExpression(
                fakeLoc("super(...args)", loc),
                superExpr,
                new ArrayList<>(),
                CollectionUtil.makeList(spreadArgs),
                false,
                false);
        ExpressionStatement superCallStmt =
            new ExpressionStatement(fakeLoc("super(...args);", loc), superCall);
        body.getBody().add(superCallStmt);
      }

      // fake method definition `() {}` or `(...args) { super(...args); }`
      List<Expression> params = new ArrayList<>();
      if (hasSuperClass) {
        Identifier argsDecl = new Identifier(fakeLoc("args", loc), "args");
        RestElement restArgs = new RestElement(fakeLoc("...args", loc), argsDecl);
        params.add(restArgs);
      }
      AFunction<BlockStatement> fndef =
          new AFunction<>(
              null,
              params,
              body,
              false,
              false,
              Collections.emptyList(),
              Collections.emptyList(),
              Collections.emptyList(),
              null,
              null,
              AFunction.noOptionalParams);
      String fnSrc = hasSuperClass ? "(...args) { super(...args); }" : "() {}";
      SourceLocation fnloc = fakeLoc(fnSrc, loc);
      FunctionExpression fn = new FunctionExpression(fnloc, fndef);

      // fake constructor definition `constructor() {}`
      // or `constructor(...args) { super(...args); }`
      String ctorSrc =
          hasSuperClass ? "constructor(...args) { super(...args); }" : "constructor() {}";
      SourceLocation ctorloc = fakeLoc(ctorSrc, loc);
      MethodDefinition ctor =
          new MethodDefinition(ctorloc, DeclarationFlags.none, Kind.CONSTRUCTOR, id, fn);
      classBody.addMember(ctor);
    }

    private SourceLocation fakeLoc(String src, Position loc) {
      return new SourceLocation(src, loc, loc);
    }

    /** The constructors of all enclosing classes. */
    private Stack<MethodDefinition> ctors = new Stack<>();

    @Override
    public Label visit(ClassBody nd, Context c) {
      ctors.push(nd.getConstructor());
      visitAll(nd.getBody(), c.parent, c.idcontext, c.childIndex);
      visitAll(
          nd.getConstructor().getParameterFields(),
          c.parent,
          c.idcontext,
          c.childIndex + nd.getBody().size());
      ctors.pop();
      return c.parent;
    }

    private int getMethodKind(MethodDefinition nd) {
      switch (nd.getKind()) {
        case METHOD:
        case CONSTRUCTOR:
          return 0;
        case GET:
          return 1;
        case SET:
          return 2;
        case FUNCTION_CALL_SIGNATURE:
          return 4;
        case CONSTRUCTOR_CALL_SIGNATURE:
          return 5;
        case INDEX_SIGNATURE:
          return 6;
      }
      return 0;
    }

    private int getFieldKind(FieldDefinition nd) {
      return nd.isParameterField() ? 9 : 8;
    }

    @Override
    public Label visit(MemberDefinition<?> nd, Context c) {
      Label methkey = trapwriter.localID(nd);
      int kind;
      if (nd instanceof MethodDefinition) {
        kind = getMethodKind((MethodDefinition) nd);
      } else {
        kind = getFieldKind((FieldDefinition) nd);
      }
      String tostring = lexicalExtractor.mkToString(nd);
      trapwriter.addTuple("properties", methkey, c.parent, c.childIndex, kind, tostring);
      locationManager.emitNodeLocation(nd, methkey);
      visitAll(nd.getDecorators(), methkey, IdContext.varBind, -1, -1);

      // the name and initialiser expression of an instance field is evaluated as part of
      // the constructor, so we adjust our syntactic context to reflect this
      MethodDefinition ctor = null;
      if (nd instanceof FieldDefinition && !nd.isStatic() && !ctors.isEmpty()) ctor = ctors.peek();
      Label constructorKey = null;
      if (ctor != null) {
        constructorKey = trapwriter.localID(ctor.getValue());
        contextManager.enterContainer(constructorKey);
      }
      visit(nd.getKey(), methkey, 0, nd.isComputed() ? IdContext.varBind : IdContext.label);
      visit(nd.getValue(), methkey, 1, c.idcontext);
      if (ctor != null) contextManager.leaveContainer();

      if (nd instanceof MethodDefinition && !nd.isCallSignature() && !nd.isIndexSignature())
        trapwriter.addTuple("isMethod", methkey);
      // Emit tuples for isStatic, isAbstract, isComputed, etc
      for (int i = 0; i < DeclarationFlags.numberOfFlags; ++i) {
        if (DeclarationFlags.hasNthFlag(nd.getFlags(), i)) {
          trapwriter.addTuple(DeclarationFlags.relationNames.get(i), methkey);
        }
      }

      if (nd instanceof FieldDefinition) {
        FieldDefinition field = (FieldDefinition) nd;
        if (field.isParameterField() && constructorKey != null) {
          trapwriter.addTuple(
              "parameter_fields", methkey, constructorKey, field.getFieldParameterIndex());
        } else {
          visit(field.getTypeAnnotation(), methkey, 2, IdContext.typeBind);
        }
      }

      if (nd.hasDeclareKeyword()) {
        trapwriter.addTuple("hasDeclareKeyword", methkey);
      }

      return methkey;
    }

    @Override
    public Label visit(MetaProperty nd, Context c) {
      return visit((Expression) nd, c);
    }

    @Override
    public Label visit(ExportAllDeclaration nd, Context c) {
      Label lbl = super.visit(nd, c);
      visit(nd.getSource(), lbl, 0);
      return lbl;
    }

    @Override
    public Label visit(ExportDefaultDeclaration nd, Context c) {
      Label lbl = super.visit(nd, c);
      visit(nd.getDeclaration(), lbl, 0, IdContext.export);
      return lbl;
    }

    @Override
    public Label visit(ExportNamedDeclaration nd, Context c) {
      Label lbl = super.visit(nd, c);
      visit(nd.getDeclaration(), lbl, -1);
      visit(nd.getSource(), lbl, -2);
      visitAll(nd.getSpecifiers(), lbl, nd.hasSource() ? IdContext.label : IdContext.export, 0);
      return lbl;
    }

    @Override
    public Label visit(ExportSpecifier nd, Context c) {
      Label lbl = super.visit(nd, c);
      visit(nd.getLocal(), lbl, 0, c.idcontext);
      visit(nd.getExported(), lbl, 1, IdContext.label);
      return lbl;
    }

    @Override
    public Label visit(ImportDeclaration nd, Context c) {
      Label lbl = super.visit(nd, c);
      visit(nd.getSource(), lbl, -1);
      visitAll(nd.getSpecifiers(), lbl);
      return lbl;
    }

    @Override
    public Label visit(ImportSpecifier nd, Context c) {
      Label lbl = super.visit(nd, c);
      visit(nd.getImported(), lbl, 0, IdContext.label);
      visit(nd.getLocal(), lbl, 1, IdContext.varAndTypeAndNamespaceDecl);
      return lbl;
    }

    @Override
    public Label visit(JSXElement nd, Context c) {
      Label lbl = super.visit(nd, c);
      JSXOpeningElement open = nd.getOpeningElement();
      IJSXName name = open.getName();
      /*
       * Children of JSX elements are populated at the following indices:
       *
       *  - -1: element name (omitted for fragments)
       *  - 0, 1, 2, ...: attributes
       *  - -2, -3, ...: body elements
       *
       * A spread attribute is represented as an attribute without
       * a name, whose value is a spread element.
       */
      visit(name, lbl, -1, isTagName(name) ? IdContext.label : IdContext.varBind);
      visitAll(open.getAttributes(), lbl, IdContext.varBind, 0, 1);
      visitAll(nd.getChildren(), lbl, IdContext.varBind, -2, -1);
      return lbl;
    }

    /**
     * A JSX element name is interpreted as an HTML tag name if it starts with a lower-case
     * character or contains a dash.
     */
    private boolean isTagName(IJSXName name) {
      if (name instanceof JSXIdentifier) {
        String id = ((JSXIdentifier) name).getName();
        return Character.isLowerCase(id.charAt(0)) || id.contains("-");
      }
      return false;
    }

    @Override
    public Label visit(JSXIdentifier nd, Context c) {
      return visit((Identifier) nd, c);
    }

    @Override
    public Label visit(JSXMemberExpression nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getObject(), key, 0);
      visit(nd.getName(), key, 1, IdContext.label);
      return key;
    }

    @Override
    public Label visit(JSXNamespacedName nd, Context c) {
      Label lbl = super.visit(nd, c);
      visit(nd.getNamespace(), lbl, 0, IdContext.label);
      visit(nd.getName(), lbl, 1, IdContext.label);
      return lbl;
    }

    @Override
    public Label visit(JSXAttribute nd, Context c) {
      Label propkey = trapwriter.localID(nd);
      String tostring = lexicalExtractor.mkToString(nd);
      trapwriter.addTuple("properties", propkey, c.parent, c.childIndex, 3, tostring);
      locationManager.emitNodeLocation(nd, propkey);
      visit(nd.getName(), propkey, 0, IdContext.label);
      visit(nd.getValue(), propkey, 1, c.idcontext);
      return propkey;
    }

    @Override
    public Label visit(JSXSpreadAttribute nd, Context c) {
      // We want to represent a spread attribute like `{...props}` as an anonymous attribute
      // whose value is a spread expression `...props`. Hence we need two entities,
      // one for the attribute and one for the spread expression, which both correspond
      // to the same AST node. We achieve this by using a special label kind for the former
      // to make the trap writer give it a different label

      // first, make one entity for the attribute, and populate its entry
      // in the `properties` table
      Label propkey = trapwriter.localID(nd, "JSXSpreadAttribute");
      String tostring = lexicalExtractor.mkToString(nd);
      trapwriter.addTuple("properties", propkey, c.parent, c.childIndex, 3, tostring);
      locationManager.emitNodeLocation(nd, propkey);

      // now populate the spread expression, stripping off the surrounding
      // braces for its tostring
      tostring = tostring.substring(1, tostring.length() - 1).trim();
      Label valkey = visit(nd, 66, tostring, new Context(propkey, 1, IdContext.varBind));
      visit(nd.getArgument(), valkey, 0);
      return propkey;
    }

    @Override
    public Label visit(JSXExpressionContainer nd, Context c) {
      return visit(nd.getExpression(), c.parent, c.childIndex);
    }

    @Override
    public Label visit(JSXEmptyExpression nd, Context c) {
      return visit(nd, 91, c);
    }

    @Override
    public Label visit(AwaitExpression nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getArgument(), key, 0);
      return key;
    }

    @Override
    public Label visit(Decorator nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getExpression(), key, 0);
      return key;
    }

    @Override
    public Label visit(BindExpression nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getObject(), key, 0);
      visit(nd.getCallee(), key, 1);
      return key;
    }

    @Override
    public Label visit(ImportWholeDeclaration nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getLhs(), key, 0, IdContext.varAndTypeAndNamespaceDecl);
      visit(nd.getRhs(), key, 1, IdContext.export);
      return key;
    }

    @Override
    public Label visit(ExportWholeDeclaration nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getRhs(), key, 0, IdContext.export);
      return key;
    }

    @Override
    public Label visit(ExternalModuleReference nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getExpression(), key, 0);
      return key;
    }

    @Override
    public Label visit(DynamicImport nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getSource(), key, 0);
      return key;
    }

    @Override
    public Label visit(InterfaceDeclaration nd, Context c) {
      Label key = super.visit(nd, c);
      if (nd.hasTypeParameters()) {
        scopeManager.enterScope(nd);
        for (TypeParameter tp : nd.getTypeParameters()) {
          scopeManager.addTypeName(tp.getId().getName());
        }
      }
      visitAll(nd.getTypeParameters(), key, IdContext.typeBind, -2, -2);
      visitAll(nd.getSuperInterfaces(), key, IdContext.typeBind, -1, -2);
      visit(nd.getName(), key, 0, IdContext.typeDecl);
      visitAll(nd.getBody(), key, IdContext.label, 2);
      if (nd.hasTypeParameters()) {
        scopeManager.leaveScope();
      }
      emitNodeSymbol(nd, key);
      return key;
    }

    @Override
    public Label visit(KeywordTypeExpr nd, Context c) {
      Label key = super.visit(nd, c);
      trapwriter.addTuple("literals", nd.getKeyword(), nd.getKeyword(), key);
      return key;
    }

    @Override
    public Label visit(ArrayTypeExpr nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getElementType(), key, 0, IdContext.typeBind);
      return key;
    }

    @Override
    public Label visit(UnionTypeExpr nd, Context c) {
      Label key = super.visit(nd, c);
      visitAll(nd.getElementTypes(), key, IdContext.typeBind, 0);
      return key;
    }

    @Override
    public Label visit(IndexedAccessTypeExpr nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getObjectType(), key, 0, IdContext.typeBind);
      visit(nd.getIndexType(), key, 1, IdContext.typeBind);
      return key;
    }

    @Override
    public Label visit(IntersectionTypeExpr nd, Context c) {
      Label key = super.visit(nd, c);
      visitAll(nd.getElementTypes(), key, IdContext.typeBind, 0);
      return key;
    }

    @Override
    public Label visit(ParenthesizedTypeExpr nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getElementType(), key, 0, IdContext.typeBind);
      return key;
    }

    @Override
    public Label visit(TupleTypeExpr nd, Context c) {
      Label key = super.visit(nd, c);
      visitAll(nd.getElementTypes(), key, IdContext.typeBind, 0);
      return key;
    }

    @Override
    public Label visit(UnaryTypeExpr nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getElementType(), key, 0, IdContext.typeBind);
      return key;
    }

    @Override
    public Label visit(GenericTypeExpr nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getTypeName(), key, -1, IdContext.typeBind);
      visitAll(nd.getTypeArguments(), key, IdContext.typeBind, 0);
      return key;
    }

    @Override
    public Label visit(TypeofTypeExpr nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getExpression(), key, 0, IdContext.varInTypeBind);
      return key;
    }

    @Override
    public Label visit(PredicateTypeExpr nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getExpression(), key, 0, IdContext.varInTypeBind);
      visit(nd.getTypeExpr(), key, 1, IdContext.typeBind);
      if (nd.hasAssertsKeyword()) {
        trapwriter.addTuple("hasAssertsKeyword", key);
      }
      return key;
    }

    @Override
    public Label visit(InterfaceTypeExpr nd, Context c) {
      Label key = super.visit(nd, c);
      visitAll(nd.getBody(), key);
      return key;
    }

    @Override
    public Label visit(ExpressionWithTypeArguments nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getExpression(), key, -1, IdContext.varBind);
      visitAll(nd.getTypeArguments(), key, IdContext.typeBind, 0);
      return key;
    }

    @Override
    public Label visit(FunctionTypeExpr nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getFunction(), key, 0);
      return key;
    }

    @Override
    public Label visit(TypeAssertion nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getExpression(), key, 0);
      visit(nd.getTypeAnnotation(), key, 1, IdContext.typeBind);
      return key;
    }

    @Override
    public Label visit(MappedTypeExpr nd, Context c) {
      Label key = super.visit(nd, c);
      scopeManager.enterScope(nd);
      scopeManager.addTypeName(nd.getTypeParameter().getId().getName());
      visit(nd.getTypeParameter(), key, 0, IdContext.typeDecl);
      visit(nd.getElementType(), key, 1, IdContext.typeBind);
      scopeManager.leaveScope();
      return key;
    }

    @Override
    public Label visit(TypeAliasDeclaration nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getId(), key, 0, IdContext.typeDecl);
      if (nd.hasTypeParameters()) {
        scopeManager.enterScope(nd);
        for (TypeParameter tp : nd.getTypeParameters()) {
          scopeManager.addTypeName(tp.getId().getName());
        }
      }
      visitAll(nd.getTypeParameters(), key, IdContext.typeDecl, 2, 1);
      visit(nd.getDefinition(), key, 1, IdContext.typeBind);
      if (nd.hasTypeParameters()) {
        scopeManager.leaveScope();
      }
      emitNodeSymbol(nd, key);
      return key;
    }

    @Override
    public Label visit(EnumDeclaration nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getId(), key, 0, IdContext.varAndTypeAndNamespaceDecl);
      visitAll(nd.getDecorators(), key, IdContext.varBind, -1, -1);
      scopeManager.enterScope(nd);
      for (EnumMember member : nd.getMembers()) {
        scopeManager.addVariables(member.getId().getName());
        scopeManager.addTypeName(member.getId().getName());
      }
      visitAll(nd.getMembers(), key, IdContext.varAndTypeDecl, 1, 1);
      scopeManager.leaveScope();
      if (nd.isConst()) {
        trapwriter.addTuple("isConstEnum", key);
      }
      if (nd.hasDeclareKeyword()) {
        trapwriter.addTuple("hasDeclareKeyword", key);
      }
      emitNodeSymbol(nd, key);
      return key;
    }

    @Override
    public Label visit(EnumMember nd, Context c) {
      Label key = trapwriter.localID(nd);
      String tostring = lexicalExtractor.mkToString(nd);
      trapwriter.addTuple("properties", key, c.parent, c.childIndex, 7, tostring);
      locationManager.emitNodeLocation(nd, key);
      visit(nd.getId(), key, 0, IdContext.varAndTypeDecl);
      visit(nd.getInitializer(), key, 1, IdContext.varBind);
      emitNodeSymbol(nd, key);
      return key;
    }

    @Override
    public Label visit(ExternalModuleDeclaration nd, Context c) {
      Label key = super.visit(nd, c);
      trapwriter.addTuple("hasDeclareKeyword", key);
      visit(nd.getName(), key, -1, IdContext.label);
      DeclaredNames hoistedVars =
          scopeManager.collectDeclaredNames(nd.getBody(), isStrict, false, DeclKind.none);
      DeclaredNames lexicalVars =
          scopeManager.collectDeclaredNames(nd.getBody(), isStrict, true, DeclKind.none);
      scopeManager.enterScope(nd);
      scopeManager.addNames(hoistedVars);
      scopeManager.addNames(lexicalVars);
      contextManager.enterContainer(key);
      visitAll(nd.getBody(), key);
      contextManager.leaveContainer();
      scopeManager.leaveScope();
      return key;
    }

    @Override
    public Label visit(ExportAsNamespaceDeclaration nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getId(), key, 0, IdContext.label);
      return key;
    }

    @Override
    public Label visit(DecoratorList nd, Context c) {
      Label key = super.visit(nd, c);
      visitAll(nd.getDecorators(), key, IdContext.varBind, 0);
      return key;
    }

    @Override
    public Label visit(GlobalAugmentationDeclaration nd, Context c) {
      // It is possible for declarations in the global scope block to refer
      // to types not declared in the global scope. For instance:
      //
      // interface I {}
      // declare global {
      //   var x: I
      // }
      //
      // At extraction time, we model this by introducing a scope for the block
      // that has the same label as the global scope, but is otherwise a normal scope.
      // The fake scope does not exist at the QL level, as it is indistinguishable
      // from the global scope.
      Label key = super.visit(nd, c);
      trapwriter.addTuple("hasDeclareKeyword", key);
      DeclaredNames hoistedVars =
          scopeManager.collectDeclaredNames(nd.getBody(), isStrict, false, DeclKind.none);
      DeclaredNames lexicalVars =
          scopeManager.collectDeclaredNames(nd.getBody(), isStrict, true, DeclKind.none);
      scopeManager.enterGlobalAugmentationScope();
      scopeManager.addNames(hoistedVars);
      scopeManager.addNames(lexicalVars);
      contextManager.enterContainer(key);
      visitAll(nd.getBody(), key);
      contextManager.leaveContainer();
      scopeManager.leaveScope();
      return key;
    }

    @Override
    public Label visit(NonNullAssertion nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getExpression(), key, 0);
      return key;
    }

    @Override
    public Label visit(ConditionalTypeExpr nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getCheckType(), key, 0, IdContext.typeBind);
      Set<String> boundTypes = scopeManager.collectDeclaredInferTypes(nd.getExtendsType());
      if (!boundTypes.isEmpty()) {
        scopeManager.enterScope(nd);
        scopeManager.addTypeNames(boundTypes);
      }
      visit(nd.getExtendsType(), key, 1, IdContext.typeBind);
      visit(nd.getTrueType(), key, 2, IdContext.typeBind);
      if (!boundTypes.isEmpty()) {
        scopeManager.leaveScope();
      }
      visit(nd.getFalseType(), key, 3, IdContext.typeBind);
      return key;
    }

    @Override
    public Label visit(InferTypeExpr nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getTypeParameter(), key, 0, IdContext.typeDecl);
      return key;
    }

    @Override
    public Label visit(ImportTypeExpr nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getPath(), key, 0, IdContext.typeBind);
      return key;
    }

    @Override
    public Label visit(OptionalTypeExpr nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getElementType(), key, 0, IdContext.typeBind);
      return key;
    }

    @Override
    public Label visit(RestTypeExpr nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getArrayType(), key, 0, IdContext.typeBind);
      return key;
    }

    @Override
    public Label visit(XMLAttributeSelector nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getAttribute(), key, 0, IdContext.label);
      return key;
    }

    @Override
    public Label visit(XMLFilterExpression nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getLeft(), key, 0);
      visit(nd.getRight(), key, 1);
      return key;
    }

    @Override
    public Label visit(XMLQualifiedIdentifier nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getLeft(), key, 0);
      visit(nd.getRight(), key, 1, nd.isComputed() ? IdContext.varBind : IdContext.label);
      return key;
    }

    @Override
    public Label visit(XMLDotDotExpression nd, Context c) {
      Label key = super.visit(nd, c);
      visit(nd.getLeft(), key, 0);
      visit(nd.getRight(), key, 1, IdContext.label);
      return key;
    }
  }

  public void extract(Node root, Platform platform, SourceType sourceType, int toplevelKind) {
    lexicalExtractor.getMetrics().startPhase(ExtractionPhase.ASTExtractor_extract);
    trapwriter.addTuple("toplevels", toplevelLabel, toplevelKind);
    locationManager.emitNodeLocation(root, toplevelLabel);

    root.accept(new V(platform, sourceType), null);
    lexicalExtractor.getMetrics().stopPhase(ExtractionPhase.ASTExtractor_extract);
  }
}
