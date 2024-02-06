import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
private import semmle.python.dataflow.new.internal.FlowSummaryImpl as FlowSummaryImpl

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
      FlowSummaryImpl::Private::Steps::summaryThroughStepTaint(nodeFrom, nodeTo, _)
    then result = "taint"
    else result = "no"
}

bindingset[parameter]
string madSummary(
  DataFlow::Node argument, string parameter, Function function, DataFlow::Node outNode
) {
  exists(string package, string functionPath, string argumentPath, string returnPath, string mode |
    (
      exists(string moduleName |
        package = function.getScope().getName().splitAt(".", 0) and
        moduleName = function.getScope().getName().splitAt(".", 1) and
        if moduleName = "__init__"
        then functionPath = "Member[" + function.getName() + "]"
        else functionPath = "Member[" + moduleName + "].Member[" + function.getName() + "]"
      )
      or
      not exists(function.getScope().getName().splitAt(".", 1)) and
      package = function.getScope().getName() and
      functionPath = "Member[" + function.getName() + "]"
    ) and
    (
      exists(int index |
        parameter = function.getArg(index).getName() and
        argumentPath = "Argument[" + index.toString() + "]"
      )
      or
      exists(function.getArgByName(parameter)) and
      argumentPath = "Argument[" + parameter + ":]"
      or
      not exists(int index | parameter = function.getArg(index).getName()) and
      not exists(function.getArgByName(parameter)) and
      argumentPath = "Argument[?]"
    ) and
    (
      outNode.(DataFlow::CallCfgNode).getArg(_) = argument and
      returnPath = "ReturnValue"
      or
      outNode.(DataFlow::CallCfgNode).getArgByName(_) = argument and
      returnPath = "ReturnValue"
      or
      not outNode.(DataFlow::CallCfgNode).getArg(_) = argument and
      not outNode.(DataFlow::CallCfgNode).getArgByName(_) = argument and
      returnPath =
        argument.getLocation().toString() + ": " + argument.toString() + " -> " + outNode.toString()
    ) and
    mode = "taint"
  |
    result =
      "- [\"" + package + "\", \"" + functionPath + "\", \"" + argumentPath + "\", \"" + returnPath +
        "\", \"" + mode + "\"]"
  )
}

abstract class EntryPointsByQuery extends string {
  bindingset[this]
  EntryPointsByQuery() { any() }

  abstract predicate subpath(
    DataFlow::Node argument, DataFlow::ParameterNode parameter, DataFlow::Node outNode
  );

  predicate entryPoint(
    DataFlow::Node argument, string parameterName, string functionName, DataFlow::Node outNode,
    string alreadyModelled, string madSummary
  ) {
    exists(DataFlow::ParameterNode parameter, Function function |
      parameterName = parameter.getParameter().getName() and
      functionName = function.getLocation().getFile().getShortName() + ":" + function.getName()
    |
      this.subpath(argument, parameter, outNode) and
      not inStdLib(argument) and
      inStdLib(parameter) and
      function = parameter.getScope() and
      alreadyModelled = stepsTo(argument, outNode) and
      (
        madSummary = madSummary(argument, parameterName, function, outNode)
        or
        not exists(madSummary(argument, parameterName, function, outNode)) and
        madSummary =
          argument.getLocation().getFile().getBaseName() + ":" + argument.toString() + " -> " +
            outNode.toString()
      )
    )
  }
}

// Not in a separate configuration file.
// module EntryPointsForHardcodedCredentialsQuery {
//     private import semmle.python.security.dataflow.HardcodedCredentialsQuery
//     module Flow = HardcodedCredentialsFlow;
//     private import Flow::PathGraph
//     private class EntryPointsForHardcodedCredentialsQuery extends EntryPointsByQuery {
//         EntryPointsForHardcodedCredentialsQuery() { this = "HardcodedCredentialsQuery" }
//         override predicate subpath(
//             DataFlow::Node argument, DataFlow::ParameterNode parameter, DataFlow::Node outNode
//         ) {
//             exists(Flow::PathNode arg, Flow::PathNode par, Flow::PathNode out |
//                 subpaths(arg, par, _, out)
//             |
//                 argument = arg.getNode() and
//                 parameter = par.getNode() and
//                 outNode = out.getNode()
//             )
//         }
//     }
// }
//
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

