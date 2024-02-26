import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
private import semmle.python.dataflow.new.internal.FlowSummaryImpl as FlowSummaryImpl
private import semmle.python.dataflow.new.internal.ImportResolution

// predicate debug(
//   DataFlow::Node nodeFrom, DataFlow::Node nodeTo, FlowSummaryImpl::Public::SummarizedCallable sc
// ) {
//   FlowSummaryImpl::Private::Steps::summaryThroughStepTaint(nodeFrom, nodeTo, sc)
// }
// string fullyQualifiedName(DataFlow::Node def) {
//   exists(Module mod, string relevantName | ImportResolution::module_export(mod, relevantName, def) |
//     mod.isPackageInit() and
//     result = mod.getPackageName() + "." + relevantName
//     or
//     not mod.isPackageInit() and
//     result = mod.getName() + "." + relevantName
//   )
// }
pragma[inline]
predicate inStdLib(DataFlow::Node node) { node.getLocation().getFile().inStdlib() }

pragma[inline]
string stepsTo(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  if
    DataFlow::localFlow(nodeFrom, nodeTo)
    or
    FlowSummaryImpl::Private::Steps::summaryThroughStepValue(nodeFrom, nodeTo, _)
    or
    FlowSummaryImpl::Private::Steps::summaryThroughStepValue(nodeFrom,
      nodeTo.(DataFlow::PostUpdateNode).getPreUpdateNode(), _)
  then result = "value"
  else
    if
      TaintTracking::localTaint(nodeFrom, nodeTo)
      or
      exists(TaintTracking::AdditionalTaintStep s | s.step(nodeFrom, nodeTo))
      or
      FlowSummaryImpl::Private::Steps::summaryThroughStepTaint(nodeFrom, nodeTo, _)
      or
      FlowSummaryImpl::Private::Steps::summaryThroughStepTaint(nodeFrom,
        nodeTo.(DataFlow::PostUpdateNode).getPreUpdateNode(), _)
    then result = "taint"
    else result = "no"
}

string computeScopePath(Scope scope) {
  // base case
  if scope instanceof Module
  then
    scope.(Module).isPackageInit() and
    result = scope.(Module).getPackageName()
    or
    not scope.(Module).isPackageInit() and
    result = scope.(Module).getName()
  else
    //recursive cases
    if scope instanceof Class
    then
      result = computeScopePath(scope.(Class).getEnclosingScope()) + "." + scope.(Class).getName()
    else
      if scope instanceof Function
      then
        result =
          computeScopePath(scope.(Function).getEnclosingScope()) + "." + scope.(Function).getName()
      else result = "unknown: " + scope.toString()
}

string computeFunctionName(Function function) { result = computeScopePath(function) }

bindingset[fullyQualified]
predicate fullyQualifiedToYamlFormat(string fullyQualified, string type2, string path) {
  exists(int firstDot | firstDot = fullyQualified.indexOf(".", 0, 0) |
    type2 = fullyQualified.prefix(firstDot) and
    path =
      ("Member[" + fullyQualified.suffix(firstDot + 1).replaceAll(".", "].Member[") + "]")
          .replaceAll(".Member[__init__].", "")
          .replaceAll("Member[__init__].", "")
  )
}

pragma[inline]
string computeArgumentPath(string parameter, Function function) {
  exists(int index |
    parameter = function.getArg(index).getName() and
    result = "Argument[" + index.toString() + "]"
  )
  or
  exists(function.getArgByName(parameter)) and
  result = "Argument[" + parameter + ":]"
}

bindingset[parameter, function]
pragma[inline]
string computeReturnPath(
  DataFlow::Node argument, string parameter, Function function, DataFlow::Node outNode
) {
  outNode.(DataFlow::CallCfgNode).getArg(_) = argument and
  result = "ReturnValue"
  or
  outNode.(DataFlow::CallCfgNode).getArgByName(_) = argument and
  result = "ReturnValue"
  or
  outNode.(DataFlow::PostUpdateNode).getPreUpdateNode() = argument and
  (
    result = computeArgumentPath(parameter, function)
    or
    not exists(computeArgumentPath(parameter, function)) and
    result = "Argument[?]"
  )
}

