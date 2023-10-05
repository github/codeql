/**
 * Provides classes for modeling the server-side form/file parsing libraries.
 */

import javascript
import semmle.javascript.frameworks.ReadableStream

/**
 * A module for modeling [busboy](https://www.npmjs.com/package/busboy) package
 */
module BusBoy {
  /**
   * A source of remote flow from the `Busboy` library.
   */
  private class BusBoyRemoteFlow extends RemoteFlowSource {
    BusBoyRemoteFlow() {
      exists(API::Node busboyOnEvent |
        busboyOnEvent = API::moduleImport("busboy").getReturn().getMember("on")
      |
        // Files
        busboyOnEvent.getParameter(0).asSink().mayHaveStringValue("file") and
        // second param of 'file' event is a Readable stream
        this = readableStreamDataNode(busboyOnEvent.getParameter(1).getParameter(1)).asSource()
        or
        // Fields
        busboyOnEvent.getParameter(0).asSink().mayHaveStringValue(["file", "field"]) and
        this =
          API::moduleImport("busboy")
              .getReturn()
              .getMember("on")
              .getParameter(1)
              .getAParameter()
              .asSource()
      )
    }

    override string getSourceType() { result = "parsed user value from Busbuy" }
  }

  /**
   * Holds if busboy file data as additional taint steps according to a Readable Stream type
   *
   * TODO: I don't know how it can be a global taint step!
   */
  predicate busBoyReadableAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(API::Node busboyOnEvent |
      busboyOnEvent = API::moduleImport("busboy").getReturn().getMember("on")
    |
      busboyOnEvent.getParameter(0).asSink().mayHaveStringValue("file") and
      customStreamPipeAdditionalTaintStep(busboyOnEvent.getParameter(1).getParameter(1), pred, succ)
    )
  }
}

/**
 * A module for modeling [formidable](https://www.npmjs.com/package/formidable) package
 */
module Formidable {
  /**
   * A source of remote flow from the `Formidable` library parsing a HTTP request.
   */
  private class FormidableRemoteFlow extends RemoteFlowSource {
    FormidableRemoteFlow() {
      exists(API::Node formidable |
        formidable = API::moduleImport("formidable").getReturn()
        or
        formidable = API::moduleImport("formidable").getMember("formidable").getReturn()
        or
        formidable =
          API::moduleImport("formidable").getMember(["IncomingForm", "Formidable"]).getInstance()
      |
        this =
          formidable.getMember("parse").getACall().getABoundCallbackParameter(1, any(int i | i > 0))
        or
        // if callback is not provide a promise will be returned,
        // return values contains [fields,files] members
        exists(API::Node parseMethod |
          parseMethod = formidable.getMember("parse") and parseMethod.getNumParameter() = 1
        |
          this = parseMethod.getReturn().asSource()
        )
        or
        // event handler
        this = formidable.getMember("on").getParameter(1).getAParameter().asSource()
      )
    }

    override string getSourceType() { result = "parsed user value from Formidable" }
  }
}

API::Node test() {
  result =
    API::moduleImport("multiparty").getMember("Form").getInstance().getMember("on").getASuccessor*()
}

/**
 * A module for modeling [multiparty](https://www.npmjs.com/package/multiparty) package
 */
module Multiparty {
  /**
   * A source of remote flow from the `Multiparty` library.
   */
  private class MultipartyRemoteFlow extends RemoteFlowSource {
    MultipartyRemoteFlow() {
      exists(API::Node form |
        form = API::moduleImport("multiparty").getMember("Form").getInstance()
      |
        exists(API::CallNode parse | parse = form.getMember("parse").getACall() |
          this = parse.getParameter(1).getParameter([1, 2]).asSource()
        )
        or
        exists(API::Node on | on = form.getMember("on") |
          (
            on.getParameter(0).asSink().mayHaveStringValue(["file", "field"]) and
            this = on.getParameter(1).getParameter([0, 1]).asSource()
            or
            on.getParameter(0).asSink().mayHaveStringValue("part") and
            this = readableStreamDataNode(on.getParameter(1).getParameter(0)).asSink()
          )
        )
      )
    }

    override string getSourceType() { result = "parsed user value from Multiparty" }
  }

  /**
   * Holds if multiparty part data as additional taint steps according to a Readable Stream type
   *
   * TODO: I don't know how it can be a global taint step!
   */
  predicate multipartyReadableAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(API::Node multipartyOnEvent |
      multipartyOnEvent =
        API::moduleImport("multiparty").getMember("Form").getInstance().getMember("on")
    |
      multipartyOnEvent.getParameter(0).asSink().mayHaveStringValue("part") and
      customStreamPipeAdditionalTaintStep(multipartyOnEvent.getParameter(1).getParameter(0), pred,
        succ)
    )
  }
}