module EntryPointsForCleartextLoggingQuery {
  private import semmle.python.security.dataflow.CleartextLoggingQuery

  module Flow = CleartextLoggingFlow;

  private import Flow::PathGraph

  private class EntryPointsForCleartextLoggingQuery extends EntryPointsByQuery {
    EntryPointsForCleartextLoggingQuery() { this = "CleartextLoggingQuery" }

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

module EntryPointsForSqlInjectionQuery {
  private import semmle.python.security.dataflow.SqlInjectionQuery

  module Flow = SqlInjectionFlow;

  private import Flow::PathGraph

  private class EntryPointsForSqlInjectionQuery extends EntryPointsByQuery {
    EntryPointsForSqlInjectionQuery() { this = "SqlInjectionQuery" }

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

module EntryPointsForWeakSensitiveDataHashingQuery {
  private import semmle.python.security.dataflow.WeakSensitiveDataHashingQuery

  module Flow = WeakSensitiveDataHashingFlow;

  private import Flow::PathGraph

  private class EntryPointsForWeakSensitiveDataHashingQuery extends EntryPointsByQuery {
    EntryPointsForWeakSensitiveDataHashingQuery() { this = "WeakSensitiveDataHashingQuery" }

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

module EntryPointsForUrlRedirectQuery {
  private import semmle.python.security.dataflow.UrlRedirectQuery

  module Flow = UrlRedirectFlow;

  private import Flow::PathGraph

  private class EntryPointsForUrlRedirectQuery extends EntryPointsByQuery {
    EntryPointsForUrlRedirectQuery() { this = "UrlRedirectQuery" }

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

module EntryPointsForPathInjectionQuery {
  private import semmle.python.security.dataflow.PathInjectionQuery

  module Flow = PathInjectionFlow;

  private import Flow::PathGraph

  private class EntryPointsForPathInjectionQuery extends EntryPointsByQuery {
    EntryPointsForPathInjectionQuery() { this = "PathInjectionQuery" }

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

module EntryPointsForPartialServerSideRequestForgeryQuery {
  private import semmle.python.security.dataflow.ServerSideRequestForgeryQuery

  module Flow = PartialServerSideRequestForgeryFlow;

  private import Flow::PathGraph

