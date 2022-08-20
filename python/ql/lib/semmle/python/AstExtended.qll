import python
private import semmle.python.internal.CachedStages

/** A syntactic node (Class, Function, Module, Expr, Stmt or Comprehension) corresponding to a flow node */
abstract class AstNode extends AstNode_ {
  /*
   * Special comment for documentation generation.
   * All subclasses of `AstNode` that represent concrete syntax should have
   * a comment of the form:
   */

  /* syntax: ... */
  /** Gets the scope that this node occurs in */
  abstract Scope getScope();

  /**
   * Gets a flow node corresponding directly to this node.
   * NOTE: For some statements and other purely syntactic elements,
   * there may not be a `ControlFlowNode`
   */
  cached
  ControlFlowNode getAFlowNode() {
    Stages::AST::ref() and
    py_flow_bb_node(result, this, _, _)
  }

  /** Gets the location for this AST node */
  cached
  Location getLocation() { none() }

  /**
   * Whether this syntactic element is artificial, that is it is generated
   * by the compiler and is not present in the source
   */
  predicate isArtificial() { none() }

  /**
   * Gets a child node of this node in the AST. This predicate exists to aid exploration of the AST
   * and other experiments. The child-parent relation may not be meaningful.
   * For a more meaningful relation in terms of dependency use
   * Expr.getASubExpression(), Stmt.getASubStatement(), Stmt.getASubExpression() or
   * Scope.getAStmt().
   */
  cached
  abstract AstNode getAChildNode();

  /**
   * Gets the parent node of this node in the AST. This predicate exists to aid exploration of the AST
   * and other experiments. The child-parent relation may not be meaningful.
   * For a more meaningful relation in terms of dependency use
   * Expr.getASubExpression(), Stmt.getASubStatement(), Stmt.getASubExpression() or
   * Scope.getAStmt() applied to the parent.
   */
  cached
  AstNode getParentNode() {
    Stages::AST::ref() and
    result.getAChildNode() = this
  }

  /** Whether this contains `inner` syntactically */
  predicate contains(AstNode inner) { this.getAChildNode+() = inner }

  pragma[nomagic]
  private predicate containsInScope(AstNode inner, Scope scope) {
    this.contains(inner) and
    not inner instanceof Scope and
    scope = this.getScope()
  }

  /** Whether this contains `inner` syntactically and `inner` has the same scope as `this` */
  predicate containsInScope(AstNode inner) { this.containsInScope(inner, inner.getScope()) }
}

/* Parents */
/** The parent of a `Function`. Internal implementation class */
class FunctionParent extends FunctionParent_ { }

/** The parent of an `Arguments` node. Internal implementation class */
class ArgumentsParent extends ArgumentsParent_ { }

/** The parent of an `ExprList`. Internal implementation class */
class ExprListParent extends ExprListParent_ { }

/** The parent of an `ExprContext`. Internal implementation class */
class ExprContextParent extends ExprContextParent_ { }

/** The parent of a `StmtList`. Internal implementation class */
class StmtListParent extends StmtListParent_ { }

/** The parent of a `StrList`. Internal implementation class */
class StrListParent extends StrListParent_ { }

/** The parent of an `Expr`. Internal implementation class */
class ExprParent extends ExprParent_ { }

/** The parent of a `PatternList`. Internal implementation class */
class PatternListParent extends PatternListParent_ { }

/** The parent of a `Pattern`. Internal implementation class */
class PatternParent extends PatternParent_ { }

class DictItem extends DictItem_, AstNode {
  override string toString() { result = DictItem_.super.toString() }

  override AstNode getAChildNode() { none() }

  override Scope getScope() { none() }
}

/** A comprehension part, the 'for a in seq' part of  [ a * a for a in seq ] */
class Comprehension extends Comprehension_, AstNode {
  /** Gets the scope of this comprehension */
  override Scope getScope() {
    /* Comprehensions exists only in Python 2 list comprehensions, so their scope is that of the list comp. */
    exists(ListComp l | this = l.getAGenerator() | result = l.getScope())
  }

  override string toString() { result = "Comprehension" }

  override Location getLocation() {
    Stages::AST::ref() and
    result = Comprehension_.super.getLocation()
  }

  pragma[nomagic]
  override AstNode getAChildNode() {
    Stages::AST::ref() and
    result = this.getASubExpression()
  }

  Expr getASubExpression() {
    result = this.getIter() or
    result = this.getAnIf() or
    result = this.getTarget()
  }
}

class BytesOrStr extends BytesOrStr_ { }

/**
 * A part of a string literal formed by implicit concatenation.
 * For example the string literal "abc" expressed in the source as `"a" "b" "c"`
 * would be composed of three `StringPart`s.
 */
class StringPart extends StringPart_, AstNode {
  override Scope getScope() {
    exists(Bytes b | this = b.getAnImplicitlyConcatenatedPart() | result = b.getScope())
    or
    exists(Unicode u | this = u.getAnImplicitlyConcatenatedPart() | result = u.getScope())
  }

  override AstNode getAChildNode() { none() }

  override string toString() { result = StringPart_.super.toString() }

  override Location getLocation() { result = StringPart_.super.getLocation() }
}

class StringPartList extends StringPartList_ { }

/* **** Lists ***/
/** A parameter list */
class ParameterList extends @py_parameter_list {
  Function getParent() { py_parameter_lists(this, result) }

  /** Gets a parameter */
  Parameter getAnItem() {
    /* Item can be a Name or a Tuple, both of which are expressions */
    py_exprs(result, _, this, _)
  }

  /** Gets the nth parameter */
  Parameter getItem(int index) {
    /* Item can be a Name or a Tuple, both of which are expressions */
    py_exprs(result, _, this, index)
  }

  string toString() { result = "ParameterList" }
}

/** A list of Comprehensions (for generating parts of a set, list or dictionary comprehension) */
class ComprehensionList extends ComprehensionList_ { }

/** A list of expressions */
class ExprList extends ExprList_ {
  /* syntax: Expr, ... */
}

/** A list of patterns */
class PatternList extends PatternList_ { }

class DictItemList extends DictItemList_ { }

class DictItemListParent extends DictItemListParent_ { }

/** A list of strings (the primitive type string not Bytes or Unicode) */
class StringList extends StringList_ { }

/** A list of aliases in an import statement */
class AliasList extends AliasList_ { }
