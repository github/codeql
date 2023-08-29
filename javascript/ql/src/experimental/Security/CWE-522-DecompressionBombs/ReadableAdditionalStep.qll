import javascript
import API

predicate readablePipeAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(API::Node receiver |
    receiver =
      [
        API::moduleImport("fs").getMember("createReadStream"),
        API::moduleImport("stream").getMember("Readable")
      ]
  |
    genaralStreamPipeAdditionalTaintStep(receiver, pred, succ)
  )
}

predicate promisesFileHandlePipeAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(API::Node receiver |
    receiver =
      nodeJsPromisesFileSystem()
          .getMember("open")
          .getASuccessor*()
          .getMember(["createReadStream", "createWriteStream"])
          .getReturn()
  |
    genaralStreamPipeAdditionalTaintStep(receiver, pred, succ)
  )
}

// git receiver which we'll have receiver(pred).pipe(succ) and other succerssor pipe methods
predicate genaralStreamPipeAdditionalTaintStep(
  API::Node receiver, DataFlow::Node pred, DataFlow::Node succ
) {
  // this step connect the first pipe parameter to the last pipe parameter
  pred = [receiver.getParameter(0).asSink(), receiver.asSource()] and
  succ = receiver.getASuccessor*().getMember("pipe").getParameter(0).asSink()
  or
  // this step connect the a pipe parameter to the next pipe parameter
  exists(API::Node cn | cn = receiver.getASuccessor*() |
    pred = cn.getParameter(0).asSink() and
    succ = cn.getReturn().getMember("pipe").getParameter(0).asSink()
  )
}

predicate streamPipelineAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
  // this step connect the a pipe parameter to the next parameter
  exists(API::Node cn, int i |
    i in [0 .. 10] and
    cn = nodeJsStream().getMember("pipeline")
  |
    pred = cn.getParameter(i).asSink() and
    succ = cn.getParameter(i + 1).asSink()
  )
  or
  // this step connect the first pipe parameter to the next parameter
  exists(API::Node cn, int i |
    i in [1 .. 10] and
    cn = nodeJsStream().getMember("pipeline")
  |
    pred = cn.getParameter(0).asSink() and
    succ = cn.getParameter(i).asSink()
  )
}

/**
 * Promises API
 */
API::Node nodeJsPromisesFileSystem() {
  result = [API::moduleImport("fs").getMember("promises"), API::moduleImport("fs/promises")]
}

/**
 * Stream Promises API
 */
API::Node nodeJsStream() {
  result = [API::moduleImport("stream/promises"), API::moduleImport("stream").getMember("promises")]
}
