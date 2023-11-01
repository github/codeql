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
  result =
    [
      "crit", "dir", "trace", "verbose", "warn", "debug", "error", "emerg", "fatal", "info", "log",
      "notice", "silly"
    ]
}

/**
 * Provides classes for working the builtin Node.js/Browser `console`.
 */
private module Console {
  /**
   * An API entrypoint for the global `console` variable.
   */
  private class ConsoleGlobalEntry extends API::EntryPoint {
    ConsoleGlobalEntry() { this = "ConsoleGlobalEntry" }

    override DataFlow::SourceNode getASource() { result = DataFlow::globalVarRef("console") }
  }

  /**
   * Gets a api node for the console library.
   */
  private API::Node console() {
    result = API::moduleImport("console") or
    result = any(ConsoleGlobalEntry e).getANode()
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
      this = console().getMember(name).getACall()
    }

    override DataFlow::Node getAMessageComponent() {
      (
        if name = "assert"
        then result = this.getArgument([1 .. this.getNumArgument()])
        else result = this.getAnArgument()
      )
      or
      result = this.getASpreadArgument()
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
      this = API::moduleImport("loglevel").getMember(getAStandardLoggerMethodName()).getACall()
    }

    override DataFlow::Node getAMessageComponent() { result = this.getAnArgument() }
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
        API::moduleImport("winston")
            .getMember("createLogger")
            .getReturn()
            .getMember(getAStandardLoggerMethodName())
            .getACall()
    }

    override DataFlow::Node getAMessageComponent() {
      if this.getMethodName() = "log"
      then result = this.getOptionArgument(0, "message")
      else result = this.getAnArgument()
    }
  }
}

/**
 * Provides classes for working with [log4js](https://github.com/log4js-node/log4js-node).
 */
private module Log4js {
  /**
   * A call to the log4js logging mechanism.
   */
  class Log4jsLoggerCall extends LoggerCall {
    Log4jsLoggerCall() {
      this =
        API::moduleImport("log4js")
            .getMember("getLogger")
            .getReturn()
            .getMember(getAStandardLoggerMethodName())
            .getACall()
    }

    override DataFlow::Node getAMessageComponent() { result = this.getAnArgument() }
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
      this = API::moduleImport("npmlog").getMember(name).getACall() and
      name = getAStandardLoggerMethodName()
    }

    override DataFlow::Node getAMessageComponent() {
      (
        if name = "log"
        then result = this.getArgument([1 .. this.getNumArgument()])
        else result = this.getAnArgument()
      )
      or
      result = this.getASpreadArgument()
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
      this = API::moduleImport("fancy-log").getMember(getAStandardLoggerMethodName()).getACall() or
      this = API::moduleImport("fancy-log").getACall()
    }

    override DataFlow::Node getAMessageComponent() { result = this.getAnArgument() }
  }
}

/**
 * A class modeling [debug](https://npmjs.org/package/debug) as a logging mechanism.
 */
private class DebugLoggerCall extends LoggerCall, API::CallNode {
  DebugLoggerCall() { this = API::moduleImport("debug").getReturn().getACall() }

  override DataFlow::Node getAMessageComponent() { result = this.getAnArgument() }
}

/**
 * A step through the [`ansi-colors`](https://https://npmjs.org/package/ansi-colors) library.
 */
class AnsiColorsStep extends TaintTracking::SharedTaintStep {
  override predicate stringManipulationStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(API::CallNode call | call = API::moduleImport("ansi-colors").getAMember*().getACall() |
      pred = call.getArgument(0) and
      succ = call
    )
  }
}

/**
 * A step through the [`colors`](https://npmjs.org/package/colors) library.
 * This step ignores the `String.prototype` modifying part of the `colors` library.
 */
class ColorsStep extends TaintTracking::SharedTaintStep {
  override predicate stringManipulationStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(API::CallNode call |
      call =
        API::moduleImport([
            "colors",
            // the `colors/safe` variant avoids modifying the prototype methods
            "colors/safe"
          ]).getAMember*().getACall()
    |
      pred = call.getArgument(0) and
      succ = call
    )
  }
}

/**
 * A step through the [`wrap-ansi`](https://npmjs.org/package/wrap-ansi) library.
 */
