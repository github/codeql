/**
 * Provides classes for identifying comparisons against a list of compile-time
 * constants and considering them as taint-sanitizers.
 */

import java
private import semmle.code.java.controlflow.Guards
private import semmle.code.java.dataflow.TaintTracking

/**
 * A comparison against a list of compile-time constants, sanitizing taint by
 * restricting to a set of known values.
 */
class ListOfConstantsComparisonSanitizerGuard extends TaintTracking::DefaultTaintSanitizer {
  ListOfConstantsComparisonSanitizerGuard() {
    this = DataFlow::BarrierGuard<listOfConstantsComparisonSanitizerGuard/3>::getABarrierNode()
  }
}

private predicate listOfConstantsComparisonSanitizerGuard(Guard g, Expr e, boolean outcome) {
  exists(ListOfConstantsComparison locc |
    g = locc and
    e = locc.getExpr() and
    outcome = locc.getOutcome()
  )
}

/** A comparison against a list of compile-time constants. */
abstract class ListOfConstantsComparison extends Guard {
  Expr e;
  boolean outcome;

  ListOfConstantsComparison() {
    exists(this) and
    outcome = [true, false]
  }

  /** Gets the expression that is compared to a list of constants. */
  Expr getExpr() { result = e }

  /** Gets the value of `this` when `e` is in the list of constants. */
  boolean getOutcome() { result = outcome }
}

/**
 * Holds if the method call `mc` has only compile-time constant arguments (and
 * at least one argument). To account for varargs methods, we also include
 * a single array argument which is initialized locally with at least one
 * compile-time constant.
 */
predicate methodCallHasConstantArguments(MethodCall mc) {
  // f("a", "b", "c")
  forex(Expr e | e = mc.getAnArgument() |
    not e.getType() instanceof Array and e.isCompileTimeConstant()
  )
  or
  // String[] a = {"a", "b", "c"};
  // f(a)
  mc.getNumArgument() = 1 and
  mc.getArgument(0).getType() instanceof Array and
  exists(ArrayInit arr | DataFlow::localExprFlow(arr, mc.getArgument(0)) |
    forex(Expr e | e = arr.getAnInit() | e.isCompileTimeConstant())
  )
}

/** The name of a class implementing `java.util.Collection`. */
class CollectionClass extends string {
  CollectionClass() { this = ["List", "Set"] }
}

/** Classes for `java.util.List` and `java.util.Set`. */
module Collection {
  private class CollectionContainsCall extends MethodCall {
    CollectionClass collectionClass;

    /** Gets whether the collection is a "List" or a "Set". */
    CollectionClass getCollectionClass() { result = collectionClass }

    CollectionContainsCall() {
      exists(Method m |
        this.getMethod() = m and
        m.hasName("contains") and
        m.getDeclaringType()
            .getSourceDeclaration()
            .getASourceSupertype*()
            .hasQualifiedName("java.util", collectionClass)
      )
    }
  }

  /**
   * A call with a collection of class `collectionClass` as argument `arg` (or
   * as qualifier, if `arg` is -1) which will not add any new non-constant
   * elements to it.
   */
  abstract class SafeCall extends Call {
    int arg;
    CollectionClass collectionClass;

    SafeCall() {
      arg = -1 and exists(this.getQualifier())
      or
      exists(this.getArgument(arg))
    }

    /** Gets whether the collection is a "List" or a "Set". */
    CollectionClass getCollectionClass() { result = collectionClass }

    /** Gets the argument index, or -1 for the qualifier. */
    int getArg() { result = arg }
  }

  private class AddConstantElement extends SafeCall, MethodCall {
    AddConstantElement() {
      arg = -1 and
      exists(Method m, RefType t |
        this.getMethod() = m and
        t = m.getDeclaringType().getSourceDeclaration().getASourceSupertype*()
      |
        collectionClass = "List" and
        t.hasQualifiedName("java.util", "List") and
        m.getName() = ["add", "addFirst", "addLast"] and
        this.getArgument(m.getNumberOfParameters() - 1).isCompileTimeConstant()
        or
        collectionClass = "Set" and
        t.hasQualifiedName("java.util", "Set") and
        m.getName() = "add" and
        this.getArgument(0).isCompileTimeConstant()
      )
    }
  }

  private class UnmodifiableCollection extends SafeCall, MethodCall {
    UnmodifiableCollection() {
      arg = 0 and
      exists(Method m |
        this.getMethod() = m and
        m.hasName("unmodifiable" + collectionClass) and
        m.getDeclaringType()
            .getSourceDeclaration()
            .getASourceSupertype*()
            .hasQualifiedName("java.util", "Collections")
      )
    }
  }

  /**
   * Gets an `Expr` which locally flows to `e` and which nothing locally flows
   * to.
   */
  private Expr getALocalExprFlowRoot(Expr e) {
    DataFlow::localExprFlow(result, e) and
    not exists(Expr e2 | e2 != result | DataFlow::localExprFlow(e2, result))
  }

  /**
   * Holds if `e` was not involved in any calls which might add non-constant
   * elements.
   */
  private predicate noUnsafeCalls(Expr e) {
    forall(MethodCall mc, int arg, Expr x |
      DataFlow::localExprFlow(x, e) and
      (
        arg = -1 and x = mc.getQualifier()
        or
        x = mc.getArgument(arg)
      )
    |
      x = e or arg = mc.(SafeCall).getArg()
    )
  }

