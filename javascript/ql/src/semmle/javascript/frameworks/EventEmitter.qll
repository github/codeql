import javascript

module EventEmitter {
  /** Gets the name of a method on `EventEmitter` that returns `this`. */
  string chainableMethod() {
    result = "off" or
    result = "removeAllListeners" or
    result = "removeListener" or
    result = "setMaxListeners" or
    result = on()
  }

  /** Gets the name of a method on `EventEmitter` that registers an event handler. */
  string on() {
    result = "addListener" or
    result = "on" or
    result = "once" or
    result = "prependListener" or
    result = "prependOnceListener"
  }


  private DataFlow::SourceNode trackEventEmitter(DataFlow::TypeTracker t, EventEmitterRange::Range emitter) {
    t.start() and result = emitter
    or
    exists(DataFlow::TypeTracker t2, DataFlow::SourceNode pred | pred = trackEventEmitter(t2, emitter) |
      result = pred.track(t2, t)
      or
      // invocation of a chainable method
      exists(DataFlow::MethodCallNode mcn |
        mcn = pred.getAMethodCall(EventEmitter::chainableMethod()) and
        // exclude getter versions
        exists(mcn.getAnArgument()) and
        result = mcn and
        t = t2.continue()
      )
    )
  }

  /**
   * Type tracking of an EventEmitter. Types are tracked through the chainable methods in the NodeJS eventEmitter.
   */
  DataFlow::SourceNode trackEventEmitter(EventEmitterRange::Range emitter) {
    result = trackEventEmitter(DataFlow::TypeTracker::end(), emitter)
  }

  /**
   * An EventEmitter instance that implements the NodeJS EventEmitter API. 
   * Extend EventEmitter::Range to mark something as being an EventEmitter. 
   */
  class EventEmitter extends DataFlow::Node {
    EventEmitterRange::Range range;

    EventEmitter() { this = range }
  }

  module EventEmitterRange {
    /**
     * An object that implements the EventEmitter API.
     * Extending this class does nothing, its mostly to indicate intent.
     * The magic only happens when extending EventRegistration::Range and EventDispatch::Range.
     */
    abstract class Range extends DataFlow::Node {}

    /**
     * An NodeJS EventEmitter instance.
     * Events dispatched on this EventEmitter will be handled by event handlers registered on this EventEmitter.
     * (That is opposed to e.g. SocketIO, which implements the same interface, but where events cross object boundaries).
     */
    abstract class NodeJSEventEmitter extends Range {
      DataFlow::SourceNode ref() { result = trackEventEmitter(this) }
    }

    private class ImportedNodeJSEventEmitter extends NodeJSEventEmitter {
      ImportedNodeJSEventEmitter() {
        exists(DataFlow::SourceNode clazz |
          clazz = DataFlow::moduleImport("events") or
          clazz = DataFlow::moduleMember("events", "EventEmitter")
        |
          this = clazz.getAnInstantiation()
        )
      }
    }
  }

  /**
   * A registration of an event handler on an EventEmitter.
   */
  class EventRegistration extends DataFlow::Node {
    EventRegistration::Range range;

    EventRegistration() { this = range }

    /** Gets the EventEmitter that the event handler is registered on. */
    final EventEmitter getEmitter() { result = range.getEmitter() }

    /** Gets the name of the channel if possible. */
    string getChannel() { result = range.getChannel() }

    /** Gets the `i`th parameter in the event handler. */
    DataFlow::Node getReceivedItem(int i) { result = range.getReceivedItem(i) }

    /**
     * Gets a value that is returned by the event handler.
     * The default implementation is that no value can be returned.
     */
    DataFlow::Node getAReturnedValue() { result = range.getAReturnedValue() }

    /**
     * Holds if this event handler can return a value to the given `dispatch`.
     * The default implementation is that there exists no such dispatch.
     */
    predicate canReturnTo(EventDispatch dispatch) { range.canReturnTo(dispatch) }
  }

  module EventRegistration {
    /**
     * A registration of an event handler on an EventEmitter.
     * The default implementation assumes that `this` is a DataFlow::InvokeNode where the
     * first argument is a string describing which channel is registered, and the second
     * argument is the event handler callback.
     */
    abstract class Range extends DataFlow::Node {
      EventEmitterRange::Range emitter;

      final EventEmitter getEmitter() { result = emitter }

      string getChannel() {
        this.(DataFlow::InvokeNode).getArgument(0).mayHaveStringValue(result)
      }

      DataFlow::Node getReceivedItem(int i) {
        result = this.(DataFlow::InvokeNode).getABoundCallbackParameter(1, i)
      }

      DataFlow::Node getAReturnedValue() { none() }

      predicate canReturnTo(EventDispatch dispatch) { none() }
    }

    private class NodeJSEventRegistration extends Range, DataFlow::MethodCallNode {
      override EventEmitterRange::NodeJSEventEmitter emitter;

      NodeJSEventRegistration() { this = emitter.ref().getAMethodCall(EventEmitter::on()) }
    }
  }

  /**
   * A dispatch of an event on an EventEmitter.
   */
  class EventDispatch extends DataFlow::Node {
    EventDispatch::Range range;

    EventDispatch() { this = range }

    /** Gets the emitter that the event dispatch happens on. */
    EventEmitter getEmitter() { result = range.getEmitter() }

    /** Gets the name of the channel if possible. */
    string getChannel() { result = range.getChannel() }

    /** Gets the `i`th argument that is send to the event handler. */
    DataFlow::Node getSentItem(int i) { result = range.getSentItem(i) }

    /**
     * Get an EventRegistration that this event dispatch can send an event to.
     * The default implementation is that the emitters of the dispatch and registration have to be equal.
     * Channels are by default ignored.
     */
    EventRegistration getAReceiver() { result = range.getAReceiver() }
  }

  module EventDispatch {
    /**
     * A dispatch of an event on an EventEmitter.
     * The default implementation assumes that the dispatch is a DataFlow::InvokeNode,
     * where the first argument is a string describing the channel, and the `i`+1 argument
     * is the `i`th item sent to the event handler.
     */
    abstract class Range extends DataFlow::Node {
      EventEmitterRange::Range emitter;

      final EventEmitter getEmitter() { result = emitter }

      string getChannel() {
        this.(DataFlow::InvokeNode).getArgument(0).mayHaveStringValue(result)
      }

      DataFlow::Node getSentItem(int i) {
        result = this.(DataFlow::InvokeNode).getArgument(i + 1)
      }

      EventRegistration::Range getAReceiver() {
        this.getEmitter() = result.getEmitter()
      }
    }

    private class NodeJSEventDispatch extends Range, DataFlow::MethodCallNode {
      override EventEmitterRange::NodeJSEventEmitter emitter;

      NodeJSEventDispatch() { this = emitter.ref().getAMethodCall("emit") }
    }
  }

  /**
   * A taint-step that models data-flow between event handlers and event dispatchers.
   */
  private class EventEmitterTaintStep extends DataFlow::AdditionalFlowStep {
    EventRegistration reg;
    EventDispatch dispatch;

    EventEmitterTaintStep() {
      this = dispatch and
      reg = dispatch.getAReceiver() and
      not dispatch.getChannel() != reg.getChannel()
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(int i | i >= 0 |
        pred = dispatch.getSentItem(i) and
        succ = reg.getReceivedItem(i)
      )
      or
      reg.canReturnTo(dispatch) and
      pred = reg.getAReturnedValue() and
      succ = dispatch
    }
  }
}
