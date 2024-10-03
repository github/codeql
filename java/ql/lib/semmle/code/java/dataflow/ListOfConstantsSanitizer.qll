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

  private class NonConstantElementAddition extends Expr {
    CollectionClass collectionClass;

    /** Gets whether the collection is a "List" or a "Set". */
    CollectionClass getCollectionClass() { result = collectionClass }

    NonConstantElementAddition() {
      exists(Method m, RefType t, MethodCall mc |
        this = mc.getQualifier() and
        mc.getMethod() = m and
        t = m.getDeclaringType().getSourceDeclaration().getASourceSupertype*()
      |
        collectionClass = "List" and
        t.hasQualifiedName("java.util", "List") and
        m.getName() = ["add", "addFirst", "addLast"] and
        not mc.getArgument(m.getNumberOfParameters() - 1).isCompileTimeConstant()
        or
        collectionClass = "Set" and
        t.hasQualifiedName("java.util", "Set") and
        m.getName() = ["add"] and
        not mc.getArgument(0).isCompileTimeConstant()
        or
        // If a whole collection is added then we don't try to track if it contains
        // only compile-time constants, and conservatively assume that it does.
        t.hasQualifiedName("java.util", "Collection") and
        m.getName() = "addAll"
      )
    }
  }

  private predicate collectionOfConstantsLocalFlowTo(CollectionClass collectionClass, Expr e) {
    exists(CollectionOfConstants loc |
      loc.getCollectionClass() = collectionClass and DataFlow::localExprFlow(loc, e)
    |
      loc.isImmutable()
      or
      not DataFlow::localExprFlow(any(NonConstantElementAddition ncea), e)
    )
  }

  private predicate collectionOfConstantsFlowsTo(CollectionClass collectionClass, Expr e) {
    collectionOfConstantsLocalFlowTo(collectionClass, e)
    or
    // Access a static final field to get an immutable list of constants.
    exists(Field f |
      f.isStatic() and
      f.isFinal() and
      forall(Expr v | v = f.getInitializer() or v = f.getAnAccess().(FieldWrite).getASource() |
        v =
          any(CollectionOfConstants loc |
            loc.getCollectionClass() = collectionClass and loc.isImmutable()
          )
      )
    |
      DataFlow::localExprFlow(f.getAnAccess(), e)
    )
  }

  /**
   * An invocation of `java.util.List.contains` where the qualifier contains only
   * compile-time constants.
   */
  private class CollectionOfConstantsContains extends ListOfConstantsComparison {
    CollectionOfConstantsContains() {
      exists(CollectionContainsCall mc |
        this = mc and
        e = mc.getArgument(0) and
        outcome = true and
        collectionOfConstantsFlowsTo(mc.getCollectionClass(), mc.getQualifier())
      )
    }
  }

  /**
   * An instance of `java.util.List` which contains only compile-time constants.
   */
  abstract class CollectionOfConstants extends Call {
    CollectionClass collectionClass;

    /** Gets whether the collection is a "List" or a "Set". */
    CollectionClass getCollectionClass() { result = collectionClass }

    /** Holds if this list of constants is immutable. */
    abstract predicate isImmutable();
  }

  /**
   * A invocation of a constructor of a type that extends `java.util.List` or
   * `java.util.Set` which constructs an empty mutable list.
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

    override predicate isImmutable() { none() }
  }

  /**
   * A invocation of a constructor of a type that extends `java.util.List` or
   * `java.util.Set` which constructs a non-empty mutable list.
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
      collectionOfConstantsFlowsTo(_, this.getArgument(0))
    }

    override predicate isImmutable() { none() }
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

    override predicate isImmutable() { none() }
  }

  /**
   * An invocation of `java.util.List.of` which constructs an immutable list
   * which contains only compile-time constants.
   */
  private class CollectionOfConstantsCreatedWithOf extends MethodCall, CollectionOfConstants {
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

    override predicate isImmutable() { any() }
  }

  /**
   * An invocation of `java.util.Collections.unmodifiableList` or
   * `java.util.Collections.unmodifiableSet` which constructs an immutable
   * list/set which contains only compile-time constants.
   */
  private class CollectionOfConstantsCreatedWithCollectionsUnmodifiableList extends MethodCall,
    CollectionOfConstants
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
        collectionOfConstantsFlowsTo(collectionClass, this.getArgument(0))
      )
    }

    override predicate isImmutable() { any() }
  }
}