class WrapAnsiStep extends TaintTracking::SharedTaintStep {
  override predicate stringManipulationStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(API::CallNode call | call = API::moduleImport("wrap-ansi").getACall() |
      pred = call.getArgument(0) and
      succ = call
    )
  }
}

/**
 * A step through the [`colorette`](https://npmjs.org/package/colorette) library.
 */
class ColoretteStep extends TaintTracking::SharedTaintStep {
  override predicate stringManipulationStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(API::CallNode call | call = API::moduleImport("colorette").getAMember().getACall() |
      pred = call.getArgument(0) and
      succ = call
    )
  }
}

/**
 * A step through the [`cli-highlight`](https://npmjs.org/package/cli-highlight) library.
 */
class CliHighlightStep extends TaintTracking::SharedTaintStep {
  override predicate stringManipulationStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(API::CallNode call |
      call = API::moduleImport("cli-highlight").getMember("highlight").getACall()
    |
      pred = call.getArgument(0) and
      succ = call
    )
  }
}

/**
 * A step through the [`cli-color`](https://npmjs.org/package/cli-color) library.
 */
class CliColorStep extends TaintTracking::SharedTaintStep {
  override predicate stringManipulationStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(API::CallNode call | call = API::moduleImport("cli-color").getAMember*().getACall() |
      pred = call.getArgument(0) and
      succ = call
    )
  }
}

/**
 * A step through the [`slice-ansi`](https://npmjs.org/package/slice-ansi) library.
 */
class SliceAnsiStep extends TaintTracking::SharedTaintStep {
  override predicate stringManipulationStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(API::CallNode call | call = API::moduleImport("slice-ansi").getACall() |
      pred = call.getArgument(0) and
      succ = call
    )
  }
}

/**
 * A step through the [`kleur`](https://npmjs.org/package/kleur) library.
 */
class KleurStep extends TaintTracking::SharedTaintStep {
  private API::Node kleurInstance() {
    result = API::moduleImport("kleur")
    or
    result = this.kleurInstance().getAMember().getReturn()
  }

  override predicate stringManipulationStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(API::CallNode call | call = this.kleurInstance().getAMember().getACall() |
      pred = call.getArgument(0) and
      succ = call
    )
  }
}

/**
 * A step through the [`chalk`](https://npmjs.org/package/chalk) library.
 */
class ChalkStep extends TaintTracking::SharedTaintStep {
  override predicate stringManipulationStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(API::CallNode call | call = API::moduleImport("chalk").getAMember*().getACall() |
      pred = call.getArgument(0) and
      succ = call
    )
  }
}

/**
 * A step through the [`strip-ansi`](https://npmjs.org/package/strip-ansi) library.
 */
class StripAnsiStep extends TaintTracking::SharedTaintStep {
  override predicate stringManipulationStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(API::CallNode call | call = API::moduleImport("strip-ansi").getACall() |
      pred = call.getArgument(0) and
      succ = call
    )
  }
}

/**
 * Provides classes and predicates for working with the `pino` library.
 */
private module Pino {
  /**
   * Gets a logger instance created by importing the `pino` library.
   */
  private API::Node pinoApi() {
    result = API::moduleImport("pino").getReturn()
    or
    result = pinoApi().getMember("child").getReturn()
  }

  /**
   * Gets a logger instance from the `pino` library.
   */
  private API::Node pino() {
    result = pinoApi()
    or
    // `pino` is installed as the "log" property on the request object in `Express` and similar libraries.
    // in `Hapi` the property is "logger".
    exists(Http::RequestNode req, API::Node reqNode |
      reqNode.asSource() = req.getALocalSource() and
      result = reqNode.getMember(["log", "logger"])
    )
  }

  /**
   * A logging call to the `pino` library.
   */
  private class PinoCall extends LoggerCall {
    PinoCall() {
      this = pino().getMember(["trace", "debug", "info", "warn", "error", "fatal"]).getACall()
    }

    override DataFlow::Node getAMessageComponent() { result = this.getAnArgument() }
  }
}

/**
 * A step through the [`ansi-to-html`](https://npmjs.org/package/ansi-to-html) library.
 */
class AnsiToHtmlStep extends TaintTracking::SharedTaintStep {
  override predicate stringManipulationStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(API::CallNode call |
      call = API::moduleImport("ansi-to-html").getInstance().getMember("toHtml").getACall()
    |
      pred = call.getArgument(0) and
      succ = call
    )
  }
}
