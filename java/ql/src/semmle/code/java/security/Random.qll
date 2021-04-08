import java
import semmle.code.java.dataflow.DefUse
import semmle.code.java.dataflow.DataFlow

/**
 * The `java.security.SecureRandom` class.
 */
class SecureRandomNumberGenerator extends RefType {
  SecureRandomNumberGenerator() { this.hasQualifiedName("java.security", "SecureRandom") }
}

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

/**
 * A method access calling a method declared on `java.security.SecureRandom`
 * that returns random data or writes random data to an argument.
 */
class GetRandomData extends StdlibRandomSource {
  GetRandomData() { this.getQualifier().getType() instanceof SecureRandomNumberGenerator }
}

private predicate isSeeded(RValue use) {
  isSeeding(_, use)
  or
  exists(GetRandomData da, RValue seeduse |
    da.getQualifier() = seeduse and
    useUsePair(seeduse, use)
  )
}

private class PredictableSeedFlowConfiguration extends DataFlow::Configuration {
  PredictableSeedFlowConfiguration() { this = "Random::PredictableSeedFlowConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof PredictableSeedExpr
  }

  override predicate isSink(DataFlow::Node sink) { isSeeding(sink.asExpr(), _) }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    predictableCalcStep(node1.asExpr(), node2.asExpr())
  }
}

private predicate predictableCalcStep(Expr e1, Expr e2) {
  e2.(BinaryExpr).hasOperands(e1, any(PredictableSeedExpr p))
  or
  exists(AssignOp a | a = e2 | e1 = a.getDest() and a.getRhs() instanceof PredictableSeedExpr)
  or
  exists(ConstructorCall cc, TypeNumber t | cc = e2 |
    cc.getArgument(0) = e1 and
    t.hasSubtype*(cc.getConstructedType())
  )
  or
  exists(Method m, MethodAccess ma |
    ma = e2 and
    e1 = ma.getQualifier() and
    m = ma.getMethod() and
    exists(TypeNumber t | hasSubtype*(t, m.getDeclaringType())) and
    (
      m.getName().matches("to%String") or
      m.getName() = "toByteArray" or
      m.getName().matches("%Value")
    )
  )
  or
  exists(Method m, MethodAccess ma |
    ma = e2 and
    e1 = ma.getArgument(0) and
    m = ma.getMethod() and
    exists(TypeNumber t | hasSubtype*(t, m.getDeclaringType())) and
    (
      m.getName().matches("parse%") or
      m.getName().matches("valueOf%") or
      m.getName().matches("to%String")
    )
  )
}

private predicate safelySeeded(RValue use) {
  exists(Expr arg |
    isSeeding(arg, use) and
    not exists(PredictableSeedFlowConfiguration conf | conf.hasFlowToExpr(arg))
  )
  or
  exists(GetRandomData da, RValue seeduse |
    da.getQualifier() = seeduse and useUsePair(seeduse, use)
  |
    not exists(RValue prior | useUsePair(prior, seeduse) | isSeeded(prior))
  )
}

predicate unsafelySeeded(RValue use, PredictableSeedExpr source) {
  isSeedingSource(_, use, source) and
  not safelySeeded(use)
}

private predicate isSeeding(Expr arg, RValue use) {
  exists(Expr e, VariableAssign def |
    def.getSource() = e and
    isSeedingConstruction(e, arg)
  |
    defUsePair(def, use) or
    def.getDestVar().(Field).getAnAccess() = use
  )
  or
  exists(Expr e, RValue seeduse |
    e.(MethodAccess).getQualifier() = seeduse and
    isRandomSeeding(e, arg) and
    useUsePair(seeduse, use)
  )
}

private predicate isSeedingSource(Expr arg, RValue use, Expr source) {
  isSeeding(arg, use) and
  exists(PredictableSeedFlowConfiguration conf |
    conf.hasFlow(DataFlow::exprNode(source), DataFlow::exprNode(arg))
  )
}

private predicate isRandomSeeding(MethodAccess m, Expr arg) {
  exists(Method def | m.getMethod() = def |
    def.getDeclaringType() instanceof SecureRandomNumberGenerator and
    def.getName() = "setSeed" and
    arg = m.getArgument(0)
  )
}

private predicate isSeedingConstruction(ClassInstanceExpr c, Expr arg) {
  c.getConstructedType() instanceof SecureRandomNumberGenerator and
  c.getNumArgument() = 1 and
  c.getArgument(0) = arg
}

class PredictableSeedExpr extends Expr {
  PredictableSeedExpr() {
    this.(MethodAccess).getCallee() instanceof ReturnsPredictableExpr
    or
    this instanceof CompileTimeConstantExpr
    or
    this.(ArrayCreationExpr).getInit() instanceof PredictableSeedExpr
    or
    exists(ArrayInit init | init = this |
      forall(Expr e | e = init.getAnInit() | e instanceof PredictableSeedExpr)
    )
  }
}

abstract class ReturnsPredictableExpr extends Method { }

class ReturnsSystemTime extends ReturnsPredictableExpr {
  ReturnsSystemTime() {
    this.getDeclaringType().hasQualifiedName("java.lang", "System") and
    this.hasName("currentTimeMillis")
    or
    this.getDeclaringType().hasQualifiedName("java.lang", "System") and this.hasName("nanoTime")
  }
}
