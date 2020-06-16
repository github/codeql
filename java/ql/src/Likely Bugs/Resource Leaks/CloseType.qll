import java
import semmle.code.java.frameworks.Jdbc
import semmle.code.java.frameworks.Servlets
import semmle.code.java.frameworks.Mockito

/**
 * Expression `e` is assigned to variable `v`.
 */
private predicate flowsInto(Expr e, Variable v) {
  e = v.getAnAssignedValue()
  or
  exists(CastExpr c | flowsInto(c, v) | e = c.getExpr())
  or
  exists(ConditionalExpr c | flowsInto(c, v) | e = c.getTrueExpr() or e = c.getFalseExpr())
}

/**
 * A type in the `java.sql` package with a `close` method.
 * (Prior to Java 7, these types were not subtypes of `Closeable` or `AutoCloseable`.)
 */
predicate sqlType(RefType t) {
  exists(RefType sup | sup = t.getASupertype*() and sup.getAMethod().hasName("close") |
    sup.hasQualifiedName("java.sql", "Connection") or
    sup.hasQualifiedName("java.sql", "Statement") or
    sup.hasQualifiedName("java.sql", "ResultSet")
  )
}

/**
 * A (reflexive, transitive) subtype of `Closeable` or `AutoCloseable`,
 * or a closeable type in the `java.sql` package.
 */
private predicate closeableType(RefType t) {
  exists(RefType supertype | supertype = t.getASupertype*() |
    supertype.hasName("Closeable") or
    supertype.hasName("AutoCloseable") or
    sqlType(supertype)
  )
}

/**
 * An access to a method on a type in the 'java.sql` package that creates a closeable object in the `java.sql` package.
 * For example, `PreparedStatement.executeQuery()` or `Connection.prepareStatement(String)`.
 */
class SqlResourceOpeningMethodAccess extends MethodAccess {
  SqlResourceOpeningMethodAccess() {
    exists(Method m | this.getMethod() = m |
      m.getDeclaringType().(RefType).hasQualifiedName("java.sql", _) and
      m.getReturnType().(RefType).hasQualifiedName("java.sql", _) and
      m.getName().regexpMatch("(create|prepare|execute).*") and
      closeableType(m.getReturnType()) and
      not this.getQualifier() instanceof MockitoMockedObject
    )
  }
}

/**
 * A candidate for a "closeable init" expression, which may require calling a "close" method.
 */
class CloseableInitExpr extends Expr {
  CloseableInitExpr() {
    this instanceof ClassInstanceExpr or
    this instanceof SqlResourceOpeningMethodAccess
  }
}

/**
 * The expression `e` is either
 * - a (possibly nested) class instance creation expression of a closeable type,
 * - a SQL method access that returns an object of a closeable type, or
 *`- an access to a local variable to which a "closeable init" is assigned.
 *
 * The expression `parent` is the "closeable init" from which `e` is derived, if any, or `e` itself.
 */
private predicate closeableInit(Expr e, Expr parent) {
  exists(ClassInstanceExpr cie | cie = e |
    closeableType(cie.getType()) and
    (
      exists(Expr arg | arg = cie.getAnArgument() |
        closeableType(arg.getType()) and
        parent = arg
      )
      or
      not exists(Expr arg | arg = cie.getAnArgument() | closeableType(arg.getType())) and
      parent = cie
    )
  )
  or
  exists(SqlResourceOpeningMethodAccess ma | ma = e and parent = e)
  or
  exists(LocalVariableDecl v, Expr f | e = v.getAnAccess() and flowsInto(f, v) |
    closeableInit(f, parent)
  )
}

/**
 * The transitive closure of `closeableInit`.
 */
private predicate transitiveCloseableInit(Expr init, Expr transParent) {
  closeableInit+(init, transParent)
}

/**
 * The expression `root` is the innermost "closeable init" expression of `cie` (possibly itself).
 */
private predicate closeableInitRootCause(Expr cie, Expr root) {
  transitiveCloseableInit(cie, root) and
  not exists(Expr other | transitiveCloseableInit(root, other) and other != root)
}

