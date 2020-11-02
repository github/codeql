/**
 * Provides abstract classes representing generic concepts such as file system
 * access or system command execution, for which individual framework libraries
 * provide concrete subclasses.
 */

import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Frameworks

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
 * A data flow node that performs a file system access, including reading and writing data,
 * creating and deleting files and folders, checking and updating permissions, and so on.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `FileSystemAccess::Range` instead.
 */
class FileSystemAccess extends DataFlow::Node {
  FileSystemAccess::Range range;

  FileSystemAccess() { this = range }

  /** Gets an argument to this file system access that is interpreted as a path. */
  DataFlow::Node getAPathArgument() { result = range.getAPathArgument() }
}

/** Provides a class for modeling new file system access APIs. */
module FileSystemAccess {
  /**
   * A data-flow node that performs a file system access, including reading and writing data,
   * creating and deleting files and folders, checking and updating permissions, and so on.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `FileSystemAccess` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets an argument to this file system access that is interpreted as a path. */
    abstract DataFlow::Node getAPathArgument();
  }
}

/** Provides classes for modeling path-related APIs. */
module Path {
  /**
   * A data-flow node that performs path normalization. This is often needed in order
   * to safely access paths.
   */
  class PathNormalization extends DataFlow::Node {
    PathNormalization::Range range;

    PathNormalization() { this = range }
  }

  /** Provides a class for modeling new path normalization APIs. */
  module PathNormalization {
    /**
     * A data-flow node that performs path normalization. This is often needed in order
     * to safely access paths.
     */
    abstract class Range extends DataFlow::Node { }
  }

  /** A data-flow node that checks that a path is safe to access. */
  class SafeAccessCheck extends DataFlow::BarrierGuard {
    SafeAccessCheck::Range range;

    SafeAccessCheck() { this = range }

    override predicate checks(ControlFlowNode node, boolean branch) { range.checks(node, branch) }
  }

  /** Provides a class for modeling new path safety checks. */
  module SafeAccessCheck {
    /** A data-flow node that checks that a path is safe to access. */
    abstract class Range extends DataFlow::BarrierGuard { }
  }
}

/**
 * A data-flow node that decodes data from a binary or textual format. This
 * is intended to include deserialization, unmarshalling, decoding, unpickling,
 * decompressing, decrypting, parsing etc.
 *
 * A decoding (automatically) preserves taint from input to output. However, it can
 * also be a problem in itself, for example if it allows code execution or could result
 * in denial-of-service.
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
   * A decoding (automatically) preserves taint from input to output. However, it can
   * also be a problem in itself, for example if it allows code execution or could result
   * in denial-of-service.
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

private class DecodingAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
  override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    exists(Decoding decoding |
      nodeFrom = decoding.getAnInput() and
      nodeTo = decoding.getOutput()
    )
  }
}

/**
 * A data-flow node that encodes data to a binary or textual format. This
 * is intended to include serialization, marshalling, encoding, pickling,
 * compressing, encrypting, etc.
 *
 * An encoding (automatically) preserves taint from input to output.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `Encoding::Range` instead.
 */
class Encoding extends DataFlow::Node {
  Encoding::Range range;

  Encoding() { this = range }

  /** Gets an input that is encoded by this function. */
  DataFlow::Node getAnInput() { result = range.getAnInput() }

  /** Gets the output that contains the encoded data produced by this function. */
  DataFlow::Node getOutput() { result = range.getOutput() }

  /** Gets an identifier for the format this function decodes from, such as "JSON". */
  string getFormat() { result = range.getFormat() }
}

/** Provides a class for modeling new encoding mechanisms. */
module Encoding {
  /**
   * A data-flow node that encodes data to a binary or textual format. This
   * is intended to include serialization, marshalling, encoding, pickling,
   * compressing, encrypting, etc.
   *
   * An encoding (automatically) preserves taint from input to output.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `Encoding` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets an input that is encoded by this function. */
    abstract DataFlow::Node getAnInput();

