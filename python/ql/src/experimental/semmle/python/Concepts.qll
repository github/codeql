/**
 * Provides abstract classes representing generic concepts such as file system
 * access or system command execution, for which individual framework libraries
 * provide concrete subclasses.
 */

import python
private import experimental.dataflow.DataFlow
private import experimental.semmle.python.Frameworks

/**
 * A data-flow node that executes an operating system command,
 * for instance by spawning a new process.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `SystemCommandExecution::Range` instead.
 */
class SystemCommandExecution extends DataFlow::Node {
  SystemCommandExecution::Range self;

  SystemCommandExecution() { this = self }

  /** Gets the argument that specifies the command to be executed. */
  DataFlow::Node getCommand() { result = self.getCommand() }
}

/** Provides a class for modeling new system-command execution APIs. */
module SystemCommandExecution {
  /**
   * A data-flow node that executes an operating system command,
   * for instance by spawning a new process.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `SystemCommandExecution` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets the argument that specifies the command to be executed. */
    abstract DataFlow::Node getCommand();
  }
}

/** Provides classes for modeling HTTP-related APIs. */
module HTTP {
  /** Provides classes for modeling HTTP servers. */
  module Server {
    /**
     * An data-flow node that sets up a route on a server.
     *
     * Extend this class to model new APIs. If you want to model new APIs,
     * extend `RouteSetup::Range` instead.
     */
    class RouteSetup extends DataFlow::Node {
      RouteSetup::Range range;

      RouteSetup() { this = range }

      /** Gets the URL pattern for this route, if it can be statically determined. */
      string getUrlPattern() { result = range.getUrlPattern() }

      /** Gets a function that will handle incoming requests for this route, if any. */
      Function getARouteHandler() { result = range.getARouteHandler() }

      /**
       * Gets a parameter that will receive parts of the url when handling incoming
       * requests for this route, if any. These automatically become a `RemoteFlowSource`.
       */
      Parameter getARoutedParameter() { result = range.getARoutedParameter() }
    }

    /** Provides a class for modeling new HTTP routing APIs. */
    module RouteSetup {
      /**
       * An data-flow node that sets up a route on a server.
       *
       * Extend this class to model new APIs. If you want to refine existing API models,
       * extend `RouteSetup` instead.
       */
      abstract class Range extends DataFlow::Node {
        /** Gets the URL pattern for this route, if it can be statically determined. */
        abstract string getUrlPattern();

        /** Gets a function that will handle incoming requests for this route, if any. */
        abstract Function getARouteHandler();

        /**
         * Gets a parameter that will receive parts of the url when handling incoming
         * requests for this route, if any. These automatically become a `RemoteFlowSource`.
         */
        abstract Parameter getARoutedParameter();
      }
    }
  }
}
