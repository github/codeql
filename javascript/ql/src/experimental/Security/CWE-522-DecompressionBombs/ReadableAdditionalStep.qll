import javascript
import API

predicate readablePipeAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
  // this step connect the first pipe parameter to the last pipe parameter
  exists(API::Node cn |
    cn =
      [
        API::moduleImport("fs").getMember("createReadStream"),
        API::moduleImport("stream").getMember("Readable")
      ]
  |
    pred = cn.getParameter(0).asSink() and
    succ = cn.getASuccessor*().getMember("pipe").getParameter(0).asSink()
  )
  or
  // this step connect the a pipe parameter to the next pipe parameter
  exists(API::Node cn |
    cn =
      [
        API::moduleImport("fs").getMember("createReadStream"),
        API::moduleImport("stream").getMember("Readable")
      ].getASuccessor*()
  |
    pred = cn.getParameter(0).asSink() and
    succ = cn.getReturn().getMember("pipe").getParameter(0).asSink()
  )
  or
  // this step connect the a pipe parameter to the next parameter
  exists(API::Node cn, int i |
    i in [0 .. 10] and
    cn =
      [
        API::moduleImport("stream/promises").getMember("pipeline"),
        API::moduleImport("stream").getMember("pipeline")
      ]
  |
    pred = cn.getParameter(i).asSink() and
    succ = cn.getParameter(i + 1).asSink()
  )
  or
  // this step connect the first pipe parameter to all of the next parameters
  exists(API::Node cn, int i |
    i in [1 .. 10] and
    cn =
      [
        API::moduleImport("stream/promises").getMember("pipeline"),
        API::moduleImport("stream").getMember("pipeline")
      ]
  |
    pred = cn.getParameter(0).asSink() and
    succ = cn.getParameter(i).asSink()
  )
}
