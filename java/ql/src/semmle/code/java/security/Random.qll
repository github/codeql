import java
import semmle.code.java.dataflow.DefUse
import semmle.code.java.dataflow.DataFlow

class SecureRandomNumberGenerator extends RefType {
  SecureRandomNumberGenerator() { this.hasQualifiedName("java.security", "SecureRandom") }
}

class GetRandomData extends MethodAccess {
  GetRandomData() {
    this.getMethod().getName().matches("next%") and
    this.getQualifier().getType() instanceof SecureRandomNumberGenerator
  }
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
