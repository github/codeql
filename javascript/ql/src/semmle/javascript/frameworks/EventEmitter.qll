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
  abstract class EventEmitter extends DataFlow::Node {
    /**
     * Get a method name that returns `this` on this type of emitter.
     */
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

    /**
     * Get a reference through type-tracking to this EventEmitter. 
     * The type-tracking tracks through chainable methods.
     */
    DataFlow::SourceNode ref() { result = ref(DataFlow::TypeTracker::end()) }
  }

  /**
   * A registration of an event handler on a particular EventEmitter.
   */
  abstract class EventRegistration extends DataFlow::Node {
    EventEmitter emitter;

    /** Gets the EventEmitter that the event handler is registered on. */
    final EventEmitter getEmitter() {
      result = emitter
    }

    /** Gets the name of the channel if possible. */
    abstract string getChannel();

    /** Gets the `i`th parameter in the event handler. */
    abstract DataFlow::Node getEventHandlerParameter(int i);
    
    /**
     * Gets a value that is returned by the event handler. 
     * The default implementation is that no value can be returned.
     */
    DataFlow::Node getAReturnedValue() { none() }
    
    /**
     * Holds if this event handler can return a value to the given `dispatch`. 
     * The default implementation is that there exists no such dispatch. 
     */
    predicate canReturnTo(EventDispatch dispatch) { none() }
  }

  /**
   * A dispatch of an event on an EventEmitter.
   */
  abstract class EventDispatch extends DataFlow::Node {
    EventEmitter emitter;

    /** Gets the emitter that the event dispatch happens on. */    
    final EventEmitter getEmitter() {
      result = emitter
    }
    
    /** Gets the name of the channel if possible. */
    abstract string getChannel();

    /** Gets the `i`th argument that is send to the event handler. */
    abstract DataFlow::Node getDispatchedArgument(int i);
    
    /**
     * Holds if this event dispatch can send an event to the given even registration. 
     * The default implementation is that the emitters of the dispatch and registration have to be equal.
     */
    predicate canSendTo(EventRegistration destination) { this.getEmitter() = destination.getEmitter() }
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

  /**
   * Concrete classes for modeling EventEmitter in NodeJS.
   */
  private module NodeJSEventEmitter {
    private class NodeJSEventEmitter extends EventEmitter {
      NodeJSEventEmitter() {
        exists(DataFlow::SourceNode clazz |
          clazz = DataFlow::moduleImport("events") or
          clazz = DataFlow::moduleMember("events", "EventEmitter")
        |
          this = clazz.getAnInstantiation()
        )
      }
    }

    private class EventEmitterRegistration extends EventRegistration, DataFlow::MethodCallNode {
      EventEmitterRegistration() { this = emitter.ref().getAMethodCall(EventEmitter::on()) }

      override string getChannel() { this.getArgument(0).mayHaveStringValue(result) }

      override DataFlow::Node getEventHandlerParameter(int i) {
        result = this.(DataFlow::MethodCallNode).getABoundCallbackParameter(1, i)
      }    
    }

    private class EventEmitterDispatch extends EventDispatch, DataFlow::MethodCallNode {
      EventEmitterDispatch() {
        this = emitter.ref().getAMethodCall("emit")
      }

      override string getChannel() { this.getArgument(0).mayHaveStringValue(result) }

      override DataFlow::Node getDispatchedArgument(int i) { result = this.getArgument(i + 1) }
    }
  }
}
