import java
import semmle.code.java.security.PathSanitizer
import TestUtilities.InlineFlowTest

class EnableLegacy extends EnableLegacyConfiguration {
  EnableLegacy() { exists(this) }
}

class PathSanitizerConf extends DefaultTaintFlowConf {
  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof PathInjectionSanitizer
  }
}

class Test extends InlineFlowTest {
  override DataFlow::Configuration getValueFlowConfig() { none() }

  override DataFlow::Configuration getTaintFlowConfig() { result = any(PathSanitizerConf config) }
}
