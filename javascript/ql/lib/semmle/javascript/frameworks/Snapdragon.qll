/**
 * Provides classes for working with applications using [snapdragon](https://www.npmjs.com/package/snapdragon).
 */

import javascript

/**
 * A module modeling taint steps for the [snapdragon](https://www.npmjs.com/package/snapdragon) library.
 */
private module Snapdragon {
  private API::Node getSetCall(API::Node base) { result = base.getMember("set").getReturn() }

  /**
   * A taint step through the [snapdragon](https://www.npmjs.com/package/snapdragon) library.
   *
   * Models both parsing (converting a string to an AST) and compilation (converting an AST to a string).
   * For example:
   * ```JavaScript
   * var snapdragon = new (require("snapdragon"))();
   * snapdragon.parser.set("foo", function () {
   *  sink(this); // <- sink
   * });
   * snapdragon.parse("source", opts); // <- source
   * ```
   */
  private class SnapDragonStep extends DataFlow::SharedFlowStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(string methodName, API::CallNode set, API::CallNode call, API::Node base |
        // the handler, registered with a call to `.set`.
        set = getSetCall+(base.getMember(methodName + "r")).getAnImmediateUse() and
        // the snapdragon instance. The API is chaining, you can also use the instance directly.
        base = API::moduleImport("snapdragon").getInstance() and
        methodName = ["parse", "compile"] and
        (
          // snapdragon.parse(..)
          call = getSetCall*(base).getMember(methodName).getACall()
          or
          // snapdragon.parser.set().set().parse(..)
          call = getSetCall*(set.getReturn()).getMember(methodName).getACall()
        )
      |
        pred = call.getArgument(0) and
        (
          // for parsers handlers the input is the `this` pointer.
          methodName = "parse" and
          succ = DataFlow::thisNode(set.getCallback(1).getFunction())
          or
          // for compiler handlers the input is the first parameter.
          methodName = "compile" and
          succ = set.getParameter(1).getParameter(0).getAnImmediateUse()
        )
      )
    }
  }
}
