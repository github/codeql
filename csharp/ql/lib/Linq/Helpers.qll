/**
 * Helpers.qll
 * Provides helper classes and methods related to LINQ.
 */

private import csharp
private import semmle.code.csharp.frameworks.system.collections.Generic as GenericCollections
private import semmle.code.csharp.frameworks.system.Collections as Collections

//#################### PREDICATES ####################
private Stmt firstStmt(ForEachStmt fes) {
  if fes.getBody() instanceof BlockStmt
  then result = fes.getBody().(BlockStmt).getStmt(0)
  else result = fes.getBody()
}

private int numStmts(ForEachStmt fes) {
  if fes.getBody() instanceof BlockStmt
  then result = count(fes.getBody().(BlockStmt).getAStmt())
  else result = 1
}

private predicate returnsLoopVariable(ForEachStmt fes, Stmt s) {
  exists(ReturnStmt ret |
    ret = s.stripSingletonBlocks() and
    ret.getExpr().stripImplicit().(VariableAccess).getTarget() = fes.getVariable()
  )
}

private predicate hasNullDefault(Type t) { t.isRefType() or t instanceof NullableType }

private predicate returnsDefaultValueAfterForeach(ForEachStmt fes) {
  exists(BlockStmt enclosingBlock, int i, Type elementType, ReturnStmt ret |
    enclosingBlock.getStmt(i) = fes and
    enclosingBlock.getStmt(i + 1) = ret and
    elementType = fes.getVariable().getType()
  |
    ret.getExpr().stripImplicit() instanceof NullLiteral and
    hasNullDefault(elementType)
    or
    exists(DefaultValueExpr defaultValue |
      defaultValue = ret.getExpr().stripImplicit() and
      (
        defaultValue.getType() = elementType
        or
        hasNullDefault(elementType) and
        hasNullDefault(defaultValue.getType())
      )
    )
  )
}

private predicate terminatesCallable(Stmt s) {
  exists(Stmt stripped | stripped = s.stripSingletonBlocks() |
    stripped instanceof ReturnStmt
    or
    stripped instanceof YieldBreakStmt
    or
    stripped instanceof ThrowStmt
    or
    stripped instanceof BreakStmt
    or
    stripped = any(BlockStmt b | terminatesCallable(b.getLastStmt()))
    or
    stripped =
      any(IfStmt nested |
        terminatesCallable(nested.getThen()) and
        terminatesCallable(nested.getElse())
      )
  )
}

/** Holds if the type's qualified name is "System.Linq.Enumerable" */
predicate isEnumerableType(ValueOrRefType t) {
  t.hasFullyQualifiedName("System.Linq", "Enumerable")
}

/** Holds if the type's qualified name starts with "System.Collections.Generic.IEnumerable" */
predicate isIEnumerableType(ValueOrRefType t) {
  exists(string type |
    t.hasFullyQualifiedName("System.Collections.Generic", type) and
    type.matches("IEnumerable%")
  )
}

/** DEPRECATED: Use `ForEachStmtGenericEnumerable` instead. */
deprecated class ForeachStmtGenericEnumerable = ForEachStmtGenericEnumerable;

/**
 * A class of foreach statements where the iterable expression
 * supports the use of the LINQ extension methods on `IEnumerable<T>`.
 */
class ForEachStmtGenericEnumerable extends ForEachStmt {
  ForEachStmtGenericEnumerable() {
    exists(ValueOrRefType t | t = this.getIterableExpr().getType() |
      t.getABaseType*().getUnboundDeclaration() instanceof
        GenericCollections::SystemCollectionsGenericIEnumerableTInterface or
      t.(ArrayType).getRank() = 1
    )
  }
}

/** DEPRECATED: Use `ForEachStmtEnumerable` instead. */
deprecated class ForeachStmtEnumerable = ForEachStmtEnumerable;

/**
 * A class of foreach statements where the iterable expression
 * supports the use of the LINQ extension methods on `IEnumerable`.
 */
