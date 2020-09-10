package com.semmle.js.extractor;

import com.semmle.js.ast.AClass;
import com.semmle.js.ast.AFunctionExpression;
import com.semmle.js.ast.ArrayExpression;
import com.semmle.js.ast.ArrayPattern;
import com.semmle.js.ast.AssignmentExpression;
import com.semmle.js.ast.AwaitExpression;
import com.semmle.js.ast.BinaryExpression;
import com.semmle.js.ast.BindExpression;
import com.semmle.js.ast.BlockStatement;
import com.semmle.js.ast.BreakStatement;
import com.semmle.js.ast.CallExpression;
import com.semmle.js.ast.CatchClause;
import com.semmle.js.ast.Chainable;
import com.semmle.js.ast.ClassBody;
import com.semmle.js.ast.ClassDeclaration;
import com.semmle.js.ast.ClassExpression;
import com.semmle.js.ast.ComprehensionBlock;
import com.semmle.js.ast.ComprehensionExpression;
import com.semmle.js.ast.ConditionalExpression;
import com.semmle.js.ast.Decorator;
import com.semmle.js.ast.DefaultVisitor;
import com.semmle.js.ast.DestructuringPattern;
import com.semmle.js.ast.DoWhileStatement;
import com.semmle.js.ast.DynamicImport;
import com.semmle.js.ast.EnhancedForStatement;
import com.semmle.js.ast.ExportAllDeclaration;
import com.semmle.js.ast.ExportDefaultDeclaration;
import com.semmle.js.ast.ExportDefaultSpecifier;
import com.semmle.js.ast.ExportNamedDeclaration;
import com.semmle.js.ast.ExportNamespaceSpecifier;
import com.semmle.js.ast.ExportSpecifier;
import com.semmle.js.ast.Expression;
import com.semmle.js.ast.ExpressionStatement;
import com.semmle.js.ast.FieldDefinition;
import com.semmle.js.ast.ForStatement;
import com.semmle.js.ast.FunctionDeclaration;
import com.semmle.js.ast.IFunction;
import com.semmle.js.ast.INode;
import com.semmle.js.ast.IStatementContainer;
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
import com.semmle.js.ast.Loop;
import com.semmle.js.ast.MemberDefinition;
import com.semmle.js.ast.MemberExpression;
import com.semmle.js.ast.MethodDefinition;
import com.semmle.js.ast.Node;
import com.semmle.js.ast.ObjectExpression;
import com.semmle.js.ast.ObjectPattern;
import com.semmle.js.ast.ParenthesizedExpression;
import com.semmle.js.ast.Program;
import com.semmle.js.ast.Property;
import com.semmle.js.ast.ReturnStatement;
import com.semmle.js.ast.SequenceExpression;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.SpreadElement;
import com.semmle.js.ast.Statement;
import com.semmle.js.ast.Super;
import com.semmle.js.ast.SwitchCase;
import com.semmle.js.ast.SwitchStatement;
import com.semmle.js.ast.TaggedTemplateExpression;
import com.semmle.js.ast.TemplateLiteral;
import com.semmle.js.ast.ThrowStatement;
import com.semmle.js.ast.TryStatement;
import com.semmle.js.ast.UnaryExpression;
import com.semmle.js.ast.UpdateExpression;
import com.semmle.js.ast.VariableDeclaration;
import com.semmle.js.ast.VariableDeclarator;
import com.semmle.js.ast.Visitor;
import com.semmle.js.ast.WhileStatement;
import com.semmle.js.ast.WithStatement;
import com.semmle.js.ast.XMLAnyName;
import com.semmle.js.ast.XMLAttributeSelector;
import com.semmle.js.ast.XMLDotDotExpression;
import com.semmle.js.ast.XMLFilterExpression;
import com.semmle.js.ast.XMLQualifiedIdentifier;
import com.semmle.js.ast.YieldExpression;
import com.semmle.js.ast.jsx.IJSXName;
import com.semmle.js.ast.jsx.JSXAttribute;
import com.semmle.js.ast.jsx.JSXElement;
import com.semmle.js.ast.jsx.JSXExpressionContainer;
import com.semmle.js.ast.jsx.JSXMemberExpression;
import com.semmle.js.ast.jsx.JSXNamespacedName;
import com.semmle.js.ast.jsx.JSXOpeningElement;
import com.semmle.js.ast.jsx.JSXSpreadAttribute;
import com.semmle.js.extractor.ExtractionMetrics.ExtractionPhase;
import com.semmle.ts.ast.DecoratorList;
import com.semmle.ts.ast.EnumDeclaration;
import com.semmle.ts.ast.EnumMember;
import com.semmle.ts.ast.ExportWholeDeclaration;
import com.semmle.ts.ast.ExpressionWithTypeArguments;
import com.semmle.ts.ast.ExternalModuleReference;
import com.semmle.ts.ast.ImportWholeDeclaration;
import com.semmle.ts.ast.NamespaceDeclaration;
import com.semmle.ts.ast.NonNullAssertion;
import com.semmle.ts.ast.TypeAssertion;
import com.semmle.util.collections.CollectionUtil;
import com.semmle.util.data.Pair;
import com.semmle.util.trap.TrapWriter;
import com.semmle.util.trap.TrapWriter.Label;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Stack;

/**
 * Extractor for intra-procedural expression-level control flow graphs.
 *
 * <p>The nodes in the CFG are expressions, statements, and synthetic entry and exit nodes for every
 * function and for every toplevel.
 *
 * <p>Exceptional control flow is modeled (mostly) conservatively inside `try`-`catch`, i.e., most
 * syntactic constructs that can throw an exception at runtime will get a CFG edge to the enclosing
 * `catch`. We do not model the possible exception resulting from accessing an undeclared global
 * variable, or possible exceptions thrown by implicitly invoked conversion methods.
 *
 * <p>Outside `try`-`catch`, only `throw` statements have their exceptional control flow modeled:
 * they have the `exit` node of the enclosing function or toplevel as their successor.
 *
 * <p>Control flow through `finally` is modeled imprecisely: there is only a single copy of each
 * `finally` block in the CFG, so different control flow paths through a `finally` block get merged
 * at the block.
 *
 * <p>The control flow inside compound expressions and statements reflects execution order at
 * runtime. For most statements that contain expressions, the statement appears in the CFG before
 * the contained expression. The two exceptions here are `return` and `throw`, which both appear
 * _after_ the contained expression to reflect the fact that the return/throw happens after the
 * expression has been evaluated.
 *
 * <p>For assignments, we take the assignment expression itself to express the operation of
 * assigning the RHS to the LHS. Thus, in a simple assignment expression of the form `lhs = rhs`,
 * the control flow is lhs -&gt; rhs -&gt; lhs = rhs.
 *
 * <p>For most binary expressions, the expression node itself represents the operator application,
 * so the CFG of `x + y` is x -&gt; y -&gt; x + y. For short-circuiting operators, on the other
 * hand, the expression node itself acts more like an `if` statement, hence it comes first in the
 * CFG: `x &amp;&amp; y` has CFG
 *
 * <p>x &amp;&amp; y +&gt; x -&gt; y +&gt; f |_________|
 *
 * <p>Finally, for a variable declarator with an initialiser, the declarator represents the
 * assignment of the initialiser expression to the variable. So, the CFG of `var x = 23` is x -&gt;
 * 23 -&gt; var x = 23.
 *
 * <p>The CFG of each function starts with a preamble that visits the parameters and, for ECMAScript
 * 2015 and above, their default arguments, followed by the identifiers of each function declaration
 * in the body in lexical order. This reflects the fact that function declarations are hoisted, but
 * their initialisation happens after parameters have been assigned.
 *
 * <p>Similar considerations apply to toplevels: the preamble visits any import specifiers first,
 * reflecting the fact that imports are resolved before module evaluation starts, followed by (the
 * identifiers of) hoisted function declarations.
 */
public class CFGExtractor {
  private final TrapWriter trapwriter;
  private final Label toplevelLabel;
  private final LocationManager locationManager;
  private final ExtractionMetrics metrics;

  public CFGExtractor(ASTExtractor astExtractor) {
    this.trapwriter = astExtractor.getTrapwriter();
    this.toplevelLabel = astExtractor.getToplevelLabel();
    this.locationManager = astExtractor.getLocationManager();
    this.metrics = astExtractor.getMetrics();
  }

  @SuppressWarnings("unchecked")
  private static Iterable<Node> foreach(Object nd) {
    if (nd == null) return Collections.<Node>emptySet();
    if (nd instanceof Node) return CollectionUtil.singletonIterable((Node) nd);
    return (Iterable<Node>) nd;
  }

