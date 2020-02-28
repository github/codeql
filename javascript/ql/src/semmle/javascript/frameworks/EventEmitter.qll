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
   * Gets a node that refers to an EventEmitter object.
   */
  DataFlow::SourceNode trackEventEmitter(EventEmitter emitter) {
    result = trackEventEmitter(DataFlow::TypeTracker::end(), emitter)
  }

  private DataFlow::SourceNode trackEventEmitter(DataFlow::TypeTracker t, EventEmitter emitter) {
    t.start() and result = emitter
    or
    exists(DataFlow::TypeTracker t2, DataFlow::SourceNode pred |
      pred = trackEventEmitter(t2, emitter)
    |
      result = pred.track(t2, t)
      or
      // invocation of a chainable method
      exists(DataFlow::MethodCallNode mcn |
        mcn = pred.getAMethodCall(chainableMethod()) and
        // exclude getter versions
        exists(mcn.getAnArgument()) and
        result = mcn and
        t = t2.continue()
      )
    )
  }

  /**
   * An object that implements the EventEmitter API.
   * Extending this class does nothing, its mostly to indicate intent.
   *
   * The classes EventRegistration::Range and EventDispatch::Range must be extended to get a working EventEmitter model.
   * An EventRegistration models a method call that registers some event handler on an EventEmitter.
   * And EventDispatch models that some event is dispatched on an EventEmitter.
   *
   * Both the EventRegistration and EventDispatch have a field `emitter`,
   * which is the EventEmitter that events are registered on / dispatched to respectively.
   *
   * Here is a simple JavaScript example with the NodeJS EventEmitter:
   *    var e = new EventEmitter(); // <- EventEmitter
   *    e.on("name", (data) => {...}); // <- EventRegistration
   *    e.emit("name", "foo"); // <- EventDispatch
   */
  abstract class Range extends DataFlow::Node { }
}

/**
 * An EventEmitter instance that implements the EventEmitter API.
 * Extend EventEmitter::Range to mark something as being an EventEmitter.
 */
class EventEmitter extends DataFlow::Node {
  EventEmitter::Range range;

  EventEmitter() { this = range }
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
   * Get a dispatch that this event handler can return a value to.
   * The default implementation is that there exists no such dispatch.
   */
  EventDispatch getAReturnDispatch() { result = range.getAReturnDispatch() }
}

module EventRegistration {
  /**
   * A registration of an event handler on an EventEmitter.
   */
  abstract class Range extends DataFlow::Node {
    EventEmitter::Range emitter;

    final EventEmitter getEmitter() { result = emitter }

    abstract string getChannel();

    abstract DataFlow::Node getReceivedItem(int i);

    DataFlow::Node getAReturnedValue() { none() }

    EventDispatch::Range getAReturnDispatch() { none() }
  }

  /**
   * A default implementation of an EventRegistration.
   * The default implementation assumes that `this` is a DataFlow::InvokeNode where the
   * first argument is a string describing which channel is registered, and the second
   * argument is the event handler callback.
   */
  abstract class DefaultEventRegistration extends Range, DataFlow::InvokeNode {
    override string getChannel() { this.getArgument(0).mayHaveStringValue(result) }

    override DataFlow::Node getReceivedItem(int i) {
      result = this.getABoundCallbackParameter(1, i)
    }
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
   */
  abstract class Range extends DataFlow::Node {
    EventEmitter::Range emitter;

    final EventEmitter getEmitter() { result = emitter }

    abstract string getChannel();

    abstract DataFlow::Node getSentItem(int i);

    abstract EventRegistration::Range getAReceiver();
  }

  /**
   * A default implementation of an EventDispatch.
   * The default implementation assumes that the dispatch is a DataFlow::InvokeNode,
   * where the first argument is a string describing the channel, and the `i`+1 argument
   * is the `i`th item sent to the event handler.
   */
  abstract class DefaultEventDispatch extends Range, DataFlow::InvokeNode {
    override string getChannel() { this.getArgument(0).mayHaveStringValue(result) }

    override DataFlow::Node getSentItem(int i) { result = this.getArgument(i + 1) }

    override EventRegistration::Range getAReceiver() { this.getEmitter() = result.getEmitter() }
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
    dispatch = reg.getAReturnDispatch() and
    pred = reg.getAReturnedValue() and
    succ = dispatch
  }
}
