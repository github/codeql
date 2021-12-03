/**
 * Provides classes modeling security-relevant aspects of the log libraries.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.dataflow.new.RemoteFlowSources
private import experimental.semmle.python.Concepts
private import semmle.python.frameworks.Flask
private import semmle.python.ApiGraphs

/**
 * Provides models for Python's log-related libraries.
 */
private module log {
  /**
   * Log output method list.
   *
   * See https://docs.python.org/3/library/logging.html#logger-objects
   */
  private class LogOutputMethods extends string {
    LogOutputMethods() {
      this in ["info", "error", "warn", "warning", "debug", "critical", "exception", "log"]
    }
  }

  /**
   * The class used to find the log output method of the `logging` module.
   *
   * See `LogOutputMethods`
   */
  private class LoggingCall extends DataFlow::CallCfgNode, LogOutput::Range {
    LoggingCall() {
      this = API::moduleImport("logging").getMember(any(LogOutputMethods m)).getACall()
    }

    override DataFlow::Node getAnInput() {
      this.getFunction().(DataFlow::AttrRead).getAttributeName() != "log" and
      result in [this.getArg(_), this.getArgByName(_)] // this includes the arg named "msg"
      or
      this.getFunction().(DataFlow::AttrRead).getAttributeName() = "log" and
      result in [this.getArg(any(int i | i > 0)), this.getArgByName(any(string s | s != "level"))]
    }
  }

  /**
   * The class used to find log output methods related to the `logging.getLogger` instance.
   *
   * See `LogOutputMethods`
   */
  private class LoggerCall extends DataFlow::CallCfgNode, LogOutput::Range {
    LoggerCall() {
      this =
        API::moduleImport("logging")
            .getMember("getLogger")
            .getReturn()
            .getMember(any(LogOutputMethods m))
            .getACall()
    }

    override DataFlow::Node getAnInput() {
      this.getFunction().(DataFlow::AttrRead).getAttributeName() != "log" and
      result in [this.getArg(_), this.getArgByName(_)] // this includes the arg named "msg"
      or
      this.getFunction().(DataFlow::AttrRead).getAttributeName() = "log" and
      result in [this.getArg(any(int i | i > 0)), this.getArgByName(any(string s | s != "level"))]
    }
  }

  /**
   * The class used to find the relevant log output method of the `flask.Flask.logger` instance (flask application).
   *
   * See `LogOutputMethods`
   */
  private class FlaskLoggingCall extends DataFlow::CallCfgNode, LogOutput::Range {
    FlaskLoggingCall() {
      this =
        Flask::FlaskApp::instance()
            .getMember("logger")
            .getMember(any(LogOutputMethods m))
            .getACall()
    }

    override DataFlow::Node getAnInput() {
      this.getFunction().(DataFlow::AttrRead).getAttributeName() != "log" and
      result in [this.getArg(_), this.getArgByName(_)] // this includes the arg named "msg"
      or
      this.getFunction().(DataFlow::AttrRead).getAttributeName() = "log" and
      result in [this.getArg(any(int i | i > 0)), this.getArgByName(any(string s | s != "level"))]
    }
  }

  /**
   * The class used to find the relevant log output method of the `django.utils.log.request_logger` instance (django application).
   *
   * See `LogOutputMethods`
   */
  private class DjangoLoggingCall extends DataFlow::CallCfgNode, LogOutput::Range {
    DjangoLoggingCall() {
      this =
        API::moduleImport("django")
            .getMember("utils")
            .getMember("log")
            .getMember("request_logger")
            .getMember(any(LogOutputMethods m))
            .getACall()
    }

    override DataFlow::Node getAnInput() {
      this.getFunction().(DataFlow::AttrRead).getAttributeName() != "log" and
      result in [this.getArg(_), this.getArgByName(_)] // this includes the arg named "msg"
      or
      this.getFunction().(DataFlow::AttrRead).getAttributeName() = "log" and
      result in [this.getArg(any(int i | i > 0)), this.getArgByName(any(string s | s != "level"))]
    }
  }
}