  private Iterable<Node> hcaerof(final Object nd) {
    if (nd == null) return Collections.<Node>emptySet();
    if (nd instanceof Node) return CollectionUtil.singletonIterable((Node) nd);
    return new Iterable<Node>() {
      @SuppressWarnings("unchecked")
      @Override
      public Iterator<Node> iterator() {
        return CollectionUtil.reverseIterator((List<Node>) nd);
      }
    };
  }

  /** Returns a list of all the nodes in a tree of nested lists. */
  private List<Node> flattenNestedList(Iterable<?> lists) {
    return flattenNestedList(lists, new ArrayList<>());
  }

  /**
   * Appends all the nodes in a tree of nested lists the given output list, and returns that list.
   */
  private List<Node> flattenNestedList(Iterable<?> lists, List<Node> output) {
    for (Object object : lists) {
      if (object == null) continue;
      if (object instanceof Node) {
        output.add((Node) object);
      } else if (object instanceof Iterable<?>) {
        flattenNestedList((Iterable<?>) object, output);
      } else {
        throw new RuntimeException("Cannot flatten object: " + object);
      }
    }
    return output;
  }

  private static Object union(Object xs, Object ys) {
    if (xs == null) return ys;
    if (ys == null) return xs;
    if (xs instanceof List<?>) {
      @SuppressWarnings("unchecked")
      List<Node> xsCopy = new ArrayList<Node>((List<Node>) xs);
      for (Node y : foreach(ys)) if (!xsCopy.contains(y)) xsCopy.add(y);
      return xsCopy;
    } else {
      if (ys instanceof List<?>) {
        @SuppressWarnings("unchecked")
        List<Object> lys = (List<Object>) ys;
        if (!lys.contains(xs)) {
          lys = new ArrayList<Object>(lys);
          lys.add(0, xs);
        }
        return lys;
      } else if (xs == ys) {
        return xs;
      } else {
        List<Node> res = new ArrayList<Node>(2);
        res.add((Node) xs);
        res.add((Node) ys);
        return res;
      }
    }
  }

  private void succ(Object nd, Object succs) {
    Label ndkey = trapwriter.localID(nd);
    for (Node succ : foreach(succs)) succ(ndkey, succ);
  }

  private void succ(Label ndkey, Node succ) {
    trapwriter.addTuple("successor", ndkey, trapwriter.localID(succ));
  }

  /**
   * Compute the first sub-expression or sub-statement in control flow order.
   *
   * <p>Caution: If you modify this, be sure to also adjust the implementation of the corresponding
   * QL-level method ExprParent.getFirstControlFlowNode().
   */
  private static class First extends DefaultVisitor<Void, Node> {
    @Override
    public Node visit(Node nd, Void v) {
      return nd;
    }

    @Override
    public Node visit(ReturnStatement nd, Void v) {
      if (nd.hasArgument()) return nd.getArgument().accept(this, v);
      else return nd;
    }

    @Override
    public Node visit(ThrowStatement nd, Void v) {
      return nd.getArgument().accept(this, v);
    }

    @Override
    public Node visit(SpreadElement nd, Void v) {
      return nd.getArgument().accept(this, v);
    }

    @Override
    public Node visit(UnaryExpression nd, Void v) {
      return nd.getArgument().accept(this, v);
    }

    @Override
    public Node visit(UpdateExpression nd, Void v) {
      return nd.getArgument().accept(this, v);
    }

    @Override
    public Node visit(YieldExpression nd, Void v) {
      Expression argument = nd.getArgument();
      if (argument != null) return argument.accept(this, v);
      return nd;
    }

    @Override
    public Node visit(Property nd, Void v) {
      Expression key = nd.getKey();
      return (key == null ? nd.getValue() : key).accept(this, v);
    }

    @Override
    public Node visit(MemberDefinition<?> nd, Void v) {
      if (!nd.isConcrete() || nd.isParameterField()) return nd;
      return nd.getKey().accept(this, v);
    }

    // for binary operators, the operands come first (but not for short-circuiting expressions), see
    // above)
    @Override
    public Node visit(BinaryExpression nd, Void v) {
      if ("??".equals(nd.getOperator())) return nd;
      return nd.getLeft().accept(this, v);
    }

    @Override
    public Node visit(AssignmentExpression nd, Void v) {
      if (nd.getLeft() instanceof DestructuringPattern) return nd.getRight().accept(this, v);
      return nd.getLeft().accept(this, v);
    }

    @Override
    public Node visit(VariableDeclarator nd, Void v) {
      if (nd.getId() instanceof DestructuringPattern && nd.hasInit())
        return nd.getInit().accept(this, v);
      return nd.getId().accept(this, v);
    }

    @Override
    public Node visit(MemberExpression nd, Void v) {
      return nd.getObject().accept(this, v);
    }

    @Override
    public Node visit(InvokeExpression nd, Void v) {
      return nd.getCallee().accept(this, v);
    }

    @Override
    public Node visit(JSXElement nd, Void v) {
      IJSXName name = nd.getOpeningElement().getName();
      if (name == null) {
        if (nd.getChildren().isEmpty()) return nd;
        return nd.getChildren().get(0).accept(this, v);
      }
      return name.accept(this, v);
    }

    @Override
    public Node visit(JSXMemberExpression nd, Void v) {
      return nd.getObject().accept(this, v);
    }

    @Override
    public Node visit(JSXNamespacedName nd, Void v) {
      return nd.getNamespace().accept(this, v);
    }

    @Override
    public Node visit(JSXAttribute nd, Void v) {
      return nd.getName().accept(this, v);
    }

    @Override
    public Node visit(JSXSpreadAttribute nd, Void v) {
      return nd.getArgument().accept(this, v);
    }

    @Override
    public Node visit(JSXExpressionContainer nd, Void v) {
      return nd.getExpression().accept(this, v);
    }

    @Override
    public Node visit(AwaitExpression nd, Void c) {
      return nd.getArgument().accept(this, c);
    }

    @Override
    public Node visit(Decorator nd, Void v) {
      return nd.getExpression().accept(this, v);
    }

    @Override
    public Node visit(BindExpression nd, Void v) {
      if (nd.hasObject()) return nd.getObject().accept(this, v);
      return nd.getCallee().accept(this, v);
    }

    @Override
    public Node visit(ExternalModuleReference nd, Void v) {
      return nd.getExpression().accept(this, v);
    }

    @Override
    public Node visit(DynamicImport nd, Void v) {
      return nd.getSource().accept(this, v);
    }

    @Override
    public Node visit(ClassDeclaration nd, Void v) {
      if (nd.hasDeclareKeyword()) return nd;
      else return nd.getClassDef().getId();
    }

    @Override
    public Node visit(ClassExpression nd, Void v) {
      AClass def = nd.getClassDef();
      if (def.getId() != null) return def.getId();
      if (def.getSuperClass() != null) return def.getSuperClass().accept(this, v);
      Node first = def.getBody().accept(this, v);
      if (first != null) return first;
      return nd;
    }

    @Override
    public Node visit(ClassBody nd, Void v) {
      for (MemberDefinition<?> m : nd.getBody()) {
        if (m instanceof MethodDefinition) {
          Node first = m.accept(this, v);
          if (first != null) return first;
        }
      }
      return null;
    }

    @Override
    public Node visit(ExpressionWithTypeArguments nd, Void c) {
      return nd.getExpression().accept(this, c);
    }

    @Override
    public Node visit(TypeAssertion nd, Void c) {
      return nd.getExpression().accept(this, c);
    }

    @Override
    public Node visit(NonNullAssertion nd, Void c) {
      return nd.getExpression().accept(this, c);
    }

    @Override
    public Node visit(EnumDeclaration nd, Void c) {
      return nd.getId();
    }

    @Override
    public Node visit(EnumMember nd, Void c) {
      return nd.getId();
    }

    @Override
    public Node visit(DecoratorList nd, Void c) {
      if (nd.getDecorators().isEmpty()) return nd;
      return nd.getDecorators().get(0).accept(this, c);
    }

    @Override
    public Node visit(NamespaceDeclaration nd, Void c) {
      if (nd.hasDeclareKeyword()) return nd;
      return nd.getName();
    }

    @Override
    public Node visit(ImportWholeDeclaration nd, Void c) {
      return nd.getLhs();
    }

    @Override
    public Node visit(EnhancedForStatement nd, Void c) {
      return nd.getRight().accept(this, null);
    }

