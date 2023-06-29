import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.TaintTracking

module DjangoConstantSecretKeyConfig {
  /**
   * Sources are Constants that without any Tainting reach the Sinks.
   * Also Sources can be the default value of getenv or similar methods
   * in a case that no value is assigned to Desired SECRET_KEY environment variable
   */
  predicate isSource(DataFlow::Node source) {
    (
      source.asExpr().isConstant()
      or
      exists(API::Node cn |
        cn =
          [
            API::moduleImport("configparser")
                .getMember(["ConfigParser", "RawConfigParser"])
                .getReturn(),
            // legacy API https://docs.python.org/3/library/configparser.html#legacy-api-examples
            API::moduleImport("configparser")
                .getMember(["ConfigParser", "RawConfigParser"])
                .getReturn()
                .getMember("get")
                .getReturn()
          ] and
        source = cn.asSource()
      )
      or
      exists(API::CallNode cn |
        cn =
          [
            API::moduleImport("os").getMember("getenv").getACall(),
            API::moduleImport("os").getMember("environ").getMember("get").getACall()
          ] and
        (
          // this can be ideal if we assume that best security practice is that
          // we don't get SECRET_KEY from env and we always assign a secure generated random string to it
          cn.getNumArgument() = 1
          or
          cn.getNumArgument() = 2 and
          DataFlow::localFlow(any(DataFlow::Node n | n.asExpr().isConstant()), cn.getArg(1))
        ) and
        source.asExpr() = cn.asExpr()
      )
      or
      source.asExpr() =
        API::moduleImport("os").getMember("environ").getASubscript().asSource().asExpr()
    ) and
    // followings will sanitize the get_random_secret_key of django.core.management.utils and similar random generators which we have their source code and some of them can be tracking by taint tracking because they are initilized by a constant!
    exists(source.getScope().getLocation().getFile().getRelativePath()) and
    // special case for get_random_secret_key
    not source.getScope().getLocation().getFile().getBaseName() = "crypto.py"
  }

  /**
   * A sink like following SECRET_KEY Assignments
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
      exists(API::Node n, DataFlow::AttrWrite attr |
        attr.getObject().getALocalSource() = n.asSource() and
        attr.getAttributeName() = ["SECRET_KEY_FALLBACKS", "SECRET_KEY"] and
        sink = attr.getValue()
      )
    ) and
    exists(sink.getScope().getLocation().getFile().getRelativePath())
  }
}