/**
 * The type of the specified class instance creation expression or
 * the type of any of the "closeable init" expressions that it is derived from.
 */
RefType typeInDerivation(ClassInstanceExpr cie) {
  result = cie.getType()
  or
  exists(Expr transParent | transitiveCloseableInit(cie, transParent) |
    result = transParent.getType()
  )
}

/**
 * A "closeable init" whose root cause is not a field or parameter.
 */
private predicate locallyInitializedCloseable(Expr cie) {
  exists(Expr root | closeableInitRootCause(cie, root) |
    not exists(VarAccess va | va = root |
      va.getVariable() instanceof Parameter or
      va.getVariable() instanceof Field
    )
  )
}

/**
 * A locally initialized "closeable init" whose constructor does not have a throws clause.
 */
private predicate safeCloseableInit(ClassInstanceExpr cie) {
  locallyInitializedCloseable(cie) and
  not exists(cie.getConstructor().getAnException())
}

/**
 * A locally initialized "closeable init" that is neither assigned to a variable nor passed to a safe outer "closeable init".
 */
private predicate unassignedCloseableInit(CloseableInitExpr cie) {
  locallyInitializedCloseable(cie) and
  not flowsInto(cie, _) and
  not exists(ClassInstanceExpr outer | safeCloseableInit(outer) | cie = outer.getAnArgument())
}

/**
 * A locally initialized "closeable init" that flows into a field or return statement.
 */
private predicate escapingCloseableInit(CloseableInitExpr cie) {
  exists(Expr wrappingResource |
    locallyInitializedCloseable(cie) and
    (transitiveCloseableInit(wrappingResource, cie) or wrappingResource = cie)
  |
    exists(Field f | flowsInto(wrappingResource, f))
    or
    exists(ConstructorCall call | call.callsThis() or call.callsSuper() |
      closeableType(call.getConstructedType()) and
      call.getAnArgument() = wrappingResource
    )
    or
    wrappingResource.getEnclosingStmt() instanceof ReturnStmt
    or
    getCloseableVariable(wrappingResource).getAnAccess().getEnclosingStmt() instanceof ReturnStmt
    or
    exists(Parameter p0 | escapingMethodParameterClosable(p0) |
      p0.getAnArgument() = wrappingResource
      or
      exists(LocalVariableDecl v |
        p0.getAnArgument() = v.getAnAccess() and flowsInto(wrappingResource, v)
      )
    )
  )
}

/**
 * Holds if `p` is a closable that escapes by an assignment to a field.
 */
private predicate escapingMethodParameterClosable(Parameter p) {
  p.getCallable() instanceof Method and
  exists(Expr wrappingResource |
    closeableType(p.getType()) and
    (
      transitiveCloseableInit(wrappingResource, p.getAnAccess()) or
      wrappingResource = p.getAnAccess()
    )
  |
    exists(Field f | flowsInto(wrappingResource, f))
    or
    exists(Parameter p0 | escapingMethodParameterClosable(p0) |
      p0.getAnArgument() = wrappingResource
      or
      exists(LocalVariableDecl v |
        p0.getAnArgument() = v.getAnAccess() and flowsInto(wrappingResource, v)
      )
    )
  )
}

/**
 * A local variable into which the specified (locally initialized) "closeable init" flows.
 */
private LocalVariableDecl getCloseableVariable(CloseableInitExpr cie) {
  locallyInitializedCloseable(cie) and flowsInto(cie, result)
}

/**
 * A variable on which a "close" method is called, implicitly or explicitly, directly or indirectly.
 */
