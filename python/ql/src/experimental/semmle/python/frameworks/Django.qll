/**
 * Provides classes modeling security-relevant aspects of the `django` package.
 */

private import python
private import experimental.dataflow.DataFlow
private import experimental.dataflow.RemoteFlowSources
private import experimental.semmle.python.Concepts

/**
 * Provides models for the `django` PyPI package.
 * See https://django.palletsprojects.com/en/1.1.x/.
 */
private module Django {
  /** Gets a reference to the `django` module. */
  private DataFlow::Node django(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importNode("django")
    or
    exists(DataFlow::TypeTracker t2 | result = django(t2).track(t2, t))
  }

  /** Gets a reference to the `django` module. */
  DataFlow::Node django() { result = django(DataFlow::TypeTracker::end()) }

  /** Provides models for the `django` module. */
  module django {
    /** Gets a reference to the `django.db` module. */
    private DataFlow::Node db(DataFlow::TypeTracker t) {
      t.start() and
      result = DataFlow::importNode("django.db")
      or
      t.startInAttr("db") and
      result = django()
      or
      exists(DataFlow::TypeTracker t2 | result = db(t2).track(t2, t))
    }

    /** Gets a reference to the `django.db` module. */
    DataFlow::Node db() { result = db(DataFlow::TypeTracker::end()) }

    /** Provides models for the `django.db` module. */
    module db {
      /** Gets a reference to the `django.db.connection` object. */
      private DataFlow::Node connection(DataFlow::TypeTracker t) {
        t.start() and
        result = DataFlow::importNode("django.db.connection")
        or
        t.startInAttr("connection") and
        result = db()
        or
        exists(DataFlow::TypeTracker t2 | result = connection(t2).track(t2, t))
      }

      /** Gets a reference to the `django.db.connection` object. */
      DataFlow::Node connection() { result = connection(DataFlow::TypeTracker::end()) }

      /** Gets a reference to the `django.db.connection.cursor` class. */
      private DataFlow::Node classCursor(DataFlow::TypeTracker t) {
        t.start() and
        result = DataFlow::importNode("django.db.connection.cursor")
        or
        t.startInAttr("cursor") and
        result = connection()
        or
        exists(DataFlow::TypeTracker t2 | result = classCursor(t2).track(t2, t))
      }

      /** Gets a reference to the `django.db.connection.cursor` class. */
      DataFlow::Node classCursor() { result = classCursor(DataFlow::TypeTracker::end()) }

      /** Gets a reference to an instance of `django.db.connection.cursor`. */
      private DataFlow::Node cursor(DataFlow::TypeTracker t) {
        t.start() and
        result.asCfgNode().(CallNode).getFunction() = classCursor().asCfgNode()
        or
        exists(DataFlow::TypeTracker t2 | result = cursor(t2).track(t2, t))
      }

      /** Gets a reference to an instance of `django.db.connection.cursor`. */
      DataFlow::Node cursor() { result = cursor(DataFlow::TypeTracker::end()) }

      /** Gets a reference to the `django.db.connection.cursor.execute` function. */
      private DataFlow::Node execute(DataFlow::TypeTracker t) {
        t.startInAttr("execute") and
        result = cursor()
        or
        exists(DataFlow::TypeTracker t2 | result = execute(t2).track(t2, t))
      }

      /** Gets a reference to the `django.db.connection.cursor.execute` function. */
      DataFlow::Node execute() { result = execute(DataFlow::TypeTracker::end()) }
    }
  }

  /** A call to the `django.db.connection.cursor.execute` function. */
  private class DbConnectionExecute extends SqlExecution::Range, DataFlow::CfgNode {
    override CallNode node;

    DbConnectionExecute() { node.getFunction() = django::db::execute().asCfgNode() }

    override DataFlow::Node getSql() { result.asCfgNode() = node.getArg(0) }
  }
}
