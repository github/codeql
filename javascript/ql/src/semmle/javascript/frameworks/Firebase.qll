import javascript

module Firebase {
  
  /** Gets a reference to the firebase API object. */
  private DataFlow::SourceNode firebase(DataFlow::TypeTracker t) {
    result = DataFlow::moduleImport("firebase/app") and t.start()
    or
    result = DataFlow::globalVarRef("firebase") and t.start()
    or
    exists (DataFlow::TypeTracker t2 |
      result = firebase(t2).track(t2, t)
    )
  }

  /** Gets a reference to the firebase API object. */
  DataFlow::SourceNode firebase() {
    result = firebase(_)
  }

  /** Gets a reference to a firebase app created with `initializeApp`. */
  private DataFlow::SourceNode initApp(DataFlow::TypeTracker t) {
    result = firebase().getAMethodCall("initializeApp") and t.start()
    or
    exists (DataFlow::TypeTracker t2 |
      result = initApp(t2).track(t2, t)
    )
  }

  /**
   * Gets a reference to a firebase app, either the `firebase` object or an
   * app created explicitly with `initializeApp()`.
   */
  DataFlow::SourceNode app() {
    result = firebase(_) or result = initApp(_)
  }

  /** Gets a reference to a firebase database object, such as `firebase.database()`. */
  private DataFlow::SourceNode database(DataFlow::TypeTracker t) {
    result = app().getAMethodCall("database") and t.start()
    or
    exists (DataFlow::TypeTracker t2 |
      result = database(t2).track(t2, t)
    )
  }

  /** Gets a reference to a firebase database object, such as `firebase.database()`. */
  DataFlow::SourceNode database() {
    result = database(_)
  }

  /** Gets a node that refers to a `Reference` object, such as `firebase.database().ref()`. */
  DataFlow::SourceNode ref(DataFlow::TypeTracker t) {
    t.start() and
    (
      exists (string name | result = database().getAMethodCall(name) |
        name = "ref" or
        name = "refFromURL"
      )
      or
      exists (string name | result = ref(_).getAMethodCall(name) |
        name = "push" or
        name = "child"
      )
      or
      exists (string name | result = ref(_).getAPropertyRead(name) |
        name = "parent" or
        name = "root"
      )
      or
      result = snapshot().getAPropertyRead("ref")
    )
    or
    exists (DataFlow::TypeTracker t2 |
      result = ref(t2).track(t2, t)
    )
  }

  /** Gets a node that refers to a `Reference` object, such as `firebase.database().ref()`. */
  DataFlow::SourceNode ref() {
    result = ref(_)
  }
  
  /**
   * A call of form `ref.on(...)` or `ref.once(...)`.
   */
  class RefListenCall extends DataFlow::MethodCallNode {
    RefListenCall() {
      this = ref().getAMethodCall() and
      (getMethodName() = "on" or getMethodName() = "once")
    }

    DataFlow::Node getCallbackNode() {
      result = getArgument(1)
    }
  }

  /**
   * Gets a value that will be invoked with a `DataSnapshot` value as its first parameter.
   */
  DataFlow::SourceNode snapshotCallback(DataFlow::TypeTracker t) {
    t.start() and
    result = any(RefListenCall call).getCallbackNode().getALocalSource()
    or
    exists (DataFlow::TypeTracker t2 |
      result = snapshotCallback(t2).backtrack(t2, t)
    )
  }

  /**
   * Gets a value that will be invoked with a `DataSnapshot` value as its first parameter.
   */
  DataFlow::SourceNode snapshotCallback() {
    result = snapshotCallback(_)
  }

  /**
   * Gets a node that refers to a `DataSnapshot` value, such as `x` in
   * `firebase.database().ref().on('value', x => {...})`.
   */
  DataFlow::SourceNode snapshot(DataFlow::TypeTracker t) {
    t.start() and
    (
      result = snapshotCallback().(DataFlow::FunctionNode).getParameter(0)
      or
      result instanceof RefListenCall // returns promise
      or
      result = snapshot(_).getAMethodCall("child")
      or
      result = snapshot(_).getAMethodCall("forEach").getCallback(0).getParameter(0)
    )
    or
    promiseTaintStep(snapshot(t), result)
    or
    exists (DataFlow::TypeTracker t2 |
      result = ref(t2).track(t2, t)
    )
  }

  /**
   * Gets a node that refers to a `DataSnapshot` value, such as `x` in
   * `firebase.database().ref().on('value', x => {...})`.
   */
  DataFlow::SourceNode snapshot() {
    result = snapshot(_)
  }
  
  class FirebaseVal extends RemoteFlowSource {
    FirebaseVal() {
      exists (string name | this = snapshot().getAMethodCall(name) |
        name = "val" or
        name = "exportVal"
      )
    }

    override string getSourceType() {
      result = "Firebase database"
    }
  }
}