    @Override
    public Node visit(XMLAttributeSelector nd, Void c) {
      return nd.getAttribute().accept(this, c);
    }

    @Override
    public Node visit(XMLFilterExpression nd, Void c) {
      return nd.getLeft().accept(this, c);
    }

    @Override
    public Node visit(XMLQualifiedIdentifier nd, Void c) {
      return nd.getLeft().accept(this, c);
    }

    @Override
    public Node visit(XMLDotDotExpression nd, Void c) {
      return nd.getLeft().accept(this, c);
    }

    public static Node of(Node nd) {
      return nd.accept(new First(), null);
    }
  }

  /**
   * Collect all hoisted function declaration statements (that is, function declarations not nested
   * inside a block statement or control statement) in a subtree, returning an array containing
   * their declaring identifiers in lexical order.
   *
   * <p>This is used to construct the function preamble mentioned above.
   */
  private static class HoistedFunDecls extends DefaultVisitor<Void, Void> {
    private List<Identifier> decls = new ArrayList<Identifier>();

    @Override
    public Void visit(FunctionDeclaration nd, Void v) {
      // We do not consider ambient function declarations to be hoisted.
      if (!nd.hasDeclareKeyword()) {
        decls.add(nd.getId());
      }
      return null;
    }

    @Override
    public Void visit(LabeledStatement nd, Void v) {
      return nd.getBody().accept(this, v);
    }

    @Override
    public Void visit(ExportDefaultDeclaration nd, Void c) {
      return nd.getDeclaration().accept(this, c);
    }

    @Override
    public Void visit(ExportNamedDeclaration nd, Void c) {
      if (nd.hasDeclaration()) nd.getDeclaration().accept(this, c);
      return null;
    }

    private static List<Identifier> of(List<Statement> body) {
      HoistedFunDecls d = new HoistedFunDecls();
      for (Node stmt : body) stmt.accept(d, null);
      return d.decls;
    }

    public static List<Identifier> of(Program p) {
      return of(p.getBody());
    }

    public static List<Identifier> of(IFunction fn) {
      Node body = fn.getBody();
      if (body instanceof BlockStatement) return of(((BlockStatement) body).getBody());
      // if the body of the function is missing or is an expression, then there are
      // no hoisted functions
      return Collections.emptyList();
    }
  }

  /**
   * Class used to represent information about the possible successors of a CFG node during
   * extraction.
   *
   * <p>For expressions and catch clauses, we distinguish between "true" and "false" successors (the
   * former being the successors in case the expression or catch guard evaluates to a truthy value,
   * the latter the successors for the falsy case); for other CFG nodes, no such distinction is
   * made.
   */
  private abstract static class SuccessorInfo {
    /**
     * Get all possible successors, including both "true" and "false" successors where applicable.
     */
    public abstract Object getAllSuccessors();

    /**
     * Depending on the value of {@code edge}, get only the "true" or only the "false" successors
     * (if they are not distinguished, the same set will be returned in both cases.)
     */
    public abstract Object getSuccessors(boolean edge);

    /**
     * If we have both true and false successors, place guard nodes before them indicating that
     * <code>guard</code> is true or false, respectively, and return the set containing all guarded
     * successors.
     *
     * <p>Otherwise, just return the set of all successors.
     */
    public abstract Object getGuardedSuccessors(Expression guard);
  }

  /**
   * A simple implementation of {@link SuccessorInfo} that does not distinguish between "true" and
   * "false" successors.
   */
  private static class SimpleSuccessorInfo extends SuccessorInfo {
    private final Object successors;

    public SimpleSuccessorInfo(Object successors) {
      this.successors = successors;
    }

    @Override
    public Object getAllSuccessors() {
      return successors;
    }

    @Override
    public Object getSuccessors(boolean edge) {
      return successors;
    }

    @Override
    public Object getGuardedSuccessors(Expression guard) {
      return successors;
    }
  }

  /**
   * An implementation of {@link SuccessorInfo} that does distinguish between "true" and "false"
   * successors.
   */
  private class SplitSuccessorInfo extends SuccessorInfo {
    private final Object trueSuccessors;
    private final Object falseSuccessors;

    public SplitSuccessorInfo(Object trueSuccessors, Object falseSuccessors) {
      this.trueSuccessors = trueSuccessors;
      this.falseSuccessors = falseSuccessors;
    }

    @Override
    public Object getSuccessors(boolean edge) {
      return edge ? trueSuccessors : falseSuccessors;
    }

    @Override
    public Object getAllSuccessors() {
      return union(trueSuccessors, falseSuccessors);
    }

    @Override
    public Object getGuardedSuccessors(Expression guard) {
      Object trueGuard = addGuard(guard, true, trueSuccessors);
      Object falseGuard = addGuard(guard, false, falseSuccessors);
      return union(trueGuard, falseGuard);
    }
  }

  /**
   * Create a guard node stating that {@code test} evaluates to {@code outcome}, with {@code succs}
   * as its successors.
   *
   * <p>We simplify guards based on the shape of {@code test}:
   *
   * <ul>
   *   <li>If {@code test} is a parenthesised expression {@code (a)}, we create a guard for {@code
   *       a} instead.
   *   <li>If {@code test} is a negated expression {@code !a}, we create the inverse guard for
   *       {@code a} instead.
   *   <li>If {@code test} is a sequence expression {@code a, b}, we create a guard for {@code b}
   *       instead.
   *   <li>Instead of asserting that {@code a && b} is {@code true}, we assert that {@code a} and
   *       {@code b} are {@code true}.
   *   <li>Instead of asserting that {@code a || b} is {@code false}, we assert that {@code a} and
   *       {@code b} are {@code false}.
   *   <li>We never assert that {@code a && b} is {@code false} or {@code a || b} is {@code true},
   *       since by themselves these guards are not very useful.
   * </ul>
   *
   * It might seem that we do not need to do this simplification since guards are placed bottom-up.
   * However, the CFG for a logical negation <code>!a</code> is <code>a -&gt; !a</code>, that is,
   * <code>a</code> only has a single successor and does not immediately induce any guard nodes. We
   * can only add a guard for the entire <code>!a</code> expression, at which point we will try to
   * recover a condition involving <code>a</code> if possible.
   */
  private Object addGuard(Expression test, boolean outcome, Object succs) {
    if (test instanceof ParenthesizedExpression)
      return addGuard(((ParenthesizedExpression) test).getExpression(), outcome, succs);

    if (test instanceof UnaryExpression && "!".equals(((UnaryExpression) test).getOperator()))
      return addGuard(((UnaryExpression) test).getArgument(), !outcome, succs);

    if (test instanceof LogicalExpression) {
      LogicalExpression log = (LogicalExpression) test;
      String op = log.getOperator();
      if (outcome && "&&".equals(op)) {
        return addGuard(log.getLeft(), outcome, addGuard(log.getRight(), outcome, succs));
      } else if (!outcome && "||".equals(op)) {
        return addGuard(log.getLeft(), outcome, addGuard(log.getRight(), outcome, succs));
      } else {
        return succs;
      }
    }

    if (test instanceof SequenceExpression) {
      SequenceExpression seq = (SequenceExpression) test;
      List<Expression> exprs = seq.getExpressions();
      return addGuard(exprs.get(exprs.size() - 1), outcome, succs);
    }

    Node guardNode = guardNode(test, outcome);
    succ(guardNode, succs);
    return guardNode;
  }

  /** Generate guard nodes. */
  private Node guardNode(Expression nd, boolean outcome) {
    SourceLocation ndLoc = nd.getLoc();
    Node result =
        new Node(
            "Assertion", new SourceLocation(ndLoc.getSource(), ndLoc.getStart(), ndLoc.getEnd())) {
          @Override
          public <Q, A> A accept(Visitor<Q, A> v, Q q) {
            return null;
          }
        };
    Label lbl = trapwriter.localID(result);
    int kind = outcome ? 1 : 0;
    trapwriter.addTuple("guard_node", lbl, kind, trapwriter.localID(nd));
    locationManager.emitNodeLocation(result, lbl);
    return result;
  }

  private class V extends DefaultVisitor<SuccessorInfo, Void> {
    /**
     * The context stores relevant bits of syntactic context to be able to resolve jumps.
     *
     * <p>Every element in the context is either an AST node of type `Program`,
     * `FunctionDeclaration`, `FunctionExpression`, `ArrowFunctionExpression`, `WhileStatement`,
     * `DoWhileStatement`, `ForStatement`, `ForInStatement`, `ForOfStatement`, `SwitchStatement`,
     * `TryStatement`, `LabeledStatement` or a pseudo-node of type `Finally`. The latter means that
     * we are in the `catch` clause of a `try` statement that has a `finally`.
     */
    private final Stack<Node> ctxt = new Stack<Node>();

