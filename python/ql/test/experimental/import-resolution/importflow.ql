import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs
import TestUtilities.InlineExpectationsTest
import semmle.python.dataflow.new.internal.ImportResolution

/** A string that appears on the right hand side of an assignment. */
private class SourceString extends DataFlow::Node {
  string contents;

  SourceString() {
    this.asExpr().(StrConst).getText() = contents and
    this.asExpr().getParent() instanceof Assign
  }

  string getContents() { result = contents }
}

/** An argument that is checked using the `check` function. */
private class CheckArgument extends DataFlow::Node {
  CheckArgument() { this = API::moduleImport("trace").getMember("check").getACall().getArg(1) }
}

/** A data-flow node that is a reference to a module. */
private class ModuleRef extends DataFlow::Node {
  Module mod;

  ModuleRef() {
    this = ImportResolution::getModuleReference(mod) and
    not mod.getName() in ["__future__", "trace"]
  }

  string getName() { result = mod.getName() }
}

/**
 * A data-flow node that is guarded by a version check. Only supports checks of the form `if
 *sys.version_info[0] == ...` where the right hand side is either `2` or `3`.
 */
private class VersionGuardedNode extends DataFlow::Node {
  int version;

  VersionGuardedNode() {
    version in [2, 3] and
    exists(If parent, CompareNode c | parent.getBody().contains(this.asExpr()) |
      c.operands(API::moduleImport("sys")
            .getMember("version_info")
            .getASubscript()
            .asSource()
            .asCfgNode(), any(Eq eq),
        any(IntegerLiteral lit | lit.getValue() = version).getAFlowNode())
    )
  }

  int getVersion() { result = version }
}

private class ImportConfiguration extends DataFlow::Configuration {
  ImportConfiguration() { this = "ImportConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof SourceString }

  override predicate isSink(DataFlow::Node sink) {
    sink = API::moduleImport("trace").getMember("check").getACall().getArg(1)
  }
}

class ResolutionTest extends InlineExpectationsTest {
  ResolutionTest() { this = "ResolutionTest" }

  override string getARelevantTag() { result = "prints" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    (
      exists(DataFlow::PathNode source, DataFlow::PathNode sink, ImportConfiguration config |
        config.hasFlowPath(source, sink) and
        not sink.getNode() instanceof VersionGuardedNode and
        tag = "prints" and
        location = sink.getNode().getLocation() and
        value = source.getNode().(SourceString).getContents() and
        element = sink.getNode().toString()
      )
      or
      exists(ModuleRef ref |
        not ref instanceof VersionGuardedNode and
        ref instanceof CheckArgument and
        tag = "prints" and
        location = ref.getLocation() and
        value = "\"<module " + ref.getName() + ">\"" and
        element = ref.toString()
      )
    )
  }
}

private string getTagForVersion(int version) {
  result = "prints" + version and
  version = major_version()
}

class VersionSpecificResolutionTest extends InlineExpectationsTest {
  VersionSpecificResolutionTest() { this = "VersionSpecificResolutionTest" }

  override string getARelevantTag() { result = getTagForVersion(_) }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    (
      exists(DataFlow::PathNode source, DataFlow::PathNode sink, ImportConfiguration config |
        config.hasFlowPath(source, sink) and
        tag = getTagForVersion(sink.getNode().(VersionGuardedNode).getVersion()) and
        location = sink.getNode().getLocation() and
        value = source.getNode().(SourceString).getContents() and
        element = sink.getNode().toString()
      )
      or
      exists(ModuleRef ref |
        ref instanceof CheckArgument and
        tag = getTagForVersion(ref.(VersionGuardedNode).getVersion()) and
        location = ref.getLocation() and
        value = "\"<module " + ref.getName() + ">\"" and
        element = ref.toString()
      )
    )
  }
}
