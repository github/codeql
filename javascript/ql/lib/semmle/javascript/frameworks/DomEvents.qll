/**
 * Provides predicates for reasoning about events from the DOM that introduce tainted data.
 */

import javascript

/** Gets the name of a DOM event that might introduce tainted data. */
private string getATaintedDomEvent() { result = ["paste", "drop", "beforeinput"] }

/**
 * Gets a jQuery event that might introduce tainted data.
 * E.g. `e` in `$("#foo").on("paste", function(e) { ... })`.
 */
private DataFlow::SourceNode taintedJQueryEvent(DataFlow::TypeTracker t, string event) {
  t.start() and
  exists(DataFlow::CallNode call |
    call = JQuery::objectRef().getAMethodCall(["bind", "on", "live", "one", "delegate"]) and
    call.getArgument(0).mayHaveStringValue(event) and
    event = getATaintedDomEvent()
  |
    result = call.getCallback(call.getNumArgument() - 1).getParameter(0)
  )
  or
  exists(DataFlow::TypeTracker t2 | result = taintedJQueryEvent(t2, event).track(t2, t))
}

/**
 * Gets a DOM event that might introduce tainted data.
 * E.g. `e` in `document.addEventListener("paste", e => { ... })`.
 */
private DataFlow::SourceNode taintedEvent(DataFlow::TypeTracker t, string event) {
  t.start() and
  exists(DataFlow::CallNode call | call = DOM::domValueRef().getAMemberCall("addEventListener") |
    call.getArgument(0).mayHaveStringValue(event) and
    event = getATaintedDomEvent() and
    result = call.getCallback(1).getParameter(0)
  )
  or
  t.start() and
  exists(DataFlow::ParameterNode pn | result = pn |
    // https://developer.mozilla.org/en-US/docs/Web/API/ClipboardEvent
    pn.hasUnderlyingType("ClipboardEvent") and
    event = "paste"
    or
    // https://developer.mozilla.org/en-US/docs/Web/API/DragEvent
    pn.hasUnderlyingType("DragEvent") and
    event = "drop"
    or
    // https://developer.mozilla.org/en-US/docs/Web/API/InputEvent
    pn.hasUnderlyingType("InputEvent") and
    event = "beforeinput"
  )
  or
  t.start() and
  exists(DataFlow::PropWrite pw | pw = DOM::domValueRef().getAPropertyWrite("on" + event) |
    event = ["paste", "drop"] and // doesn't work for beforeinput, it's just not part of the API
    result = pw.getRhs().getABoundFunctionValue(0).getParameter(0)
  )
  or
  t.start() and
  result = taintedJQueryEvent(DataFlow::TypeTracker::end(), event).getAPropertyRead("originalEvent")
  or
  exists(DataFlow::TypeTracker t2 | result = taintedEvent(t2, event).track(t2, t))
}

/**
 * Gets a reference to a DataTransfer object.
 * https://developer.mozilla.org/en-US/docs/Web/API/ClipboardEvent/clipboardData
 */
private DataFlow::SourceNode taintedDataTransfer(DataFlow::TypeTracker t, string event) {
  t.start() and
  result = taintedEvent(DataFlow::TypeTracker::end(), event).getAPropertyRead("clipboardData") and
  event = "paste"
  or
  t.start() and
  result = taintedEvent(DataFlow::TypeTracker::end(), event).getAPropertyRead("dataTransfer") and
  event = ["drop", "beforeinput"]
  or
  exists(DataFlow::TypeTracker t2 | result = taintedDataTransfer(t2, event).track(t2, t))
}

/**
 * A reference to data from a DataTransfer object, which might originate from e.g. the clipboard.
 * Seen as a source for DOM-based XSS.
 */
private class TaintedDataTransfer extends RemoteFlowSource {
  string event;

  TaintedDataTransfer() {
    this = taintedDataTransfer(DataFlow::TypeTracker::end(), event).getAMethodCall("getData")
  }

  override string getSourceType() {
    event = "paste" and
    result = "Clipboard data"
    or
    event = "drop" and
    result = "Drag&Drop data"
    or
    event = "beforeinput" and
    result = "Input data"
  }
}