bindingset[parameter]
string madSummary(
  DataFlow::Node argument, string parameter, Function function, DataFlow::Node outNode
) {
  exists(string package, string functionPath, string argumentPath, string returnPath, string mode |
    fullyQualifiedToYamlFormat(computeFunctionName(function), package, functionPath) and
    (
      argumentPath = computeArgumentPath(parameter, function)
      or
      not exists(computeArgumentPath(parameter, function)) and
      argumentPath = "Argument[?]"
    ) and
    (
      returnPath = computeReturnPath(argument, parameter, function, outNode)
      or
      not exists(computeReturnPath(argument, parameter, function, outNode)) and
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
      functionName = computeFunctionName(function)
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
          argument.getLocation().toString() + ":" + argument.toString() + " -> " +
            outNode.toString()
      )
    )
  }
}

// Not in a separate configuration file.
// Code repeated here instead.
module EntryPointsForHardcodedCredentialsQuery {
  bindingset[char, fraction]
  predicate fewer_characters_than(StrConst str, string char, float fraction) {
    exists(string text, int chars |
      text = str.getText() and
      chars = count(int i | text.charAt(i) = char)
    |
      /* Allow one character */
      chars = 1 or
      chars < text.length() * fraction
    )
  }

  predicate possible_reflective_name(string name) {
    exists(any(ModuleValue m).attr(name))
    or
    exists(any(ClassValue c).lookup(name))
    or
    any(ClassValue c).getName() = name
    or
    exists(Module::named(name))
    or
    exists(Value::named(name))
  }

  int char_count(StrConst str) { result = count(string c | c = str.getText().charAt(_)) }

  predicate capitalized_word(StrConst str) { str.getText().regexpMatch("[A-Z][a-z]+") }

  predicate format_string(StrConst str) { str.getText().matches("%{%}%") }

  predicate maybeCredential(ControlFlowNode f) {
    /* A string that is not too short and unlikely to be text or an identifier. */
    exists(StrConst str | str = f.getNode() |
      /* At least 10 characters */
      str.getText().length() > 9 and
      /* Not too much whitespace */
      fewer_characters_than(str, " ", 0.05) and
      /* or underscores */
      fewer_characters_than(str, "_", 0.2) and
      /* Not too repetitive */
      exists(int chars | chars = char_count(str) |
        chars > 15 or
        chars * 3 > str.getText().length() * 2
      ) and
      not possible_reflective_name(str.getText()) and
      not capitalized_word(str) and
      not format_string(str)
    )
    or
    /* Or, an integer with over 32 bits */
    exists(IntegerLiteral lit | f.getNode() = lit |
      not exists(lit.getValue()) and
      /* Not a set of flags or round number */
      not lit.getN().matches("%00%")
    )
  }

  class HardcodedValueSource extends DataFlow::Node {
    HardcodedValueSource() { maybeCredential(this.asCfgNode()) }
  }

  class CredentialSink extends DataFlow::Node {
    CredentialSink() {
      exists(string name |
        name.regexpMatch(getACredentialRegex()) and
        not name.matches("%file")
      |
        any(FunctionValue func).getNamedArgumentForCall(_, name) = this.asCfgNode()
        or
        exists(Keyword k | k.getArg() = name and k.getValue().getAFlowNode() = this.asCfgNode())
        or
        exists(CompareNode cmp, NameNode n | n.getId() = name |
          cmp.operands(this.asCfgNode(), any(Eq eq), n)
          or
          cmp.operands(n, any(Eq eq), this.asCfgNode())
        )
      )
    }
  }

  /**
   * Gets a regular expression for matching names of locations (variables, parameters, keys) that
   * indicate the value being held is a credential.
   */
  private string getACredentialRegex() {
    result = "(?i).*pass(wd|word|code|phrase)(?!.*question).*" or
    result = "(?i).*(puid|username|userid).*" or
    result = "(?i).*(cert)(?!.*(format|name)).*"
  }

  private module HardcodedCredentialsConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof HardcodedValueSource }

    predicate isSink(DataFlow::Node sink) { sink instanceof CredentialSink }
  }

  module HardcodedCredentialsFlow = TaintTracking::Global<HardcodedCredentialsConfig>;

  module Flow = HardcodedCredentialsFlow;

  private import Flow::PathGraph

  private class EntryPointsForHardcodedCredentialsQuery extends EntryPointsByQuery {
    EntryPointsForHardcodedCredentialsQuery() { this = "HardcodedCredentialsQuery" }

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
// select e, functionName
select e, argument, parameter, functionName, outNode, madSummary
// select parameter, functionName, madSummary