    /** Hoisted function declarations in the enclosing statement container (function or script). */
    private final Set<Identifier> hoistedFns = new LinkedHashSet<Identifier>();

    /**
     * Hoisted import declarations in the enclosing script.
     *
     * <p>In standard ECMAScript, all import declarations are hoisted. However, we support
     * non-toplevel import declarations, which are not hoisted.
     */
    private final Set<ImportDeclaration> hoistedImports = new LinkedHashSet<ImportDeclaration>();

    private class Finally extends Node {
      private final BlockStatement body;

      public Finally(SourceLocation loc, BlockStatement body) {
        super("Finally", loc);
        this.body = body;
      }

      @Override
      public <Q, A> A accept(Visitor<Q, A> v, Q q) {
        return null;
      }
    }

    // associate statements with their (direct or indirect) labels;
    // per-function cache, cleared after each function
    private Map<Statement, Set<String>> loopLabels = new LinkedHashMap<Statement, Set<String>>();

    // cache the set of normal control flow successors;
    // per-function cache, cleared after each function
    private Map<Node, Object> followingCache = new LinkedHashMap<Node, Object>();

    // map from a node in a chain of property accesses or calls to the successor info
    // for the first node in the chain;
    // per-function cache, cleared after each function
    private Map<Chainable, SuccessorInfo> chainRootSuccessors =
        new LinkedHashMap<Chainable, SuccessorInfo>();

    /** Generate entry node. */
    private final HashMap<IStatementContainer, Node> entryNodeCache =
        new LinkedHashMap<IStatementContainer, Node>();

    private Node entry(IStatementContainer nd) {
      Node entry = entryNodeCache.get(nd);
      if (entry == null) {
        entry =
            new Node(
                "Entry", new SourceLocation("", nd.getLoc().getStart(), nd.getLoc().getStart())) {
              @Override
              public <Q, A> A accept(Visitor<Q, A> v, Q q) {
                return null;
              }
            };
        entryNodeCache.put(nd, entry);
        Label lbl = trapwriter.localID(entry);
        trapwriter.addTuple(
            "entry_cfg_node", lbl, nd instanceof Program ? toplevelLabel : trapwriter.localID(nd));
        locationManager.emitNodeLocation(entry, lbl);
      }
      return entry;
    }

    /** Generate exit node. */
    private final HashMap<IStatementContainer, Node> exitNodeCache =
        new LinkedHashMap<IStatementContainer, Node>();

    private Node exit(IStatementContainer nd) {
      Node exit = exitNodeCache.get(nd);
      if (exit == null) {
        exit =
            new Node("Exit", new SourceLocation("", nd.getLoc().getEnd(), nd.getLoc().getEnd())) {
              @Override
              public <Q, A> A accept(Visitor<Q, A> v, Q q) {
                return null;
              }
            };
        Label lbl = trapwriter.localID(exit);
        trapwriter.addTuple(
            "exit_cfg_node", lbl, nd instanceof Program ? toplevelLabel : trapwriter.localID(nd));
        locationManager.emitNodeLocation(exit, lbl);
        exitNodeCache.put(nd, exit);
      }
      return exit;
    }

    /**
     * Find the target nodes of a jump by consulting the syntactic context.
     *
     * @param type the type of the jump
     * @param label for labelled `BreakStatement` and `ContinueStatement`, the target label;
     *     otherwise null
     */
    private Object findTarget(final JumpType type, final String label) {
      return new Object() {
        private Object find(final int i) {
          if (i < 0) return null;

          Node nd = ctxt.get(i);

          if (nd instanceof Finally) {
            BlockStatement finalizer = ((Finally) nd).body;
            followingCache.put(finalizer, union(followingCache.get(finalizer), find(i - 1)));
            return First.of(finalizer);
          }

          return nd.accept(
              new DefaultVisitor<Void, Object>() {
                @Override
                public Object visit(Loop loop, Void v) {
                  Set<String> labels = loopLabels.computeIfAbsent(loop, k -> new LinkedHashSet<>());
                  if (type == JumpType.CONTINUE && (label == null || labels.contains(label)))
                    return First.of(loop.getContinueTarget());
                  else if (type == JumpType.BREAK && label == null) return followingCache.get(loop);
                  return find(i - 1);
                }

                @Override
                public Object visit(SwitchStatement nd, Void v) {
                  if (type == JumpType.BREAK && label == null) return followingCache.get(nd);
                  return find(i - 1);
                }

                @Override
                public Object visit(LabeledStatement nd, Void v) {
                  if (type == JumpType.BREAK && nd.getLabel().getName().equals(label))
                    return followingCache.get(nd);
                  return find(i - 1);
                }

                @Override
                public Object visit(TryStatement t, Void v) {
                  if (type == JumpType.THROW && !t.getAllHandlers().isEmpty()) {
                    return First.of(t.getAllHandlers().get(0));
                  }
                  if (t.hasFinalizer()) {
                    BlockStatement finalizer = t.getFinalizer();
                    followingCache.put(
                        finalizer, union(followingCache.get(finalizer), find(i - 1)));
                    return First.of(finalizer);
                  }
                  return find(i - 1);
                }

                @Override
                public Object visit(Program nd, Void v) {
                  return visit(nd);
                }

                @Override
                public Object visit(IFunction nd, Void v) {
                  return visit(nd);
                }

                private Object visit(IStatementContainer nd) {
                  if (type == JumpType.RETURN) return exit((IStatementContainer) nd);
                  return null;
                }
              },
              null);
        }
      }.find(ctxt.size() - 1);
    }

    private Node visit(Node nd, Object trueSuccessors, Object falseSuccessors) {
      if (nd == null) return null;

      followingCache.put(nd, union(followingCache.get(nd), union(trueSuccessors, falseSuccessors)));
      nd.accept(
          this,
          falseSuccessors == null
              ? new SimpleSuccessorInfo(trueSuccessors)
              : new SplitSuccessorInfo(trueSuccessors, falseSuccessors));
      return First.of(nd);
    }

    private Object seq(Object... nodes) {
      Object fst = nodes[nodes.length - 1];
      for (int i = nodes.length - 2; i >= 0; --i) {
        for (Node node : hcaerof(nodes[i])) {
          Node ffst = visit(node, fst, null);
          if (ffst != null) fst = ffst;
        }
      }
      return fst;
    }

