/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * command-injection vulnerabilities, as well as extension points for
 * adding your own.
 */

import javascript
import semmle.javascript.security.dataflow.RemoteFlowSources

module IndirectCommandInjection {
  /**
   * A data flow source for command-injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for command-injection vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for command-injection vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A source of user input from the command-line, considered as a flow source for command injection.
   */
  private class CommandLineArgumentsArrayAsSource extends Source {
    CommandLineArgumentsArrayAsSource() { this instanceof CommandLineArgumentsArray }
  }

  /**
   * An array of command-line arguments.
   */
  class CommandLineArgumentsArray extends DataFlow::SourceNode {
    CommandLineArgumentsArray() {
      this = DataFlow::globalVarRef("process").getAPropertyRead("argv")
    }
  }

  /**
   * An object containing parsed command-line arguments, considered as a flow source for command injection.
   */
  class ParsedCommandLineArgumentsAsSource extends Source {
    ParsedCommandLineArgumentsAsSource() {
      // `require('get-them-args')(...)` => `{ unknown: [], a: ... b: ... }`
      this = DataFlow::moduleImport("get-them-args").getACall()
      or
      // `require('optimist').argv` => `{ _: [], a: ... b: ... }`
      this = DataFlow::moduleMember("optimist", "argv")
      or
      // `require("arg")({...spec})` => `{_: [], a: ..., b: ...}`
      this = DataFlow::moduleImport("arg").getACall()
      or
      // `(new (require(argparse)).ArgumentParser({...spec})).parse_args()` => `{a: ..., b: ...}`
      this =
        API::moduleImport("argparse")
            .getMember("ArgumentParser")
            .getInstance()
            .getMember("parse_args")
            .getACall()
      or
      // `require('command-line-args')({...spec})` => `{a: ..., b: ...}`
      this = DataFlow::moduleImport("command-line-args").getACall()
      or
      // `require('meow')(help, {...spec})` => `{a: ..., b: ....}`
      this = DataFlow::moduleImport("meow").getACall()
      or
      // `require("dashdash").createParser(...spec)` => `{a: ..., b: ...}`
      this =
        [
          API::moduleImport("dashdash"),
          API::moduleImport("dashdash").getMember("createParser").getReturn()
        ].getMember("parse").getACall()
      or
      // `require('commander').myCmdArgumentName`
      this = commander().getAMember().getAnImmediateUse()
      or
      // `require('commander').opt()` => `{a: ..., b: ...}`
      this = commander().getMember("opts").getACall()
    }
  }

  /**
   * Holds if there is a command line parsing step from `pred` to `succ`.
   * E.g: `var succ = require("minimist")(pred)`.
   */
  predicate argsParseStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::CallNode call |
      call = DataFlow::moduleMember("args", "parse").getACall() or
      call = DataFlow::moduleImport(["yargs-parser", "minimist", "subarg"]).getACall()
    |
      succ = call and
      pred = call.getArgument(0)
    )
  }

  /**
   * Gets a Command instance from the `commander` library.
   */
  private API::Node commander() {
    result = API::moduleImport("commander")
    or
    // `require("commander").program === require("commander")`
    result = commander().getMember("program")
    or
    result = commander().getMember("Command").getInstance()
    or
    // lots of chainable methods
    result = commander().getAMember().getReturn()
  }

  /**
   * Gets an instance of `yargs`.
   * Either directly imported as a module, or through some chained method call.
   */
  private DataFlow::SourceNode yargs() {
    result = DataFlow::moduleImport("yargs")
    or
    // script used to generate list of chained methods: https://gist.github.com/erik-krogh/f8afe952c0577f4b563a993e613269ba
    exists(string method |
      not method =
        // the methods that does not return a chained `yargs` object.
        [
          "getContext", "getDemandedOptions", "getDemandedCommands", "getDeprecatedOptions",
          "_getParseContext", "getOptions", "getGroups", "getStrict", "getStrictCommands",
          "getExitProcess", "locale", "getUsageInstance", "getCommandInstance"
        ]
    |
      result = yargs().getAMethodCall(method)
    )
  }

  /**
   * An array of command line arguments (`argv`) parsed by the `yargs` libary.
   */
  class YargsArgv extends Source {
    YargsArgv() {
      this = yargs().getAPropertyRead("argv")
      or
      this = yargs().getAMethodCall("parse") and
      this.(DataFlow::MethodCallNode).getNumArgument() = 0
    }
  }

  /**
   * A command-line argument that effectively is system-controlled, and therefore not likely to be exploitable when used in the execution of another command.
   */
  private class SystemControlledCommandLineArgumentSanitizer extends Sanitizer {
    SystemControlledCommandLineArgumentSanitizer() {
      // `process.argv[0]` and `process.argv[1]` are paths to `node` and `main`.
      exists(string index | index = "0" or index = "1" |
        this = any(CommandLineArgumentsArray a).getAPropertyRead(index)
      )
    }
  }

  /**
   * A command argument to a function that initiates an operating system command.
   */
  private class SystemCommandExecutionSink extends Sink, DataFlow::ValueNode {
    SystemCommandExecutionSink() { this = any(SystemCommandExecution sys).getACommandArgument() }
  }
}
