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
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.data.ModelsAsData

/**
 * Provides classes modeling security-relevant aspects of the `fabric` PyPI package, for
 * version 1.x.
 *
 * See http://docs.fabfile.org/en/1.14/tutorial.html.
 */
private module FabricV1 {
  /** Gets a reference to the `fabric` module. */
  API::Node fabric() { result = API::moduleImport("fabric") }

  /** Provides models for the `fabric` module. */
  module Fabric {
    // -------------------------------------------------------------------------
    // fabric.api
    // -------------------------------------------------------------------------
    /** Gets a reference to the `fabric.api` module. Also known as `fabric.operations` */
    API::Node api() { result = fabric().getMember(["api", "operations"]) }

    /** Provides models for the `fabric.api` module */
    module Api {
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
      private class FabricApiLocalRunSudoCall extends SystemCommandExecution::Range, API::CallNode {
        FabricApiLocalRunSudoCall() { this = api().getMember(["local", "run", "sudo"]).getACall() }

        override DataFlow::Node getCommand() {
          result = [this.getArg(0), this.getArgByName("command")]
        }

        override predicate isShellInterpreted(DataFlow::Node arg) {
          arg = this.getCommand() and
          // defaults to running in a shell
          not this.getParameter(1, "shell")
              .getAValueReachingSink()
              .asExpr()
              .(ImmutableLiteral)
              .booleanValue() = false
        }
      }
    }
  }
}

/**
 * INTERNAL: Do not use.
 *
 * Provides classes modeling security-relevant aspects of the `fabric` PyPI package, for
 * version 2.x.
 *
 * See http://docs.fabfile.org/en/2.5/getting-started.html.
 */
module FabricV2 {
  /** Gets a reference to the `fabric` module. */
  API::Node fabric() { result = API::moduleImport("fabric") }

  /** Provides models for the `fabric` module. */
  module Fabric {
    // -------------------------------------------------------------------------
    // fabric.connection
    // -------------------------------------------------------------------------
    /** Gets a reference to the `fabric.connection` module. */
    API::Node connection() { result = fabric().getMember("connection") }

    /** Provides models for the `fabric.connection` module */
    module Connection {
      /**
       * Provides models for the `fabric.connection.Connection` class
       *
       * See https://docs.fabfile.org/en/2.5/api/connection.html#fabric.connection.Connection.
       */
      module ConnectionClass {
        /**
         *  Gets a reference to the `fabric.connection.Connection` class.
         */
        API::Node classRef() {
          result = fabric().getMember("Connection")
          or
          result = connection().getMember("Connection")
          or
          result =
            ModelOutput::getATypeNode("fabric.connection.Connection~Subclass").getASubclass*()
        }

        /**
         * A source of instances of `fabric.connection.Connection`, extend this class to model new instances.
         *
         * This can include instantiations of the class, return values from function
         * calls, or a special parameter that will be set when functions are called by an external
         * library.
         */
        abstract class Instance extends API::Node {
          override string toString() { result = this.(API::Node).toString() }
        }