    @Override
    public Void visit(Node nd, SuccessorInfo i) {
      succ(nd, i.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(Expression nd, SuccessorInfo i) {
      succ(nd, i.getGuardedSuccessors(nd));
      return null;
    }

    @Override
    public Void visit(Program nd, SuccessorInfo i) {
      this.ctxt.push(nd);
      Node entry = this.entry(nd);

      List<ImportDeclaration> imports = scanImports(nd);
      hoistedImports.addAll(imports);
      List<ImportSpecifier> importSpecifiers = new ArrayList<>();
      for (ImportDeclaration imp : imports) importSpecifiers.addAll(imp.getSpecifiers());

      List<Identifier> fns = HoistedFunDecls.of(nd);
      hoistedFns.addAll(fns);

      Object fst = this.seq(importSpecifiers, fns, nd.getBody(), this.exit(nd));
      succ(entry, fst);
      this.ctxt.pop();
      return null;
    }

    /** Return a list of all {@link ImportDeclaration}s in the given program, in lexical order. */
    private List<ImportDeclaration> scanImports(Program p) {
      List<ImportDeclaration> result = new ArrayList<>();
      // import statements can only appear at the top-level
      for (Statement s : p.getBody())
        if (s instanceof ImportDeclaration) result.add((ImportDeclaration) s);
      return result;
    }

    /**
     * Builds the CFG for the creation of the given function as part of CFG the enclosing container.
     */
    private void buildFunctionCreation(IFunction nd, SuccessorInfo i) {
      // `tail` is the last CFG node in the function creation
      INode tail = nd;
      if (!(nd instanceof AFunctionExpression) && !hoistedFns.contains(nd.getId())) {
        succ(tail, nd.getId());
        tail = nd.getId();
      }
      succ(tail, nd instanceof AFunctionExpression ? i.getSuccessors(true) : i.getAllSuccessors());
    }

    /** Builds the CFG for the body of the given function. */
    private void buildFunctionBody(IFunction nd) {
      this.ctxt.push((Node) nd);

      // build a list of all parameters and default expressions in order, with
      // the default expressions preceding their corresponding parameter
      List<Expression> paramsAndDefaults = new ArrayList<Expression>();
      for (int j = 0, n = nd.getParams().size(); j < n; ++j) {
        if (nd.hasDefault(j)) paramsAndDefaults.add(nd.getDefault(j));
        paramsAndDefaults.add((Expression) nd.getParams().get(j));
      }
      if (nd.hasRest()) paramsAndDefaults.add((Expression) nd.getRest());

      Node entry = this.entry(nd);
      List<Identifier> fns = HoistedFunDecls.of(nd);
      hoistedFns.addAll(fns);

      // if this is the constructor of a class without a superclass, we need to
      // initialise all fields before running the body of the constructor
      // (for classes with a superclass, that initialisation only happens after
      // `super` calls)
      AClass klass = constructor2Class.get(nd);
      FieldDefinition firstField = null;
      if (klass != null && !klass.hasSuperClass()) {
        Pair<FieldDefinition, FieldDefinition> p = instanceFields.peek();
        if (p != null) {
          firstField = p.fst();
          succ(p.snd(), First.of(nd.getBody()));
        }
      }

      Object fst = this.seq(nd.getBody(), this.exit(nd));
      if (firstField != null) fst = First.of(firstField);
      fst =
          this.seq(
              nd instanceof FunctionDeclaration ? null : nd.getId(), paramsAndDefaults, fns, fst);
      succ(entry, fst);

      this.ctxt.pop();
    }

    @Override
    public Void visit(IFunction nd, SuccessorInfo i) {
      // save per-function caches
      Map<Statement, Set<String>> oldLoopLabels = loopLabels;
      Map<Node, Object> oldFollowingCache = followingCache;
      Map<Chainable, SuccessorInfo> oldChainRootSuccessors = chainRootSuccessors;

      // clear caches
      loopLabels = new LinkedHashMap<>();
      followingCache = new LinkedHashMap<>();
      chainRootSuccessors = new LinkedHashMap<>();

      if (nd instanceof FunctionDeclaration && nd.hasDeclareKeyword()) {
        // All 'declared' statements have a no-op CFG node, but their children should
        // not be processed.
        succ(nd, i.getAllSuccessors());
        return null;
      }
      buildFunctionCreation(nd, i);
      buildFunctionBody(nd);

      // restore caches
      loopLabels = oldLoopLabels;
      followingCache = oldFollowingCache;
      chainRootSuccessors = oldChainRootSuccessors;

      return null;
    }

    @Override
    public Void visit(ClassDeclaration nd, SuccessorInfo i) {
      if (nd.hasDeclareKeyword()) {
        succ(nd, i.getAllSuccessors());
      } else {
        visit(nd, nd.getClassDef(), i);
      }
      return null;
    }

    @Override
    public Void visit(ClassExpression nd, SuccessorInfo i) {
      return visit(nd, nd.getClassDef(), i);
    }

    private Map<Object, AClass> constructor2Class = new LinkedHashMap<>();

    private Void visit(Node nd, AClass ac, SuccessorInfo i) {
      for (MemberDefinition<?> m : ac.getBody().getBody())
        if (m.isConstructor() && m.isConcrete()) constructor2Class.put(m.getValue(), ac);
      seq(ac.getId(), ac.getSuperClass(), ac.getBody(), nd);
      succ(nd, seq(getStaticFields(ac.getBody()), getDecoratorsOfClass(ac), i.getAllSuccessors()));
      return null;
    }

    /**
     * Gets the decorators for the given member, including parameter decorators.
     *
     * <p>The result is a tree of nested lists containing Decorator and DecoratorList nodes at the
     * leaves.
     */
    private List<?> getMemberDecorators(MemberDefinition<?> member) {
      if (member instanceof MethodDefinition) {
        MethodDefinition method = (MethodDefinition) member;
        return Arrays.asList(method.getValue().getParameterDecorators(), method.getDecorators());
      } else {
        return member.getDecorators();
      }
    }

    /**
     * Returns all the decorators on the given class and its members in the order the decorators are
     * evaluated.
     *
     * <p>We don't model the call to each decorator, only the initial evaluation.
     *
     * <p>The result is a list of Decorator and DecoratorList nodes.
     */
    private List<Node> getDecoratorsOfClass(AClass ac) {
      List<Object> instanceDecorators = new ArrayList<>();
      List<Object> staticDecorators = new ArrayList<>();
      List<Object> constructorParameterDecorators = new ArrayList<>();
      List<?> classDecorators = ac.getDecorators();
      for (MemberDefinition<?> member : ac.getBody().getBody()) {
        if (!member.isConcrete()) continue;
        List<?> decorators = getMemberDecorators(member);
        if (member.isConstructor()) {
          constructorParameterDecorators.add(decorators);
        } else if (member.isStatic()) {
          staticDecorators.add(decorators);
        } else {
          instanceDecorators.add(decorators);
        }
      }
      return flattenNestedList(
          Arrays.asList(
              instanceDecorators,
              staticDecorators,
              constructorParameterDecorators,
              classDecorators));
    }

    @Override
    public Void visit(NamespaceDeclaration nd, SuccessorInfo i) {
      if (nd.hasDeclareKeyword()) {
        succ(nd, i.getAllSuccessors());
      } else {
        List<Identifier> hoisted = HoistedFunDecls.of(nd.getBody());
        hoistedFns.addAll(hoisted);
        succ(nd.getName(), nd);
        succ(nd, seq(hoisted, nd.getBody(), i.getAllSuccessors()));
      }
      return null;
    }

    @Override
    public Void visit(Literal nd, SuccessorInfo i) {
      if (nd.isFalsy()) {
        succ(nd, i.getSuccessors(false));
      } else {
        succ(nd, i.getSuccessors(true));
      }
      return null;
    }

    @Override
    public Void visit(BlockStatement nd, SuccessorInfo i) {
      if (nd.getBody().isEmpty()) succ(nd, i.getAllSuccessors());
      else succ(nd, First.of(nd.getBody().get(0)));
      seq(nd.getBody(), i.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(CatchClause nd, SuccessorInfo i) {
      // check whether this is a guarded catch
      if (nd.hasGuard()) {
        // if so, the guard may fail and execution might continue with the next
        // catch clause (if any)
        succ(nd, nd.getParam());
        this.seq(
            nd.getParam(), nd.getGuard(), union(First.of(nd.getBody()), i.getSuccessors(false)));
        this.seq(nd.getBody(), i.getSuccessors(true));
      } else {
        // unguarded catch clauses always execute their body
        if (nd.getParam() != null) {
          succ(nd, nd.getParam());
          this.seq(nd.getParam(), nd.getBody(), i.getAllSuccessors());
        } else {
          succ(nd, First.of(nd.getBody()));
          this.seq(nd.getBody(), i.getAllSuccessors());
        }
      }
      return null;
    }

    @Override
    public Void visit(LabeledStatement nd, SuccessorInfo i) {
      Set<String> ndLabels = loopLabels.computeIfAbsent(nd, k -> new LinkedHashSet<>()),
          bodyLabels = loopLabels.computeIfAbsent(nd.getBody(), k -> new LinkedHashSet<>());
      bodyLabels.addAll(ndLabels);
      bodyLabels.add(nd.getLabel().getName());
      succ(nd, First.of(nd.getBody()));
      this.ctxt.push(nd);
      this.seq(nd.getBody(), i.getAllSuccessors());
      this.ctxt.pop();
      return null;
    }

    @Override
    public Void visit(ExpressionStatement nd, SuccessorInfo i) {
      succ(nd, First.of(nd.getExpression()));
      visit(nd.getExpression(), i.getAllSuccessors(), null);
      return null;
    }

    @Override
    public Void visit(ParenthesizedExpression nd, SuccessorInfo i) {
      succ(nd, First.of(nd.getExpression()));
      return nd.getExpression().accept(this, i);
    }

    @Override
    public Void visit(IfStatement nd, SuccessorInfo i) {
      Expression test = nd.getTest();
      succ(nd, First.of(test));
      Object following = i.getAllSuccessors();
      visit(
          test,
          First.of(nd.getConsequent()),
          nd.hasAlternate() ? First.of(nd.getAlternate()) : following);
      this.visit(nd.getConsequent(), following, null);
      this.visit(nd.getAlternate(), following, null);
      return null;
    }

    @Override
    public Void visit(ConditionalExpression nd, SuccessorInfo i) {
      Expression test = nd.getTest();
      succ(nd, First.of(test));
      visit(test, First.of(nd.getConsequent()), First.of(nd.getAlternate()));

      nd.getConsequent().accept(this, i);
      nd.getAlternate().accept(this, i);

      return null;
    }

    @Override
    public Void visit(JumpStatement nd, SuccessorInfo i) {
      JumpType tp = nd instanceof BreakStatement ? JumpType.BREAK : JumpType.CONTINUE;
      succ(nd, findTarget(tp, nd.hasLabel() ? nd.getLabel().getName() : null));
      return null;
    }

    @Override
    public Void visit(WithStatement nd, SuccessorInfo i) {
      succ(nd, First.of(nd.getObject()));
      seq(nd.getObject(), nd.getBody(), i.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(SwitchStatement nd, SuccessorInfo i) {
      this.ctxt.push(nd);
      succ(nd, First.of(nd.getDiscriminant()));

      // find all default cases (in a valid program there is
      // only one, but we want to gracefully handle switches with
      // multiple defaults)
      Object deflt = null;
      for (SwitchCase c : nd.getCases()) if (c.isDefault()) deflt = union(deflt, c);

      // compute 'following' for every case label
      outer:
      for (int j = 0, n = nd.getCases().size(); j < n; ++j) {
        SwitchCase cse = nd.getCases().get(j);
        if (cse.hasTest()) {
          // find next non-default clause
          for (int k = j + 1; k < n; ++k) {
            if (nd.getCases().get(k).hasTest()) {
              followingCache.put(cse.getTest(), nd.getCases().get(k));
              continue outer;
            }
          }

          // if there isn't one, the default clause is next
          if (deflt != null) followingCache.put(cse.getTest(), deflt);
          else
            // if there is no default clause, execution continues after the `switch`
            followingCache.put(cse.getTest(), i.getAllSuccessors());
        }
      }

      if (nd.getCases().isEmpty()) this.visit(nd.getDiscriminant(), i.getAllSuccessors(), null);
      else if (nd.getCases().size() > 1 && nd.getCases().get(0).isDefault())
        this.visit(nd.getDiscriminant(), First.of(nd.getCases().get(1)), null);
      else this.visit(nd.getDiscriminant(), First.of(nd.getCases().get(0)), null);
      this.seq(nd.getCases(), i.getAllSuccessors());
      this.ctxt.pop();
      return null;
    }

    @Override
    public Void visit(SwitchCase nd, SuccessorInfo i) {
      if (nd.hasTest()) succ(nd, First.of(nd.getTest()));
      else if (!nd.getConsequent().isEmpty()) succ(nd, First.of(nd.getConsequent().get(0)));
      else succ(nd, followingCache.get(nd));
      Object fst = followingCache.get(nd.getTest());
      if (nd.getConsequent().isEmpty()) fst = union(i.getAllSuccessors(), fst);
      else fst = union(First.of(nd.getConsequent().get(0)), fst);
      seq(nd.getTest(), fst);
      seq(nd.getConsequent(), i.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(ReturnStatement nd, SuccessorInfo i) {
      visit(nd.getArgument(), nd, null);
      succ(nd, findTarget(JumpType.RETURN, null));
      return null;
    }

    @Override
    public Void visit(ThrowStatement nd, SuccessorInfo i) {
      visit(nd.getArgument(), nd, null);
      succ(nd, findTarget(JumpType.THROW, null));
      return null;
    }

    @Override
    public Void visit(TryStatement nd, SuccessorInfo i) {
      succ(nd, First.of(nd.getBlock()));
      if (nd.hasFinalizer()) followingCache.put(nd.getFinalizer(), i.getAllSuccessors());

      ctxt.push(nd);
      Object fst = nd.hasFinalizer() ? First.of(nd.getFinalizer()) : i.getAllSuccessors();
      this.visit(nd.getBlock(), fst, null);
      ctxt.pop();

      if (nd.hasFinalizer()) ctxt.push(new Finally(nd.getFinalizer().getLoc(), nd.getFinalizer()));

      for (int j = 0, n = nd.getAllHandlers().size(); j < n; ++j)
        visit(nd.getAllHandlers().get(j), fst, j + 1 < n ? nd.getAllHandlers().get(j + 1) : null);

      if (nd.hasFinalizer()) {
        ctxt.pop();
        visit(nd.getFinalizer(), followingCache.get(nd.getFinalizer()), null);
      }
      return null;
    }

    @Override
    public Void visit(VariableDeclaration nd, SuccessorInfo i) {
      if (nd.hasDeclareKeyword()) {
        succ(nd, i.getAllSuccessors());
      } else {
        succ(nd, First.of(nd.getDeclarations().get(0)));
        seq(nd.getDeclarations(), i.getAllSuccessors());
      }
      return null;
    }

    @Override
    public Void visit(ImportWholeDeclaration nd, SuccessorInfo i) {
      seq(nd.getLhs(), nd.getRhs(), nd);
      succ(nd, i.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(ExportWholeDeclaration nd, SuccessorInfo i) {
      succ(nd, First.of(nd.getRhs()));
      seq(nd.getRhs(), i.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(LetStatement nd, SuccessorInfo i) {
      succ(nd, First.of(nd.getHead().get(0)));
      seq(nd.getHead(), nd.getBody(), i.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(LetExpression nd, SuccessorInfo i) {
      succ(nd, First.of(nd.getHead().get(0)));
      seq(nd.getHead(), nd.getBody(), i.getGuardedSuccessors(nd));
      return null;
    }

    @Override
    public Void visit(WhileStatement nd, SuccessorInfo i) {
      Expression test = nd.getTest();
      Node testStart = First.of(test);
      succ(nd, testStart);
      ctxt.push(nd);
      visit(nd.getBody(), testStart, null);
      visit(test, First.of(nd.getBody()), i.getAllSuccessors());
      ctxt.pop();
      return null;
    }

    @Override
    public Void visit(DoWhileStatement nd, SuccessorInfo i) {
      Node body = First.of(nd.getBody());
      succ(nd, body);
      ctxt.push(nd);
      Expression test = nd.getTest();
      visit(nd.getBody(), First.of(test), null);
      visit(test, body, i.getAllSuccessors());
      ctxt.pop();
      return null;
    }

    @Override
    public Void visit(EnhancedForStatement nd, SuccessorInfo i) {
      seq(nd.getRight(), nd);
      succ(nd, First.of(nd.getLeft()));
      succ(nd, i.getAllSuccessors());
      ctxt.push(nd);
      seq(nd.getLeft(), nd.getDefaultValue(), nd.getBody(), nd);
      ctxt.pop();
      return null;
    }

    @Override
    public Void visit(ForStatement nd, SuccessorInfo i) {
      succ(nd, First.of(nd.hasInit() ? nd.getInit() : nd.hasTest() ? nd.getTest() : nd.getBody()));
      ctxt.push(nd);
      Node fst = First.of(nd.hasTest() ? nd.getTest() : nd.getBody());
      visit(nd.getInit(), fst, null);

      if (nd.hasTest()) {
        Expression test = nd.getTest();
        visit(test, First.of(nd.getBody()), i.getAllSuccessors());
      }
      seq(nd.getBody(), nd.getUpdate(), fst);
      ctxt.pop();
      return null;
    }

    @Override
    public Void visit(SequenceExpression nd, SuccessorInfo i) {
      List<Expression> expressions = nd.getExpressions();
      succ(nd, First.of(expressions.get(0)));
      int n = expressions.size() - 1;
      expressions.get(n).accept(this, i);
      Node next = First.of(expressions.get(n));
      while (--n >= 0) next = visit(expressions.get(n), next, null);
      return null;
    }

    @Override
    public Void visit(ArrayExpression nd, SuccessorInfo i) {
      visitArrayLike(nd, nd.getElements(), i.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(ArrayPattern nd, SuccessorInfo i) {
      // build a list of all pattern elements and default expressions in order, with
      // the default expressions preceding their corresponding elements
      List<Expression> elementsAndDefaults = new ArrayList<Expression>();
      List<Expression> elements = nd.getElements();
      List<Expression> defaults = nd.getDefaults();
      for (int j = 0, n = elements.size(); j < n; ++j) {
        elementsAndDefaults.add(defaults.get(j));
        elementsAndDefaults.add(elements.get(j));
      }
      if (nd.hasRest()) elementsAndDefaults.add(nd.getRest());

      visitArrayLike(nd, elementsAndDefaults, i.getAllSuccessors());
      return null;
    }

    public void visitArrayLike(Node nd, List<? extends INode> elements, Object following) {
      // find the first non-omitted element
      boolean foundNonOmitted = false;
      for (INode element : elements)
        if (element != null) {
          // `nd` is followed by the first non-omitted element
          foundNonOmitted = true;
          succ(nd, First.of((Node) element));
          break;
        }

      // if all elements are omitted, `nd` is immediately followed by `following`
      if (!foundNonOmitted) succ(nd, following);

      seq(elements, following);
    }

    @Override
    public Void visit(ObjectExpression nd, SuccessorInfo i) {
      visitObjectLike(nd, nd.getProperties(), i);
      return null;
    }

    @Override
    public Void visit(ObjectPattern nd, SuccessorInfo i) {
      List<Node> allProperties = new ArrayList<Node>();
      allProperties.addAll(nd.getProperties());
      if (nd.hasRest()) allProperties.add(nd.getRest());
      visitObjectLike(nd, allProperties, i);
      return null;
    }

    /** For each enclosing class, this records the first and last non-abstract instance fields. */
    private Stack<Pair<FieldDefinition, FieldDefinition>> instanceFields = new Stack<>();

    @Override
    public Void visit(ClassBody nd, SuccessorInfo i) {
      List<FieldDefinition> fds = getConcreteInstanceFields(nd);
      if (fds.isEmpty()) {
        instanceFields.push(null);
      } else {
        seq(fds, null);
        instanceFields.push(Pair.make(fds.get(0), fds.get(fds.size() - 1)));
      }
      seq(getMethods(nd), i.getAllSuccessors());
      instanceFields.pop();
      return null;
    }

    private List<MemberDefinition<?>> getMethods(ClassBody nd) {
      List<MemberDefinition<?>> mds = new ArrayList<>();
      for (MemberDefinition<?> md : nd.getBody()) {
        if (md instanceof MethodDefinition) mds.add(md);
      }
      return mds;
    }

    private List<MemberDefinition<?>> getStaticFields(ClassBody nd) {
      List<MemberDefinition<?>> mds = new ArrayList<>();
      for (MemberDefinition<?> md : nd.getBody()) {
        if (md instanceof FieldDefinition && md.isStatic()) mds.add(md);
      }
      return mds;
    }

    private List<FieldDefinition> getConcreteInstanceFields(ClassBody nd) {
      List<FieldDefinition> fds = new ArrayList<>();
      for (MemberDefinition<?> md : nd.getBody())
        if (md instanceof FieldDefinition && !md.isStatic() && md.isConcrete())
          fds.add((FieldDefinition) md);
      return fds;
    }

    public Void visitObjectLike(Node nd, List<? extends Node> properties, SuccessorInfo i) {
      if (properties.isEmpty()) succ(nd, i.getAllSuccessors());
      else succ(nd, First.of(properties.get(0)));
      seq(properties, i.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(Property nd, SuccessorInfo i) {
      this.seq(nd.getKey(), nd.getValue(), nd.getDefaultValue(), nd.getDecorators(), nd);
      succ(nd, i.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(MemberDefinition<?> nd, SuccessorInfo i) {
      if (nd.isConcrete() && !nd.isParameterField()) {
        this.seq(nd.getKey(), nd.getValue(), nd);
      }
      succ(nd, i.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(AssignmentExpression nd, SuccessorInfo i) {
      // `a &&= b` expands to `a || (a = b);`
      // The CFG is a conditional assignment, so we go through the assignment `nd` last.
      if ("&&=".equals(nd.getOperator()) || "||=".equals(nd.getOperator()) || "??=".equals(nd.getOperator())) {
        if ("&&=".equals(nd.getOperator())) {
          // from lhs to rhs on truthy. from lhs to false-branch on falsy.
          visit(nd.getLeft(), First.of(nd.getRight()), i.getSuccessors(false));
        } else if ("||=".equals(nd.getOperator())) {
          // from lhs to true-branch on truthy. from lhs to rhs on falsy.
          visit(nd.getLeft(), i.getSuccessors(true), First.of(nd.getRight()));
        } else { // "??="
          // the union of the above - truthyness is unknown.
          visit(nd.getLeft(), union(First.of(nd.getRight()), i.getAllSuccessors()), null);
        }
        
        visit(nd.getRight(), First.of(nd), null); // from right to assignment.

        succ(nd, i.getGuardedSuccessors(nd));
      } else {
        visitAssign(nd, nd.getLeft(), nd.getRight());
        succ(nd, i.getGuardedSuccessors(nd));
      }
      return null;
    }

    protected void visitAssign(INode assgn, INode lhs, Expression rhs) {
      if (lhs instanceof DestructuringPattern) seq(rhs, lhs, assgn);
      else seq(lhs, rhs, assgn);
    }

    @Override
    public Void visit(BinaryExpression nd, SuccessorInfo i) {
      if ("??".equals(nd.getOperator())) {
        // the nullish coalescing operator is short-circuiting, but we do not add guards for it
        succ(nd, First.of(nd.getLeft()));
        Object leftSucc =
            union(
                First.of(nd.getRight()),
                i.getAllSuccessors()); // short-circuiting happens with both truthy and falsy values
        visit(nd.getLeft(), leftSucc, null);
        nd.getRight().accept(this, i);
      } else {
        this.seq(nd.getLeft(), nd.getRight(), nd);
        succ(nd, i.getGuardedSuccessors(nd));
      }
      return null;
    }

    @Override
    public Void visit(VariableDeclarator nd, SuccessorInfo i) {
      visitAssign(nd, nd.getId(), nd.getInit());
      succ(nd, i.getAllSuccessors());
      return null;
    }

    // special treatment of short-circuiting operators as explained above
    @Override
    public Void visit(LogicalExpression nd, SuccessorInfo i) {
      Expression left = nd.getLeft();
      succ(nd, First.of(left));
      if ("&&".equals(nd.getOperator()))
        visit(left, First.of(nd.getRight()), i.getSuccessors(false));
      else visit(left, i.getSuccessors(true), First.of(nd.getRight()));
      nd.getRight().accept(this, i);
      return null;
    }

    @Override
    public Void visit(SpreadElement nd, SuccessorInfo i) {
      visit(nd.getArgument(), nd, null);
      succ(nd, i.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(UnaryExpression nd, SuccessorInfo i) {
      visit(nd.getArgument(), nd, null);
      succ(nd, i.getGuardedSuccessors(nd));
      return null;
    }

    @Override
    public Void visit(UpdateExpression nd, SuccessorInfo i) {
      visit(nd.getArgument(), nd, null);
      succ(nd, i.getGuardedSuccessors(nd));
      return null;
    }

    @Override
    public Void visit(YieldExpression nd, SuccessorInfo i) {
      visit(nd.getArgument(), nd, null);
      // yield expressions may throw
      succ(nd, union(this.findTarget(JumpType.THROW, null), i.getGuardedSuccessors(nd)));
      return null;
    }

    private void preVisitChainable(Chainable chainable, Expression base, SuccessorInfo i) {
      if (!chainable
          .isOnOptionalChain()) // optimization: bookkeeping is only needed for optional chains
      return;
      // start of chain
      chainRootSuccessors.putIfAbsent(chainable, i);
      // next step in chain
      if (base instanceof Chainable)
        chainRootSuccessors.put((Chainable) base, chainRootSuccessors.get(chainable));
    }

    private void postVisitChainable(Chainable chainable, Expression base, boolean optional) {
      if (optional) {
        succ(base, chainRootSuccessors.get(chainable).getSuccessors(false));
      }
      chainRootSuccessors.remove(chainable);
    }

    @Override
    public Void visit(MemberExpression nd, SuccessorInfo i) {
      preVisitChainable(nd, nd.getObject(), i);
      seq(nd.getObject(), nd.getProperty(), nd);
      // property accesses may throw
      succ(nd, union(this.findTarget(JumpType.THROW, null), i.getGuardedSuccessors(nd)));
      postVisitChainable(nd, nd.getObject(), nd.isOptional());
      return null;
    }

    @Override
    public Void visit(InvokeExpression nd, SuccessorInfo i) {
      preVisitChainable(nd, nd.getCallee(), i);
      seq(nd.getCallee(), nd.getArguments(), nd);
      Object succs = i.getGuardedSuccessors(nd);
      if (nd instanceof CallExpression
          && nd.getCallee() instanceof Super
          && !instanceFields.isEmpty()) {
        Pair<FieldDefinition, FieldDefinition> p = instanceFields.peek();
        if (p != null) {
          FieldDefinition firstField = p.fst();
          FieldDefinition lastField = p.snd();
          succ(lastField, succs);
          succs = First.of(firstField);
        }
      }
      // calls may throw
      succ(nd, union(this.findTarget(JumpType.THROW, null), succs));
      postVisitChainable(nd, nd.getCallee(), nd.isOptional());
      return null;
    }

    @Override
    public Void visit(TaggedTemplateExpression nd, SuccessorInfo i) {
      succ(nd, First.of(nd.getTag()));
      seq(nd.getTag(), nd.getQuasi(), i.getGuardedSuccessors(nd));
      return null;
    }

    @Override
    public Void visit(TemplateLiteral nd, SuccessorInfo i) {
      if (nd.getChildren().isEmpty()) {
        succ(nd, i.getSuccessors(false));
      } else {
        succ(nd, First.of(nd.getChildren().get(0)));
        seq(nd.getChildren(), i.getGuardedSuccessors(nd));
      }
      return null;
    }

    @Override
    public Void visit(ComprehensionExpression nd, SuccessorInfo i) {
      succ(nd, visitComprehensionBlock(nd, 0, i.getSuccessors(true)));
      return null;
    }

    private Node visitComprehensionBlock(ComprehensionExpression nd, int i, Object follow) {
      int n = nd.getBlocks().size();
      if (i >= n) {
        return visitComprehensionFilter(nd, follow);
      } else {
        ComprehensionBlock block = nd.getBlocks().get(i);
        succ(block, First.of(block.getRight()));
        follow = union(First.of((Node) block.getLeft()), follow);
        seq(block.getRight(), follow);
        seq(block.getLeft(), visitComprehensionBlock(nd, i + 1, follow));
        return First.of(block);
      }
    }

    private Node visitComprehensionFilter(ComprehensionExpression nd, Object follow) {
      if (nd.hasFilter()) {
        visit(nd.getFilter(), visitComprehensionBody(nd, follow), follow);
        return First.of(nd.getFilter());
      } else {
        return visitComprehensionBody(nd, follow);
      }
    }

    private Node visitComprehensionBody(ComprehensionExpression nd, Object back) {
      seq(nd.getBody(), back);
      return First.of(nd.getBody());
    }

    @Override
    public Void visit(ExportAllDeclaration nd, SuccessorInfo c) {
      succ(nd, First.of(nd.getSource()));
      seq(nd.getSource(), c.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(ExportDefaultDeclaration nd, SuccessorInfo c) {
      succ(nd, First.of(nd.getDeclaration()));
      seq(nd.getDeclaration(), c.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(ExportNamedDeclaration nd, SuccessorInfo c) {
      if (nd.hasDeclaration()) {
        succ(nd, First.of(nd.getDeclaration()));
        seq(nd.getDeclaration(), c.getAllSuccessors());
      } else if (nd.hasSource()) {
        succ(nd, First.of(nd.getSource()));
        seq(nd.getSource(), nd.getSpecifiers(), c.getAllSuccessors());
      } else if (nd.getSpecifiers().isEmpty()) {
        succ(nd, c.getAllSuccessors());
      } else {
        succ(nd, First.of(nd.getSpecifiers().get(0)));
        seq(nd.getSpecifiers(), c.getAllSuccessors());
      }
      return null;
    }

    @Override
    public Void visit(ExportSpecifier nd, SuccessorInfo c) {
      succ(nd, First.of(nd.getLocal()));
      seq(nd.getLocal(), nd.getExported(), c.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(ExportDefaultSpecifier nd, SuccessorInfo c) {
      succ(nd, First.of(nd.getExported()));
      seq(nd.getExported(), c.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(ExportNamespaceSpecifier nd, SuccessorInfo c) {
      succ(nd, First.of(nd.getExported()));
      seq(nd.getExported(), c.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(ImportDeclaration nd, SuccessorInfo c) {
      if (hoistedImports.contains(nd) || nd.getSpecifiers().isEmpty()) {
        succ(nd, c.getAllSuccessors());
      } else {
        succ(nd, First.of(nd.getSpecifiers().get(0)));
        seq(nd.getSpecifiers(), c.getAllSuccessors());
      }
      return null;
    }

    @Override
    public Void visit(ImportSpecifier nd, SuccessorInfo c) {
      succ(nd, c.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(JSXElement nd, SuccessorInfo c) {
      JSXOpeningElement open = nd.getOpeningElement();
      IJSXName name = open.getName();
      if (name == null) seq(nd.getChildren(), nd);
      else seq(name, open.getAttributes(), nd.getChildren(), nd);
      succ(nd, c.getSuccessors(true));
      return null;
    }

    @Override
    public Void visit(JSXMemberExpression nd, SuccessorInfo c) {
      seq(nd.getObject(), nd.getName(), nd);
      succ(nd, c.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(JSXNamespacedName nd, SuccessorInfo c) {
      seq(nd.getNamespace(), nd.getName(), nd);
      succ(nd, c.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(JSXAttribute nd, SuccessorInfo c) {
      seq(nd.getName(), nd.getValue(), nd);
      succ(nd, c.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(JSXSpreadAttribute nd, SuccessorInfo c) {
      visit(nd.getArgument(), nd, null);
      Label propkey = trapwriter.localID(nd, "JSXSpreadAttribute");
      Label spreadkey = trapwriter.localID(nd);
      trapwriter.addTuple("successor", spreadkey, propkey);
      for (Node succ : foreach(c.getAllSuccessors())) succ(propkey, succ);
      return null;
    }

    @Override
    public Void visit(JSXExpressionContainer nd, SuccessorInfo c) {
      return nd.getExpression().accept(this, c);
    }

    @Override
    public Void visit(AwaitExpression nd, SuccessorInfo c) {
      seq(nd.getArgument(), nd);
      // `await` may throw
      succ(nd, union(this.findTarget(JumpType.THROW, null), c.getGuardedSuccessors(nd)));
      return null;
    }

    @Override
    public Void visit(Decorator nd, SuccessorInfo c) {
      seq(nd.getExpression(), nd);
      succ(nd, c.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(BindExpression nd, SuccessorInfo c) {
      seq(nd.getObject(), nd.getCallee(), nd);
      succ(nd, c.getSuccessors(true));
      return null;
    }

    @Override
    public Void visit(ExternalModuleReference nd, SuccessorInfo c) {
      seq(nd.getExpression(), nd);
      succ(nd, c.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(DynamicImport nd, SuccessorInfo c) {
      seq(nd.getSource(), nd);
      succ(nd, c.getSuccessors(true));
      return null;
    }

    @Override
    public Void visit(ExpressionWithTypeArguments nd, SuccessorInfo c) {
      seq(nd.getExpression(), nd);
      succ(nd, c.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(TypeAssertion nd, SuccessorInfo c) {
      seq(nd.getExpression(), nd);
      succ(nd, c.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(NonNullAssertion nd, SuccessorInfo c) {
      seq(nd.getExpression(), nd);
      succ(nd, c.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(EnumDeclaration nd, SuccessorInfo c) {
      seq(nd.getId(), nd.getMembers(), nd.getDecorators(), nd);
      succ(nd, c.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(EnumMember nd, SuccessorInfo c) {
      seq(nd.getId(), nd.getInitializer(), nd);
      succ(nd, c.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(DecoratorList nd, SuccessorInfo c) {
      seq(nd.getDecorators(), nd);
      succ(nd, c.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(XMLAnyName nd, SuccessorInfo c) {
      succ(nd, c.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(XMLAttributeSelector nd, SuccessorInfo c) {
      seq(nd.getAttribute(), nd);
      succ(nd, c.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(XMLFilterExpression nd, SuccessorInfo c) {
      seq(nd.getLeft(), nd.getRight(), nd);
      succ(nd, c.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(XMLQualifiedIdentifier nd, SuccessorInfo c) {
      seq(nd.getLeft(), nd.getRight(), nd);
      succ(nd, c.getAllSuccessors());
      return null;
    }

    @Override
    public Void visit(XMLDotDotExpression nd, SuccessorInfo c) {
      seq(nd.getLeft(), nd.getRight(), nd);
      succ(nd, c.getAllSuccessors());
      return null;
    }
  }

  public void extract(Node nd) {
    metrics.startPhase(ExtractionPhase.CFGExtractor_extract);
    nd.accept(new V(), new SimpleSuccessorInfo(null));
    metrics.stopPhase(ExtractionPhase.CFGExtractor_extract);
  }
}
