/**
 * Provides classes and predicates for the 'js/useless-expression' query.
 */

import javascript
import DOMProperties
import semmle.javascript.frameworks.xUnit

/**
 * Holds if `e` appears in a syntactic context where its value is discarded.
 */
predicate inVoidContext(Expr e) {
  exists(ExprStmt parent |
    // e is a toplevel expression in an expression statement
    parent = e.getParent() and
    // but it isn't an HTML attribute or a configuration object
    not exists(TopLevel tl | tl = parent.getParent() |
      tl instanceof CodeInAttribute
      or
      // if the toplevel in its entirety is of the form `({ ... })`,
      // it is probably a configuration object (e.g., a require.js build configuration)
      tl.getNumChildStmt() = 1 and e.stripParens() instanceof ObjectExpr
    )
  )
  or
  exists(SeqExpr seq, int i, int n |
    e = seq.getOperand(i) and
    n = seq.getNumOperands()
  |
    i < n - 1 or inVoidContext(seq)
  )
  or
  exists(ForStmt stmt | e = stmt.getUpdate())
  or
  exists(ForStmt stmt | e = stmt.getInit() |
    // Allow the pattern `for(i; i < 10; i++)`
    not e instanceof VarAccess
  )
  or
  exists(LogicalBinaryExpr logical | e = logical.getRightOperand() and inVoidContext(logical))
}

/**
 * Holds if `e` is of the form `x;` or `e.p;` and has a JSDoc comment containing a tag.
 * In that case, it is probably meant as a declaration and shouldn't be flagged by this query.
 *
 * This will still flag cases where the JSDoc comment contains no tag at all (and hence carries
 * no semantic information), and expression statements with an ordinary (non-JSDoc) comment
 * attached to them.
 */
predicate isDeclaration(Expr e) {
  (e instanceof VarAccess or e instanceof PropAccess) and
  exists(e.getParent().(ExprStmt).getDocumentation().getATag())
}

/**
 * Holds if there exists a getter for a property called `name` anywhere in the program.
 */
predicate isGetterProperty(string name) {
  // there is a call of the form `Object.defineProperty(..., name, descriptor)` ...
  exists(CallToObjectDefineProperty defProp | name = defProp.getPropertyName() |
    // ... where `descriptor` defines a getter
    defProp.hasPropertyAttributeWrite("get", _)
    or
    // ... where `descriptor` may define a getter
    exists(DataFlow::SourceNode descriptor | descriptor.flowsTo(defProp.getPropertyDescriptor()) |
      descriptor.isIncomplete(_)
      or
      // minimal escape analysis for the descriptor
      exists(DataFlow::InvokeNode invk |
        not invk = defProp and
        descriptor.flowsTo(invk.getAnArgument())
      )
    )
  )
  or
  // there is an object expression with a getter property `name`
  exists(ObjectExpr obj | obj.getPropertyByName(name) instanceof PropertyGetter)
}

/**
 * A property access that may invoke a getter.
 */
class GetterPropertyAccess extends PropAccess {
  override predicate isImpure() { isGetterProperty(getPropertyName()) }
}

/**
 * Holds if `c` is an indirect eval call of the form `(dummy, eval)(...)`, where
 * `dummy` is some expression whose value is discarded, and which simply
 * exists to prevent the call from being interpreted as a direct eval.
 */
predicate isIndirectEval(CallExpr c, Expr dummy) {
  exists(SeqExpr seq | seq = c.getCallee().stripParens() |
    dummy = seq.getOperand(0) and
    seq.getOperand(1).(GlobalVarAccess).getName() = "eval" and
    seq.getNumOperands() = 2
  )
}

/**
 * Holds if `c` is a call of the form `(dummy, e[p])(...)`, where `dummy` is
 * some expression whose value is discarded, and which simply exists
 * to prevent the call from being interpreted as a method call.
 */
predicate isReceiverSuppressingCall(CallExpr c, Expr dummy, PropAccess callee) {
  exists(SeqExpr seq | seq = c.getCallee().stripParens() |
    dummy = seq.getOperand(0) and
    seq.getOperand(1) = callee and
    seq.getNumOperands() = 2
  )
}

/**
 * Holds if evaluating `e` has no side effects (except potentially allocating
 * and initializing a new object).
 *
 * For calls, we do not check whether their arguments have any side effects:
 * even if they do, the call itself is useless and should be flagged by this
 * query.
 */
predicate noSideEffects(Expr e) {
  e.isPure()
  or
  // `new Error(...)`, `new SyntaxError(...)`, etc.
  forex(Function f | f = e.flow().(DataFlow::NewNode).getACallee() |
    f.(ExternalType).getASupertype*().getName() = "Error"
  )
}

/**
 * Holds if the expression `e` should be reported as having no effect.
 */
predicate hasNoEffect(Expr e) {
  noSideEffects(e) and
  inVoidContext(e) and
  // disregard pure expressions wrapped in a void(...)
  not e instanceof VoidExpr and
  // filter out directives (unknown directives are handled by UnknownDirective.ql)
  not exists(Directive d | e = d.getExpr()) and
  // or about externs
  not e.inExternsFile() and
  // don't complain about declarations
  not isDeclaration(e) and
  // exclude DOM properties, which sometimes have magical auto-update properties
  not isDomProperty(e.(PropAccess).getPropertyName()) and
  // exclude xUnit.js annotations
  not e instanceof XUnitAnnotation and
  // exclude common patterns that are most likely intentional
  not isIndirectEval(_, e) and
  not isReceiverSuppressingCall(_, e, _) and
  // exclude anonymous function expressions as statements; these can only arise
  // from a syntax error we already flag
  not exists(FunctionExpr fe, ExprStmt es | fe = e |
    fe = es.getExpr() and
    not exists(fe.getName())
  ) and
  // exclude block-level flow type annotations. For example: `(name: empty)`.
  not e.(ParExpr).getExpression().getLastToken().getNextToken().getValue() = ":" and
  // exclude the first statement of a try block
  not e = any(TryStmt stmt).getBody().getStmt(0).(ExprStmt).getExpr() and
  // exclude expressions that are alone in a file, and file doesn't contain a function.
  not exists(TopLevel top |
    top = e.getParent().(ExprStmt).getParent() and
    top.getNumChild() = 1 and
    not exists(Function fun | fun.getEnclosingContainer() = top)
  ) and
  // ignore Angular templates
  not e.getTopLevel() instanceof Angular2::TemplateTopLevel
}