        /**
         *  A reference to the `fabric.connection.Connection` class.
         */
        class ClassInstantiation extends Instance {
          ClassInstantiation() { this = classRef().getReturn() }
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
        API::CallNode instanceRunMethods() {
          result = any(Instance is).getMember(["run", "sudo", "local"]).getACall()
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
      API::CallNode
    {
      FabricConnectionRunSudoLocalCall() {
        this = Fabric::Connection::ConnectionClass::instanceRunMethods()
      }

      override DataFlow::Node getCommand() { result = this.getParameter(0, "command").asSink() }

      override predicate isShellInterpreted(DataFlow::Node arg) { arg = this.getCommand() }
    }

    /**
     * A `gateway` parameter of `fabric.connection.Connection` instance is considered as ssh proxy_command option and can execute command.
     * See https://docs.fabfile.org/en/latest/api/connection.html#fabric.connection.Connection
     */
    private class FabricConnectionProxyCommand extends SystemCommandExecution::Range, API::CallNode {
      FabricConnectionProxyCommand() {
        this = Fabric::Connection::ConnectionClass::classRef().getACall() and
        // we want to make sure that the connection is established otherwise the command of proxy_command won't run.
        exists(
          this.getAMethodCall([
              "run", "get", "sudo", "open_gateway", "open", "create_session", "forward_local",
              "forward_remote", "put", "shell", "sftp"
            ])
        )
      }

      override DataFlow::Node getCommand() { result = this.getParameter(4, "gateway").asSink() }

      override predicate isShellInterpreted(DataFlow::Node arg) { none() }
    }

    // -------------------------------------------------------------------------
    // fabric.tasks
    // -------------------------------------------------------------------------
    /** Gets a reference to the `fabric.tasks` module. */
    API::Node tasks() { result = fabric().getMember("tasks") }

    /** Provides models for the `fabric.tasks` module */
    module Tasks {
      /** Gets a reference to the `fabric.tasks.task` decorator. */
      API::Node task() { result in [tasks().getMember("task"), fabric().getMember("task")] }
    }

    class FabricTaskFirstParamConnectionInstance extends Fabric::Connection::ConnectionClass::Instance
    {
      FabricTaskFirstParamConnectionInstance() {
        this = Fabric::Tasks::task().getParameter(0).getParameter(0)
      }
    }

    // -------------------------------------------------------------------------
    // fabric.group
    // -------------------------------------------------------------------------
    /** Gets a reference to the `fabric.group` module. */
    API::Node group() { result = fabric().getMember("group") }

    /** Provides models for the `fabric.group` module */
    module Group {
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
      module GroupClass {
        /**
         * A source of instances of a subclass of `fabric.group, extend this class to model new instances.Group`
         *
         * This can include instantiation of a class, return value from function
         * calls, or a special parameter that will be set when functions are called by an external
         * library.
         *
         * Use `Group::subclassInstance()` predicate to get references to an instance of a subclass of `fabric.group.Group`.
         */
        abstract class ModeledSubclass extends API::Node {
          /** Gets a string representation of this element. */
          override string toString() { result = this.(API::Node).toString() }
        }

        /** Gets a reference to an instance of a subclass of `fabric.group.Group`. */
        API::Node subclassInstance() { result = any(ModeledSubclass m).getASubclass*().getReturn() }

        /**
         * Gets a reference to the `run` and `sudo` methods on an instance of a subclass of `fabric.group.Group`.
         *
         * See https://docs.fabfile.org/en/2.5/api/group.html#fabric.group.Group.run
         * See https://docs.fabfile.org/en/latest/api/group.html#fabric.group.Group.sudo
         */
        API::Node subclassInstanceRunMethod() {
          result = subclassInstance().getMember(["run", "sudo"])
        }
      }

      /**
       * A call to `run` on an instance of a subclass of `fabric.group.Group`.
       *
       * See https://docs.fabfile.org/en/2.5/api/group.html#fabric.group.Group.run
       */
      private class FabricGroupRunCall extends SystemCommandExecution::Range, API::CallNode {
        FabricGroupRunCall() {
          this = Fabric::Group::GroupClass::subclassInstanceRunMethod().getACall()
        }

        override DataFlow::Node getCommand() { result = this.getParameter(0, "command").asSink() }

        override predicate isShellInterpreted(DataFlow::Node arg) { arg = this.getCommand() }
      }

      /**
       * Provides models for the `fabric.group.SerialGroup` class
       *
       * See https://docs.fabfile.org/en/2.5/api/group.html#fabric.group.SerialGroup.
       */
      module SerialGroup {
        private class ClassInstantiation extends GroupClass::ModeledSubclass {
          ClassInstantiation() {
            this = group().getMember("SerialGroup")
            or
            this = fabric().getMember("SerialGroup")
          }
        }
      }

      /**
       * Provides models for the `fabric.group.ThreadingGroup` class
       *
       * See https://docs.fabfile.org/en/2.5/api/group.html#fabric.group.ThreadingGroup.
       */
      module ThreadingGroup {
        private class ClassInstantiation extends GroupClass::ModeledSubclass {
          ClassInstantiation() {
            this = group().getMember("ThreadingGroup")
            or
            this = fabric().getMember("ThreadingGroup")
          }
        }
      }
    }
  }
}
