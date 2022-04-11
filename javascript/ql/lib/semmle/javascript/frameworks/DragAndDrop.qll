/**
 * Provides predicates for reasoning about dragAndDrop data.
 */

import javascript

/**
 * Gets a jQuery "drop" event.
 * E.g. `e` in `$("#foo").on("drop", function(e) { ... })`.
 */
private DataFlow::SourceNode jQueryDropEvent(DataFlow::TypeTracker t) {
  t.start() and
  exists(DataFlow::CallNode call |
    call = JQuery::objectRef().getAMethodCall(["bind", "on", "live", "one", "delegate"]) and
    call.getArgument(0).mayHaveStringValue("drop")
  |
    result = call.getCallback(call.getNumArgument() - 1).getParameter(0)
  )
  or
  exists(DataFlow::TypeTracker t2 | result = jQueryDropEvent(t2).track(t2, t))
}

/**
 * Gets a DOM "drop" event.
 * E.g. `e` in `document.addEventListener("drop", e => { ... })`.
 */
private DataFlow::SourceNode dropEvent(DataFlow::TypeTracker t) {
  t.start() and
  exists(DataFlow::CallNode call | call = DOM::domValueRef().getAMemberCall("addEventListener") |
    call.getArgument(0).mayHaveStringValue("drop") and
    result = call.getCallback(1).getParameter(0)
  )
  or
  t.start() and
  exists(DataFlow::PropWrite pw | pw = DOM::domValueRef().getAPropertyWrite() |
    pw.getPropertyName() = "ondrop" and
    result = pw.getRhs().getABoundFunctionValue(0).getParameter(0)
  )
  or
  t.start() and
  result = jQueryDropEvent(DataFlow::TypeTracker::end()).getAPropertyRead("originalEvent")
  or
  exists(DataFlow::TypeTracker t2 | result = dropEvent(t2).track(t2, t))
}

/**
 * Gets a reference to the dragAndDropData DataTransfer object.
 * https://developer.mozilla.org/docs/Web/API/HTML_Drag_and_Drop_API
 */
private DataFlow::SourceNode dragAndDropDataTransferSource(DataFlow::TypeTracker t) {
  t.start() and
  exists(DataFlow::PropRead read | read = result |
    read.getPropertyName() = "dataTransfer" and
    read.getBase().getALocalSource() = dropEvent(DataFlow::TypeTracker::end())
  )
  or
  exists(DataFlow::TypeTracker t2 | result = dragAndDropDataTransferSource(t2).track(t2, t))
}

/**
 * A reference to data from the dragAndDrop. Seen as a source for DOM-based XSS.
 */
private class DragAndDropSource extends RemoteFlowSource {
  DragAndDropSource() {
    this = dragAndDropDataTransferSource(DataFlow::TypeTracker::end()).getAMethodCall("getData")
  }

  override string getSourceType() { result = "DragAndDrop data" }
}
