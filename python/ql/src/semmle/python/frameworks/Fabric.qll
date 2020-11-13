/**
 * Provides classes modeling security-relevant aspects of the `fabric` PyPI package, for
 * both version 1.x and 2.x.
 *
 * See
 * - http://docs.fabfile.org/en/1.14/tutorial.html and
 * - http://docs.fabfile.org/en/2.5/getting-started.html
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts

/**
 * Provides classes modeling security-relevant aspects of the `fabric` PyPI package, for
 * version 1.x.
 *
 * See http://docs.fabfile.org/en/1.14/tutorial.html.
 */
private module FabricV1 {
  /** Gets a reference to the `fabric` module. */
  private DataFlow::Node fabric(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importNode("fabric")
    or
    exists(DataFlow::TypeTracker t2 | result = fabric(t2).track(t2, t))
  }

  /** Gets a reference to the `fabric` module. */
  DataFlow::Node fabric() { result = fabric(DataFlow::TypeTracker::end()) }

  /**
   * Gets a reference to the attribute `attr_name` of the `fabric` module.
   * WARNING: Only holds for a few predefined attributes.
   */
  private DataFlow::Node fabric_attr(DataFlow::TypeTracker t, string attr_name) {
    attr_name in ["api"] and
    (
      t.start() and
      result = DataFlow::importNode("fabric" + "." + attr_name)
      or
      t.startInAttr(attr_name) and
      result = fabric()
    )
    or
    // Due to bad performance when using normal setup with `fabric_attr(t2, attr_name).track(t2, t)`
    // we have inlined that code and forced a join
    exists(DataFlow::TypeTracker t2 |
      exists(DataFlow::StepSummary summary |
        fabric_attr_first_join(t2, attr_name, result, summary) and
        t = t2.append(summary)
      )
    )
  }

  pragma[nomagic]
  private predicate fabric_attr_first_join(
    DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res, DataFlow::StepSummary summary
  ) {
    DataFlow::StepSummary::step(fabric_attr(t2, attr_name), res, summary)
  }

  /**
   * Gets a reference to the attribute `attr_name` of the `fabric` module.
   * WARNING: Only holds for a few predefined attributes.
   */
  private DataFlow::Node fabric_attr(string attr_name) {
    result = fabric_attr(DataFlow::TypeTracker::end(), attr_name)
  }

  /** Provides models for the `fabric` module. */
  module fabric {
    // -------------------------------------------------------------------------
    // fabric.api
    // -------------------------------------------------------------------------
    /** Gets a reference to the `fabric.api` module. */
    DataFlow::Node api() { result = fabric_attr("api") }

    /** Provides models for the `fabric.api` module */
    module api {
      /**
       * Gets a reference to the attribute `attr_name` of the `fabric.api` module.
       * WARNING: Only holds for a few predefined attributes.
       */
      private DataFlow::Node api_attr(DataFlow::TypeTracker t, string attr_name) {
        attr_name in ["run", "local", "sudo"] and
        (
          t.start() and
          result = DataFlow::importNode("fabric.api" + "." + attr_name)
          or
          t.startInAttr(attr_name) and
          result = api()
        )
        or
        // Due to bad performance when using normal setup with `api_attr(t2, attr_name).track(t2, t)`
        // we have inlined that code and forced a join
        exists(DataFlow::TypeTracker t2 |
          exists(DataFlow::StepSummary summary |
            api_attr_first_join(t2, attr_name, result, summary) and
            t = t2.append(summary)
          )
        )
      }

      pragma[nomagic]
      private predicate api_attr_first_join(
        DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res,
        DataFlow::StepSummary summary
      ) {
        DataFlow::StepSummary::step(api_attr(t2, attr_name), res, summary)
      }

      /**
       * Gets a reference to the attribute `attr_name` of the `fabric.api` module.
       * WARNING: Only holds for a few predefined attributes.
       */
      private DataFlow::Node api_attr(string attr_name) {
        result = api_attr(DataFlow::TypeTracker::end(), attr_name)
      }

