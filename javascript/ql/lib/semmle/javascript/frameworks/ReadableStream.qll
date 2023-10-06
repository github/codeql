import javascript

/**
 * Holds if there is a step between `fs.createReadStream` and `stream.Readable.from` first parameters to all other piped parameters
 */
predicate readablePipeAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(API::Node receiver |
    receiver =
      [
        API::moduleImport("fs").getMember("createReadStream"),
        API::moduleImport("stream").getMember("Readable").getMember("from")
      ]
  |
    customStreamPipeAdditionalTaintStep(receiver, pred, succ)
    or
    pred = receiver.getParameter(0).asSink() and
    succ = receiver.getReturn().asSource()
  )
}

/**
 * additional taint steps for piped stream from `createReadStream` method of `fs/promises.open`
 */
predicate promisesFileHandlePipeAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(API::Node receiver | receiver = nodeJsPromisesFileSystem().getMember("open") |
    customStreamPipeAdditionalTaintStep(receiver, pred, succ)
    or
    pred = receiver.getParameter(0).asSink() and
    succ = receiver.getReturn().asSource()
  )
}

/**
 * Gets nodejs `fs` Promises API
 */
API::Node nodeJsPromisesFileSystem() {
  result = [API::moduleImport("fs").getMember("promises"), API::moduleImport("fs/promises")]
}

/**
 * Holds if
 * or `receiver.pipe(pred).pipe(sth).pipe(succ)`
 *
 * or `receiver.pipe(sth).pipe(pred).pipe(succ)`
 *
 * or `receiver.pipe(succ)` and receiver is pred
 *
 * Receiver can be any method node that support stream pipe method, it can't be a parameter node
 *
 * Pass receiver method as receiver, not a return value of the receiver method
 */
predicate customStreamPipeAdditionalTaintStep(
  API::Node receiver, DataFlow::Node pred, DataFlow::Node succ
) {
  // following connect the first pipe parameter to the last pipe parameter
  exists(API::Node firstPipe | firstPipe = receiver.getMember("pipe") |
    pred = firstPipe.getParameter(0).asSink() and
    succ = firstPipe.getASuccessor*().getMember("pipe").getParameter(0).asSink()
  )
  or
  // following connect a pipe parameter to the next pipe parameter
  exists(API::Node cn | cn = receiver.getASuccessor+() |
    pred = cn.getParameter(0).asSink() and
    succ = cn.getReturn().getMember("pipe").getParameter(0).asSink()
  )
  or
  // it is a function that its return value is a Readable stream object
  pred = receiver.getReturn().asSource() and
  succ = receiver.getReturn().getMember("pipe").getParameter(0).asSink()
  or
  // it is a Readable stream object
  pred = receiver.asSource() and
  succ = receiver.getMember("pipe").getParameter(0).asSink()
}

/**
 * Holds if
 *
 * ```js
 * await pipeline(
 *        pred,
 *        succ_or_pred,
 *        succ
 *    )
 * ```
 */
predicate streamPipelineAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
  // this step connect the a pipeline parameter to the next pipeline parameter
  exists(API::CallNode cn, int i |
    // we assume that there are maximum 10 pipes mostly or maybe less
    i in [0 .. 10] and
    cn = nodeJsStream().getMember("pipeline").getACall()
  |
    pred = cn.getParameter(i).asSink() and
    succ = cn.getParameter(i + 1).asSink()
  )
  or
  // this step connect the first pipeline parameter to the next parameters
  exists(API::CallNode cn, int i |
    // we assume that there are maximum 10 pipes mostly or maybe less
    i in [1 .. 10] and
    cn = nodeJsStream().getMember("pipeline").getACall()
  |
    pred = cn.getParameter(0).asSink() and
    succ = cn.getParameter(i).asSink()
  )
}

/**
 * Gets `stream` Promises API
 */
API::Node nodeJsStream() {
  result = [API::moduleImport("stream/promises"), API::moduleImport("stream").getMember("promises")]
}

/**
 * Gets a Readable Stream method(not a return value of the method)
 * and returns all nodes responsible for a data read access
 */
DataFlow::Node readableStreamDataNode(API::Node stream) {
  result = stream.asSource()
  or
  // 'data' event
  exists(API::CallNode onEvent | onEvent = stream.getMember("on").getACall() |
    result = onEvent.getParameter(1).getParameter(0).asSource() and
    onEvent.getParameter(0).asSink().mayHaveStringValue("data")
  )
  or
  // 'Readable' event
  exists(API::CallNode onEvent | onEvent = stream.getMember("on").getACall() |
    (
      result = onEvent.getParameter(1).getReceiver().getMember("read").getReturn().asSource() or
      result = stream.getMember("read").getReturn().asSource()
    ) and
    onEvent.getParameter(0).asSink().mayHaveStringValue("readable")
  )
}
