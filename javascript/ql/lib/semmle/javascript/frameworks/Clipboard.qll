/**
 * Provides predicates for reasoning about clipboard data.
 */

import javascript

/**
 * Gets a jQuery "paste" event.
 * E.g. `e` in `$("#foo").on("paste", function(e) { ... })`.
 */
private DataFlow::SourceNode jQueryPasteEvent(DataFlow::TypeTracker t) {
  t.start() and
  exists(DataFlow::CallNode call |
    call = JQuery::objectRef().getAMethodCall(["bind", "on", "live", "one", "delegate"]) and
    call.getArgument(0).mayHaveStringValue("paste")
  |
    result = call.getCallback(call.getNumArgument() - 1).getParameter(0)
  )
  or
  exists(DataFlow::TypeTracker t2 | result = jQueryPasteEvent(t2).track(t2, t))
}

/**
 * Gets a DOM "paste" event.
 * E.g. `e` in `document.addEventListener("paste", e => { ... })`.
 */
private DataFlow::SourceNode pasteEvent(DataFlow::TypeTracker t) {
  t.start() and
  exists(DataFlow::CallNode call | call = DOM::domValueRef().getAMemberCall("addEventListener") |
    call.getArgument(0).mayHaveStringValue("paste") and
    result = call.getCallback(1).getParameter(0)
  )
  or
  t.start() and
  result = jQueryPasteEvent(DataFlow::TypeTracker::end()).getAPropertyRead("originalEvent")
  or
  exists(DataFlow::TypeTracker t2 | result = pasteEvent(t2).track(t2, t))
}

/**
 * Gets a reference to the clipboardData DataTransfer object.
 * https://developer.mozilla.org/en-US/docs/Web/API/ClipboardEvent/clipboardData
 */
private DataFlow::SourceNode clipboardDataTransferSource(DataFlow::TypeTracker t) {
  t.start() and
  exists(DataFlow::PropRead read | read = result |
    read.getPropertyName() = "clipboardData" and
    read.getBase().getALocalSource() = pasteEvent(DataFlow::TypeTracker::end())
  )
  or
  exists(DataFlow::TypeTracker t2 | result = clipboardDataTransferSource(t2).track(t2, t))
}

/**
 * A reference to data from the clipboard. Seen as a source for DOM-based XSS.
 */
private class ClipboardSource extends RemoteFlowSource {
  ClipboardSource() {
    this = clipboardDataTransferSource(DataFlow::TypeTracker::end()).getAMethodCall("getData")
  }

  override string getSourceType() { result = "Clipboard data" }
}