      /**
       * A call to either
       * - `fabric.api.local`
       * - `fabric.api.run`
       * - `fabric.api.sudo`
       * See
       * - https://docs.fabfile.org/en/1.14/api/core/operations.html#fabric.operations.local
       * - https://docs.fabfile.org/en/1.14/api/core/operations.html#fabric.operations.run
       * - https://docs.fabfile.org/en/1.14/api/core/operations.html#fabric.operations.sudo
       */
      private class FabricApiLocalRunSudoCall extends SystemCommandExecution::Range,
        DataFlow::CfgNode {
        override CallNode node;

        FabricApiLocalRunSudoCall() {
          node.getFunction() = api_attr(["local", "run", "sudo"]).asCfgNode()
        }

        override DataFlow::Node getCommand() {
          result.asCfgNode() = [node.getArg(0), node.getArgByName("command")]
        }
      }
    }
  }
}

/**
 * Provides classes modeling security-relevant aspects of the `fabric` PyPI package, for
 * version 2.x.
 *
 * See http://docs.fabfile.org/en/2.5/getting-st  arted.html.
 */
private module FabricV2 {
  /** Gets a reference to the `fabric` module. */
  private DataFlow::Node fabric(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importNode("fabric")
    or
    exists(DataFlow::TypeTracker t2 | result = fabric(t2).track(t2, t))
  }

  /** Gets a reference to the `fabric` module. */
  DataFlow::Node fabric() { result = fabric(DataFlow::TypeTracker::end()) }

  /**
   * Gets a reference to the attribute `attr_name` of the `fabric` module.
   * WARNING: Only holds for a few predefined attributes.
   */
  private DataFlow::Node fabric_attr(DataFlow::TypeTracker t, string attr_name) {
    attr_name in [
        // connection.py
        "connection", "Connection",
        // group.py
        "group", "SerialGroup", "ThreadingGroup",
        // tasks.py
        "tasks", "task"
      ] and
    (
      t.start() and
      result = DataFlow::importNode("fabric" + "." + attr_name)
      or
      t.startInAttr(attr_name) and
      result = fabric()
    )
    or
    // Due to bad performance when using normal setup with `fabric_attr(t2, attr_name).track(t2, t)`
    // we have inlined that code and forced a join
    exists(DataFlow::TypeTracker t2 |
      exists(DataFlow::StepSummary summary |
        fabric_attr_first_join(t2, attr_name, result, summary) and
        t = t2.append(summary)
      )
    )
  }

  pragma[nomagic]
  private predicate fabric_attr_first_join(
    DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res, DataFlow::StepSummary summary
  ) {
    DataFlow::StepSummary::step(fabric_attr(t2, attr_name), res, summary)
  }

  /**
   * Gets a reference to the attribute `attr_name` of the `fabric` module.
   * WARNING: Only holds for a few predefined attributes.
   */
  private DataFlow::Node fabric_attr(string attr_name) {
    result = fabric_attr(DataFlow::TypeTracker::end(), attr_name)
  }

  /** Provides models for the `fabric` module. */
  module fabric {
    // -------------------------------------------------------------------------
    // fabric.connection
    // -------------------------------------------------------------------------
    /** Gets a reference to the `fabric.connection` module. */
    DataFlow::Node connection() { result = fabric_attr("connection") }

    /** Provides models for the `fabric.connection` module */
    module connection {
      /**
       * Gets a reference to the attribute `attr_name` of the `fabric.connection` module.
       * WARNING: Only holds for a few predefined attributes.
       */
      private DataFlow::Node connection_attr(DataFlow::TypeTracker t, string attr_name) {
        attr_name in ["Connection"] and
        (
          t.start() and
          result = DataFlow::importNode("fabric.connection" + "." + attr_name)
          or
          t.startInAttr(attr_name) and
          result = connection()
        )
        or
        // Due to bad performance when using normal setup with `connection_attr(t2, attr_name).track(t2, t)`
        // we have inlined that code and forced a join
        exists(DataFlow::TypeTracker t2 |
          exists(DataFlow::StepSummary summary |
            connection_attr_first_join(t2, attr_name, result, summary) and
            t = t2.append(summary)
          )
        )
      }

