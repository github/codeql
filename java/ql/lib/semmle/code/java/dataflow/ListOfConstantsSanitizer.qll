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

/** Classes for `java.util.List`. */
module JavaUtilList {
  private class JavaUtilListContainsCall extends MethodCall {
    JavaUtilListContainsCall() {
      exists(Method m |
        this.getMethod() = m and
        m.hasName("contains") and
        m.getDeclaringType().getSourceDeclaration().hasQualifiedName("java.util", "List")
      )
    }
  }

  private class NonConstantElementAddition extends Expr {
    NonConstantElementAddition() {
      exists(Method m, RefType t, MethodCall mc |
        this = mc.getQualifier() and
        mc.getMethod() = m and
        t = m.getDeclaringType().getSourceDeclaration().getASourceSupertype*()
      |
        t.hasQualifiedName("java.util", "List") and
        m.getName() = ["add", "addFirst", "addLast"] and
        not mc.getArgument(m.getNumberOfParameters() - 1).isCompileTimeConstant()
        or
        // If a whole collection is added then we don't try to track if it contains
        // only compile-time constants, and conservatively assume that it does.
        t.hasQualifiedName("java.util", ["Collection", "List"]) and m.getName() = "addAll"
      )
    }
  }

  private predicate javaUtilListOfConstantsLocalFlowTo(Expr e) {
    exists(JavaUtilListOfConstants loc | DataFlow::localExprFlow(loc, e) |
      loc.isImmutable()
      or
      not DataFlow::localExprFlow(any(NonConstantElementAddition ncea), e)
    )
  }

  private predicate javaUtilListOfConstantsFlowsTo(Expr e) {
    javaUtilListOfConstantsLocalFlowTo(e)
    or
    // Access a static final field to get an immutable list of constants.
    exists(Field f |
      f.isStatic() and
      f.isFinal() and
      forall(Expr v | v = f.getInitializer() or v = f.getAnAccess().(FieldWrite).getASource() |
        v = any(JavaUtilListOfConstants loc | loc.isImmutable())
      )
    |
      DataFlow::localExprFlow(f.getAnAccess(), e)
    )
  }

  /**
   * An invocation of `java.util.List.contains` where the qualifier contains only
   * compile-time constants.
   */
  private class JavaUtilListOfConstantsContains extends ListOfConstantsComparison {
    JavaUtilListOfConstantsContains() {
      exists(JavaUtilListContainsCall mc |
        this = mc and
        e = mc.getArgument(0) and
        outcome = true and
        javaUtilListOfConstantsFlowsTo(mc.getQualifier())
      )
    }
  }

  /**
   * An instance of `java.util.List` which contains only compile-time constants.
   */
  abstract class JavaUtilListOfConstants extends Call {
    /** Holds if this list of constants is immutable. */
    abstract predicate isImmutable();
  }

  /**
   * A invocation of a constructor of a type that extends `java.util.List`
   * which constructs an empty mutable list.
   */
  private class JavaUtilListOfConstantsEmptyConstructor extends ClassInstanceExpr,
    JavaUtilListOfConstants
  {
    JavaUtilListOfConstantsEmptyConstructor() {
      this.getConstructedType()
          .getSourceDeclaration()
          .getASourceSupertype*()
          .hasQualifiedName("java.util", "List") and
      exists(Constructor c | c = this.getConstructor() |
        c.hasNoParameters()
        or
        c.getNumberOfParameters() = 1 and
        c.getParameter(0).getType().(PrimitiveType).hasName("int")
      )
    }

    override predicate isImmutable() { none() }
  }

  /**
   * A invocation of a constructor of a type that extends `java.util.List`
   * which constructs an empty mutable list.
   */
  private class JavaUtilListOfConstantsNonEmptyConstructor extends ClassInstanceExpr,
    JavaUtilListOfConstants
  {
    JavaUtilListOfConstantsNonEmptyConstructor() {
      this.getConstructedType()
          .getSourceDeclaration()
          .getASourceSupertype*()
          .hasQualifiedName("java.util", "List") and
      exists(Constructor c | c = this.getConstructor() |
        c.getNumberOfParameters() = 1 and
        c.getParameter(0)
            .getType()
            .(RefType)
            .getASourceSupertype*()
            .hasQualifiedName("java.util", "Collection")
      ) and
      javaUtilListOfConstantsFlowsTo(this.getArgument(0))
    }

    override predicate isImmutable() { none() }
  }

  /**
   * A invocation of `java.util.Arrays.asList` which constructs a mutable list.
   */
  private class JavaUtilArraysAsList extends MethodCall, JavaUtilListOfConstants {
    JavaUtilArraysAsList() {
      exists(Method m | this.getMethod() = m |
        m.hasName("asList") and
        m.getDeclaringType().getSourceDeclaration().hasQualifiedName("java.util", "Arrays")
      ) and
      methodCallHasConstantArguments(this)
    }

    override predicate isImmutable() { none() }
  }

  /**
   * An invocation of `java.util.List.of` which constructs an immutable list
   * which contains only compile-time constants.
   */
  private class JavaUtilListOfConstantsCreatedWithListOf extends MethodCall, JavaUtilListOfConstants
  {
    JavaUtilListOfConstantsCreatedWithListOf() {
      exists(Method m | this.getMethod() = m |
        m.hasName("of") and
        m.getDeclaringType().getSourceDeclaration().hasQualifiedName("java.util", "List")
      ) and
      methodCallHasConstantArguments(this)
    }

    override predicate isImmutable() { any() }
  }

  /**
   * An invocation of `java.util.Collections.unmodifiableList` which constructs an immutable list
   * which contains only compile-time constants.
   */
  private class JavaUtilListOfConstantsCreatedWithCollectionsUnmodifiableList extends MethodCall,
    JavaUtilListOfConstants
  {
    JavaUtilListOfConstantsCreatedWithCollectionsUnmodifiableList() {
      exists(Method m |
        m.hasName("unmodifiableList") and
        m.getDeclaringType().getSourceDeclaration().hasQualifiedName("java.util", "Collections") and
        this.getMethod() = m
      |
        javaUtilListOfConstantsFlowsTo(this.getArgument(0))
      )
    }

    override predicate isImmutable() { any() }
  }
}
