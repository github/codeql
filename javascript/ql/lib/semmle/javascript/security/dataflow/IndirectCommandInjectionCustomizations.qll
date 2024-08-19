/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * command-injection vulnerabilities, as well as extension points for
 * adding your own.
 */

import javascript

module IndirectCommandInjection {
  /**
   * A data flow source for command-injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets a description of this source. */
    string describe() { result = "command-line argument" }
  }

  /**
   * A data flow sink for command-injection vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for command-injection vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A read of `process.env`, considered as a flow source for command injection.
   */
  private class ProcessEnvAsSource extends Source {
    ProcessEnvAsSource() { this = NodeJSLib::process().getAPropertyRead("env") }

    override string describe() { result = "environment variable" }
  }

  /** Gets a data flow node referring to `process.env`. */
  private DataFlow::SourceNode envObject(DataFlow::TypeTracker t) {
    t.start() and
    result = NodeJSLib::process().getAPropertyRead("env")
    or
    exists(DataFlow::TypeTracker t2 | result = envObject(t2).track(t2, t))
  }

  /** Gets a data flow node referring to `process.env`. */
  private DataFlow::SourceNode envObject() { result = envObject(DataFlow::TypeTracker::end()) }

  /**
   * Gets the name of an environment variable that is assumed to be safe.
   */
  private string getASafeEnvironmentVariable() {
    result =
      [
        "GITHUB_ACTION", "GITHUB_ACTION_PATH", "GITHUB_ACTION_REPOSITORY", "GITHUB_ACTIONS",
        "GITHUB_ACTOR", "GITHUB_API_URL", "GITHUB_BASE_REF", "GITHUB_ENV", "GITHUB_EVENT_NAME",
        "GITHUB_EVENT_PATH", "GITHUB_GRAPHQL_URL", "GITHUB_JOB", "GITHUB_PATH", "GITHUB_REF",
        "GITHUB_REPOSITORY", "GITHUB_REPOSITORY_OWNER", "GITHUB_RUN_ID", "GITHUB_RUN_NUMBER",
        "GITHUB_SERVER_URL", "GITHUB_SHA", "GITHUB_WORKFLOW", "GITHUB_WORKSPACE"
      ]
  }

  /** Sanitizer that blocks flow through safe environment variables. */
  private class SafeEnvVariableSanitizer extends Sanitizer {
    SafeEnvVariableSanitizer() {
      this = envObject().getAPropertyRead(getASafeEnvironmentVariable())
    }
  }

  /**
   * An object containing command-line arguments, considered as a flow source for command injection.
   */
  private class CommandLineArgumentsAsSource extends Source instanceof CommandLineArguments { }

  /**
   * A command-line argument that effectively is system-controlled, and therefore not likely to be exploitable when used in the execution of another command.
   */
  private class SystemControlledCommandLineArgumentSanitizer extends Sanitizer {
    SystemControlledCommandLineArgumentSanitizer() {
      // `process.argv[0]` and `process.argv[1]` are paths to `node` and `main`.
      exists(string index | index = "0" or index = "1" |
        this = DataFlow::globalVarRef("process").getAPropertyRead("argv").getAPropertyRead(index)
      )
    }
  }

  /**
   * A command argument to a function that initiates an operating system command as a shell invocation.
   */
  private class SystemCommandExecutionSink extends Sink, DataFlow::ValueNode {
    SystemCommandExecutionSink() {
      exists(SystemCommandExecution sys |
        sys.isShellInterpreted(this) and this = sys.getACommandArgument()
      )
    }
  }
}
