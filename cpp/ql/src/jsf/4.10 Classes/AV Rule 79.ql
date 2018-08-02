/**
 * @name Resource not released in destructor
 * @description All resources acquired by a class should be released by its destructor. Avoid the use of the 'open / close' pattern, since C++ constructors and destructors provide a safer way to handle resource acquisition and release. Best practice in C++ is to use the 'RAII' technique: constructors allocate resources and destructors free them.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/resource-not-released-in-destructor
 * @tags efficiency
 *       readability
 *       external/cwe/cwe-404
 */
import cpp

// List pairs of functions that do resource acquisition/release
// Extend this to add custom function pairs. As written the query
// will only apply if the resource is the *return value* of the
// first call and a *parameter* to the second. Other cases should
// be handled differently.
predicate resourceManagementPair(string acquire, string release) {

  (acquire = "fopen" and release = "fclose")
  or
  (acquire = "open" and release = "close")
  or
  (acquire = "socket" and release = "close")

}

// List functions that return malloc-allocated memory. Customize
// to list your own functions there
predicate mallocFunction(Function malloc) {
  malloc.hasName("malloc") or malloc.hasName("calloc") or // Not realloc: doesn't acquire it, really
  malloc.hasName("strdup")
}

private predicate isRelease(string release) {
  resourceManagementPair(_, release) or
  release = "free" or
  release = "delete"
}

/**
 * Gets the expression `e` or a `PointerDereferenceExpr` around
 * it.
 */
Expr exprOrDereference(Expr e) {
  result = e or
  result.(PointerDereferenceExpr).getOperand() = e
}

/**
 * Holds if the expression `e` releases expression `released`, whether directly
 * or via one or more function call(s).
 */
private predicate exprReleases(Expr e, Expr released, string releaseType) {
  (
    // `e` is a call to a release function and `released` is any argument
    e.(FunctionCall).getTarget().getName() = releaseType and
    isRelease(releaseType) and
    e.(FunctionCall).getAnArgument() = released
  ) or (
    // `e` is a call to `delete` and `released` is the target
    e.(DeleteExpr).getExpr() = released and
    releaseType = "delete"
  ) or (
    // `e` is a call to `delete[]` and `released` is the target
    e.(DeleteArrayExpr).getExpr() = released and
    releaseType = "delete"
  ) or exists(Function f, int arg |
    // `e` is a call to a function that releases one of it's parameters,
    // and `released` is the corresponding argument
    e.(FunctionCall).getTarget() = f and
    e.(FunctionCall).getArgument(arg) = released and
    exprReleases(_, exprOrDereference(f.getParameter(arg).getAnAccess()), releaseType)
  ) or exists(Function f, Expr innerThis |
    // `e` is a call to a method that releases `this`, and `released`
    // is the object that is called
    e.(FunctionCall).getTarget() = f and
    e.(FunctionCall).getQualifier() = exprOrDereference(released) and
    innerThis.getEnclosingFunction() = f and
    exprReleases(_, innerThis, releaseType) and
    innerThis instanceof ThisExpr and
    releaseType = "delete"
  )
}

class Resource extends MemberVariable {

  Resource() { not isStatic() }

  // Check that an expr is somewhere in this class - does not have to be a constructor
  predicate inSameClass(Expr e) {
    e.getEnclosingFunction().(MemberFunction).getDeclaringType() = this.getDeclaringType()
  }

  private predicate calledFromDestructor(Function f) {
    (f instanceof Destructor and f.getDeclaringType() = this.getDeclaringType())
    or
    exists(Function mid, FunctionCall fc |
      calledFromDestructor(mid) and
      fc.getEnclosingFunction() = mid and
      fc.getTarget() = f and
      f.getDeclaringType() = this.getDeclaringType())
  }

  predicate inDestructor(Expr e) {
    exists(Function f | f = e.getEnclosingFunction() |
      calledFromDestructor(f)
    )
  }

  predicate acquisitionWithRequiredRelease(Expr acquire, string releaseName) {
    acquire.(Assignment).getLValue() = this.getAnAccess() and
    // Should be in this class, but *any* member method will do
    this.inSameClass(acquire) and
    // Check that it is an acquisition function and return the corresponding free
    (
      exists(Function f | f = acquire.(Assignment).getRValue().(FunctionCall).getTarget() and
         (resourceManagementPair(f.getName(), releaseName) or (mallocFunction(f) and (releaseName = "free" or releaseName = "delete")))
      )
      or
      (acquire = this.getANew() and releaseName = "delete")
    )
  }

  private Assignment getANew() {
    result.getLValue() = this.getAnAccess() and
    (result.getRValue() instanceof NewExpr or result.getRValue() instanceof NewArrayExpr) and
    this.inSameClass(result)
  }

  Expr getAReleaseExpr(string releaseName) {
    exprReleases(result, this.getAnAccess(), releaseName)
  }
}

