/**
 * @name Uncontrolled data used in path expression
 * @description Accessing paths influenced by users can allow an
 *              attacker to access unexpected resources.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id cpp/path-injection
 * @tags security
 *       external/cwe/cwe-022
 *       external/cwe/cwe-023
 *       external/cwe/cwe-036
 *       external/cwe/cwe-073
 */

import cpp
import semmle.code.cpp.security.FunctionWithWrappers
import semmle.code.cpp.security.Security
import semmle.code.cpp.ir.IR
import semmle.code.cpp.ir.dataflow.TaintTracking
import DataFlow::PathGraph

/**
 * A function for opening a file.
 */
class FileFunction extends FunctionWithWrappers {
  FileFunction() {
    exists(string nme | this.hasGlobalName(nme) |
      nme = ["fopen", "_fopen", "_wfopen", "open", "_open", "_wopen"]
      or
      // create file function on windows
      nme.matches("CreateFile%")
    )
    or
    this.hasQualifiedName("std", "fopen")
    or
    // on any of the fstream classes, or filebuf
    exists(string nme | this.getDeclaringType().hasQualifiedName("std", nme) |
      nme = ["basic_fstream", "basic_ifstream", "basic_ofstream", "basic_filebuf"]
    ) and
    // we look for either the open method or the constructor
    (this.getName() = "open" or this instanceof Constructor)
  }

  // conveniently, all of these functions take the path as the first parameter!
  override predicate interestingArg(int arg) { arg = 0 }
}

Expr asSourceExpr(DataFlow::Node node) {
  result = node.asConvertedExpr()
  or
  result = node.asDefiningArgument()
}

Expr asSinkExpr(DataFlow::Node node) {
  result =
    node.asOperand()
        .(SideEffectOperand)
        .getUse()
        .(ReadSideEffectInstruction)
        .getArgumentDef()
        .getUnconvertedResultExpression()
}

/**
 * Holds for a variable that has any kind of upper-bound check anywhere in the program.
 * This is biased towards being inclusive and being a coarse overapproximation because
 * there are a lot of valid ways of doing an upper bounds checks if we don't consider
 * where it occurs, for example:
 * ```cpp
 *   if (x < 10) { sink(x); }
 *
 *   if (10 > y) { sink(y); }
 *
 *   if (z > 10) { z = 10; }
 *   sink(z);
 * ```
 */
predicate hasUpperBoundsCheck(Variable var) {
  exists(RelationalOperation oper, VariableAccess access |
    oper.getAnOperand() = access and
    access.getTarget() = var and
    // Comparing to 0 is not an upper bound check
    not oper.getAnOperand().getValue() = "0"
  )
}

class TaintedPathConfiguration extends TaintTracking::Configuration {
  TaintedPathConfiguration() { this = "TaintedPathConfiguration" }

  override predicate isSource(DataFlow::Node node) { isUserInput(asSourceExpr(node), _) }

  override predicate isSink(DataFlow::Node node) {
    exists(FileFunction fileFunction |
      fileFunction.outermostWrapperFunctionCall(asSinkExpr(node), _)
    )
  }

  override predicate isSanitizerIn(DataFlow::Node node) { this.isSource(node) }

  override predicate isSanitizer(DataFlow::Node node) {
    node.asExpr().(Call).getTarget().getUnspecifiedType() instanceof ArithmeticType
    or
    exists(LoadInstruction load, Variable checkedVar |
      load = node.asInstruction() and
      checkedVar = load.getSourceAddress().(VariableAddressInstruction).getAstVariable() and
      hasUpperBoundsCheck(checkedVar)
    )
  }

  predicate hasFilteredFlowPath(DataFlow::PathNode source, DataFlow::PathNode sink) {
    this.hasFlowPath(source, sink) and
    not exists(DataFlow::PathNode source2 |
      this.hasFlowPath(source2, sink) and
      asSourceExpr(source.getNode()) = asSourceExpr(source2.getNode())
    |
      not exists(source.getNode().asConvertedExpr()) and exists(source2.getNode().asConvertedExpr())
    )
  }
}

from
  FileFunction fileFunction, Expr taintedArg, Expr taintSource, TaintedPathConfiguration cfg,
  DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode, string taintCause, string callChain
where
  taintedArg = asSinkExpr(sinkNode.getNode()) and
  fileFunction.outermostWrapperFunctionCall(taintedArg, callChain) and
  cfg.hasFilteredFlowPath(sourceNode, sinkNode) and
  taintSource = asSourceExpr(sourceNode.getNode()) and
  isUserInput(taintSource, taintCause)
select taintedArg, sourceNode, sinkNode,
  "This argument to a file access function is derived from $@ and then passed to " + callChain + ".",
  taintSource, "user input (" + taintCause + ")"
