/**
 * Defines classes representing random data sources.
 */

import java

/**
 * A method access that returns random data or writes random data to an argument.
 */
abstract class RandomDataSource extends MethodAccess {
  /**
   * Gets the integer lower bound, inclusive, of the values returned by this call,
   * if applicable to this method's type and a constant bound is known.
   */
  int getLowerBound() { result = this.getLowerBoundExpr().(CompileTimeConstantExpr).getIntValue() }

  /**
   * Gets the integer lower bound, inclusive, of the values returned by this call,
   * if applicable to this method's type and a bound is known.
   */
  Expr getLowerBoundExpr() { none() }

  /**
   * Gets the integer upper bound, exclusive, of the values returned by this call,
   * if applicable to this method's type and a constant bound is known.
   */
  int getUpperBound() { result = this.getUpperBoundExpr().(CompileTimeConstantExpr).getIntValue() }

  /**
   * Gets the integer upper bound, exclusive, of the values returned by this call,
   * if applicable to this method's type and a bound is known.
   */
  Expr getUpperBoundExpr() { none() }

  /**
   * Holds if this source of random data may return bounded values (e.g. integers between 1 and 10).
   * If it does not hold, it may return any value in the range of its result type (e.g., any possible integer).
   */
  predicate resultMayBeBounded() { none() }

  /**
   * Gets the result of this source of randomness: either the method access itself, or some argument
   * in the case where it writes random data to that argument.
   */
  abstract Expr getOutput();
}

/**
 * A method access calling a method declared on `java.util.Random`
 * that returns random data or writes random data to an argument.
 */
class StdlibRandomSource extends RandomDataSource {
  Method m;

  StdlibRandomSource() {
    m = this.getMethod() and
    m.getName().matches("next%") and
    m.getDeclaringType().getAnAncestor().hasQualifiedName("java.util", "Random")
  }

  // Note for the following bounds functions: `java.util.Random` only defines no-arg versions
  // of `nextInt` and `nextLong` plus `nextInt(int x)`, bounded to the range [0, x)
  // However `ThreadLocalRandom` provides one- and two-arg versions of `nextInt` and `nextLong`
  // which allow both lower and upper bounds for both types.
  override int getLowerBound() {
    // If this call is to `nextInt(int)` or `nextLong(long), the lower bound is zero.
    m.hasName(["nextInt", "nextLong"]) and
    m.getNumberOfParameters() = 1 and
    result = 0
    or
    result = super.getLowerBound() // Include a lower bound provided via `getLowerBoundExpr`
  }

  override Expr getLowerBoundExpr() {
    // If this call is to `nextInt(int, int)` or `nextLong(long, long)`, the lower bound is the first argument.
    m.hasName(["nextInt", "nextLong"]) and
    m.getNumberOfParameters() = 2 and
    result = this.getArgument(0)
  }

  override Expr getUpperBoundExpr() {
    // If this call is to `nextInt(int)` or `nextLong(long)`, the upper bound is the first argument.
    // If it calls `nextInt(int, int)` or `nextLong(long, long)`, the upper bound is the second argument.
    m.hasName(["nextInt", "nextLong"]) and
    (
      m.getNumberOfParameters() = 1 and
      result = this.getArgument(0)
      or
      m.getNumberOfParameters() = 2 and
      result = this.getArgument(1)
    )
  }

  override predicate resultMayBeBounded() {
    // `next` may be restricted by its `bits` argument,
    // `nextBoolean` can't possibly be usefully bounded,
    // `nextDouble` and `nextFloat` are between 0 and 1,
    // `nextGaussian` is extremely unlikely to hit max values.
    m.hasName(["next", "nextBoolean", "nextDouble", "nextFloat", "nextGaussian"])
    or
    m.hasName(["nextInt", "nextLong"]) and
    m.getNumberOfParameters() = [1, 2]
  }

  override Expr getOutput() {
    if m.hasName("getBytes") then result = this.getArgument(0) else result = this
  }
}

/**
 * A method access calling a method declared on `org.apache.commons.lang3.RandomUtils`
 * that returns random data or writes random data to an argument.
 */
class ApacheCommonsRandomSource extends RandomDataSource {
  Method m;

  ApacheCommonsRandomSource() {
    m = this.getMethod() and
    m.getName().matches("next%") and
    m.getDeclaringType().hasQualifiedName("org.apache.commons.lang3", "RandomUtils")
  }

  override Expr getLowerBoundExpr() {
    // If this call is to `nextInt(int, int)` or `nextLong(long, long)`, the lower bound is the first argument.
    m.hasName(["nextInt", "nextLong"]) and
    m.getNumberOfParameters() = 2 and
    result = this.getArgument(0)
  }

  override Expr getUpperBoundExpr() {
    // If this call is to `nextInt(int, int)` or `nextLong(long, long)`, the upper bound is the second argument.
    m.hasName(["nextInt", "nextLong"]) and
    m.getNumberOfParameters() = 2 and
    result = this.getArgument(1)
  }

  override predicate resultMayBeBounded() {
    m.hasName(["nextDouble", "nextFloat"])
    or
    m.hasName(["nextInt", "nextLong"]) and
    m.getNumberOfParameters() = 2
  }

  override Expr getOutput() { result = this }
}
