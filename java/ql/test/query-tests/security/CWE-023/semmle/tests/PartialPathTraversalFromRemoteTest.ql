import java
import TestUtilities.InlineFlowTest
import semmle.code.java.security.PartialPathTraversalQuery

class EnableLegacy extends EnableLegacyConfiguration {
  EnableLegacy() { exists(this) }
}

class TestRemoteSource extends RemoteFlowSource {
  TestRemoteSource() { this.asParameter().hasName(["dir", "path"]) }

  override string getSourceType() { result = "TestSource" }
}

class Test extends InlineFlowTest {
  override DataFlow::Configuration getValueFlowConfig() { none() }

  override TaintTracking::Configuration getTaintFlowConfig() {
    result instanceof PartialPathTraversalFromRemoteConfig
  }
}
