/**
 * Provides classes for working with xUnit.js tests.
 */

import javascript

/** Holds if an initialization of xUnit.js is detected. */
private predicate xUnitDetected() {
  // look for `Function.RegisterNamespace("xUnit.js");`
  exists(MethodCallExpr mc |
    mc.getParent() instanceof ExprStmt and
    mc = DataFlow::globalVarRef("Function").getAMemberCall("RegisterNamespace").asExpr() and
    mc.getNumArgument() = 1 and
    mc.getArgument(0).getStringValue() = "xUnit.js"
  )
}

/** Holds if `e` looks like an xUnit.js attribute, possibly with arguments. */
private predicate possiblyAttribute(Expr e, string name) {
  exists(Identifier id | id = e or id = e.(CallExpr).getCallee() |
    name = id.getName() and
    name.regexpMatch("Async|Data|Fact|Fixture|Import|ImportJson|Skip|Trait")
  )
}

/**
 * A bracketed list of expressions.
 *
 * Depending on their syntactic position, such lists will either be parsed as
 * array expressions, or as a property index expression where the indexing
 * expression is a comma expression: for example, in `[a, b][c, d]`, the
 * list `[a, b]` is an array expression, whereas `[c, d]` is an indexing
 * expression.
 *
 * We also allow singleton lists, as in `[a][b]`.
 */
abstract private class BracketedListOfExpressions extends Expr {
  /** Gets the `i`th element expression of this list. */
  abstract Expr getElement(int i);
}

/**
 * An array expression viewed as a bracketed list of expressions.
 */
private class ArrayExprIsABracketedListOfExpressions extends ArrayExpr, BracketedListOfExpressions {
  override predicate isImpure() { ArrayExpr.super.isImpure() }

  /** Gets the `i`th element of this array literal. */
  override Expr getElement(int i) { result = ArrayExpr.super.getElement(i) }
}

/**
 * A bracketed list of expressions that appears right after another such list,
 * and is hence parsed as an index expression.
 *
 * Note that the index expression itself does not include the opening and
 * closing brackets, for which we compensate by overriding `getFirstToken()`
 * and `getLastToken()`.
 */
private class IndexExprIndexIsBracketedListOfExpressions extends BracketedListOfExpressions {
  IndexExprIndexIsBracketedListOfExpressions() {
    exists(IndexExpr idx, Expr base |
      base = idx.getBase() and
      this = idx.getIndex() and
      // restrict to case where previous expression is also bracketed
      (base instanceof IndexExpr or base instanceof ArrayExpr)
    )
  }

  override Expr getElement(int i) {
    result = this.(SeqExpr).getChildExpr(i)
    or
    not this instanceof SeqExpr and i = 0 and result = this
  }

  override Token getFirstToken() {
    // include opening bracket
    result = BracketedListOfExpressions.super.getFirstToken().getPreviousToken()
  }

  override Token getLastToken() {
    // include closing bracket
    result = BracketedListOfExpressions.super.getLastToken().getNextToken()
  }
}

/**
 * Holds if `ann` annotates `trg`, possibly skipping over other intervening
 * annotations.
 *
 * We use a token-level definition, since depending on the number of annotations involved
 * the AST structure can become pretty complicated.
 */
private predicate annotationTarget(BracketedListOfExpressions ann, XUnitTarget trg) {
  // every element looks like an attribute
  forex(Expr e | e = ann.getElement(_) | possiblyAttribute(e, _)) and
  // followed directly either by a target or by another annotation
  exists(Token next | next = ann.getLastToken().getNextToken() |
    trg.getFirstToken() = next
    or
    exists(BracketedListOfExpressions ann2 | ann2.getFirstToken() = next |
      annotationTarget(ann2, trg)
    )
  )
}

/**
 * An xUnit.js annotation, such as `[Fixture]` or `[Data(23)]` annotating
 * a target declaration or definition.
 */
class XUnitAnnotation extends Expr {
  XUnitAnnotation() {
    xUnitDetected() and
    annotationTarget(this, _)
  }

  /** Gets the declaration or definition to which this annotation belongs. */
  XUnitTarget getTarget() { annotationTarget(this, result) }

  /** Gets the `i`th attribute of this annotation. */
  Expr getAttribute(int i) { result = this.(BracketedListOfExpressions).getElement(i) }

  /** Gets an attribute of this annotation. */
  Expr getAnAttribute() { result = getAttribute(_) }

  /** Gets the number of attributes of this annotation. */
  int getNumAttribute() { result = strictcount(getAnAttribute()) }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    // extend location to cover brackets
    exists(Location l1, Location l2 |
      l1 = getFirstToken().getLocation() and
      l2 = getLastToken().getLocation()
    |
      filepath = l1.getFile().getAbsolutePath() and
      startline = l1.getStartLine() and
      startcolumn = l1.getStartColumn() and
      endline = l2.getEndLine() and
      endcolumn = l2.getEndColumn()
    )
  }
}

/**
 * A declaration or definition that can serve as the target of an xUnit.js
 * annotation: a function declaration, a variable declaration, or an assignment.
 */
class XUnitTarget extends Stmt {
  XUnitTarget() {
    this instanceof FunctionDeclStmt or
    this instanceof VarDeclStmt or
    this.(ExprStmt).getExpr() instanceof AssignExpr
  }

  /** Gets an annotation of which this is the target, if any. */
  XUnitAnnotation getAnAnnotation() { this = result.getTarget() }
}

/**
 * An xUnit.js attribute appearing in an annotation.
 */
class XUnitAttribute extends Expr {
  XUnitAttribute() { exists(XUnitAnnotation ann | this = ann.getAnAttribute()) }

  /** Gets the name of this attribute. */
  string getName() { possiblyAttribute(this, result) }

  /** Gets the `i`th parameter of this attribute. */
  Expr getParameter(int i) { result = this.(CallExpr).getArgument(i) }

  /** Gets a parameter of this attribute. */
  Expr getAParameter() { result = getParameter(_) }

  /** Gets the number of parameters of this attribute. */
  int getNumParameter() { result = count(getAParameter()) }
}

/**
 * A function with an xUnit.js annotation.
 */
private class XUnitAnnotatedFunction extends Function {
  XUnitAnnotatedFunction() {
    exists(XUnitTarget target | exists(target.getAnAnnotation()) |
      this = target or
      this = target.(VarDeclStmt).getADecl().getInit() or
      this = target.(ExprStmt).getExpr().(AssignExpr).getRhs()
    )
  }

  /** Gets an xUnit.js annotation on this function. */
  XUnitAnnotation getAnAnnotation() {
    result = this.(XUnitTarget).getAnAnnotation() or
    result = this.(Expr).getEnclosingStmt().(XUnitTarget).getAnAnnotation()
  }
}

/**
 * An xUnit.js `Fixture` annotation.
 */
class XUnitFixtureAnnotation extends XUnitAnnotation {
  XUnitFixtureAnnotation() { getAnAttribute().accessesGlobal("Fixture") }
}

/**
 * An xUnit.js fixture.
 */
class XUnitFixture extends XUnitAnnotatedFunction {
  XUnitFixture() { getAnAnnotation() instanceof XUnitFixtureAnnotation }
}

/**
 * An xUnit.js `Fact` annotation.
 */
class XUnitFactAnnotation extends XUnitAnnotation {
  XUnitFactAnnotation() { getAnAttribute().accessesGlobal("Fact") }
}

/**
 * An xUnit.js fact.
 */
class XUnitFact extends XUnitAnnotatedFunction {
  XUnitFact() { getAnAnnotation() instanceof XUnitFactAnnotation }
}
