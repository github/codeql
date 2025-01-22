/** Provides classes and methods shared by randomness-related queries. */

import java
import semmle.code.java.dataflow.DefUse
import semmle.code.java.dataflow.DataFlow
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

private predicate isSeeded(VarRead use) {
  isSeeding(_, use)
  or
  exists(GetRandomData da, VarRead seeduse |
    da.getQualifier() = seeduse and
    useUsePair(seeduse, use)
  )
}

private module PredictableSeedFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr() instanceof PredictableSeedExpr }

  predicate isSink(DataFlow::Node sink) { isSeeding(sink.asExpr(), _) }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    predictableCalcStep(node1.asExpr(), node2.asExpr())
  }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    // This predicate matches `PredictableSeed.ql`, which is the only place
    // where `PredictableSeedFlowConfig` is used.
    exists(GetRandomData da, VarRead use |
      result = da.getLocation() and
      da.getQualifier() = use and
      isSeeding(sink.asExpr(), use)
    )
  }
}

private module PredictableSeedFlow = DataFlow::Global<PredictableSeedFlowConfig>;

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
  exists(Method m, MethodCall ma |
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
  exists(Method m, MethodCall ma |
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

private predicate safelySeeded(VarRead use) {
  exists(Expr arg |
    isSeeding(arg, use) and
    not PredictableSeedFlow::flowToExpr(arg)
  )
  or
  exists(GetRandomData da, VarRead seeduse |
    da.getQualifier() = seeduse and useUsePair(seeduse, use)
  |
    not exists(VarRead prior | useUsePair(prior, seeduse) | isSeeded(prior))
  )
}

/**
 * Holds if predictable seed `source` is used to initialise a random-number generator
 * used at `use`.
 */
predicate unsafelySeeded(VarRead use, PredictableSeedExpr source) {
  isSeedingSource(_, use, source) and
  not safelySeeded(use)
}

private predicate isSeeding(Expr arg, VarRead use) {
  exists(Expr e, VariableAssign def |
    def.getSource() = e and
    isSeedingConstruction(e, arg)
  |
    defUsePair(def, use) or
    def.getDestVar().(Field).getAnAccess() = use
  )
  or
  exists(Expr e, VarRead seeduse |
    e.(MethodCall).getQualifier() = seeduse and
    isRandomSeeding(e, arg) and
    useUsePair(seeduse, use)
  )
}

private predicate isSeedingSource(Expr arg, VarRead use, Expr source) {
  isSeeding(arg, use) and
  PredictableSeedFlow::flow(DataFlow::exprNode(source), DataFlow::exprNode(arg))
}

private predicate isRandomSeeding(MethodCall m, Expr arg) {
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
    this.(MethodCall).getCallee() instanceof ReturnsPredictableExpr
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
