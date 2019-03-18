/**
 * Provides classes and predicates for reasoning about code using the Firebase API.
 */
import javascript

module Firebase {
  /** Gets a reference to the firebase API object. */
  private DataFlow::SourceNode firebase(DataFlow::TypeTracker t) {
    t.start() and
    (
      result = DataFlow::moduleImport("firebase/app")
      or
      result = DataFlow::moduleImport("firebase-admin")
      or
      result = DataFlow::globalVarRef("firebase")
    )
    or
    exists (DataFlow::TypeTracker t2 |
      result = firebase(t2).track(t2, t)
    )
  }

  /** Gets a reference to the `firebase/app` or `firebase-admin` API object. */
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

  module Database {
  
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
  
    /** Gets a node that refers to a `Query` or `Reference` object. */
    DataFlow::SourceNode query(DataFlow::TypeTracker t) {
      t.start() and
      (
        result = ref(t) // a Reference can be used as a Query
        or
        exists (string name | result = query(_).getAMethodCall(name) |
          name = "endAt" or
          name = "limitTo" + any(string s) or
          name = "orderBy" + any(string s) or
          name = "startAt"
        )
      )
      or
      exists (DataFlow::TypeTracker t2 |
        result = query(t2).track(t2, t)
      )
    }
  
    /** Gets a node that refers to a `Query` or `Reference` object. */
    DataFlow::SourceNode query() {
      result = query(_)
    }
    
    /**
     * A call of form `query.on(...)` or `query.once(...)`.
     */
    class QueryListenCall extends DataFlow::MethodCallNode {
      QueryListenCall() {
        this = query().getAMethodCall() and
        (getMethodName() = "on" or getMethodName() = "once")
      }
  
      DataFlow::Node getCallbackNode() {
        result = getArgument(1)
      }
    }
    
    /**
     * Gets a node that is passed as the callback to a `Reference.transaction` call.
     */
    DataFlow::SourceNode transactionCallback(DataFlow::TypeBackTracker t) {
      t.start() and
      result = ref().getAMethodCall("transaction").getArgument(0).getALocalSource()
      or
      exists (DataFlow::TypeBackTracker t2 |
        result = transactionCallback(t2).backtrack(t2, t)
      )
    }
  
    /**
     * Gets a node that is passed as the callback to a `Reference.transaction` call.
     */
    DataFlow::SourceNode transactionCallback() {
      result = transactionCallback(_)
    }
  }

  /**
   * Provides predicates for reasoning about the the Firebase Cloud Functions API,
   * sometimes referred to just as just "Firebase Functions".
   */
  module CloudFunctions {
    /** Gets a reference to the Cloud Functions namespace. */
    DataFlow::SourceNode namespace(DataFlow::TypeTracker t) {
      t.start() and
      result = DataFlow::moduleImport("firebase-functions")
      or
      exists (DataFlow::TypeTracker t2 |
        result = namespace(t2).track(t2, t)
      )
    }
    
    /** Gets a reference to the Cloud Functions namespace. */
    DataFlow::SourceNode namespace() {
      result = namespace(_)
    }

    /** Gets a reference to a Cloud Functions database object. */
    DataFlow::SourceNode database(DataFlow::TypeTracker t) {
      t.start() and
      result = namespace().getAPropertyRead("database")
      or
      exists (DataFlow::TypeTracker t2 |
        result = database(t2).track(t2, t)
      )
    }

    /** Gets a reference to a Cloud Functions database object. */
    DataFlow::SourceNode database() {
      result = database(_)
    }
    
    /** Gets a dataflow node holding a `RefBuilder` object. */
    DataFlow::SourceNode refBuilder(DataFlow::TypeTracker t) {
      t.start() and
      result = database().getAMethodCall("ref")
      or
      exists (DataFlow::TypeTracker t2 |
        result = refBuilder(t2).track(t2, t)
      )
    }

    /** Gets a dataflow node holding a `RefBuilder` object. */
    DataFlow::SourceNode ref() {
      result = refBuilder(_)
    }

    /** Gets a call that registers a listener on a `RefBuilder`, such as `ref.onCreate(...)`. */
    class RefBuilderListenCall extends DataFlow::MethodCallNode {
      RefBuilderListenCall() {
        this = ref().getAMethodCall() and
        getMethodName() = "on" + any(string s)
      }
  
      /**
       * Gets the dataflow node holding the listener callback.
       */
      DataFlow::Node getCallbackNode() {
        result = getArgument(0)
      }
    }
  }
  
  /**
   * Gets a value that will be invoked with a `DataSnapshot` value as its first parameter.
   */
  DataFlow::SourceNode snapshotCallback(DataFlow::TypeBackTracker t) {
    t.start() and
    (
      result = any(Database::QueryListenCall call).getCallbackNode().getALocalSource()
      or
      result = any(CloudFunctions::RefBuilderListenCall call).getCallbackNode().getALocalSource()
    )
    or
    exists (DataFlow::TypeBackTracker t2 |
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
   * Gets a node that refers to a `DataSnapshot` value or a promise or `Change`
   * object containing `DataSnapshot`s.
   */
  DataFlow::SourceNode snapshot(DataFlow::TypeTracker t) {
    t.start() and
    (
      result = snapshotCallback().(DataFlow::FunctionNode).getParameter(0)
      or
      result instanceof Database::QueryListenCall // returns promise
      or
      result = snapshot(_).getAMethodCall("child")
      or
      result = snapshot(_).getAMethodCall("forEach").getCallback(0).getParameter(0)
      or
      exists (string prop | result = snapshot(_).getAPropertyRead(prop) |
        prop = "before" or // only defined on Change objects
        prop = "after"
      )
    )
    or
    promiseTaintStep(snapshot(t), result)
    or
    exists (DataFlow::TypeTracker t2 |
      result = snapshot(t2).track(t2, t)
    )
  }

  /**
   * Gets a node that refers to a `DataSnapshot` value, such as `x` in
   * `firebase.database().ref().on('value', x => {...})`.
   */
  DataFlow::SourceNode snapshot() {
    result = snapshot(_)
  }

  /**
   * A reference to a value obtained from a Firebase database.
   */
  class FirebaseVal extends RemoteFlowSource {
    FirebaseVal() {
      exists (string name | this = snapshot().getAMethodCall(name) |
        name = "val" or
        name = "exportVal"
      )
      or
      this = Database::transactionCallback().(DataFlow::FunctionNode).getParameter(0)
    }

    override string getSourceType() {
      result = "Firebase database"
    }
  }
}
