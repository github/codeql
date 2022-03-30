/**
 * Provides default sources, sinks, and sanitizers for reasoning about
 * DoS attacks using objects with unbounded length property,
 * as well as extension points for adding your own.
 */

import javascript

module LoopBoundInjection {
  import semmle.javascript.security.TaintedObject

  /**
   * Holds if an exception will be thrown whenever `e` evaluates to `undefined` or `null`.
   */
  predicate isCrashingWithNullValues(Expr e) {
    exists(ExprOrStmt ctx |
      e = ctx.(PropAccess).getBase()
      or
      e = ctx.(InvokeExpr).getCallee()
      or
      e = ctx.(AssignExpr).getRhs() and
      ctx.(AssignExpr).getLhs() instanceof DestructuringPattern
      or
      e = ctx.(SpreadElement).getOperand()
      or
      e = ctx.(ForOfStmt).getIterationDomain()
    )
  }

  /**
   * A loop that iterates through some array using the `length` property.
   * The loop is either of the style `for(..; i < arr.length;...)` or `while(i < arr.length) {..;i++;..}`.
   */
  class ArrayIterationLoop extends Stmt {
    LocalVariable indexVariable;
    LoopStmt loop;
    DataFlow::PropRead lengthRead;

    ArrayIterationLoop() {
      this = loop and
      exists(RelationalComparison compare |
        compare = loop.getTest() and
        compare.getLesserOperand() = indexVariable.getAnAccess() and
        lengthRead.getPropertyName() = "length" and
        lengthRead.flowsToExpr(compare.getGreaterOperand())
      ) and
      exists(IncExpr inc | inc.getOperand() = indexVariable.getAnAccess() |
        inc = loop.(ForStmt).getUpdate()
        or
        inc.getEnclosingStmt().getParentStmt*() = loop.getBody()
      )
    }

    /**
     * Gets the length read in the loop test.
     */
    DataFlow::PropRead getLengthRead() { result = lengthRead }

    /**
     * Gets the loop test of this loop.
     */
    Expr getTest() { result = loop.getTest() }

    /**
     * Gets the body of this loop.
     */
    Stmt getBody() { result = loop.getBody() }

    /**
     * Gets the variable holding the loop variable and current array index.
     */
    LocalVariable getIndexVariable() { result = indexVariable }
  }

  /**
   * A data flow sink for untrusted user input that is being looped through.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * Holds if there exists an array access indexed by the variable `var` where it is likely that
   * the array access will cause a crash if `var` grows unbounded.
   */
  predicate hasCrashingArrayAccess(Variable var) {
    exists(DataFlow::PropRead arrayRead, Expr throws |
      arrayRead.getPropertyNameExpr() = var.getAnAccess() and
      arrayRead.flowsToExpr(throws) and
      isCrashingWithNullValues(throws)
    )
  }

  /**
   * An object that that is being iterated in a `for` loop, such as `for (..; .. sink.length; ...) ...`
   */
  private class LoopSink extends Sink {
    LoopSink() {
      exists(ArrayIterationLoop loop |
        this = loop.getLengthRead().getBase() and
        not hasCrashingArrayAccess(loop.getIndexVariable()) and
        // The existence of some kind of early-exit usually indicates that the loop will stop early and no DoS happens.
        not exists(BreakStmt br | br.getTarget() = loop) and
        not exists(ReturnStmt ret |
          ret.getParentStmt*() = loop.getBody() and
          ret.getContainer() = loop.getContainer()
        ) and
        not exists(ThrowStmt throw |
          loop.getBody() = throw.getParentStmt*() and
          not loop.getBody() = throw.getTarget().getParent*()
        )
      )
    }
  }