      pragma[nomagic]
      private predicate connection_attr_first_join(
        DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res,
        DataFlow::StepSummary summary
      ) {
        DataFlow::StepSummary::step(connection_attr(t2, attr_name), res, summary)
      }

      /**
       * Gets a reference to the attribute `attr_name` of the `fabric.connection` module.
       * WARNING: Only holds for a few predefined attributes.
       */
      private DataFlow::Node connection_attr(string attr_name) {
        result = connection_attr(DataFlow::TypeTracker::end(), attr_name)
      }

      /**
       * Provides models for the `fabric.connection.Connection` class
       *
       * See https://docs.fabfile.org/en/2.5/api/connection.html#fabric.connection.Connection.
       */
      module Connection {
        /** Gets a reference to the `fabric.connection.Connection` class. */
        private DataFlow::Node classRef(DataFlow::TypeTracker t) {
          t.start() and
          result = connection_attr("Connection")
          or
          // handle `fabric.Connection` alias
          t.start() and
          result = fabric_attr("Connection")
          or
          exists(DataFlow::TypeTracker t2 | result = classRef(t2).track(t2, t))
        }

        /** Gets a reference to the `fabric.connection.Connection` class. */
        DataFlow::Node classRef() { result = classRef(DataFlow::TypeTracker::end()) }

        /**
         * A source of an instance of `fabric.connection.Connection`.
         *
         * This can include instantiation of the class, return value from function
         * calls, or a special parameter that will be set when functions are called by an external
         * library.
         *
         * Use `Connection::instance()` predicate to get references to instances of `fabric.connection.Connection`.
         */
        abstract class InstanceSource extends DataFlow::Node { }

        private class ClassInstantiation extends InstanceSource, DataFlow::CfgNode {
          override CallNode node;

          ClassInstantiation() { node.getFunction() = classRef().asCfgNode() }
        }

        /** Gets a reference to an instance of `fabric.connection.Connection`. */
        private DataFlow::Node instance(DataFlow::TypeTracker t) {
          t.start() and
          result instanceof InstanceSource
          or
          exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
        }

        /** Gets a reference to an instance of `fabric.connection.Connection`. */
        DataFlow::Node instance() { result = instance(DataFlow::TypeTracker::end()) }

        /**
         * Gets a reference to either `run`, `sudo`, or `local` method on a
         * `fabric.connection.Connection` instance.
         *
         * See
         * - https://docs.fabfile.org/en/2.5/api/connection.html#fabric.connection.Connection.run
         * - https://docs.fabfile.org/en/2.5/api/connection.html#fabric.connection.Connection.sudo
         * - https://docs.fabfile.org/en/2.5/api/connection.html#fabric.connection.Connection.local
         */
        private DataFlow::Node instanceRunMethods(DataFlow::TypeTracker t) {
          t.startInAttr(["run", "sudo", "local"]) and
          result = instance()
          or
          exists(DataFlow::TypeTracker t2 | result = instanceRunMethods(t2).track(t2, t))
        }

        /**
         * Gets a reference to either `run`, `sudo`, or `local` method on a
         * `fabric.connection.Connection` instance.
         *
         * See
         * - https://docs.fabfile.org/en/2.5/api/connection.html#fabric.connection.Connection.run
         * - https://docs.fabfile.org/en/2.5/api/connection.html#fabric.connection.Connection.sudo
         * - https://docs.fabfile.org/en/2.5/api/connection.html#fabric.connection.Connection.local
         */
        DataFlow::Node instanceRunMethods() {
          result = instanceRunMethods(DataFlow::TypeTracker::end())
        }
      }
    }

    /**
     * A call to either `run`, `sudo`, or `local` on a `fabric.connection.Connection` instance.
     * See
     * - https://docs.fabfile.org/en/2.5/api/connection.html#fabric.connection.Connection.run
     * - https://docs.fabfile.org/en/2.5/api/connection.html#fabric.connection.Connection.sudo
     * - https://docs.fabfile.org/en/2.5/api/connection.html#fabric.connection.Connection.local
     */
    private class FabricConnectionRunSudoLocalCall extends SystemCommandExecution::Range,
      DataFlow::CfgNode {
      override CallNode node;

      FabricConnectionRunSudoLocalCall() {
        node.getFunction() = fabric::connection::Connection::instanceRunMethods().asCfgNode()
      }

      override DataFlow::Node getCommand() {
        result.asCfgNode() = [node.getArg(0), node.getArgByName("command")]
      }
    }

