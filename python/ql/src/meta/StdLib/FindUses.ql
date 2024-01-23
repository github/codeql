import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking

pragma[inline]
predicate inStdLib(DataFlow::Node node) { node.getLocation().getFile().inStdlib() }

pragma[inline]
string stepsTo(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  if DataFlow::localFlow(nodeFrom, nodeTo)
  then result = "local"
  else
    if
      TaintTracking::localTaint(nodeFrom, nodeTo)
      or
      exists(TaintTracking::AdditionalTaintStep s | s.step(nodeFrom, nodeTo))
      or
      // TODO: This is an attempt to recognize flow summary models, but it does not work.
      exists(
        TaintTracking::AdditionalTaintStep s, DataFlow::Node entryNode, DataFlow::Node exitNode
      |
        s.step(entryNode, exitNode)
      |
        TaintTracking::localTaint(nodeFrom, entryNode) and
        TaintTracking::localTaint(exitNode, nodeTo)
      )
    then result = "taint"
    else result = "no"
}

abstract class EntryPointsByQuery extends string {
  bindingset[this]
  EntryPointsByQuery() { any() }

  abstract predicate subpath(
    DataFlow::Node argument, DataFlow::ParameterNode parameter, DataFlow::Node outNode
  );

  predicate entryPoint(
    DataFlow::Node argument, string parameterName, string functionName, DataFlow::Node outNode,
    string alreadyModelled
  ) {
    exists(DataFlow::ParameterNode parameter, Function function |
      parameterName = parameter.getParameter().getName() and
      functionName = function.getLocation().getFile().getShortName() + ":" + function.getName()
    |
      this.subpath(argument, parameter, outNode) and
      not inStdLib(argument) and
      inStdLib(parameter) and
      function = parameter.getScope() and
      alreadyModelled = stepsTo(argument, outNode)
    )
  }
}

module EntryPointsForRegexInjectionQuery {
  private import semmle.python.security.dataflow.RegexInjectionQuery

  module Flow = RegexInjectionFlow;

  private import Flow::PathGraph

  private class EntryPointsForRegexInjectionQuery extends EntryPointsByQuery {
    EntryPointsForRegexInjectionQuery() { this = "RegexInjectionQuery" }

    override predicate subpath(
      DataFlow::Node argument, DataFlow::ParameterNode parameter, DataFlow::Node outNode
    ) {
      exists(Flow::PathNode arg, Flow::PathNode par, Flow::PathNode out |
        subpaths(arg, par, _, out)
      |
        argument = arg.getNode() and
        parameter = par.getNode() and
        outNode = out.getNode()
      )
    }
  }
}

module EntryPointsForUnsafeShellCommandConstructionQuery {
  private import semmle.python.security.dataflow.UnsafeShellCommandConstructionQuery

  module Flow = UnsafeShellCommandConstructionFlow;

  private import Flow::PathGraph

  private class EntryPointsForUnsafeShellCommandConstructionQuery extends EntryPointsByQuery {
    EntryPointsForUnsafeShellCommandConstructionQuery() {
      this = "UnsafeShellCommandConstructionQuery"
    }

    override predicate subpath(
      DataFlow::Node argument, DataFlow::ParameterNode parameter, DataFlow::Node outNode
    ) {
      exists(Flow::PathNode arg, Flow::PathNode par, Flow::PathNode out |
        subpaths(arg, par, _, out)
      |
        argument = arg.getNode() and
        parameter = par.getNode() and
        outNode = out.getNode()
      )
    }
  }
}

module EntryPointsForPolynomialReDoSQuery {
  private import semmle.python.security.dataflow.PolynomialReDoSQuery

  module Flow = PolynomialReDoSFlow;

  private import Flow::PathGraph

  private class EntryPointsForPolynomialReDoSQuery extends EntryPointsByQuery {
    EntryPointsForPolynomialReDoSQuery() { this = "PolynomialReDoSQuery" }

    override predicate subpath(
      DataFlow::Node argument, DataFlow::ParameterNode parameter, DataFlow::Node outNode
    ) {
      exists(Flow::PathNode arg, Flow::PathNode par, Flow::PathNode out |
        subpaths(arg, par, _, out)
      |
        argument = arg.getNode() and
        parameter = par.getNode() and
        outNode = out.getNode()
      )
    }
  }
}

from
  EntryPointsByQuery e, DataFlow::Node argument, string parameter, string functionName,
  DataFlow::Node outNode, string alreadyModelled
where
  e.entryPoint(argument, parameter, functionName, outNode, alreadyModelled) and
  alreadyModelled = "no"
// select e, argument, parameter, functionName, outNode, alreadyModelled
select e, parameter, functionName, alreadyModelled