  /**
   * Holds if `name` is a method from lodash vulnerable to a DoS attack if called with a tainted object.
   */
  predicate loopableLodashMethod(string name) {
    name =
      [
        "chunk", "compact", "difference", "differenceBy", "differenceWith", "drop", "dropRight",
        "dropRightWhile", "dropWhile", "fill", "findIndex", "findLastIndex", "flatten",
        "flattenDeep", "flattenDepth", "initial", "intersection", "intersectionBy",
        "intersectionWith", "join", "remove", "reverse", "slice", "sortedUniq", "sortedUniqBy",
        "tail", "union", "unionBy", "unionWith", "uniqBy", "unzip", "unzipWith", "without", "zip",
        "zipObject", "zipObjectDeep", "zipWith", "countBy", "each", "forEach", "eachRight",
        "forEachRight", "filter", "find", "findLast", "flatMap", "flatMapDeep", "flatMapDepth",
        "forEach", "forEachRight", "groupBy", "invokeMap", "keyBy", "map", "orderBy", "partition",
        "reduce", "reduceRight", "reject", "sortBy"
      ]
  }

  /**
   * A method call to a lodash method that iterates over an array-like structure,
   * such as `_.filter(sink, ...)`.
   */
  private class LodashIterationSink extends Sink {
    LodashIterationSink() {
      exists(string name, DataFlow::CallNode call |
        loopableLodashMethod(name) and
        call = LodashUnderscore::member(name).getACall() and
        call.getArgument(0) = this and
        // Here it is just assumed that the array element is the first parameter in the callback function.
        not exists(DataFlow::FunctionNode func |
          func.flowsTo(call.getAnArgument()) and
          (
            // Looking for obvious null-pointers happening on the array elements in the iteration.
            // Similar to what is done in the loop iteration sink.
            exists(Expr throws |
              func.getParameter(0).flowsToExpr(throws) and
              isCrashingWithNullValues(throws)
            )
            or
            // Similar to the loop sink - the existence of an early-exit usually means that no DoS can happen.
            exists(ThrowStmt throw | throw.getTarget() = func.asExpr())
            or
            // A crash happens looking up the index variable.
            hasCrashingArrayAccess(func.getParameter(1).getParameter().getVariable())
          )
        )
      )
    }
  }

  /**
   * A source of objects that can cause DoS if iterated using the .length property.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A source of remote user input objects.
   */
  class TaintedObjectSource extends Source {
    TaintedObjectSource() { this instanceof TaintedObject::Source }
  }

  /**
   * A sanitizer that blocks taint flow if the array is checked to be an array using an `isArray` function.
   */
  class IsArraySanitizerGuard extends TaintTracking::LabeledSanitizerGuardNode, DataFlow::ValueNode {
    override CallExpr astNode;

    IsArraySanitizerGuard() { astNode.getCalleeName() = "isArray" }

    override predicate sanitizes(boolean outcome, Expr e, DataFlow::FlowLabel label) {
      true = outcome and
      e = astNode.getAnArgument() and
      label = TaintedObject::label()
    }
  }

  /**
   * A sanitizer that blocks taint flow if the array is checked to be an array using an `X instanceof Array` check.
   */
  class InstanceofArraySanitizerGuard extends TaintTracking::LabeledSanitizerGuardNode,
    DataFlow::ValueNode {
    override BinaryExpr astNode;

    InstanceofArraySanitizerGuard() {
      astNode.getOperator() = "instanceof" and
      DataFlow::globalVarRef("Array").flowsToExpr(astNode.getRightOperand())
    }

    override predicate sanitizes(boolean outcome, Expr e, DataFlow::FlowLabel label) {
      true = outcome and
      e = astNode.getLeftOperand() and
      label = TaintedObject::label()
    }
  }

  /**
   * A sanitizer that blocks taint flow if the length of an array is limited.
   *
   * Also implicitly makes sure that only the first DoS-prone loop is selected by the query (as the .length test has outcome=false when exiting the loop).
   */
  class LengthCheckSanitizerGuard extends TaintTracking::LabeledSanitizerGuardNode,
    DataFlow::ValueNode {
    override RelationalComparison astNode;
    DataFlow::PropRead propRead;

    LengthCheckSanitizerGuard() {
      propRead.flowsToExpr(astNode.getGreaterOperand()) and
      propRead.getPropertyName() = "length"
    }

    override predicate sanitizes(boolean outcome, Expr e, DataFlow::FlowLabel label) {
      false = outcome and
      e = propRead.getBase().asExpr() and
      label = TaintedObject::label()
    }
  }
}
