/**
 * Provides classes for working with the AST-based representation of JavaScript programs.
 */

import javascript
private import internal.StmtContainers
private import semmle.javascript.internal.CachedStages

/**
 * A program element corresponding to JavaScript code, such as an expression
 * or a statement.
 *
 * This class provides generic traversal methods applicable to all AST nodes,
 * such as obtaining the children of an AST node.
 *
 * Examples:
 *
 * ```
 * function abs(x) {
 *   return x < 0 ? -x : x;
 * }
 * abs(-42);
 * ```
 */
class AstNode extends @ast_node, NodeInStmtContainer {
  override Location getLocation() { hasLocation(this, result) }

  override File getFile() {
    result = this.getLocation().getFile() // Specialized for performance reasons
  }

  /** Gets the first token belonging to this element. */
  Token getFirstToken() {
    exists(Location l1, Location l2 |
      l1 = this.getLocation() and
      l2 = result.getLocation() and
      l1.getFile() = l2.getFile() and
      l1.getStartLine() = l2.getStartLine() and
      l1.getStartColumn() = l2.getStartColumn()
    )
  }

  /** Gets the last token belonging to this element. */
  Token getLastToken() {
    exists(Location l1, Location l2 |
      l1 = this.getLocation() and
      l2 = result.getLocation() and
      l1.getFile() = l2.getFile() and
      l1.getEndLine() = l2.getEndLine() and
      l1.getEndColumn() = l2.getEndColumn()
    ) and
    // exclude empty EOF token
    not result instanceof EOFToken
  }

  /** Gets a token belonging to this element. */
  Token getAToken() {
    exists(string path, int sl, int sc, int el, int ec, int tksl, int tksc, int tkel, int tkec |
      this.getLocation().hasLocationInfo(path, sl, sc, el, ec) and
      result.getLocation().hasLocationInfo(path, tksl, tksc, tkel, tkec)
    |
      (
        sl < tksl
        or
        sl = tksl and sc <= tksc
      ) and
      (
        tkel < el
        or
        tkel = el and tkec <= ec
      )
    ) and
    // exclude empty EOF token
    not result instanceof EOFToken
  }

  /** Gets the toplevel syntactic unit to which this element belongs. */
  cached
  TopLevel getTopLevel() { Stages::Ast::ref() and result = this.getParent().getTopLevel() }

  /**
   * Gets the `i`th child node of this node.
   *
   * _Note_: The indices of child nodes are considered an implementation detail and may
   * change between versions of the extractor.
   */
  AstNode getChild(int i) {
    result = this.getChildExpr(i) or
    result = this.getChildStmt(i) or
    properties(result, this, i, _, _) or
    result = this.getChildTypeExpr(i)
  }

  /** Gets the `i`th child statement of this node. */
  Stmt getChildStmt(int i) { stmts(result, _, this, i, _) }

  /** Gets the `i`th child expression of this node. */
  Expr getChildExpr(int i) { exprs(result, _, this, i, _) }

  /** Gets the `i`th child type expression of this node. */
  TypeExpr getChildTypeExpr(int i) { typeexprs(result, _, this, i, _) }

  /** Gets a child node of this node. */
  AstNode getAChild() { result = this.getChild(_) }

  /** Gets a child expression of this node. */
  Expr getAChildExpr() { result = this.getChildExpr(_) }

  /** Gets a child statement of this node. */
  Stmt getAChildStmt() { result = this.getChildStmt(_) }

  /** Gets the number of child nodes of this node. */
  int getNumChild() { result = count(this.getAChild()) }

  /** Gets the number of child expressions of this node. */
  int getNumChildExpr() { result = count(this.getAChildExpr()) }

  /** Gets the number of child statements of this node. */
  int getNumChildStmt() { result = count(this.getAChildStmt()) }

  /** Gets the parent node of this node, if any. */
  cached
  AstNode getParent() { Stages::Ast::ref() and this = result.getAChild() }

  /** Gets the first control flow node belonging to this syntactic entity. */
  ControlFlowNode getFirstControlFlowNode() { result = this }

  /** Holds if this syntactic entity belongs to an externs file. */
  predicate inExternsFile() { this.getTopLevel().isExterns() }

  /**
   * Holds if this is an ambient node that is not a `TypeExpr` and is not inside a `.d.ts` file
   *
   * Since the overwhelming majority of ambient nodes are `TypeExpr` or inside `.d.ts` files,
   * we avoid caching them.
   */
  cached
  private predicate isAmbientInternal() {
    Stages::Ast::ref() and
    this.getParent().isAmbientInternal()
    or
    not isAmbientTopLevel(this.getTopLevel()) and
    (
      this instanceof ExternalModuleDeclaration
      or
      this instanceof GlobalAugmentationDeclaration
      or
      this instanceof ExportAsNamespaceDeclaration
      or
      this instanceof TypeAliasDeclaration
      or
      this instanceof InterfaceDeclaration
      or
      has_declare_keyword(this)
      or
      has_type_keyword(this)
      or
      // An export such as `export declare function f()` should be seen as ambient.
      has_declare_keyword(this.(ExportNamedDeclaration).getOperand())
      or
      exists(Function f |
        this = f and
        not f.hasBody()
      )
    )
  }

