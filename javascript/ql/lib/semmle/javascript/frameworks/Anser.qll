/**
 * Provides classes for working with applications using [anser](https://www.npmjs.com/package/anser).
 */

import javascript

/**
 * A taint step for the [anser](https://www.npmjs.com/package/anser) library.
 */
private class AnserTaintStep extends TaintTracking::SharedTaintStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    exists(API::CallNode call |
      call =
        API::moduleImport("anser")
            .getMember(["linkify", "ansiToHtml", "ansiToText", "ansiToJson"])
            .getACall()
      or
      call =
        API::moduleImport("anser")
            .getInstance()
            .getMember([
                "linkify", "ansiToHtml", "ansiToText", "ansiToJson", "process", "processChunkJson",
                "processChunk"
              ])
            .getACall()
    |
      succ = call and
      pred = call.getArgument(0)
    )
  }
}
