/**
 * Provides abstract classes representing generic concepts such as file system
 * access or system command execution, for which individual framework libraries
 * provide concrete subclasses.
 */

import python
private import experimental.dataflow.DataFlow
private import experimental.semmle.python.Frameworks
private import experimental.dataflow.RemoteFlowSources

/**
 * A data-flow node that executes an operating system command,
 * for instance by spawning a new process.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `SystemCommandExecution::Range` instead.
 */
class SystemCommandExecution extends DataFlow::Node {
  SystemCommandExecution::Range range;

  SystemCommandExecution() { this = range }

  /** Gets the argument that specifies the command to be executed. */
  DataFlow::Node getCommand() { result = range.getCommand() }
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

/**
 * A data-flow node that decodes data from a binary or textual format. This
 * is intended to include deserialization, unmarshalling, decoding, unpickling,
 * decompressing, decrypting, parsing etc.
 *
 * Doing so should normally preserve taint, but it can also be a problem
 * in itself, e.g. if it allows code execution or could result in denial-of-service.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `Decoding::Range` instead.
 */
class Decoding extends DataFlow::Node {
  Decoding::Range range;

  Decoding() { this = range }

  /** Holds if this call may execute code embedded in its input. */
  predicate mayExecuteInput() { range.mayExecuteInput() }

  /** Gets an input that is decoded by this function. */
  DataFlow::Node getAnInput() { result = range.getAnInput() }

  /** Gets the output that contains the decoded data produced by this function. */
  DataFlow::Node getOutput() { result = range.getOutput() }

  /** Gets an identifier for the format this function decodes from, such as "JSON". */
  string getFormat() { result = range.getFormat() }
}

/** Provides a class for modeling new decoding mechanisms. */
module Decoding {
  /**
   * A data-flow node that decodes data from a binary or textual format. This
   * is intended to include deserialization, unmarshalling, decoding, unpickling,
   * decompressing, decrypting, parsing etc.
   *
   * Doing so should normally preserve taint, but it can also be a problem
   * in itself, e.g. if it allows code execution or could result in denial-of-service.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `Decoding` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Holds if this call may execute code embedded in its input. */
    abstract predicate mayExecuteInput();

    /** Gets an input that is decoded by this function. */
    abstract DataFlow::Node getAnInput();

    /** Gets the output that contains the decoded data produced by this function. */
    abstract DataFlow::Node getOutput();

    /** Gets an identifier for the format this function decodes from, such as "JSON". */
    abstract string getFormat();
  }
}

/**
 * A data-flow node that dynamically executes Python code.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `CodeExecution::Range` instead.
 */
class CodeExecution extends DataFlow::Node {
  CodeExecution::Range range;

  CodeExecution() { this = range }

  /** Gets the argument that specifies the code to be executed. */
  DataFlow::Node getCode() { result = range.getCode() }
}

/** Provides a class for modeling new dynamic code execution APIs. */
module CodeExecution {
  /**
   * A data-flow node that dynamically executes Python code.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `CodeExecution` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets the argument that specifies the code to be executed. */
    abstract DataFlow::Node getCode();
  }
}

/** Provides classes for modeling HTTP-related APIs. */
module HTTP {
  /** Provides classes for modeling HTTP servers. */
  module Server {
    /**
     * An data-flow node that sets up a route on a server.
     *
     * Extend this class to refine existing API models. If you want to model new APIs,
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

    private class RoutedParameter extends RemoteFlowSource::Range, DataFlow::ParameterNode {
      RoutedParameter() { this.getParameter() = any(RouteSetup setup).getARoutedParameter() }

      override string getSourceType() { result = "RoutedParameter" }
    }
  }
}
