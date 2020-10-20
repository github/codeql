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

      /** Gets a reference to the `django.db.models` module. */
      private DataFlow::Node models(DataFlow::TypeTracker t) {
        t.start() and
        result = DataFlow::importNode("django.db.models")
        or
        t.startInAttr("models") and
        result = django()
        or
        exists(DataFlow::TypeTracker t2 | result = models(t2).track(t2, t))
      }

      /** Gets a reference to the `django.db.models` module. */
      DataFlow::Node models() { result = models(DataFlow::TypeTracker::end()) }

      /** Provides models for the `django.db.models` module. */
      module models {
        /** Gets a reference to the `django.db.models.Model` class. */
        private DataFlow::Node classModel(DataFlow::TypeTracker t) {
          t.start() and
          result = DataFlow::importNode("django.db.models.Model")
          or
          t.startInAttr("Model") and
          result = models()
          or
          exists(DataFlow::TypeTracker t2 | result = classModel(t2).track(t2, t))
        }

        /** Gets a reference to the `django.db.models.Model` class. */
        DataFlow::Node classModel() { result = classModel(DataFlow::TypeTracker::end()) }

        /** Gets a definition of a subclass the `django.db.models.Model` class. */
        class ClassModelSubclassDef extends ControlFlowNode {
          string name;

          ClassModelSubclassDef() {
            exists(ClassExpr ce |
              this.getNode() = ce and
              ce.getABase() = classModel().asExpr() and
              ce.getName() = name
            )
          }

          string getName() { result = name }
        }

        /**
         * A reference to a class that is a subclass of the `django.db.models.Model` class.
         * This is quite an approximation, since it simply matches identifiers.
         */
        class ClassModelSubclass extends DataFlow::CfgNode {
          override NameNode node;

          ClassModelSubclass() { node.getId() = any(ClassModelSubclassDef cd).getName() }
        }

        /** Gets a reference to the `objects` object of a django model. */
        private DataFlow::Node objects(DataFlow::TypeTracker t) {
          t.startInAttr("objects") and
          result instanceof ClassModelSubclass
          or
          exists(DataFlow::TypeTracker t2 | result = objects(t2).track(t2, t))
        }

        /** Gets a reference to the `objects` object of a model. */
        DataFlow::Node objects() { result = objects(DataFlow::TypeTracker::end()) }

        /**
         * Gets a reference to the attribute `attr_name` of an `objects` object.
         * WARNING: Only holds for a few predefined attributes.
         */
        private DataFlow::Node objects_attr(DataFlow::TypeTracker t, string attr_name) {
          attr_name in ["annotate", "extra", "raw"] and
          t.startInAttr(attr_name) and
          result = objects()
          or
          // Due to bad performance when using normal setup with `objects_attr(t2, attr_name).track(t2, t)`
          // we have inlined that code and forced a join
          exists(DataFlow::TypeTracker t2 |
            exists(DataFlow::StepSummary summary |
              objects_attr_first_join(t2, attr_name, result, summary) and
              t = t2.append(summary)
            )
          )
        }

        pragma[nomagic]
        private predicate objects_attr_first_join(
          DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res,
          DataFlow::StepSummary summary
        ) {
          DataFlow::StepSummary::step(objects_attr(t2, attr_name), res, summary)
        }

        /**
         * Gets a reference to the attribute `attr_name` of an `objects` object.
         * WARNING: Only holds for a few predefined attributes.
         */
        DataFlow::Node objects_attr(string attr_name) {
          result = objects_attr(DataFlow::TypeTracker::end(), attr_name)
        }

        /** Gets a reference to the `django.db.models.expressions` object. */
        private DataFlow::Node expressions(DataFlow::TypeTracker t) {
          t.start() and
          result = DataFlow::importNode("django.db.models.expressions")
          or
          t.startInAttr("expressions") and
          result = models()
          or
          exists(DataFlow::TypeTracker t2 | result = expressions(t2).track(t2, t))
        }

        /** Gets a reference to the `django.db.models.expressions` object. */
        DataFlow::Node expressions() { result = expressions(DataFlow::TypeTracker::end()) }

        /** Gets a reference to the `django.db.models.expressions.RawSQL` class. */
        private DataFlow::Node classRawSQL(DataFlow::TypeTracker t) {
          t.start() and
          result = DataFlow::importNode("django.db.models.expressions.RawSQL")
          or
          t.startInAttr("RawSQL") and
          result = expressions()
          or
          exists(DataFlow::TypeTracker t2 | result = classRawSQL(t2).track(t2, t))
        }

        /** Gets a reference to the `django.db.models.expressions.RawSQL` class. */
        DataFlow::Node classRawSQL() { result = classRawSQL(DataFlow::TypeTracker::end()) }
      }
    }
  }

  /** A call to the `django.db.connection.cursor.execute` function. */
  private class DbConnectionExecute extends SqlExecution::Range, DataFlow::CfgNode {
    override CallNode node;

    DbConnectionExecute() { node.getFunction() = django::db::execute().asCfgNode() }

    override DataFlow::Node getSql() { result.asCfgNode() = node.getArg(0) }
  }

  /** A call to the `annotate` function on a model using a `RawSQL` argument. */
  private class ObjectsAnnotate extends SqlExecution::Range, DataFlow::CfgNode {
    override CallNode node;
    CallNode raw;

    ObjectsAnnotate() {
      node.getFunction() = django::db::models::objects_attr("annotate").asCfgNode() and
      raw = node.getArg(0) and
      raw.getFunction() = django::db::models::classRawSQL().asCfgNode()
    }

    override DataFlow::Node getSql() { result.asCfgNode() = raw.getArg(0) }
  }

  /** A call to the `raw` function on a model. */
  private class ObjectsRaw extends SqlExecution::Range, DataFlow::CfgNode {
    override CallNode node;

    ObjectsRaw() { node.getFunction() = django::db::models::objects_attr("raw").asCfgNode() }

    override DataFlow::Node getSql() { result.asCfgNode() = node.getArg(0) }
  }

  /** A call to the `raw` function on a model. */
  private class ObjectsExtra extends SqlExecution::Range, DataFlow::CfgNode {
    override CallNode node;

    ObjectsExtra() { node.getFunction() = django::db::models::objects_attr("extra").asCfgNode() }

    override DataFlow::Node getSql() { result.asCfgNode() = node.getArg(0) }
  }
}
