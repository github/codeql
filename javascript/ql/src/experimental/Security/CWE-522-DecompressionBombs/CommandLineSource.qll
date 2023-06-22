import javascript
import DataFlow::PathGraph
import API

/**
 * there are FP when the types are not str
 * because int,boolean types are not really dangerous as a source node
 */
abstract class CommandLineFlowSource extends API::Node { }

class Yargs extends CommandLineFlowSource {
  Yargs() {
    this = API::moduleImport("yargs/yargs").getASuccessor().getMember("argv") or
    this = API::moduleImport("yargs/yargs").getASuccessor().getMember("argv").getAMember()
  }
}

class Argv extends CommandLineFlowSource {
  Argv() {
    exists(string numOfArg |
      this = API::moduleImport(["node:process", "process"]).getMember("argv").getMember(numOfArg) and
      not numOfArg = ["0", "1", "forEach"]
    )
    or
    this =
      API::moduleImport("node:process")
          .getMember("argv")
          .getMember("forEach")
          .getParameter(0)
          .getParameter(1)
  }
}

predicate test(API::Node n) {
  n = API::moduleImport("commander").getMember("Command").getASuccessor*().getInstance()
}

class Commander extends CommandLineFlowSource {
  Commander() {
    // opts() are { key : value }
    // args are remaining arguments
    exists(API::Node n |
      n =
        [
          API::moduleImport("commander").getMember("Command").getASuccessor*().getInstance(),
          // https://github.com/tj/commander.js#life-cycle-hooks
          // https://github.com/tj/commander.js/blob/master/examples/hook.js
          API::moduleImport("commander")
              .getMember("Command")
              .getASuccessor*()
              .getMember("hook")
              .getParameter(1)
              .getParameter(_),
          // https://github.com/tj/commander.js/blob/master/examples/action-this.js
          API::moduleImport("commander")
              .getMember("Command")
              .getASuccessor*()
              .getMember("action")
              .getParameter(0)
              .getReceiver()
        ]
    |
      this = n.getMember("opts").getReturn().getMember(_)
      or
      this = n.getMember("args")
    )
    or
    // action handlers has FP because of options and command in `.action((name, options, command)`
    // https://github.com/tj/commander.js#action-handler
    // https://github.com/tj/commander.js#commands
    this =
      API::moduleImport("commander")
          .getMember("Command")
          .getASuccessor*()
          .getMember("action")
          .getParameter(0)
          .getParameter(_)
    or
    // why we can't have forEach global taintStep?
    // https://github.com/tj/commander.js#command-arguments
    this =
      API::moduleImport("commander")
          .getMember("Command")
          .getASuccessor*()
          .getMember("action")
          .getParameter(0)
          .getParameter(_)
          .getASuccessor*()
          .getMember("forEach")
          .getParameter(0)
          .getParameter(0)
    or
    // Custom option processing
    // https://github.com/tj/commander.js#custom-option-processing
    // https://github.com/tj/commander.js/blob/master/examples/options-custom-processing.js
    this =
      API::moduleImport("commander")
          .getMember("Command")
          .getASuccessor*()
          .getMember("option")
          .getParameter(2)
          .getParameter(_)
  }
}