  private class EntryPointsForPartialServerSideRequestForgeryQuery extends EntryPointsByQuery {
    EntryPointsForPartialServerSideRequestForgeryQuery() {
      this = "PartialServerSideRequestForgeryQuery"
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

module EntryPointsForCleartextStorageQuery {
  private import semmle.python.security.dataflow.CleartextStorageQuery

  module Flow = CleartextStorageFlow;

  private import Flow::PathGraph

  private class EntryPointsForCleartextStorageQuery extends EntryPointsByQuery {
    EntryPointsForCleartextStorageQuery() { this = "CleartextStorageQuery" }

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

module EntryPointsForStackTraceExposureQuery {
  private import semmle.python.security.dataflow.StackTraceExposureQuery

  module Flow = StackTraceExposureFlow;

  private import Flow::PathGraph

  private class EntryPointsForStackTraceExposureQuery extends EntryPointsByQuery {
    EntryPointsForStackTraceExposureQuery() { this = "StackTraceExposureQuery" }

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

module EntryPointsForReflectedXssQuery {
  private import semmle.python.security.dataflow.ReflectedXssQuery

  module Flow = ReflectedXssFlow;

  private import Flow::PathGraph

  private class EntryPointsForReflectedXssQuery extends EntryPointsByQuery {
    EntryPointsForReflectedXssQuery() { this = "ReflectedXssQuery" }

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

// Not a flow query
// module EntryPointsForWeakFilePermissionsQuery {
//   private import semmle.python.security.dataflow.WeakFilePermissionsQuery
//   module Flow = WeakFilePermissionsFlow;
//   private import Flow::PathGraph
//   private class EntryPointsForWeakFilePermissionsQuery extends EntryPointsByQuery {
//     EntryPointsForWeakFilePermissionsQuery() { this = "WeakFilePermissionsQuery" }
//     override predicate subpath(
//       DataFlow::Node argument, DataFlow::ParameterNode parameter, DataFlow::Node outNode
//     ) {
//       exists(Flow::PathNode arg, Flow::PathNode par, Flow::PathNode out |
//         subpaths(arg, par, _, out)
//       |
//         argument = arg.getNode() and
//         parameter = par.getNode() and
//         outNode = out.getNode()
//       )
//     }
//   }
// }
//
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

module EntryPointsForUnsafeDeserializationQuery {
  private import semmle.python.security.dataflow.UnsafeDeserializationQuery

  module Flow = UnsafeDeserializationFlow;

  private import Flow::PathGraph

  private class EntryPointsForUnsafeDeserializationQuery extends EntryPointsByQuery {
    EntryPointsForUnsafeDeserializationQuery() { this = "UnsafeDeserializationQuery" }

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

module EntryPointsForLogInjectionQuery {
  private import semmle.python.security.dataflow.LogInjectionQuery

  module Flow = LogInjectionFlow;

  private import Flow::PathGraph

  private class EntryPointsForLogInjectionQuery extends EntryPointsByQuery {
    EntryPointsForLogInjectionQuery() { this = "LogInjectionQuery" }

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

module EntryPointsForFullServerSideRequestForgeryQuery {
  private import semmle.python.security.dataflow.ServerSideRequestForgeryQuery

  module Flow = FullServerSideRequestForgeryFlow;

  private import Flow::PathGraph

  private class EntryPointsForFullServerSideRequestForgeryQuery extends EntryPointsByQuery {
    EntryPointsForFullServerSideRequestForgeryQuery() { this = "FullServerSideRequestForgeryQuery" }

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

// Not a flow query
// module EntryPointsForIncompleteHostnameRegExpQuery {
//   private import semmle.python.security.regexp.HostnameRegex
//   module Flow = IncompleteHostnameRegExpFlow;
//   private import Flow::PathGraph
//   private class EntryPointsForIncompleteHostnameRegExpQuery extends EntryPointsByQuery {
//     EntryPointsForIncompleteHostnameRegExpQuery() { this = "IncompleteHostnameRegExpQuery" }
//     override predicate subpath(
//       DataFlow::Node argument, DataFlow::ParameterNode parameter, DataFlow::Node outNode
//     ) {
//       exists(Flow::PathNode arg, Flow::PathNode par, Flow::PathNode out |
//         subpaths(arg, par, _, out)
//       |
//         argument = arg.getNode() and
//         parameter = par.getNode() and
//         outNode = out.getNode()
//       )
//     }
//   }
// }
//
module EntryPointsForCommandInjectionQuery {
  private import semmle.python.security.dataflow.CommandInjectionQuery

  module Flow = CommandInjectionFlow;

  private import Flow::PathGraph

  private class EntryPointsForCommandInjectionQuery extends EntryPointsByQuery {
    EntryPointsForCommandInjectionQuery() { this = "CommandInjectionQuery" }

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

// Not a path query
// module EntryPointsForBindToAllInterfacesQuery {
//   private import semmle.python.security.dataflow.BindToAllInterfacesQuery
//   module Flow = BindToAllInterfacesFlow;
//   private import Flow::PathGraph
//   private class EntryPointsForBindToAllInterfacesQuery extends EntryPointsByQuery {
//     EntryPointsForBindToAllInterfacesQuery() { this = "BindToAllInterfacesQuery" }
//     override predicate subpath(
//       DataFlow::Node argument, DataFlow::ParameterNode parameter, DataFlow::Node outNode
//     ) {
//       exists(Flow::PathNode arg, Flow::PathNode par, Flow::PathNode out |
//         subpaths(arg, par, _, out)
//       |
//         argument = arg.getNode() and
//         parameter = par.getNode() and
//         outNode = out.getNode()
//       )
//     }
//   }
// }
//
from
  EntryPointsByQuery e, DataFlow::Node argument, string parameter, string functionName,
  DataFlow::Node outNode, string alreadyModelled, string madSummary
where
  e.entryPoint(argument, parameter, functionName, outNode, alreadyModelled, madSummary) and
  alreadyModelled = "no"
// select e, parameter, functionName, madSummary
select parameter, functionName, madSummary
