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
 *       external/jsf
 */

import cpp
import Critical.NewDelete
import semmle.code.cpp.valuenumbering.GlobalValueNumbering

/**
 * An expression that acquires a resource, and the kind of resource that is acquired.  The
 * kind of a resource indicates which acquisition/release expressions can be paired.
 */
predicate acquireExpr(Expr acquire, string kind) {
  exists(FunctionCall fc, Function f, string name |
    fc = acquire and
    f = fc.getTarget() and
    f.hasGlobalOrStdName(name) and
    (
      name = "fopen" and
      kind = "file"
      or
      name = "open" and
      kind = "file descriptor"
      or
      name = "socket" and
      kind = "file descriptor"
    )
  )
  or
  allocExpr(acquire, kind)
}

/**
 * An expression that releases a resource, and the kind of resource that is released.  The
 * kind of a resource indicates which acquisition/release expressions can be paired.
 */
predicate releaseExpr(Expr release, Expr resource, string kind) {
  exists(FunctionCall fc, Function f, string name |
    fc = release and
    f = fc.getTarget() and
    f.hasGlobalOrStdName(name) and
    (
      name = "fclose" and
      resource = fc.getArgument(0) and
      kind = "file"
      or
      name = "close" and
      resource = fc.getArgument(0) and
      kind = "file descriptor"
    )
  )
  or
  exists(string releaseKind |
    freeExpr(release, resource, releaseKind) and
    (
      kind = "malloc" and
      releaseKind = "free"
      or
      kind = "new" and
      releaseKind = "delete"
      or
      kind = "new[]" and
      releaseKind = "delete[]"
    )
  )
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
private predicate exprReleases(Expr e, Expr released, string kind) {
  // `e` is a call to a release function and `released` is the released argument
  releaseExpr(e, released, kind)
  or
  exists(int arg, VariableAccess access, Function f |
    // `e` is a call to a function that releases one of it's parameters,
    // and `released` is the corresponding argument
    (
      e.(FunctionCall).getTarget() = f or
      e.(FunctionCall).getTarget().(MemberFunction).getAnOverridingFunction+() = f
    ) and
    access = f.getParameter(arg).getAnAccess() and
    e.(FunctionCall).getArgument(arg) = released and
    exprReleases(_,
      pragma[only_bind_into](exprOrDereference(globalValueNumber(access).getAnExpr())), kind)
  )
  or
  exists(Function f, ThisExpr innerThis |
    // `e` is a call to a method that releases `this`, and `released`
    // is the object that is called
    (
      e.(FunctionCall).getTarget() = f or
      e.(FunctionCall).getTarget().(MemberFunction).getAnOverridingFunction+() = f
    ) and
    e.(FunctionCall).getQualifier() = exprOrDereference(released) and
    innerThis.getEnclosingFunction() = f and
    exprReleases(_, pragma[only_bind_into](globalValueNumber(innerThis).getAnExpr()), kind)
  )
}

class Resource extends MemberVariable {
  Resource() { not this.isStatic() }

  // Check that an expr is somewhere in this class - does not have to be a constructor
  predicate inSameClass(Expr e) {
    e.getEnclosingFunction().(MemberFunction).getDeclaringType() = this.getDeclaringType()
  }

  private predicate calledFromDestructor(Function f) {
    f instanceof Destructor and f.getDeclaringType() = this.getDeclaringType()
    or
    exists(Function mid, FunctionCall fc |
      this.calledFromDestructor(mid) and
      fc.getEnclosingFunction() = mid and
      fc.getTarget() = f and
      f.getDeclaringType() = this.getDeclaringType()
    )
  }

  predicate inDestructor(Expr e) {
    exists(Function f | f = e.getEnclosingFunction() | this.calledFromDestructor(f))
  }

  predicate acquisitionWithRequiredKind(Assignment acquireAssign, string kind) {
    // acquireAssign is an assignment to this resource
    acquireAssign.getLValue() = this.getAnAccess() and
    // Should be in this class, but *any* member method will do
    this.inSameClass(acquireAssign) and
    // Check that it is an acquisition function and return the corresponding kind
    acquireExpr(acquireAssign.getRValue(), kind)
  }

  Expr getAReleaseExpr(string kind) { exprReleases(result, this.getAnAccess(), kind) }
}

predicate unreleasedResource(Resource r, Expr acquire, File f, int acquireLine) {
  // Note: there could be several release functions, because there could be
  // several functions called 'fclose' for example. We want to check that
  // *none* of these functions are called to release the resource
  r.acquisitionWithRequiredKind(acquire, _) and
  not exists(Expr releaseExpr, string kind |
    r.acquisitionWithRequiredKind(acquire, kind) and
    releaseExpr = r.getAReleaseExpr(kind) and
    r.inDestructor(releaseExpr)
  ) and
  f = acquire.getFile() and
  acquireLine = acquire.getLocation().getStartLine() and
  not exists(ExprCall exprCall |
    // expression call (function pointer or lambda) with `r` as an
    // argument, which could release it.
    exprCall.getAnArgument() = r.getAnAccess() and
    r.inDestructor(exprCall)
  ) and
  // check that any destructor for this class has a block; if it doesn't,
  // we must be missing information.
  forall(Class c, Destructor d |
    r.getDeclaringType().isConstructedFrom*(c) and
    d = c.getAMember() and
    not d.isCompilerGenerated() and
    not d.isDefaulted() and
    not d.isDeleted()
  |
    exists(d.getBlock())
  )
}

predicate freedInSameMethod(Resource r, Expr acquire) {
  unreleasedResource(r, acquire, _, _) and
  exists(Expr releaseExpr, string kind |
    r.acquisitionWithRequiredKind(acquire, kind) and
    releaseExpr = r.getAReleaseExpr(kind) and
    releaseExpr.getEnclosingElement+() = acquire.getEnclosingFunction()
  )
}

/**
 * Resource `r`, acquired by `acquire`, is passed to some external
 * object in the function where it's acquired.  This other object
 * may have taken responsibility for freeing the resource.
 */
predicate leakedInSameMethod(Resource r, Expr acquire) {
  unreleasedResource(r, acquire, _, _) and
  exists(Function f |
    acquire.getEnclosingFunction() = f and
    (
      exists(FunctionCall fc |
        // `r` (or something computed from it) is passed to another function
        // near to where it's acquired, and might be stored elsewhere.
        fc.getAnArgument().getAChild*() = r.getAnAccess() and
        fc.getEnclosingFunction() = f
      )
      or
      exists(Variable v, Expr e |
        // `r` (or something computed from it) is stored in another variable
        // near to where it's acquired, and might be released through that
        // variable.
        v.getAnAssignedValue() = e and
        e.getAChild*() = r.getAnAccess() and
        e.getEnclosingFunction() = f
      )
      or
      exists(FunctionCall fc |
        // `this` (i.e. the class where `r` is acquired) is passed into `r` via a
        // method, or the constructor.  `r` may use this to register itself with
        // `this` in some way, ensuring it is later deleted.
        fc.getEnclosingFunction() = f and
        fc.getAnArgument() instanceof ThisExpr and
        (
          fc.getQualifier() = r.getAnAccess() or // e.g. `r->setOwner(this)`
          fc = acquire.getAChild*() // e.g. `r = new MyClass(this)`
        )
      )
    )
  )
  or
  exists(FunctionAccess fa, string kind |
    // the address of a function that releases `r` is taken (and likely
    // used to release `r` at some point).
    r.acquisitionWithRequiredKind(acquire, kind) and
    fa.getTarget() = r.getAReleaseExpr(kind).getEnclosingFunction()
  )
}

pragma[noopt]
predicate badRelease(Resource r, Expr acquire, Function functionCallingRelease, int line) {
  unreleasedResource(r, acquire, _, _) and
  exists(Expr releaseExpr, string kind, Location releaseExprLocation, Function acquireFunction |
    r.acquisitionWithRequiredKind(acquire, kind) and
    releaseExpr = r.getAReleaseExpr(kind) and
    releaseExpr.getEnclosingFunction() = functionCallingRelease and
    functionCallingRelease.getDeclaringType() = r.getDeclaringType() and
    releaseExprLocation = releaseExpr.getLocation() and
    line = releaseExprLocation.getStartLine() and
    acquireFunction = acquire.getEnclosingFunction() and
    functionCallingRelease != acquireFunction
  )
}

Class qtObject() { result.getABaseClass*().hasGlobalName("QObject") }

PointerType qtObjectReference() { result.getBaseType() = qtObject() }

Constructor qtParentConstructor() {
  exists(Parameter p |
    p.getName() = "parent" and
    p.getType() = qtObjectReference() and
    result.getAParameter() = p and
    result.getDeclaringType() = qtObject()
  )
}

predicate automaticallyReleased(Assignment acquire) {
  // sub-types of the Qt type QObject are released by their parent (if they have one)
  exists(NewExpr alloc |
    alloc.getAllocatedType() = qtObject() and
    acquire.getRValue() = alloc and
    alloc.getInitializer() = qtParentConstructor().getACallToThisFunction()
  )
}

from Resource r, Expr acquire, File f, string message
where
  unreleasedResource(r, acquire, f, _) and
  not freedInSameMethod(r, acquire) and
  not leakedInSameMethod(r, acquire) and
  (
    exists(Function releaseFunction, int releaseLine |
      badRelease(r, acquire, releaseFunction, releaseLine) and
      message =
        "Resource " + r.getName() + " is acquired by class " + r.getDeclaringType().getName() +
          " but not released in the destructor. It is released from " + releaseFunction.getName() +
          " on line " + releaseLine +
          ", so this function may need to be called from the destructor."
    )
    or
    not badRelease(r, _, _, _) and
    message =
      "Resource " + r.getName() + " is acquired by class " + r.getDeclaringType().getName() +
        " but not released anywhere in this class."
  ) and
  not automaticallyReleased(acquire) and
  not r.getDeclaringType() instanceof TemplateClass // template classes may contain insufficient information for this analysis; results from instantiations will usually suffice.
select acquire, message
