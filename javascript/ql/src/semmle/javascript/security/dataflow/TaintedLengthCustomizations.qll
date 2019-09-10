/**
 * Provides default sources, sinks and sanitisers for reasoning about
 * DOS attacks using objects with unbounded length object. 
 * As well as extension points for adding your own.
 */

import javascript

module TaintedLength {
  import semmle.javascript.security.dataflow.RemoteFlowSources
  import semmle.javascript.security.TaintedObject
  import DataFlow::PathGraph

  // Heavily inspired by Expr::inNullSensitiveContext
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

  // Inspired by LoopIterationSkippedDueToShifting::ArrayIterationLoop
  // Added some Dataflow to the .length access.
  // Added support for while/dowhile loops.
  class ArrayIterationLoop extends Stmt {
    LocalVariable indexVariable;
    LoopStmt loop;

    ArrayIterationLoop() {
      this = loop and 
      exists(RelationalComparison compare, DataFlow::PropRead lengthRead |
        compare = loop.getTest() and
        compare.getLesserOperand() = indexVariable.getAnAccess() and
        lengthRead.accesses(_, "length") and
        lengthRead.flowsToExpr(compare.getGreaterOperand())
      ) and
      (
        loop.(ForStmt).getUpdate().(IncExpr).getOperand() = indexVariable.getAnAccess() or
        loop.getBody().getAChild*().(IncExpr).getOperand() = indexVariable.getAnAccess()
      )
    }

    Expr getTest() {
      result = loop.getTest()
    }
    
    Stmt getBody() {
      result = loop.getBody()   
    }

    /**
     * Gets the variable holding the loop variable and current array index.
     */
    LocalVariable getIndexVariable() { result = indexVariable }
  }

  abstract class Sink extends DataFlow::Node { }

  // for (..; .. sink.length; ...) ...
  private class LoopSink extends Sink {
    LoopSink() {
      exists(ArrayIterationLoop loop, Expr lengthAccess, DataFlow::PropRead lengthRead |
        loop.getTest().getAChild*() = lengthAccess and
        lengthRead.flowsToExpr(lengthAccess) and
        lengthRead.accesses(this, "length") and
        // In the DOS we are looking for arrayRead will evaluate to undefined.
        // If an obvious nullpointer happens on this undefined, then the DOS cannot happen.
        not exists(DataFlow::PropRead arrayRead, Expr throws |
          // It doesn't only happen inside the for-loop, outside is also a sink (assuming it happens before).
          loop.getBody().getAChild*() = arrayRead.asExpr() and
          loop.getBody().getAChild*() = throws and
          arrayRead.getPropertyNameExpr() = loop.getIndexVariable().getAnAccess() and
          arrayRead.flowsToExpr(throws) and
          isCrashingWithNullValues(throws)
        ) and
        // The existance of some kind of early-exit usually indicates that the loop will stop early and no DOS happens.
        not exists(BreakStmt br | br.getTarget() = loop) and
        not exists(ReturnStmt ret |
          loop.getBody().getAChild*() = ret and
          ret.getContainer() = loop.getContainer()
        ) and
        not exists(ThrowStmt throw |
          loop.getBody().getAChild*() = throw and
          not loop.getBody().getAChild*() = throw.getTarget()
        )
      )
    }
  }