  /** Holds if `e` is a collection of constants. */
  private predicate isCollectionOfConstants(Expr e) {
    forex(Expr r | r = getALocalExprFlowRoot(e) |
      r instanceof CollectionOfConstants
      or
      // Access a static final field to get an immutable list of constants.
      exists(Field f | r = f.getAnAccess() |
        f.isStatic() and
        f.isFinal() and
        forall(Expr v | v = f.getInitializer() | v instanceof ImmutableCollectionOfConstants) and
        forall(Expr fieldSource | fieldSource = f.getAnAccess().(FieldWrite).getASource() |
          forall(Expr root | root = getALocalExprFlowRoot(fieldSource) |
            root instanceof ImmutableCollectionOfConstants
          ) and
          noUnsafeCalls(fieldSource)
        )
      )
    ) and
    noUnsafeCalls(e)
  }

  /**
   * An invocation of `java.util.List.contains` or `java.util.Set.contains`
   * where the qualifier contains only compile-time constants.
   */
  private class CollectionOfConstantsContains extends ListOfConstantsComparison {
    CollectionOfConstantsContains() {
      exists(CollectionContainsCall mc |
        this = mc and
        e = mc.getArgument(0) and
        outcome = true and
        isCollectionOfConstants(mc.getQualifier())
      )
    }
  }

  /**
   * An instance of `java.util.List` or `java.util.Set` which contains only
   * compile-time constants.
   */
  abstract class CollectionOfConstants extends Call {
    CollectionClass collectionClass;

    /** Gets whether the collection is a "List" or a "Set". */
    CollectionClass getCollectionClass() { result = collectionClass }
  }

  /**
   * An immutable instance of `java.util.List` or `java.util.Set` which
   * contains only compile-time constants.
   */
  abstract class ImmutableCollectionOfConstants extends CollectionOfConstants { }

  /**
   * A invocation of a constructor of a type that extends `java.util.List` or
   * `java.util.Set` which constructs an empty mutable list/set.
   */
  private class CollectionOfConstantsEmptyConstructor extends ClassInstanceExpr,
    CollectionOfConstants
  {
    CollectionOfConstantsEmptyConstructor() {
      this.getConstructedType()
          .getSourceDeclaration()
          .getASourceSupertype*()
          .hasQualifiedName("java.util", collectionClass) and
      exists(Constructor c | c = this.getConstructor() |
        c.hasNoParameters()
        or
        c.getNumberOfParameters() = 1 and
        c.getParameter(0).getType().(PrimitiveType).hasName("int")
        or
        c.getNumberOfParameters() = 2 and
        c.getParameter(0).getType().(PrimitiveType).hasName("int") and
        c.getParameter(0).getType().(PrimitiveType).hasName("float")
      )
    }
  }

  /**
   * A invocation of a constructor of a type that extends `java.util.List` or
   * `java.util.Set` which constructs a non-empty mutable list/set.
   */
  private class CollectionOfConstantsNonEmptyConstructor extends ClassInstanceExpr,
    CollectionOfConstants
  {
    CollectionOfConstantsNonEmptyConstructor() {
      this.getConstructedType()
          .getSourceDeclaration()
          .getASourceSupertype*()
          .hasQualifiedName("java.util", collectionClass) and
      exists(Constructor c | c = this.getConstructor() |
        c.getNumberOfParameters() = 1 and
        c.getParameter(0)
            .getType()
            .(RefType)
            .getASourceSupertype*()
            .hasQualifiedName("java.util", "Collection")
      ) and
      // Note that any collection can be used in the non-empty constructor.
      isCollectionOfConstants(this.getArgument(0))
    }
  }

  /**
   * A invocation of `java.util.Arrays.asList` which constructs a mutable list.
   */
  private class JavaUtilArraysAsList extends MethodCall, CollectionOfConstants {
    JavaUtilArraysAsList() {
      collectionClass = "List" and
      exists(Method m | this.getMethod() = m |
        m.hasName("asList") and
        m.getDeclaringType()
            .getSourceDeclaration()
            .getASourceSupertype*()
            .hasQualifiedName("java.util", "Arrays")
      ) and
      methodCallHasConstantArguments(this)
    }
  }

  /**
   * An invocation of `java.util.List.of` or `java.util.Set.of` which
   * constructs an immutable list/set which contains only compile-time constants.
   */
  private class CollectionOfConstantsCreatedWithOf extends MethodCall,
    ImmutableCollectionOfConstants
  {
    CollectionOfConstantsCreatedWithOf() {
      exists(Method m | this.getMethod() = m |
        m.hasName("of") and
        m.getDeclaringType()
            .getSourceDeclaration()
            .getASourceSupertype*()
            .hasQualifiedName("java.util", collectionClass)
      ) and
      methodCallHasConstantArguments(this)
    }
  }

  /**
   * An invocation of `java.util.Collections.unmodifiableList` or
   * `java.util.Collections.unmodifiableSet` which constructs an immutable
   * list/set which contains only compile-time constants.
   */
  private class CollectionOfConstantsCreatedWithCollectionsUnmodifiableList extends MethodCall,
    ImmutableCollectionOfConstants
  {
    CollectionOfConstantsCreatedWithCollectionsUnmodifiableList() {
      exists(Method m |
        m.hasName("unmodifiable" + collectionClass) and
        m.getDeclaringType()
            .getSourceDeclaration()
            .getASourceSupertype*()
            .hasQualifiedName("java.util", "Collections") and
        this.getMethod() = m
      |
        isCollectionOfConstants(this.getArgument(0))
      )
    }
  }
}
