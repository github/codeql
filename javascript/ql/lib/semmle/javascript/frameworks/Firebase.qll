/**
 * Provides classes and predicates for reasoning about code using the Firebase API.
 */

import javascript

module Firebase {
  /** Gets a reference to the Firebase API object. */
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
    exists(DataFlow::TypeTracker t2 | result = firebase(t2).track(t2, t))
  }

  /** Gets a reference to the `firebase/app` or `firebase-admin` API object. */
  DataFlow::SourceNode firebase() { result = firebase(DataFlow::TypeTracker::end()) }

  /** Gets a reference to a Firebase app created with `initializeApp`. */
  private DataFlow::SourceNode initApp(DataFlow::TypeTracker t) {
    t.start() and
    result = firebase().getAMethodCall("initializeApp")
    or
    t.start() and
    result.hasUnderlyingType("firebase", "app.App")
    or
    exists(DataFlow::TypeTracker t2 | result = initApp(t2).track(t2, t))
  }

  /**
   * Gets a reference to a Firebase app, either the `firebase` object or an
   * app created explicitly with `initializeApp()`.
   */
  DataFlow::SourceNode app() {
    result = firebase(DataFlow::TypeTracker::end()) or
    result = initApp(DataFlow::TypeTracker::end())
  }

  module Database {
    /** Gets a reference to a Firebase database object, such as `firebase.database()`. */
    private DataFlow::SourceNode database(DataFlow::TypeTracker t) {
      result = app().getAMethodCall("database") and t.start()
      or
      t.start() and
      result.hasUnderlyingType("firebase", "database.Database")
      or
      exists(DataFlow::TypeTracker t2 | result = database(t2).track(t2, t))
    }

    /** Gets a reference to a Firebase database object, such as `firebase.database()`. */
    DataFlow::SourceNode database() { result = database(DataFlow::TypeTracker::end()) }

    /** Gets a node that refers to a `Reference` object, such as `firebase.database().ref()`. */
    private DataFlow::SourceNode ref(DataFlow::TypeTracker t) {
      t.start() and
      (
        exists(string name | result = database().getAMethodCall(name) |
          name = "ref" or
          name = "refFromURL"
        )
        or
        exists(string name | result = ref().getAMethodCall(name) |
          name = "push" or
          name = "child"
        )
        or
        exists(string name | result = ref().getAPropertyRead(name) |
          name = "parent" or
          name = "root"
        )
        or
        result = snapshot().getAPropertyRead("ref")
        or
        result.hasUnderlyingType("firebase", "database.Reference")
      )
      or
      exists(DataFlow::TypeTracker t2 | result = ref(t2).track(t2, t))
    }

    /** Gets a node that refers to a `Reference` object, such as `firebase.database().ref()`. */
    DataFlow::SourceNode ref() { result = ref(DataFlow::TypeTracker::end()) }

    /** Gets a node that refers to a `Query` or `Reference` object. */
    private DataFlow::SourceNode query(DataFlow::TypeTracker t) {
      t.start() and
      (
        result = ref(t) // a Reference can be used as a Query
        or
        exists(string name | result = query().getAMethodCall(name) |
          name = "endAt" or
          name = "limitTo" + any(string s) or
          name = "orderBy" + any(string s) or
          name = "startAt"
        )
        or
        result.hasUnderlyingType("firebase", "database.Query")
      )
      or
      exists(DataFlow::TypeTracker t2 | result = query(t2).track(t2, t))
    }

    /** Gets a node that refers to a `Query` or `Reference` object. */
    DataFlow::SourceNode query() { result = query(DataFlow::TypeTracker::end()) }

    /**
     * A call of form `query.on(...)` or `query.once(...)`.
     */
    class QueryListenCall extends DataFlow::MethodCallNode {
      QueryListenCall() {
        this = query().getAMethodCall() and
        (getMethodName() = "on" or getMethodName() = "once")
      }

      /**
       * Gets the argument in which the callback is passed.
       */
      DataFlow::Node getCallbackNode() { result = getArgument(1) }
    }

    /**
     * Gets a node that is passed as the callback to a `Reference.transaction` call.
     */
    private DataFlow::SourceNode transactionCallback(DataFlow::TypeBackTracker t) {
      t.start() and
      result = ref().getAMethodCall("transaction").getArgument(0).getALocalSource()
      or
      exists(DataFlow::TypeBackTracker t2 | result = transactionCallback(t2).backtrack(t2, t))
    }

    /**
     * Gets a node that is passed as the callback to a `Reference.transaction` call.
     */
    DataFlow::SourceNode transactionCallback() {
      result = transactionCallback(DataFlow::TypeBackTracker::end())
    }
  }

  /**
   * Provides predicates for reasoning about the the Firebase Cloud Functions API,
   * sometimes referred to just as just "Firebase Functions".
   */
  module CloudFunctions {
    /** Gets a reference to the Cloud Functions namespace. */
    private DataFlow::SourceNode namespace(DataFlow::TypeTracker t) {
      t.start() and
      result = DataFlow::moduleImport("firebase-functions")
      or
      exists(DataFlow::TypeTracker t2 | result = namespace(t2).track(t2, t))
    }

    /** Gets a reference to the Cloud Functions namespace. */
    DataFlow::SourceNode namespace() { result = namespace(DataFlow::TypeTracker::end()) }

    /** Gets a reference to a Cloud Functions database object. */
    private DataFlow::SourceNode database(DataFlow::TypeTracker t) {
      t.start() and
      result = namespace().getAPropertyRead("database")
      or
      exists(DataFlow::TypeTracker t2 | result = database(t2).track(t2, t))
    }

    /** Gets a reference to a Cloud Functions database object. */
    DataFlow::SourceNode database() { result = database(DataFlow::TypeTracker::end()) }

    /** Gets a data flow node holding a `RefBuilder` object. */
    private DataFlow::SourceNode refBuilder(DataFlow::TypeTracker t) {
      t.start() and
      result = database().getAMethodCall("ref")
      or
      exists(DataFlow::TypeTracker t2 | result = refBuilder(t2).track(t2, t))
    }

    /** Gets a data flow node holding a `RefBuilder` object. */
    DataFlow::SourceNode ref() { result = refBuilder(DataFlow::TypeTracker::end()) }

    /** A call that registers a listener on a `RefBuilder`, such as `ref.onCreate(...)`. */
    class RefBuilderListenCall extends DataFlow::MethodCallNode {
      RefBuilderListenCall() {
        this = ref().getAMethodCall() and
        getMethodName() = "on" + any(string s)
      }

      /**
       * Gets the data flow node holding the listener callback.
       */
      DataFlow::Node getCallbackNode() { result = getArgument(0) }
    }

    /**
     * A call to a Firebase method that sets up a route.
     */
    private class RouteSetup extends HTTP::Servers::StandardRouteSetup, CallExpr {
      RouteSetup() {
        this = namespace().getAPropertyRead("https").getAMemberCall("onRequest").asExpr()
      }

      override DataFlow::SourceNode getARouteHandler() {
        result = getARouteHandler(DataFlow::TypeBackTracker::end())
      }

      private DataFlow::SourceNode getARouteHandler(DataFlow::TypeBackTracker t) {
        t.start() and
        result = getArgument(0).flow().getALocalSource()
        or
        exists(DataFlow::TypeBackTracker t2 | result = getARouteHandler(t2).backtrack(t2, t))
      }

      override Expr getServer() { none() }
    }

    /**
     * A function used as a route handler.
     */
    private class RouteHandler extends Express::RouteHandler, HTTP::Servers::StandardRouteHandler,
      DataFlow::ValueNode {
      override Function astNode;

      RouteHandler() { this = any(RouteSetup setup).getARouteHandler() }

      override Parameter getRouteHandlerParameter(string kind) {
        kind = "request" and result = astNode.getParameter(0)
        or
        kind = "response" and result = astNode.getParameter(1)
      }
    }
  }

  /**
   * Gets a value that will be invoked with a `DataSnapshot` value as its first parameter.
   */
  private DataFlow::SourceNode snapshotCallback(DataFlow::TypeBackTracker t) {
    t.start() and
    (
      result = any(Database::QueryListenCall call).getCallbackNode().getALocalSource()
      or
      result = any(CloudFunctions::RefBuilderListenCall call).getCallbackNode().getALocalSource()
    )
    or
    exists(DataFlow::TypeBackTracker t2 | result = snapshotCallback(t2).backtrack(t2, t))
  }

  /**
   * Gets a value that will be invoked with a `DataSnapshot` value as its first parameter.
   */
  DataFlow::SourceNode snapshotCallback() {
    result = snapshotCallback(DataFlow::TypeBackTracker::end())
  }

  /**
   * Gets a node that refers to a `DataSnapshot` value or a promise or `Change`
   * object containing `DataSnapshot`s.
   */
  private DataFlow::SourceNode snapshot(DataFlow::TypeTracker t) {
    t.start() and
    (
      result = snapshotCallback().(DataFlow::FunctionNode).getParameter(0)
      or
      result instanceof Database::QueryListenCall // returns promise
      or
      result = snapshot().getAMethodCall("child")
      or
      result = snapshot().getAMethodCall("forEach").getCallback(0).getParameter(0)
      or
      exists(string prop | result = snapshot().getAPropertyRead(prop) |
        prop = "before" or // only defined on Change objects
        prop = "after"
      )
      or
      result.hasUnderlyingType("firebase", "database.DataSnapshot")
    )
    or
    TaintTracking::promiseStep(snapshot(t), result)
    or
    exists(DataFlow::TypeTracker t2 | result = snapshot(t2).track(t2, t))
  }

  /**
   * Gets a node that refers to a `DataSnapshot` value, such as `x` in
   * `firebase.database().ref().on('value', x => {...})`.
   */
  DataFlow::SourceNode snapshot() { result = snapshot(DataFlow::TypeTracker::end()) }

  /**
   * A reference to a value obtained from a Firebase database.
   */
  class FirebaseVal extends RemoteFlowSource {
    FirebaseVal() {
      exists(string name | this = snapshot().getAMethodCall(name) |
        name = "val" or
        name = "exportVal"
      )
      or
      this = Database::transactionCallback().(DataFlow::FunctionNode).getParameter(0)
    }

    override string getSourceType() { result = "Firebase database" }
  }
}
