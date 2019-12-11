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

  /**
   * An instance of the NodeJS EventEmitter class.
   * Extend this class to mark something as being an instance of the EventEmitter class.
   */
  final class EventEmitter extends DataFlow::Node {
    EventEmitterRange::Range range;

    EventEmitter() { this = range }

    /**
     * Get a method name that returns `this` on this type of emitter.
     */
    string getAChainableMethod() { result = range.getAChainableMethod() }

    /**
     * Get a reference through type-tracking to this EventEmitter.
     * The type-tracking tracks through chainable methods.
     */
    DataFlow::SourceNode ref() { result = range.ref() }
  }

  module EventEmitterRange {
    abstract class Range extends DataFlow::Node {
      string getAChainableMethod() { result = EventEmitter::chainableMethod() }

      private DataFlow::SourceNode ref(DataFlow::TypeTracker t) {
        t.start() and result = this
        or
        exists(DataFlow::TypeTracker t2, DataFlow::SourceNode pred | pred = ref(t2) |
          result = pred.track(t2, t)
          or
          // invocation of a chainable method
          exists(DataFlow::MethodCallNode mcn |
            mcn = pred.getAMethodCall(this.getAChainableMethod()) and
            // exclude getter versions
            exists(mcn.getAnArgument()) and
            result = mcn and
            t = t2.continue()
          )
        )
      }

      DataFlow::SourceNode ref() { result = ref(DataFlow::TypeTracker::end()) }
    }

    abstract class NodeJSEventEmitter extends Range {}

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
   * A registration of an event handler on a particular EventEmitter.
   */
  final class EventRegistration extends DataFlow::Node {
    EventRegistration::Range range;

    EventRegistration() { this = range }

    /** Gets the EventEmitter that the event handler is registered on. */
    final EventEmitter getEmitter() { result = range.getEmitter() }

    /** Gets the name of the channel if possible. */
    string getChannel() { result = range.getChannel() }

    /** Gets the `i`th parameter in the event handler. */
    DataFlow::Node getEventHandlerParameter(int i) { result = range.getEventHandlerParameter(i) }

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
    abstract class Range extends DataFlow::CallNode {
      EventEmitterRange::Range emitter;

      final EventEmitter getEmitter() { result = emitter }

      string getChannel() {
        this.getArgument(0).mayHaveStringValue(result)
      }

      DataFlow::Node getEventHandlerParameter(int i) {
        result = this.getABoundCallbackParameter(1, i)
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
  final class EventDispatch extends DataFlow::CallNode {
    EventDispatch::Range range;

    EventDispatch() { this = range }

    /** Gets the emitter that the event dispatch happens on. */
    EventEmitter getEmitter() { result = range.getEmitter() }

    /** Gets the name of the channel if possible. */
    string getChannel() { result = range.getChannel() }

    /** Gets the `i`th argument that is send to the event handler. */
    DataFlow::Node getDispatchedArgument(int i) { result = range.getDispatchedArgument(i) }

    /**
     * Holds if this event dispatch can send an event to the given even registration.
     * The default implementation is that the emitters of the dispatch and registration have to be equal.
     */
    predicate canSendTo(EventRegistration destination) { range.canSendTo(destination) }
  }

  module EventDispatch {
    abstract class Range extends DataFlow::CallNode {
      EventEmitterRange::Range emitter;

      final EventEmitter getEmitter() { result = emitter }

      string getChannel() {
        this.getArgument(0).mayHaveStringValue(result)
      }

      DataFlow::Node getDispatchedArgument(int i) {
        result = this.getArgument(i + 1)
      }

      predicate canSendTo(EventRegistration destination) {
        this.getEmitter() = destination.getEmitter()
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
      dispatch.canSendTo(reg) and
      reg.getChannel() = dispatch.getChannel()
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(int i | i >= 0 |
        pred = dispatch.getDispatchedArgument(i) and
        succ = reg.getEventHandlerParameter(i)
      )
      or
      reg.canReturnTo(dispatch) and
      pred = reg.getAReturnedValue() and
      succ = dispatch
    }
  }
}
