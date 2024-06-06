/**
 * @name Arbitrary file write during tarfile extraction
 * @description Extracting files from a malicious tar archive without validating that the
 *              destination file path is within the destination directory can cause files outside
 *              the destination directory to be overwritten.
 * @kind path-problem
 * @id py/tarslip-extended
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @tags security
 *       experimental
 *       external/cwe/cwe-022
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import TarSlipImprovFlow::PathGraph
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.internal.Attributes
import semmle.python.dataflow.new.BarrierGuards
import semmle.python.dataflow.new.RemoteFlowSources

/**
 * Handle those three cases of Tarfile opens:
 *  - `tarfile.open()`
 *  - `tarfile.TarFile()`
 *  - `MKtarfile.Tarfile.open()`
 */
API::Node tarfileOpen() {
  result in [
      API::moduleImport("tarfile").getMember(["open", "TarFile"]),
      API::moduleImport("tarfile").getMember("TarFile").getASubclass().getMember("open")
    ]
}

/**
 * Handle the previous three cases, plus the use of `closing` in the previous cases
 */
class AllTarfileOpens extends API::CallNode {
  AllTarfileOpens() {
    this = tarfileOpen().getACall()
    or
    exists(API::Node closing, Node arg |
      closing = API::moduleImport("contextlib").getMember("closing") and
      this = closing.getACall() and
      arg = this.getArg(0) and
      arg = tarfileOpen().getACall()
    )
  }
}

/**
 * A taint-tracking configuration for detecting more "TarSlip" vulnerabilities.
 */
private module TarSlipImprovConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source = tarfileOpen().getACall() }

  predicate isSink(DataFlow::Node sink) {
    (
      // A sink capturing method calls to `extractall` without `members` argument.
      // For a call to `file.extractall` without `members` argument, `file` is considered a sink.
      exists(MethodCallNode call, AllTarfileOpens atfo |
        call = atfo.getReturn().getMember("extractall").getACall() and
        not exists(Node arg | arg = call.getArgByName("members")) and
        sink = call.getObject()
      )
      or
      // A sink capturing method calls to `extractall` with `members` argument.
      // For a call to `file.extractall` with `members` argument, `file` is considered a sink if not
      // a the `members` argument contains a NameConstant as None, a List or call to the method `getmembers`.
      // Otherwise, the argument of `members` is considered a sink.
      exists(MethodCallNode call, Node arg, AllTarfileOpens atfo |
        call = atfo.getReturn().getMember("extractall").getACall() and
        arg = call.getArgByName("members") and
        if
          arg.asCfgNode() instanceof NameConstantNode or
          arg.asCfgNode() instanceof ListNode
        then sink = call.getObject()
        else
          if arg.(MethodCallNode).getMethodName() = "getmembers"
          then sink = arg.(MethodCallNode).getObject()
          else sink = call.getArgByName("members")
      )
      or
      // An argument to `extract` is considered a sink.
      exists(AllTarfileOpens atfo |
        sink = atfo.getReturn().getMember("extract").getACall().getArg(0)
      )
      or
      //An argument to `_extract_member` is considered a sink.
      exists(MethodCallNode call, AllTarfileOpens atfo |
        call = atfo.getReturn().getMember("_extract_member").getACall() and
        call.getArg(1).(AttrRead).accesses(sink, "name")
      )
    ) and
    not sink.getScope().getLocation().getFile().inStdlib()
  }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    nodeTo.(MethodCallNode).calls(nodeFrom, "getmembers") and
    nodeFrom instanceof AllTarfileOpens
    or
    // To handle the case of `with closing(tarfile.open()) as file:`
    // we add a step from the first argument of `closing` to the call to `closing`,
    // whenever that first argument is a return of `tarfile.open()`.
    nodeTo = API::moduleImport("contextlib").getMember("closing").getACall() and
    nodeFrom = nodeTo.(API::CallNode).getArg(0) and
    nodeFrom = tarfileOpen().getReturn().getAValueReachableFromSource()
  }
}

/** Global taint-tracking for detecting more "TarSlip" vulnerabilities. */
module TarSlipImprovFlow = TaintTracking::Global<TarSlipImprovConfig>;

from TarSlipImprovFlow::PathNode source, TarSlipImprovFlow::PathNode sink
where TarSlipImprovFlow::flowPath(source, sink)
select sink, source, sink, "Extraction of tarfile from $@ to a potentially untrusted source $@.",
  source.getNode(), source.getNode().toString(), sink.getNode(), sink.getNode().toString()