private predicate closeCalled(Variable v) {
  // `close()` is implicitly called on variables declared or referenced
  // in the resources clause of try-with-resource statements.
  exists(TryStmt try | try.getAResourceVariable() = v)
  or
  // Otherwise, there should be an explicit call to a method whose name contains "close".
  exists(MethodAccess e |
    v = getCloseableVariable(_) or v instanceof Parameter or v instanceof LocalVariableDecl
  |
    e.getMethod().getName().toLowerCase().matches("%close%") and
    exists(VarAccess va | va = v.getAnAccess() |
      e.getQualifier() = va or
      e.getAnArgument() = va
    )
    or
    // The "close" call could happen indirectly inside a helper method of unknown name.
    exists(int i | exprs(v.getAnAccess(), _, _, e, i) |
      exists(Parameter p, int j | params(p, _, j, e.getMethod(), _) |
        closeCalled(p) and i = j
        or
        // The helper method could be iterating over a varargs parameter.
        exists(EnhancedForStmt for | for.getExpr() = p.getAnAccess() |
          closeCalled(for.getVariable().getVariable())
        ) and
        p.isVarargs() and
        j <= i
      )
    )
  )
}

/**
 * A locally initialized "closeable init" that flows into a variable on which a "close" method is called
 * or is immediately closed after creation.
 */
private predicate closedResource(CloseableInitExpr cie) {
  locallyInitializedCloseable(cie) and
  (
    exists(LocalVariableDecl v | closeCalled(v) |
      exists(Expr wrappingResource |
        wrappingResource = cie or transitiveCloseableInit(wrappingResource, cie)
      |
        flowsInto(wrappingResource, v)
      )
    )
    or
    immediatelyClosed(cie)
  )
}

private predicate immediatelyClosed(ClassInstanceExpr cie) {
  exists(MethodAccess ma | ma.getQualifier() = cie | ma.getMethod().hasName("close"))
}

/**
 * A unassigned or locally-assigned "closeable init" that does not escape and is not closed.
 */
private predicate badCloseableInitImpl(CloseableInitExpr cie) {
  unassignedCloseableInit(cie) and not immediatelyClosed(cie) and not escapingCloseableInit(cie)
  or
  locallyInitializedCloseable(cie) and not closedResource(cie) and not escapingCloseableInit(cie)
}

/**
 * The innermost "closeable init" of `cie` that does not escape and is never closed.
 */
predicate badCloseableInit(CloseableInitExpr cie) {
  badCloseableInitImpl(cie) and
  not exists(CloseableInitExpr cie2 |
    transitiveCloseableInit(cie, cie2) and cie2 != cie and badCloseableInitImpl(cie2)
  )
}

/**
 * A locally initialized "closeable init" that does not need to be closed.
 */
predicate noNeedToClose(CloseableInitExpr cie) {
  locallyInitializedCloseable(cie) and
  (
    cie instanceof ClassInstanceExpr and not exists(cie.(ClassInstanceExpr).getAnArgument())
    or
    exists(RefType t | t = cie.getType() and t.fromSource() |
      exists(Method close | close.getDeclaringType() = t and close.getName() = "close" |
        not exists(close.getBody().getAChild())
      )
    )
    or
    exists(CloseableInitExpr sqlStmt, LocalVariableDecl v |
      // If a `java.sql.Statement` is closed, an associated `java.sql.ResultSet` is implicitly closed.
      sqlStmt.getType().(RefType).getASupertype*() instanceof TypeStatement and
      flowsInto(sqlStmt, v) and
      closedResource(sqlStmt) and
      cie.getType() instanceof TypeResultSet and
      cie.(SqlResourceOpeningMethodAccess).getQualifier() = v.getAnAccess()
    )
    or
    exists(MethodAccess ma | cie.(ClassInstanceExpr).getAnArgument() = ma |
      ma.getMethod() instanceof ServletResponseGetOutputStreamMethod or
      ma.getMethod() instanceof ServletResponseGetWriterMethod or
      ma.getMethod() instanceof ServletRequestGetBodyMethod
    )
  )
  or
  exists(CloseableInitExpr inner | transitiveCloseableInit(cie, inner) | noNeedToClose(inner))
  or
  exists(CloseableInitExpr inner | transitiveCloseableInit(cie, inner) |
    closeCalled(getCloseableVariable(inner))
  )
}
