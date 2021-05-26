import ql
private import codeql_ql.ast.internal.AstNodes

/** An AST node of a QL program */
class AstNode extends TAstNode {
  string toString() { result = "ASTNode" }

  Location getLocation() { result = toGenerated(this).getLocation() }

  AstNode getParent() { toGenerated(result) = toGenerated(this).getParent() }

  string getAPrimaryQlClass() { result = "???" }
}

/**
 * A classless predicate.
 */
class ClasslessPredicate extends TClasslessPredicate, AstNode {
  // TODO: Make super class for predicate things. (classless, class predicate, charpred)
  Generated::ModuleMember member;
  Generated::ClasslessPredicate pred;

  ClasslessPredicate() { this = TClasslessPredicate(member, pred) }

  predicate isPrivate() {
    member.getAFieldOrChild().(Generated::Annotation).getName().getValue() = "private"
  }

  override string getAPrimaryQlClass() { result = "ClasslessPredicate" }

  /**
   * Gets the `i`th parameter of the predicate.
   */
  VarDecl getParameter(int i) {
    toGenerated(result) =
      rank[i](Generated::VarDecl decl, int index | decl = pred.getChild(index) | decl order by index)
  }

  /**
   * Gets the body of the predicate.
   */
  Body getBody() { toGenerated(result) = pred.getChild(_) }

  /**
   * Gets the name of the predicate
   */
  string getName() { result = pred.getName().getValue() }
}

/**
 * A predicate in a class.
 */
class ClassPredicate extends TClassPredicate, AstNode {
  Generated::MemberPredicate pred;

  ClassPredicate() { this = TClassPredicate(pred) }

  /**
   * Gets the name of the predicate.
   */
  string getName() { result = pred.getName().getValue() }

  /**
   * Gets the body containing the implementation of the predicate.
   */
  Body getBody() { toGenerated(result) = pred.getChild(_) }

  // TODO: ReturnType.
  override string getAPrimaryQlClass() { result = "ClassPredicate" }

  override Class getParent() { result.getAClassPredicate() = this }
}

/**
 * A characteristic predicate of a class.
 */
class CharPred extends TCharPred, AstNode {
  Generated::Charpred pred;

  CharPred() { this = TCharPred(pred) }

  override string getAPrimaryQlClass() { result = "CharPred" }

  /*
   * Gets the body of the predicate.
   * TODO: The body is just directly an Expr in the generated AST. Wait for Expr type to appear.
   * Body getBody() { toGenerated(result) = pred.getChild(_) }MemberPredicate
   */

  override Class getParent() { result.getCharPred() = this }
}

/**
 * A variable declaration, with a type and a name.
 */
class VarDecl extends TVarDecl, AstNode {
  Generated::VarDecl var;

  VarDecl() { this = TVarDecl(var) }

  /**
   * Gets the name for this variable declaration.
   */
  string getName() { result = var.getChild(_).(Generated::VarName).getChild().getValue() }

  override string getAPrimaryQlClass() { result = "VarDecl" }

  override AstNode getParent() {
    result = super.getParent()
    or
    result.(Class).getAField() = this
  }
  // TODO: Getter for the Type.
}

/**
 * A QL class.
 */
class Class extends TClass, AstNode {
  Generated::Dataclass cls;

  Class() { this = TClass(cls) }

  override string getAPrimaryQlClass() { result = "Class" }

  /**
   * Gets the name of the class.
   */
  string getName() { result = cls.getName().getValue() }

  /**
   * Gets the charateristic predicate for this class.
   */
  CharPred getCharPred() {
    toGenerated(result) = cls.getChild(_).(Generated::ClassMember).getChild(0).(Generated::Charpred)
  }

  /**
   * Gets a predicate in this class.
   */
  ClassPredicate getAClassPredicate() {
    toGenerated(result) = cls.getChild(_).(Generated::ClassMember).getChild(0)
  }

  /**
   * Gets predicate `name` implemented in this class.
   */
  ClassPredicate getClassPredicate(string name) {
    result = getAClassPredicate() and
    result.getName() = name
  }

  /**
   * Gets a field in this class.
   */
  VarDecl getAField() {
    toGenerated(result) =
      cls.getChild(_).(Generated::ClassMember).getChild(0).(Generated::Field).getChild()
  }
  // TODO: extends, modifiers.
}

/**
 * The body of a predicate.
 */
class Body extends TBody, AstNode {
  Generated::Body body;

  Body() { this = TBody(body) }

  override string getAPrimaryQlClass() { result = "Body" }
  // TODO: Children.
}

/** A formula, such as `x = 6 and y < 5`. */
abstract class Formula extends AstNode { }

/** An `and` formula, with 2 or more operands. */
class Conjunction extends TConjunction, AstNode, Formula {
  Generated::Conjunction conj;

  Conjunction() { this = TConjunction(conj) }

  override string getAPrimaryQlClass() { result = "Conjunction" }

  /** Gets an operand to this formula. */
  Formula getAnOperand() { toGenerated(result) in [conj.getLeft(), conj.getRight()] }
}

/** An `or` formula, with 2 or more operands. */
class Disjunction extends TDisjunction, AstNode {
  Generated::Disjunction disj;

  Disjunction() { this = TDisjunction(disj) }

  override string getAPrimaryQlClass() { result = "Disjunction" }

  /** Gets an operand to this formula. */
  Formula getAnOperand() { toGenerated(result) in [disj.getLeft(), disj.getRight()] }
}

class ComparisonOp extends TComparisonOp, AstNode {
  Generated::Compop op;

  ComparisonOp() {this = TComparisonOp(op)}


}

class ComparisonFormula extends TComparisonFormula, Formula {
  Expr getLeftOperand() {none()}
  Expr getRightOperand() {none()}
  Expr getAnOperand() {none()}
  ComparisonOp getOperator() {none()}
  //ComparisonSymbol getSymbol() {none()}
}

/** An expression, such as `x+4`. */
abstract class Expr extends AstNode {}

/** A function symbol, such as `+` or `*`. */
class FunctionSymbol extends string {
  FunctionSymbol() { this = "+" or this = "-" or this = "*" or this = "/" or this = "%" }
}

/** A binary operation, such as `x+3` or `y/2` */
abstract class BinOpExpr extends Expr {}

class AddExpr extends TAddExpr, BinOpExpr {
  Generated::AddExpr addexpr;

  AddExpr() {this = TAddExpr(addexpr)}
  Expr getLeftOperand() { toGenerated(result) = addexpr.getLeft() }
  Expr getRightOperand() { toGenerated(result) = addexpr.getRight() }
  Expr getAnOperand() { result = getLeftOperand() or result = getRightOperand() }
  
  FunctionSymbol getOperator() { result = addexpr.getChild().getValue() }
}