    // -------------------------------------------------------------------------
    // fabric.tasks
    // -------------------------------------------------------------------------
    /** Gets a reference to the `fabric.tasks` module. */
    DataFlow::Node tasks() { result = fabric_attr("tasks") }

    /** Provides models for the `fabric.tasks` module */
    module tasks {
      /** Gets a reference to the `fabric.tasks.task` decorator. */
      private DataFlow::Node task(DataFlow::TypeTracker t) {
        t.start() and
        result = DataFlow::importNode("fabric.tasks.task")
        or
        t.startInAttr("task") and
        result = tasks()
        or
        // Handle `fabric.task` alias
        t.startInAttr("task") and
        result = fabric()
        or
        exists(DataFlow::TypeTracker t2 | result = task(t2).track(t2, t))
      }

      /** Gets a reference to the `fabric.tasks.task` decorator. */
      DataFlow::Node task() { result = task(DataFlow::TypeTracker::end()) }
    }

    class FabricTaskFirstParamConnectionInstance extends fabric::connection::Connection::InstanceSource,
      DataFlow::ParameterNode {
      FabricTaskFirstParamConnectionInstance() {
        exists(Function func |
          func.getADecorator() = fabric::tasks::task().asExpr() and
          this.getParameter() = func.getArg(0)
        )
      }
    }

    // -------------------------------------------------------------------------
    // fabric.group
    // -------------------------------------------------------------------------
    /** Gets a reference to the `fabric.group` module. */
    DataFlow::Node group() { result = fabric_attr("group") }

    /** Provides models for the `fabric.group` module */
    module group {
      /**
       * Gets a reference to the attribute `attr_name` of the `fabric.group` module.
       * WARNING: Only holds for a few predefined attributes.
       */
      private DataFlow::Node group_attr(DataFlow::TypeTracker t, string attr_name) {
        attr_name in ["SerialGroup", "ThreadingGroup"] and
        (
          t.start() and
          result = DataFlow::importNode("fabric.group" + "." + attr_name)
          or
          t.startInAttr(attr_name) and
          result = group()
        )
        or
        // Due to bad performance when using normal setup with `group_attr(t2, attr_name).track(t2, t)`
        // we have inlined that code and forced a join
        exists(DataFlow::TypeTracker t2 |
          exists(DataFlow::StepSummary summary |
            group_attr_first_join(t2, attr_name, result, summary) and
            t = t2.append(summary)
          )
        )
      }

      pragma[nomagic]
      private predicate group_attr_first_join(
        DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res,
        DataFlow::StepSummary summary
      ) {
        DataFlow::StepSummary::step(group_attr(t2, attr_name), res, summary)
      }

      /**
       * Gets a reference to the attribute `attr_name` of the `fabric.group` module.
       * WARNING: Only holds for a few predefined attributes.
       */
      private DataFlow::Node group_attr(string attr_name) {
        result = group_attr(DataFlow::TypeTracker::end(), attr_name)
      }

      /**
       * Provides models for the `fabric.group.Group` class and its subclasses.
       *
       * `fabric.group.Group` is an abstract class, that has concrete implementations
       * `SerialGroup` and `ThreadingGroup`.
       *
       * See
       * - https://docs.fabfile.org/en/2.5/api/group.html#fabric.group.Group
       * - https://docs.fabfile.org/en/2.5/api/group.html#fabric.group.SerialGroup
       * - https://docs.fabfile.org/en/2.5/api/group.html#fabric.group.ThreadingGroup
       */
      module Group {
        /**
         * A source of an instance of a subclass of `fabric.group.Group`
         *
         * This can include instantiation of a class, return value from function
         * calls, or a special parameter that will be set when functions are called by an external
         * library.
         *
         * Use `Group::subclassInstance()` predicate to get references to an instance of a subclass of `fabric.group.Group`.
         */
        abstract class SubclassInstanceSource extends DataFlow::Node { }

