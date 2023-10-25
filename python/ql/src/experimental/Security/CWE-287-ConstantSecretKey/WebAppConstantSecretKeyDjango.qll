import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.TaintTracking
import WebAppConstantSecretKeySource

module DjangoConstantSecretKeyConfig {
  /**
   * Sources are Constants that without any Tainting reach the Sinks.
   * Also Sources can be the default value of getenv or similar methods
   * in a case that no value is assigned to Desired SECRET_KEY environment variable
   */
  predicate isSource(DataFlow::Node source) { source instanceof WebAppConstantSecretKeySource }

  /**
   * Holds if There is a sink like following SECRET_KEY Assignments
   * ```python
   *from django.conf import settings
   *settings.configure(
   *    SECRET_KEY="constant",
   *)
   * # or
   *settings.SECRET_KEY = "constant"
   * ```
   */
  predicate isSink(DataFlow::Node sink) {
    exists(API::moduleImport("django")) and
    (
      exists(AssignStmt e | e.getTarget(0).(Name).getId() = ["SECRET_KEY", "SECRET_KEY_FALLBACKS"] |
        sink.asExpr() = e.getValue()
      )
      or
      exists(API::Node settings |
        settings =
          API::moduleImport("django").getMember("conf").getMember(["global_settings", "settings"]) and
        sink =
          settings
              .getMember("configure")
              .getKeywordParameter(["SECRET_KEY_FALLBACKS", "SECRET_KEY"])
              .asSink()
      )
      or
      exists(DataFlow::AttrWrite attr |
        attr.getAttributeName() = ["SECRET_KEY_FALLBACKS", "SECRET_KEY"] and
        sink = attr.getValue()
      )
    ) and
    exists(sink.getScope().getLocation().getFile().getRelativePath()) and
    not sink.getScope().getLocation().getFile().inStdlib()
  }
}
