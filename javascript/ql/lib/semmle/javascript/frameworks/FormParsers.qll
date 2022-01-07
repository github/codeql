/**
 * Provides classes for modeling the server-side form/file parsing libraries.
 */

import javascript

/**
 * A source of remote flow from the `Busboy` library.
 */
private class BusBoyRemoteFlow extends RemoteFlowSource {
  BusBoyRemoteFlow() {
    this =
      API::moduleImport("busboy")
          .getInstance()
          .getMember("on")
          .getParameter(1)
          .getAParameter()
          .getAnImmediateUse()
  }

  override string getSourceType() { result = "parsed user value from Busbuy" }
}

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
    )
  }

  override string getSourceType() { result = "parsed user value from Formidable" }
}

/**
 * A source of remote flow from the `Multiparty` library.
 */
private class MultipartyRemoteFlow extends RemoteFlowSource {
  MultipartyRemoteFlow() {
    exists(API::Node form | form = API::moduleImport("multiparty").getMember("Form").getInstance() |
      exists(API::CallNode parse | parse = form.getMember("parse").getACall() |
        this = parse.getParameter(1).getAParameter().getAnImmediateUse()
      )
      or
      exists(API::CallNode on | on = form.getMember("on").getACall() |
        on.getArgument(0).mayHaveStringValue(["part", "file", "field"]) and
        this = on.getParameter(1).getAParameter().getAnImmediateUse()
      )
    )
  }

  override string getSourceType() { result = "parsed user value from Multiparty" }
}