  predicate loopableLodashMethod(string name) {
    name = "chunk" or
    name = "compact" or
    name = "difference" or
    name = "differenceBy" or
    name = "differenceWith" or
    name = "drop" or
    name = "dropRight" or
    name = "dropRightWhile" or
    name = "dropWhile" or
    name = "fill" or
    name = "findIndex" or
    name = "findLastIndex" or
    name = "flatten" or
    name = "flattenDeep" or
    name = "flattenDepth" or
    name = "initial" or
    name = "intersection" or
    name = "intersectionBy" or
    name = "intersectionWith" or
    name = "join" or
    name = "remove" or
    name = "reverse" or
    name = "slice" or
    name = "sortedUniq" or
    name = "sortedUniqBy" or
    name = "tail" or
    name = "union" or
    name = "unionBy" or
    name = "unionWith" or
    name = "uniqBy" or
    name = "unzip" or
    name = "unzipWith" or
    name = "without" or
    name = "zip" or
    name = "zipObject" or
    name = "zipObjectDeep" or
    name = "zipWith" or
    name = "countBy" or
    name = "each" or
    name = "forEach" or
    name = "eachRight" or
    name = "forEachRight" or
    name = "filter" or
    name = "find" or
    name = "findLast" or
    name = "flatMap" or
    name = "flatMapDeep" or
    name = "flatMapDepth" or
    name = "forEach" or
    name = "forEachRight" or
    name = "groupBy" or
    name = "invokeMap" or
    name = "keyBy" or
    name = "map" or
    name = "orderBy" or
    name = "partition" or
    name = "reduce" or
    name = "reduceRight" or
    name = "reject" or
    name = "sortBy"
  }

  // _.each(sink);
  private class LodashIterationSink extends Sink {
    DataFlow::CallNode call;

    LodashIterationSink() {
      exists(string name |
        loopableLodashMethod(name) and
        call = any(LodashUnderscore::member(name)).getACall() and
        call.getArgument(0) = this and
        
        // Here it is just assumed that the array elements is the first parameter in the callback function.
        not exists(DataFlow::FunctionNode func, DataFlow::ParameterNode e |
          func.flowsTo(call.getAnArgument()) and
          e = func.getParameter(0) and
          (
            // Looking for obvious null-pointers happening on the array elements in the iteration.
            // Similar to what is done in the loop iteration sink.
            exists(Expr throws |
              throws = func.asExpr().(Function).getBody().getAChild*() and
              e.flowsToExpr(throws) and
              isCrashingWithNullValues(throws)
            )
            or
            // similar to the loop sink - the existance of an early-exit usually means that no DOS can happen.
            exists(ThrowStmt throw |
              throw = func.asExpr().(Function).getBody().getAChild*() and
              throw.getTarget() = func.asExpr()
            )
          )
        )
      )
    }
  }
  
  abstract class Source extends DataFlow::Node { }
  
  /**
   * A source of remote user input objects.
   */
  class TaintedObjectSource extends Source {
    TaintedObjectSource() { this instanceof TaintedObject::Source }
  }
  

  class IsArraySanitizerGuard extends TaintTracking::LabeledSanitizerGuardNode,
    DataFlow::ValueNode {
    override CallExpr astNode;

    IsArraySanitizerGuard() { astNode.getCalleeName() = "isArray" }

    override predicate sanitizes(boolean outcome, Expr e, DataFlow::FlowLabel label) {
      true = outcome and
      e = astNode.getAnArgument() and
      label = TaintedObject::label()
    }
  }

  class InstanceofArraySanitizerGuard extends TaintTracking::LabeledSanitizerGuardNode,
    DataFlow::ValueNode {
    override BinaryExpr astNode;

    InstanceofArraySanitizerGuard() {
      astNode.getOperator() = "instanceof" and
      astNode.getRightOperand().(Identifier).getName() = "Array"
    }

    override predicate sanitizes(boolean outcome, Expr e, DataFlow::FlowLabel label) {
      true = outcome and
      e = astNode.getLeftOperand() and
      label = TaintedObject::label()
    }
  }

  // Does two things:
  // 1) Detects any length-check that limits the size of the .length property.
  // 2) Makes sure that only the first loop that is DOS-prone is selected by the query. (due to the .length test having outcome=false when exiting the loop).
  class LengthCheckSanitizerGuard extends TaintTracking::LabeledSanitizerGuardNode,
    DataFlow::ValueNode {
    override RelationalComparison astNode;

    PropAccess propAccess;

    LengthCheckSanitizerGuard() {
      propAccess = astNode.getGreaterOperand().getAChild*() and
      propAccess.getPropertyName() = "length"
    }

    override predicate sanitizes(boolean outcome, Expr e, DataFlow::FlowLabel label) {
      false = outcome and
      astNode.getAChild*() = e and
      label = TaintedObject::label()
    }
  }
}
