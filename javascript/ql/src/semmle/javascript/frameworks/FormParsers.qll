/**
 * Provides classes for modelling the server-side form/file parsing libraries.
 */

import javascript

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