    /** Gets the output that contains the encoded data produced by this function. */
    abstract DataFlow::Node getOutput();

    /** Gets an identifier for the format this function decodes from, such as "JSON". */
    abstract string getFormat();
  }
}

private class EncodingAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
  override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    exists(Encoding encoding |
      nodeFrom = encoding.getAnInput() and
      nodeTo = encoding.getOutput()
    )
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

/**
 * A data-flow node that executes SQL statements.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `SqlExecution::Range` instead.
 */
class SqlExecution extends DataFlow::Node {
  SqlExecution::Range range;

  SqlExecution() { this = range }

  /** Gets the argument that specifies the SQL statements to be executed. */
  DataFlow::Node getSql() { result = range.getSql() }
}

/** Provides a class for modeling new SQL execution APIs. */
module SqlExecution {
  /**
   * A data-flow node that executes SQL statements.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `SqlExecution` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets the argument that specifies the SQL statements to be executed. */
    abstract DataFlow::Node getSql();
  }
}

/** Provides classes for modeling HTTP-related APIs. */
module HTTP {
  /** Provides classes for modeling HTTP servers. */
  module Server {
    /**
     * A data-flow node that sets up a route on a server.
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
       * A data-flow node that sets up a route on a server.
       *
       * Extend this class to model new APIs. If you want to refine existing API models,
       * extend `RouteSetup` instead.
       */
      abstract class Range extends DataFlow::Node {
        /** Gets the argument used to set the URL pattern. */
        abstract DataFlow::Node getUrlPatternArg();

        /** Gets the URL pattern for this route, if it can be statically determined. */
        string getUrlPattern() {
          exists(StrConst str |
            DataFlow::localFlow(DataFlow::exprNode(str), this.getUrlPatternArg()) and
            result = str.getText()
          )
        }

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

    /**
     * A data-flow node that creates a HTTP response on a server.
     *
     * Note: we don't require that this response must be sent to a client (a kind of
     * "if a tree falls in a forest and nobody hears it" situation).
     *
     * Extend this class to refine existing API models. If you want to model new APIs,
     * extend `HttpResponse::Range` instead.
     */
    class HttpResponse extends DataFlow::Node {
      HttpResponse::Range range;

      HttpResponse() { this = range }

      /** Gets the data-flow node that specifies the body of this HTTP response. */
      DataFlow::Node getBody() { result = range.getBody() }

      /** Gets the mimetype of this HTTP response, if it can be statically determined. */
      string getMimetype() { result = range.getMimetype() }
    }

    /** Provides a class for modeling new HTTP response APIs. */
    module HttpResponse {
      /**
       * A data-flow node that creates a HTTP response on a server.
       *
       * Note: we don't require that this response must be sent to a client (a kind of
       * "if a tree falls in a forest and nobody hears it" situation).
       *
       * Extend this class to model new APIs. If you want to refine existing API models,
       * extend `HttpResponse` instead.
       */
      abstract class Range extends DataFlow::Node {
        /** Gets the data-flow node that specifies the body of this HTTP response. */
        abstract DataFlow::Node getBody();

        /** Gets the data-flow node that specifies the content-type/mimetype of this HTTP response, if any. */
        abstract DataFlow::Node getMimetypeOrContentTypeArg();

        /** Gets the default mimetype that should be used if `getMimetypeOrContentTypeArg` has no results. */
        abstract string getMimetypeDefault();

        /** Gets the mimetype of this HTTP response, if it can be statically determined. */
        string getMimetype() {
          exists(StrConst str |
            DataFlow::localFlow(DataFlow::exprNode(str), this.getMimetypeOrContentTypeArg()) and
            result = str.getText().splitAt(";", 0)
          )
          or
          not exists(this.getMimetypeOrContentTypeArg()) and
          result = this.getMimetypeDefault()
        }
      }
    }
  }
}
