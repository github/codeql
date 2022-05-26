/** Provides classes and methods shared by randomness-related queries. */

import java
import semmle.code.java.dataflow.DefUse
import semmle.code.java.dataflow.DataFlow6
import RandomDataSource

/**
 * The `java.security.SecureRandom` class.
 */
class SecureRandomNumberGenerator extends RefType {
  SecureRandomNumberGenerator() { this.hasQualifiedName("java.security", "SecureRandom") }
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

private class PredictableSeedFlowConfiguration extends DataFlow6::Configuration {
  PredictableSeedFlowConfiguration() { this = "Random::PredictableSeedFlowConfiguration" }

  override predicate isSource(DataFlow6::Node source) {
    source.asExpr() instanceof PredictableSeedExpr
  }

  override predicate isSink(DataFlow6::Node sink) { isSeeding(sink.asExpr(), _) }

  override predicate isAdditionalFlowStep(DataFlow6::Node node1, DataFlow6::Node node2) {
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
    exists(TypeNumber t | hasDescendant(t, m.getDeclaringType())) and
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
    exists(TypeNumber t | hasDescendant(t, m.getDeclaringType())) and
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

/**
 * Holds if predictable seed `source` is used to initialise a random-number generator
 * used at `use`.
 */
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
    conf.hasFlow(DataFlow6::exprNode(source), DataFlow6::exprNode(arg))
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

/**
 * A constant, call to a `ReturnsPredictableExpr` method, or an array initialiser
 * consisting entirely of the same.
 */
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

/**
 * A method whose return value is predictable (not necessarily constant).
 *
 * Extend this class in order that all randomness-related queries should consider the result
 * of a particular method predictable when noting bad RNG seeding and related issues.
 */
abstract class ReturnsPredictableExpr extends Method { }

private class ReturnsSystemTime extends ReturnsPredictableExpr {
  ReturnsSystemTime() {
    this.getDeclaringType().hasQualifiedName("java.lang", "System") and
    this.hasName("currentTimeMillis")
    or
    this.getDeclaringType().hasQualifiedName("java.lang", "System") and this.hasName("nanoTime")
  }
}