        /** Gets a reference to an instance of a subclass of `fabric.group.Group`. */
        private DataFlow::Node subclassInstance(DataFlow::TypeTracker t) {
          t.start() and
          result instanceof SubclassInstanceSource
          or
          exists(DataFlow::TypeTracker t2 | result = subclassInstance(t2).track(t2, t))
        }

        /** Gets a reference to an instance of a subclass of `fabric.group.Group`. */
        DataFlow::Node subclassInstance() {
          result = subclassInstance(DataFlow::TypeTracker::end())
        }

        /**
         * Gets a reference to the `run` method on an instance of a subclass of `fabric.group.Group`.
         *
         * See https://docs.fabfile.org/en/2.5/api/group.html#fabric.group.Group.run
         */
        private DataFlow::Node subclassInstanceRunMethod(DataFlow::TypeTracker t) {
          t.startInAttr("run") and
          result = subclassInstance()
          or
          exists(DataFlow::TypeTracker t2 | result = subclassInstanceRunMethod(t2).track(t2, t))
        }

        /**
         * Gets a reference to the `run` method on an instance of a subclass of `fabric.group.Group`.
         *
         * See https://docs.fabfile.org/en/2.5/api/group.html#fabric.group.Group.run
         */
        DataFlow::Node subclassInstanceRunMethod() {
          result = subclassInstanceRunMethod(DataFlow::TypeTracker::end())
        }
      }

      /**
       * A call to `run` on an instance of a subclass of `fabric.group.Group`.
       *
       * See https://docs.fabfile.org/en/2.5/api/group.html#fabric.group.Group.run
       */
      private class FabricGroupRunCall extends SystemCommandExecution::Range, DataFlow::CfgNode {
        override CallNode node;

        FabricGroupRunCall() {
          node.getFunction() = fabric::group::Group::subclassInstanceRunMethod().asCfgNode()
        }

        override DataFlow::Node getCommand() {
          result.asCfgNode() = [node.getArg(0), node.getArgByName("command")]
        }
      }

      /**
       * Provides models for the `fabric.group.SerialGroup` class
       *
       * See https://docs.fabfile.org/en/2.5/api/group.html#fabric.group.SerialGroup.
       */
      module SerialGroup {
        /** Gets a reference to the `fabric.group.SerialGroup` class. */
        private DataFlow::Node classRef(DataFlow::TypeTracker t) {
          t.start() and
          result = group_attr("SerialGroup")
          or
          // Handle `fabric.SerialGroup` alias
          t.start() and
          result = fabric_attr("SerialGroup")
          or
          exists(DataFlow::TypeTracker t2 | result = classRef(t2).track(t2, t))
        }

        /** Gets a reference to the `fabric.group.SerialGroup` class. */
        private DataFlow::Node classRef() { result = classRef(DataFlow::TypeTracker::end()) }

        private class ClassInstantiation extends Group::SubclassInstanceSource, DataFlow::CfgNode {
          override CallNode node;

          ClassInstantiation() { node.getFunction() = classRef().asCfgNode() }
        }
      }

      /**
       * Provides models for the `fabric.group.ThreadingGroup` class
       *
       * See https://docs.fabfile.org/en/2.5/api/group.html#fabric.group.ThreadingGroup.
       */
      module ThreadingGroup {
        /** Gets a reference to the `fabric.group.ThreadingGroup` class. */
        private DataFlow::Node classRef(DataFlow::TypeTracker t) {
          t.start() and
          result = group_attr("ThreadingGroup")
          or
          // Handle `fabric.ThreadingGroup` alias
          t.start() and
          result = fabric_attr("ThreadingGroup")
          or
          exists(DataFlow::TypeTracker t2 | result = classRef(t2).track(t2, t))
        }

        /** Gets a reference to the `fabric.group.ThreadingGroup` class. */
        DataFlow::Node classRef() { result = classRef(DataFlow::TypeTracker::end()) }

        private class ClassInstantiation extends Group::SubclassInstanceSource, DataFlow::CfgNode {
          override CallNode node;

          ClassInstantiation() { node.getFunction() = classRef().asCfgNode() }
        }
      }
    }
  }
}