class ForEachStmtEnumerable extends ForEachStmt {
  ForEachStmtEnumerable() {
    exists(ValueOrRefType t | t = this.getIterableExpr().getType() |
      t.getABaseType*() instanceof Collections::SystemCollectionsIEnumerableInterface or
      t.(ArrayType).getRank() = 1
    )
  }
}

private signature predicate linqCandidateSig(Stmt s, Expr e);

private module LinqFilterOpportunity<linqCandidateSig/2 linqCandidate> {
  predicate missed(ForEachStmtGenericEnumerable fes, Stmt s) {
    s = firstStmt(fes) and
    // The linq candidate expression accesses the loop variable, and the
    // candidate doesn't access an in, out, or ref parameter.
    exists(Expr candidate | linqCandidate(s, candidate) |
      fes.getVariable().getAnAccess() = candidate.getAChildExpr*()
    )
  }
}

private module LinqMapOpportunity<linqCandidateSig/2 linqCandidate> {
  predicate missed(ForEachStmt fes, Stmt s) {
    s = firstStmt(fes) and
    // The linq candidate (and only the candidate) expression accesses the loop variable and the
    // candidate doesn't access an in, out, or ref parameter.
    exists(Expr candidate | linqCandidate(s, candidate) |
      forex(VariableAccess va | va = fes.getVariable().getAnAccess() |
        va = candidate.getAChildExpr*()
      )
    )
  }
}

private predicate linqAllCandidate(Stmt s, Expr e) {
  s =
    any(IfStmt is |
      e = is.getCondition() and
      not exists(is.getElse()) and // The then case of the if assigns false to something and breaks out of the loop.
      exists(Assignment a, BoolLiteral bl |
        a = is.getThen().getAChild*() and
        bl = a.getRightOperand() and
        bl.toString() = "false"
      ) and
      is.getThen().getAChild*() instanceof BreakStmt
    )
}

/**
 * Holds if `foreach` statement `fes` could be converted to a `.All()` call.
 * That is, the `ForEachStmt` contains a single `if` with a condition that
 * accesses the loop variable and with a body that assigns `false` to a variable
 * and `break`s out of the `foreach`.
 */
predicate missedAllOpportunity(ForEachStmtGenericEnumerable fes) {
  // The loop contains an if statement with no else case, and nothing else.
  LinqFilterOpportunity<linqAllCandidate/2>::missed(fes, _) and
  numStmts(fes) = 1
}

private predicate linqCastCandidate(Stmt s, Expr e) {
  s =
    any(LocalVariableDeclStmt lvds |
      exists(CastExpr ce |
        ce = lvds.getAVariableDeclExpr().getInitializer() and
        e = ce.getExpr() and
        e instanceof LocalVariableAccess
      )
    )
}

/**
 * Holds if the `foreach` statement `fes` can be converted to a `.Cast()` call.
 * That is, the loop variable is accessed only in the first statement of the
 * block, the access is a cast, and the first statement is a
 * local variable declaration statement `s`.
 */
predicate missedCastOpportunity(ForEachStmtEnumerable fes, LocalVariableDeclStmt s) {
  LinqMapOpportunity<linqCastCandidate/2>::missed(fes, s)
}

private predicate linqOfTypeCandidate(Stmt s, Expr e) {
  s =
    any(LocalVariableDeclStmt lvds |
      exists(AsExpr ae |
        ae = lvds.getAVariableDeclExpr().getInitializer() and
        e = ae.getExpr() and
        e instanceof LocalVariableAccess
      )
    )
}

/**
 * Holds if `foreach` statement `fes` can be converted to an `.OfType()` call.
 * That is, the loop variable is accessed only in the first statement of the
 * block, the access is a cast with the `as` operator, and the first statement
 * is a local variable declaration statement `s`.
 */
predicate missedOfTypeOpportunity(ForEachStmtEnumerable fes, LocalVariableDeclStmt s) {
  LinqMapOpportunity<linqOfTypeCandidate/2>::missed(fes, s)
}

private predicate linqSelectCandidate(Stmt s, Expr e) {
  s =
    any(LocalVariableDeclStmt lvds |
      e = lvds.getAVariableDeclExpr().getInitializer() and
      not e instanceof Cast and
      not e.getAChildExpr*() instanceof AwaitExpr
    )
}

