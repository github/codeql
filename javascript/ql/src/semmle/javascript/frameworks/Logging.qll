/**
 * Provides classes for working with logging libraries.
 */

import javascript

/**
 * A call to a logging mechanism.
 */
abstract class LoggerCall extends DataFlow::CallNode {
  /**
   * Gets a node that contributes to the logged message.
   */
  abstract DataFlow::Node getAMessageComponent();
}

/**
 * Gets a log level name that is used in RFC5424, `npm`, `console`.
 */
string getAStandardLoggerMethodName() {
  result = "crit" or
  result = "dir" or
  result = "debug" or
  result = "error" or
  result = "emerg" or
  result = "fatal" or
  result = "info" or
  result = "log" or
  result = "notice" or
  result = "silly" or
  result = "trace" or
  result = "verbose" or
  result = "warn"
}

/**
 * Provides classes for working the builtin Node.js/Browser `console`.
 */
private module Console {
  /**
   * Gets a data flow source node for the console library.
   */
  private DataFlow::SourceNode console() {
    result = DataFlow::moduleImport("console") or
    result = DataFlow::globalVarRef("console")
  }

  /**
   * A call to the console logging mechanism.
   */
  class ConsoleLoggerCall extends LoggerCall {
    string name;

    ConsoleLoggerCall() {
      (
        name = getAStandardLoggerMethodName() or
        name = "assert"
      ) and
      this = console().getAMemberCall(name)
    }

    override DataFlow::Node getAMessageComponent() {
      (
        if name = "assert"
        then result = getArgument([1 .. getNumArgument()])
        else result = getAnArgument()
      )
      or
      result = getASpreadArgument()
    }

    /**
     * Gets the name of the console logging method, e.g. "log", "error", "assert", etc.
     */
    string getName() { result = name }
  }
}

/**
 * Provides classes for working with [loglevel](https://github.com/pimterry/loglevel).
 */
private module Loglevel {
  /**
   * A call to the loglevel logging mechanism.
   */
  class LoglevelLoggerCall extends LoggerCall {
    LoglevelLoggerCall() {
      this = DataFlow::moduleMember("loglevel", getAStandardLoggerMethodName()).getACall()
    }

    override DataFlow::Node getAMessageComponent() { result = getAnArgument() }
  }
}

/**
 * Provides classes for working with [winston](https://github.com/winstonjs/winston).
 */
private module Winston {
  /**
   * A call to the winston logging mechanism.
   */
  class WinstonLoggerCall extends LoggerCall, DataFlow::MethodCallNode {
    WinstonLoggerCall() {
      this =
        DataFlow::moduleMember("winston", "createLogger")
            .getACall()
            .getAMethodCall(getAStandardLoggerMethodName())
    }

    override DataFlow::Node getAMessageComponent() {
      if getMethodName() = "log"
      then result = getOptionArgument(0, "message")
      else result = getAnArgument()
    }
  }
}

/**
 * Provides classes for working with [log4js](https://github.com/log4js-node/log4js-node).
 */
private module log4js {
  /**
   * A call to the log4js logging mechanism.
   */
  class Log4jsLoggerCall extends LoggerCall {
    Log4jsLoggerCall() {
      this =
        DataFlow::moduleMember("log4js", "getLogger")
            .getACall()
            .getAMethodCall(getAStandardLoggerMethodName())
    }

    override DataFlow::Node getAMessageComponent() { result = getAnArgument() }
  }
}

/**
 * Provides classes for working with [npmlog](https://github.com/npm/npmlog)
 */
private module Npmlog {
  /**
   * A call to the npmlog logging mechanism.
   */
  class Npmlog extends LoggerCall {
    string name;

    Npmlog() {
      this = DataFlow::moduleMember("npmlog", name).getACall() and
      name = getAStandardLoggerMethodName()
    }

    override DataFlow::Node getAMessageComponent() {
      (
        if name = "log"
        then result = getArgument([1 .. getNumArgument()])
        else result = getAnArgument()
      )
      or
      result = getASpreadArgument()
    }
  }
}

/**
 * Provides classes for working with [fancy-log](https://github.com/gulpjs/fancy-log).
 */
private module Fancylog {
  /**
   * A call to the fancy-log logging mechanism.
   */
  class Fancylog extends LoggerCall {
    Fancylog() {
      this = DataFlow::moduleMember("fancy-log", getAStandardLoggerMethodName()).getACall() or
      this = DataFlow::moduleImport("fancy-log").getACall()
    }

    override DataFlow::Node getAMessageComponent() { result = getAnArgument() }
  }
}
