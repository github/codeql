/** Provides modeling for parsed command line arguments. */

import javascript

/**
 * An object containing command-line arguments, potentially parsed by a library.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `CommandLineArguments::Range` instead.
 */
class CommandLineArguments extends ThreatModelSource instanceof CommandLineArguments::Range { }

/** Provides a class for modeling new sources of remote user input. */
module CommandLineArguments {
  /**
   * An object containing command-line arguments, potentially parsed by a library.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `CommandLineArguments` instead.
   */
  abstract class Range extends ThreatModelSource::Range {
    override string getThreatModel() { result = "commandargs" }

    override string getSourceType() { result = "CommandLineArguments" }
  }
}

/** A read of `process.argv`, considered as a threat-model source. */
private class ProcessArgv extends CommandLineArguments::Range {
  ProcessArgv() {
    // `process.argv[0]` and `process.argv[1]` are paths to `node` and `main`, and
    // therefore should not be considered a threat-source... However, we don't have an
    // easy way to exclude them, so we need to allow them.
    this = NodeJSLib::process().getAPropertyRead("argv")
  }

  override string getSourceType() { result = "process.argv" }
}

private class DefaultModels extends CommandLineArguments::Range {
  DefaultModels() {
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
    this = commander().getAMember().asSource()
    or
    // `require('commander').opt()` => `{a: ..., b: ...}`
    this = commander().getMember("opts").getACall()
    or
    this = API::moduleImport("yargs/yargs").getReturn().getMember("argv").asSource()
  }
}

/**
 * A step for propagating taint through command line parsing,
 * such as `var succ = require("minimist")(pred)`.
 */
private class ArgsParseStep extends TaintTracking::SharedTaintStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::CallNode call |
      call = DataFlow::moduleMember("args", "parse").getACall() or
      call =
        DataFlow::moduleImport(["yargs-parser", "minimist", "subarg", "yargs/yargs", "yargs"])
            .getACall()
    |
      succ = call and
      pred = call.getArgument(0)
    )
    or
    exists(API::Node commanderNode | commanderNode = commander() |
      pred = commanderNode.getMember(["parse", "parseAsync"]).getACall().getAnArgument() and
      succ =
        [
          commanderNode.getMember("opts").getACall(), commanderNode.getAMember().asSource(),
          commander()
              .getMember("action")
              .getACall()
              .getArgument(0)
              .(DataFlow::FunctionNode)
              .getAParameter()
        ]
    )
    or
    exists(DataFlow::MethodCallNode methodCall | methodCall = yargs() |
      pred = methodCall.getReceiver() and
      succ = methodCall
    )
    or
    exists(DataFlow::CallNode call, DataFlow::Node options |
      call = DataFlow::moduleImport(["arg", "command-line-args"]).getACall() and
      succ = call and
      options = call.getArgument(1) and
      exists(DataFlow::PropWrite write |
        write.getBase() = options and
        write.getPropertyName() = "argv" and
        pred = write.getRhs()
      )
    )
  }
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
  result = DataFlow::moduleImport(["yargs", "yargs/yargs"])
  or
  result = DataFlow::moduleImport(["yargs", "yargs/yargs"]).getACall()
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
 * An array of command line arguments (`argv`) parsed by the `yargs` library.
 */
private class YargsArgv extends CommandLineArguments::Range {
  YargsArgv() {
    this = yargs().getAPropertyRead("argv")
    or
    this = yargs().getAMethodCall("parse") and
    this.(DataFlow::MethodCallNode).getNumArgument() = 0
  }
}