  /**
   * Holds if this is part of an ambient declaration or type annotation in a TypeScript file.
   *
   * A declaration is ambient if it occurs under a `declare` modifier or is
   * an interface declaration, type alias, type annotation, or type-only import/export declaration.
   *
   * The TypeScript compiler emits no code for ambient declarations, but they
   * can affect name resolution and type checking at compile-time.
   */
  pragma[inline]
  predicate isAmbient() {
    this.isAmbientInternal()
    or
    isAmbientTopLevel(this.getTopLevel())
    or
    this instanceof TypeExpr
  }
}

/** DEPRECATED: Alias for AstNode */
deprecated class ASTNode = AstNode;

/**
 * Holds if the given file is a `.d.ts` file.
 */
cached
private predicate isAmbientTopLevel(TopLevel tl) {
  Stages::Ast::ref() and tl.getFile().getBaseName().matches("%.d.ts")
}

/**
 * A toplevel syntactic unit; that is, a stand-alone script, an inline script
 * embedded in an HTML `<script>` tag, a code snippet assigned to an HTML event
 * handler attribute, or a `javascript:` URL.
 *
 * Example:
 *
 * ```
 * <script>
 * window.done = true;
 * </script>
 * ```
 */
class TopLevel extends @toplevel, StmtContainer {
  /** Holds if this toplevel is minified. */
  cached
  predicate isMinified() {
    Stages::Ast::ref() and
    // file name contains 'min' (not as part of a longer word)
    this.getFile().getBaseName().regexpMatch(".*[^-._]*[-._]min([-._].*)?\\.\\w+")
    or
    exists(int numstmt | numstmt = strictcount(Stmt s | s.getTopLevel() = this) |
      // there are more than two statements per line on average
      numstmt.(float) / this.getNumberOfLines() > 2 and
      // and there are at least ten statements overall
      numstmt >= 10
    )
    or
    // many variables, and they all have short names
    count(VarDecl d | d.getTopLevel() = this) > 100 and
    forall(VarDecl d | d.getTopLevel() = this | d.getName().length() <= 2)
  }

  /** Holds if this toplevel is an externs definitions file. */
  predicate isExterns() {
    // either it was explicitly extracted as an externs file...
    is_externs(this)
    or
    // ...or it has a comment with an `@externs` tag in it
    exists(JSDocTag externs |
      externs.getTitle() = "externs" and
      externs.getTopLevel() = this
    )
  }

  /** Gets the toplevel to which this element belongs, that is, itself. */
  override TopLevel getTopLevel() { result = this }

  /** Gets the number of lines in this toplevel. */
  int getNumberOfLines() { numlines(this, result, _, _) }

  /** Gets the number of lines containing code in this toplevel. */
  int getNumberOfLinesOfCode() { numlines(this, _, result, _) }

  /** Gets the number of lines containing comments in this toplevel. */
  int getNumberOfLinesOfComments() { numlines(this, _, _, result) }

  override predicate isStrict() { this.getAStmt() instanceof StrictModeDecl }

  override ControlFlowNode getFirstControlFlowNode() { result = this.getEntry() }

  override string toString() { result = "<toplevel>" }
}

/**
 * A stand-alone file or script originating from an HTML `<script>` element.
 *
 * Example:
 *
 * ```
 * <script>
 * window.done = true;
 * </script>
 * ```
 */
class Script extends TopLevel {
  Script() { this instanceof @script or this instanceof @inline_script }
}

/**
 * A stand-alone file or an external script originating from an HTML `<script>` element.
 *
 * Example:
 *
 * ```
 * #! /usr/bin/node
 * console.log("Hello, world!");
 * ```
 */
class ExternalScript extends @script, Script { }

/**
 * A script embedded inline in an HTML `<script>` element.
 *
 * Example:
 *
 * ```
 * <script>
 * window.done = true;
 * </script>
 * ```
 */
class InlineScript extends @inline_script, Script { }

/**
 * A code snippet originating from an HTML attribute value.
 *
 * Examples:
 *
 * ```
 * <div onclick="alert('hi')">Click me</div>
 * <a href="javascript:alert('hi')">Click me</a>
 * ```
 */
class CodeInAttribute extends TopLevel {
  CodeInAttribute() {
    this instanceof @event_handler or
    this instanceof @javascript_url or
    this instanceof @template_toplevel
  }
}