predicate unreleasedResource(Resource r, Expr acquire, File f, int acquireLine) {
    // Note: there could be several release functions, because there could be
    // several functions called 'fclose' for example. We want to check that
    // *none* of these functions are called to release the resource
    r.acquisitionWithRequiredRelease(acquire, _) and
    not exists(Expr releaseExpr, string releaseName |
         r.acquisitionWithRequiredRelease(acquire, releaseName) and
         releaseExpr = r.getAReleaseExpr(releaseName) and
         r.inDestructor(releaseExpr)
    )
    and f = acquire.getFile()
    and acquireLine = acquire.getLocation().getStartLine()
}

predicate freedInSameMethod(Resource r, Expr acquire) {
  unreleasedResource(r, acquire, _, _) and
  exists(Expr releaseExpr, string releaseName |
    r.acquisitionWithRequiredRelease(acquire, releaseName) and
    releaseExpr = r.getAReleaseExpr(releaseName) and
    releaseExpr.getEnclosingFunction() = acquire.getEnclosingFunction()
  )
}

/**
 * Resource `r`, acquired by `acquire`, is passed to some external
 * object in the function where it's acquired.  This other object
 * may have taken responsibility for freeing the resource.
 */
predicate leakedInSameMethod(Resource r, Expr acquire) {
  unreleasedResource(r, acquire, _, _) and
  (
    exists(FunctionCall fc |
      // `r` (or something computed from it) is passed to another function
      // near to where it's acquired, and might be stored elsewhere.
      fc.getAnArgument().getAChild*() = r.getAnAccess() and
      fc.getEnclosingFunction() = acquire.getEnclosingFunction()
    ) or exists(Variable v, Expr e | 
      // `r` (or something computed from it) is stored in another variable
      // near to where it's acquired, and might be released through that
      // variable.
      v.getAnAssignedValue() = e and
      e.getAChild*() = r.getAnAccess() and
      e.getEnclosingFunction() = acquire.getEnclosingFunction()
    ) or exists(FunctionCall fc |
      // `this` (i.e. the class where `r` is acquired) is passed into `r` via a
      // method, or the constructor.  `r` may use this to register itself with
      // `this` in some way, ensuring it is later deleted.
      fc.getEnclosingFunction() = acquire.getEnclosingFunction() and
      fc.getAnArgument() instanceof ThisExpr and
      (
        fc.getQualifier() = r.getAnAccess() or // e.g. `r->setOwner(this)`
        fc = acquire.getAChild*() // e.g. `r = new MyClass(this)`
      )
    )
  )
}

pragma[noopt] predicate badRelease(Resource r, Expr acquire, Function functionCallingRelease, int line) {
  unreleasedResource(r, acquire, _, _) and
  exists(Expr releaseExpr, string releaseName,
         Location releaseExprLocation, Function acquireFunction |
    r.acquisitionWithRequiredRelease(acquire, releaseName) and
    releaseExpr = r.getAReleaseExpr(releaseName) and
    releaseExpr.getEnclosingFunction() = functionCallingRelease and
    functionCallingRelease.getDeclaringType() = r.getDeclaringType() and
    releaseExprLocation = releaseExpr.getLocation() and
    line = releaseExprLocation.getStartLine() and
    acquireFunction = acquire.getEnclosingFunction() and
    functionCallingRelease != acquireFunction
  )
}

Class qtObject() { result.getABaseClass*().getQualifiedName() = "QObject" }
PointerType qtObjectReference() { result.getBaseType() = qtObject() }
Constructor qtParentConstructor() {
  exists(Parameter p |
    p.getName() = "parent" and
    p.getType() = qtObjectReference() and
    result.getAParameter() = p and
    result.getDeclaringType() = qtObject()
  )
}

predicate automaticallyReleased(Assignment acquire)
{
  // sub-types of the Qt type QObject are released by their parent (if they have one)
  exists(NewExpr alloc |
    alloc.getType() = qtObject() and
    acquire.getRValue() = alloc and
    alloc.getInitializer() = qtParentConstructor().getACallToThisFunction()
  )
}

from Resource r, Expr acquire, File f, string message
where unreleasedResource(r, acquire, f, _) and
      not freedInSameMethod(r, acquire) and
      not leakedInSameMethod(r, acquire) and
      (
        exists(Function releaseFunction, int releaseLine | badRelease(r, acquire, releaseFunction, releaseLine) and
          message =
          "Resource " + r.getName() + " is acquired by class " + r.getDeclaringType().getName() +
          " but not released in the destructor. It is released from " + releaseFunction.getName() + " on line " + releaseLine +
          ", so this function may need to be called from the destructor."
        )
        or
        (
          not badRelease(r, _, _, _) and
          message = "Resource " + r.getName() + " is acquired by class " + r.getDeclaringType().getName() + " but not released anywhere in this class."
        )
      ) and
      not automaticallyReleased(acquire) and
      not r.getDeclaringType() instanceof TemplateClass // template classes may contain insufficient information for this analysis; results from instantiations will usually suffice.
select acquire, message