/**
 * Holds if `foreach` statement `fes` can be converted to a `.Select()` call.
 * That is, the loop variable is accessed only in the first statement of the
 * block, the access is not a cast, the first statement is a
 * local variable declaration statement `s`, and the initializer does not
 * contain an `await` expression (since `Select` does not support async lambdas).
 */
predicate missedSelectOpportunity(ForEachStmtGenericEnumerable fes, LocalVariableDeclStmt s) {
  LinqMapOpportunity<linqSelectCandidate/2>::missed(fes, s)
}

private predicate linqWhereCandidateCase1(Stmt s, Expr e) {
  s =
    any(IfStmt is |
      e = is.getCondition() and
      is.getThen() instanceof ContinueStmt
    )
}

private predicate linqWhereCandidateCase2(Stmt s, Expr e) {
  s =
    any(IfStmt is |
      e = is.getCondition() and
      not exists(is.getElse()) and
      not terminatesCallable(is.getThen())
    )
}

/**
 * Holds if `foreach` statement `fes` could be converted to a `.Where()` call.
 * That is, first statement of the loop is an `if`, which accesses the loop
 * variable, and the body of the `if` is either a `continue` or there's nothing
 * else in the loop than the `if`.
 */
predicate missedWhereOpportunity(ForEachStmtGenericEnumerable fes, IfStmt is) {
  // The body of the `if` is a continue.
  LinqFilterOpportunity<linqWhereCandidateCase1/2>::missed(fes, is)
  or
  // There's nothing else in the loop than the `if`.
  LinqFilterOpportunity<linqWhereCandidateCase2/2>::missed(fes, is) and
  numStmts(fes) = 1
}

private predicate linqFirstOrDefaultCandidate(Stmt s, Expr e) {
  s =
    any(IfStmt is |
      e = is.getCondition() and
      not exists(is.getElse()) and
      not e.getAChildExpr*() instanceof AwaitExpr
    )
}

/**
 * Holds if `foreach` statement `fes` could be converted to a `.FirstOrDefault()` call.
 * That is, the loop contains a single `if` statement that accesses the loop variable,
 * returns the loop variable when the condition matches, and is followed by a default return.
 */
predicate missedFirstOrDefaultOpportunity(ForEachStmtGenericEnumerable fes, IfStmt is) {
  // The loop only checks whether the current element is the first match.
  LinqFilterOpportunity<linqFirstOrDefaultCandidate/2>::missed(fes, is) and
  numStmts(fes) = 1 and
  not fes.isAsync() and
  not fes.getVariable().isCaptured() and
  returnsLoopVariable(fes, is.getThen()) and
  fes.getElementType() = fes.getVariable().getType() and
  returnsDefaultValueAfterForeach(fes)
}

//#################### CLASSES ####################
/** A LINQ Any(...) call. */
class AnyCall extends MethodCall {
  AnyCall() {
    exists(Method m |
      m = this.getTarget().getUnboundDeclaration() and
      isEnumerableType(m.getDeclaringType()) and
      m.hasName("Any`1")
    )
  }
}

/** A LINQ Count(...) call. */
class CountCall extends MethodCall {
  CountCall() {
    exists(Method m |
      m = this.getTarget().getUnboundDeclaration() and
      isEnumerableType(m.getDeclaringType()) and
      m.hasName("Count`1")
    )
  }
}

/** A variable of type IEnumerable&lt;T>, for some T. */
class IEnumerableSequence extends Variable {
  IEnumerableSequence() { isIEnumerableType(this.getType()) }
}

/** A LINQ Select(...) call. */
class SelectCall extends ExtensionMethodCall {
  SelectCall() {
    exists(Method m |
      m = this.getTarget().getUnboundDeclaration() and
      isEnumerableType(m.getDeclaringType()) and
      m.hasName("Select`2")
    )
  }

  /** Gets the anonymous function expression supplied as the argument to the Select (if possible). */
  AnonymousFunctionExpr getFunctionExpr() { result = this.getArgument(1) }
}