/**
 * A code snippet originating from an event handler attribute.
 *
 * Example:
 *
 * ```
 * <div onclick="alert('hi')">Click me</div>
 * ```
 */
class EventHandlerCode extends @event_handler, CodeInAttribute { }

/**
 * A code snippet originating from a URL with the `javascript:` URL scheme.
 *
 * Example:
 *
 * ```
 * <a href="javascript:alert('hi')">Click me</a>
 * ```
 */
class JavaScriptUrl extends @javascript_url, CodeInAttribute { }

/** DEPRECATED: Alias for JavaScriptUrl */
deprecated class JavaScriptURL = JavaScriptUrl;

/**
 * A toplevel syntactic entity containing Closure-style externs definitions.
 *
 * Example:
 *
 * <pre>
 * /** @externs *&#47;
 * /** @typedef {String} *&#47;
 * var MyString;
 * </pre>
 */
class Externs extends TopLevel {
  Externs() { this.isExterns() }
}

/**
 * A program element that is either an expression or a statement.
 *
 * Examples:
 *
 * ```
 * var i = 0;
 * i = 9
 * ```
 */
class ExprOrStmt extends @expr_or_stmt, ControlFlowNode, AstNode { }

/**
 * A program element that contains statements, but isn't itself
 * a statement, in other words a toplevel or a function.
 *
 * Example:
 *
 * ```
 * function f() {
 *   g();
 * }
 * ```
 */
class StmtContainer extends @stmt_container, AstNode {
  /** Gets the innermost enclosing container in which this container is nested. */
  cached
  StmtContainer getEnclosingContainer() { none() }

  /**
   * Gets the innermost enclosing function or top-level,
   * possibly this container itself if it is a function or top-level.
   *
   * To get a strictly enclosing function or top-level, use
   * `getEnclosingContainer().getFunctionBoundary()`.
   *
   * TypeScript namespace declarations are containers that are not considered
   * function boundaries.  In plain JavaScript, all containers are function boundaries.
   */
  StmtContainer getFunctionBoundary() {
    if this instanceof Function or this instanceof TopLevel
    then result = this
    else result = this.getEnclosingContainer().getFunctionBoundary()
  }

  /** Gets a statement that belongs to this container. */
  Stmt getAStmt() { result.getContainer() = this }

  /**
   * Gets the body of this container.
   *
   * For scripts or modules, this is the container itself; for functions,
   * it is the function body.
   */
  AstNode getBody() { result = this }

  /**
   * Gets the (unique) entry node of the control flow graph for this toplevel or function.
   *
   * For most purposes, the start node should be used instead of the entry node;
   * see predicate `getStart()`.
   */
  ControlFlowEntryNode getEntry() { result.getContainer() = this }

  /** Gets the (unique) exit node of the control flow graph for this toplevel or function. */
  ControlFlowExitNode getExit() { result.getContainer() = this }

  /**
   * Gets the (unique) CFG node at which execution of this toplevel or function begins.
   *
   * Unlike the entry node, which is a synthetic construct, the start node corresponds to
   * an actual program element, such as the first statement of a toplevel or the first
   * parameter of a function.
   *
   * Empty toplevels do not have a start node.
   */
  ConcreteControlFlowNode getStart() { successor(this.getEntry(), result) }

  /**
   * Gets the entry basic block of this function, that is, the basic block
   * containing the entry node of its CFG.
   */
  EntryBasicBlock getEntryBB() { result = this.getEntry() }

  /**
   * Gets the start basic block of this function, that is, the basic block
   * containing the start node of its CFG.
   */
  BasicBlock getStartBB() { result.getANode() = this.getStart() }

  /** Gets the scope induced by this toplevel or function, if any. */
  Scope getScope() { scopenodes(this, result) }

  /**
   * Holds if the code in this container is executed in ECMAScript strict mode.
   *
   * See Annex C of the ECMAScript language specification.
   */
  predicate isStrict() { this.getEnclosingContainer().isStrict() }
}

/**
 * Provides a class `ValueNode` encompassing all program elements that evaluate to
 * a value at runtime.
 */
module AST {
  /**
   * A program element that evaluates to a value or destructures a value at runtime.
   * This includes expressions and destructuring patterns, but also function and
   * class declaration statements, as well as TypeScript namespace and enum declarations.
   *
   * Examples:
   *
   * ```
   * 0                               // expression
   * (function id(x) { return x; })  // parenthesized function expression
   * function id(x) { return x; }    // function declaration
   * ```
   */
  class ValueNode extends AstNode, @dataflownode {
    /** Gets type inference results for this element. */
    DataFlow::AnalyzedNode analyze() { result = DataFlow::valueNode(this).analyze() }

    /** Gets the data flow node associated with this program element. */
    DataFlow::ValueNode flow() { result = DataFlow::valueNode(this) }
  }
}
