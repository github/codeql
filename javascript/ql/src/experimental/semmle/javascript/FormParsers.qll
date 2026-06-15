/**
 * Provides classes for modeling the server-side form/file parsing libraries.
 */

import javascript
import experimental.semmle.javascript.ReadableStream

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
        this = readableStreamDataNode(busboyOnEvent.getParameter(1).getParameter(1))
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
   * A busboy file data step according to a Readable Stream type
   */
  private class AdditionalTaintStep extends TaintTracking::SharedTaintStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(API::Node busboyOnEvent |
        busboyOnEvent = API::moduleImport("busboy").getReturn().getMember("on")
      |
        busboyOnEvent.getParameter(0).asSink().mayHaveStringValue("file") and
        customStreamPipeAdditionalTaintStep(busboyOnEvent.getParameter(1).getParameter(1), pred,
          succ)
      )
    }
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
            this = readableStreamDataNode(on.getParameter(1).getParameter(0))
          )
        )
      )
    }

    override string getSourceType() { result = "parsed user value from Multiparty" }
  }

  /**
   * A multiparty part data step according to a Readable Stream type
   */
  private class AdditionalTaintStep extends TaintTracking::SharedTaintStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
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
}

/**
 * A module for modeling [dicer](https://www.npmjs.com/package/dicer) package
 */
module Dicer {
  /**
   * A source of remote flow from the `dicer` library.
   */
  private class DicerRemoteFlow extends RemoteFlowSource {
    DicerRemoteFlow() {
      exists(API::Node dicer | dicer = API::moduleImport("dicer").getInstance() |
        exists(API::Node on | on = dicer.getMember("on") |
          on.getParameter(0).asSink().mayHaveStringValue("part") and
          this = readableStreamDataNode(on.getParameter(1).getParameter(0))
          or
          exists(API::Node onPart | onPart = on.getParameter(1).getParameter(0).getMember("on") |
            onPart.getParameter(0).asSink().mayHaveStringValue("header") and
            this = onPart.getParameter(1).getParameter(0).asSource()
          )
        )
      )
    }

    override string getSourceType() { result = "parsed user value from Dicer" }
  }

  /**
   * A dicer part data step according to a Readable Stream type
   */
  private class AdditionalTaintStep extends TaintTracking::SharedTaintStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(API::Node onEvent |
        onEvent = API::moduleImport("dicer").getInstance().getMember("on")
      |
        onEvent.getParameter(0).asSink().mayHaveStringValue("part") and
        customStreamPipeAdditionalTaintStep(onEvent.getParameter(1).getParameter(0), pred, succ)
      )
    }
  }
}
