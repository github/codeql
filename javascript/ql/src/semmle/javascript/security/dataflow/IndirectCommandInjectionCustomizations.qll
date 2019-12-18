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
      this = DataFlow::moduleImport("get-them-args").getACall() or
      // `require('minimist')(...)` => `{ _: [], a: ... b: ... }`
      this = DataFlow::moduleImport("minimist").getACall() or
      // `require('yargs').argv` => `{ _: [], a: ... b: ... }`
      this = DataFlow::moduleMember("yargs", "argv") or
      // `require('optimist').argv` => `{ _: [], a: ... b: ... }`
      this = DataFlow::moduleMember("optimist", "argv")
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
