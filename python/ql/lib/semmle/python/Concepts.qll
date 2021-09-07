/**
 * Provides abstract classes representing generic concepts such as file system
 * access or system command execution, for which individual framework libraries
 * provide concrete subclasses.
 */

private import python
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

/**
 * A data flow node that writes data to the file system access.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `FileSystemWriteAccess::Range` instead.
 */
class FileSystemWriteAccess extends FileSystemAccess {
  override FileSystemWriteAccess::Range range;

  /**
   * Gets a node that represents data to be written to the file system (possibly with
   * some transformation happening before it is written, like JSON encoding).
   */
  DataFlow::Node getADataNode() { result = range.getADataNode() }
}

/** Provides a class for modeling new file system writes. */
module FileSystemWriteAccess {
  /**
   * A data flow node that writes data to the file system access.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `FileSystemWriteAccess` instead.
   */
  abstract class Range extends FileSystemAccess::Range {
    /**
     * Gets a node that represents data to be written to the file system (possibly with
     * some transformation happening before it is written, like JSON encoding).
     */
    abstract DataFlow::Node getADataNode();
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
 * A data-flow node that logs data.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `Logging::Range` instead.
 */
class Logging extends DataFlow::Node {
  Logging::Range range;

  Logging() { this = range }

  /** Gets an input that is logged. */
  DataFlow::Node getAnInput() { result = range.getAnInput() }
}

/** Provides a class for modeling new logging mechanisms. */
module Logging {
  /**
   * A data-flow node that logs data.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `Logging` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets an input that is logged. */
    abstract DataFlow::Node getAnInput();
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

/**
 * A data-flow node that escapes meta-characters, which could be used to prevent
 * injection attacks.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `Escaping::Range` instead.
 */
class Escaping extends DataFlow::Node {
  Escaping::Range range;

  Escaping() {
    this = range and
    // escapes that don't have _both_ input/output defined are not valid
    exists(range.getAnInput()) and
    exists(range.getOutput())
  }

  /** Gets an input that will be escaped. */
  DataFlow::Node getAnInput() { result = range.getAnInput() }

  /** Gets the output that contains the escaped data. */
  DataFlow::Node getOutput() { result = range.getOutput() }

  /**
   * Gets the context that this function escapes for, such as `html`, or `url`.
   */
  string getKind() { result = range.getKind() }
}

/** Provides a class for modeling new escaping APIs. */
module Escaping {
  /**
   * A data-flow node that escapes meta-characters, which could be used to prevent
   * injection attacks.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `Escaping` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets an input that will be escaped. */
    abstract DataFlow::Node getAnInput();

    /** Gets the output that contains the escaped data. */
    abstract DataFlow::Node getOutput();

    /**
     * Gets the context that this function escapes for.
     *
     * While kinds are represented as strings, this should not be relied upon. Use the
     * predicates in  the `Escaping` module, such as `getHtmlKind`.
     */
    abstract string getKind();
  }

  /** Gets the escape-kind for escaping a string so it can safely be included in HTML. */
  string getHtmlKind() { result = "html" }
  // TODO: If adding an XML kind, update the modeling of the `MarkupSafe` PyPI package.
  //
  // Technically it claims to escape for both HTML and XML, but for now we don't have
  // anything that relies on XML escaping, so I'm going to defer deciding whether they
  // should be the same kind, or whether they deserve to be treated differently.
}

/**
 * An escape of a string so it can be safely included in
 * the body of an HTML element, for example, replacing `{}` in
 * `<p>{}</p>`.
 */
class HtmlEscaping extends Escaping {
  HtmlEscaping() { range.getKind() = Escaping::getHtmlKind() }
}

/** Provides classes for modeling HTTP-related APIs. */
module HTTP {
  import semmle.python.web.HttpConstants

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

      /**
       * Gets a function that will handle incoming requests for this route, if any.
       *
       * NOTE: This will be modified in the near future to have a `RequestHandler` result, instead of a `Function`.
       */
      Function getARequestHandler() { result = range.getARequestHandler() }

      /**
       * Gets a parameter that will receive parts of the url when handling incoming
       * requests for this route, if any. These automatically become a `RemoteFlowSource`.
       */
      Parameter getARoutedParameter() { result = range.getARoutedParameter() }

      /** Gets a string that identifies the framework used for this route setup. */
      string getFramework() { result = range.getFramework() }
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
            this.getUrlPatternArg().getALocalSource() = DataFlow::exprNode(str) and
            result = str.getText()
          )
        }

        /**
         * Gets a function that will handle incoming requests for this route, if any.
         *
         * NOTE: This will be modified in the near future to have a `RequestHandler` result, instead of a `Function`.
         */
        abstract Function getARequestHandler();

        /**
         * Gets a parameter that will receive parts of the url when handling incoming
         * requests for this route, if any. These automatically become a `RemoteFlowSource`.
         */
        abstract Parameter getARoutedParameter();

        /** Gets a string that identifies the framework used for this route setup. */
        abstract string getFramework();
      }
    }

    /**
     * A function that will handle incoming HTTP requests.
     *
     * Extend this class to refine existing API models. If you want to model new APIs,
     * extend `RequestHandler::Range` instead.
     */
    class RequestHandler extends Function {
      RequestHandler::Range range;

      RequestHandler() { this = range }

      /**
       * Gets a parameter that could receive parts of the url when handling incoming
       * requests, if any. These automatically become a `RemoteFlowSource`.
       */
      Parameter getARoutedParameter() { result = range.getARoutedParameter() }

      /** Gets a string that identifies the framework used for this route setup. */
      string getFramework() { result = range.getFramework() }
    }

    /** Provides a class for modeling new HTTP request handlers. */
    module RequestHandler {
      /**
       * A function that will handle incoming HTTP requests.
       *
       * Extend this class to model new APIs. If you want to refine existing API models,
       * extend `RequestHandler` instead.
       *
       * Only extend this class if you can't provide a `RouteSetup`, since we handle that case automatically.
       */
      abstract class Range extends Function {
        /**
         * Gets a parameter that could receive parts of the url when handling incoming
         * requests, if any. These automatically become a `RemoteFlowSource`.
         */
        abstract Parameter getARoutedParameter();

        /** Gets a string that identifies the framework used for this request handler. */
        abstract string getFramework();
      }
    }

    private class RequestHandlerFromRouteSetup extends RequestHandler::Range {
      RouteSetup rs;

      RequestHandlerFromRouteSetup() { this = rs.getARequestHandler() }

      override Parameter getARoutedParameter() {
        result = rs.getARoutedParameter() and
        result in [this.getArg(_), this.getArgByName(_)]
      }

      override string getFramework() { result = rs.getFramework() }
    }

    /** A parameter that will receive parts of the url when handling an incoming request. */
    private class RoutedParameter extends RemoteFlowSource::Range, DataFlow::ParameterNode {
      RequestHandler handler;

      RoutedParameter() { this.getParameter() = handler.getARoutedParameter() }

      override string getSourceType() { result = handler.getFramework() + " RoutedParameter" }
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
            this.getMimetypeOrContentTypeArg().getALocalSource() = DataFlow::exprNode(str) and
            result = str.getText().splitAt(";", 0)
          )
          or
          not exists(this.getMimetypeOrContentTypeArg()) and
          result = this.getMimetypeDefault()
        }
      }
    }

    /**
     * A data-flow node that creates a HTTP redirect response on a server.
     *
     * Note: we don't require that this redirect must be sent to a client (a kind of
     * "if a tree falls in a forest and nobody hears it" situation).
     *
     * Extend this class to refine existing API models. If you want to model new APIs,
     * extend `HttpRedirectResponse::Range` instead.
     */
    class HttpRedirectResponse extends HttpResponse {
      override HttpRedirectResponse::Range range;

      HttpRedirectResponse() { this = range }

      /** Gets the data-flow node that specifies the location of this HTTP redirect response. */
      DataFlow::Node getRedirectLocation() { result = range.getRedirectLocation() }
    }

    /** Provides a class for modeling new HTTP redirect response APIs. */
    module HttpRedirectResponse {
      /**
       * A data-flow node that creates a HTTP redirect response on a server.
       *
       * Note: we don't require that this redirect must be sent to a client (a kind of
       * "if a tree falls in a forest and nobody hears it" situation).
       *
       * Extend this class to model new APIs. If you want to refine existing API models,
       * extend `HttpResponse` instead.
       */
      abstract class Range extends HTTP::Server::HttpResponse::Range {
        /** Gets the data-flow node that specifies the location of this HTTP redirect response. */
        abstract DataFlow::Node getRedirectLocation();
      }
    }

    /**
     * A data-flow node that sets a cookie in an HTTP response.
     *
     * Extend this class to refine existing API models. If you want to model new APIs,
     * extend `HTTP::CookieWrite::Range` instead.
     */
    class CookieWrite extends DataFlow::Node {
      CookieWrite::Range range;

      CookieWrite() { this = range }

      /**
       * Gets the argument, if any, specifying the raw cookie header.
       */
      DataFlow::Node getHeaderArg() { result = range.getHeaderArg() }

      /**
       * Gets the argument, if any, specifying the cookie name.
       */
      DataFlow::Node getNameArg() { result = range.getNameArg() }

      /**
       * Gets the argument, if any, specifying the cookie value.
       */
      DataFlow::Node getValueArg() { result = range.getValueArg() }
    }

    /** Provides a class for modeling new cookie writes on HTTP responses. */
    module CookieWrite {
      /**
       * A data-flow node that sets a cookie in an HTTP response.
       *
       * Note: we don't require that this redirect must be sent to a client (a kind of
       * "if a tree falls in a forest and nobody hears it" situation).
       *
       * Extend this class to model new APIs. If you want to refine existing API models,
       * extend `HttpResponse` instead.
       */
      abstract class Range extends DataFlow::Node {
        /**
         * Gets the argument, if any, specifying the raw cookie header.
         */
        abstract DataFlow::Node getHeaderArg();

        /**
         * Gets the argument, if any, specifying the cookie name.
         */
        abstract DataFlow::Node getNameArg();

        /**
         * Gets the argument, if any, specifying the cookie value.
         */
        abstract DataFlow::Node getValueArg();
      }
    }
  }
}

/**
 * Provides models for cryptographic things.
 *
 * Note: The `CryptographicAlgorithm` class currently doesn't take weak keys into
 * consideration for the `isWeak` member predicate. So RSA is always considered
 * secure, although using a low number of bits will actually make it insecure. We plan
 * to improve our libraries in the future to more precisely capture this aspect.
 */
module Cryptography {
  /** Provides models for public-key cryptography, also called asymmetric cryptography. */
  module PublicKey {
    /**
     * A data-flow node that generates a new key-pair for use with public-key cryptography.
     *
     * Extend this class to refine existing API models. If you want to model new APIs,
     * extend `KeyGeneration::Range` instead.
     */
    class KeyGeneration extends DataFlow::Node {
      KeyGeneration::Range range;

      KeyGeneration() { this = range }

      /** Gets the name of the cryptographic algorithm (for example `"RSA"` or `"AES"`). */
      string getName() { result = range.getName() }

      /** Gets the argument that specifies the size of the key in bits, if available. */
      DataFlow::Node getKeySizeArg() { result = range.getKeySizeArg() }

      /**
       * Gets the size of the key generated (in bits), as well as the `origin` that
       * explains how we obtained this specific key size.
       */
      int getKeySizeWithOrigin(DataFlow::Node origin) {
        result = range.getKeySizeWithOrigin(origin)
      }

      /** Gets the minimum key size (in bits) for this algorithm to be considered secure. */
      int minimumSecureKeySize() { result = range.minimumSecureKeySize() }
    }

    /** Provides classes for modeling new key-pair generation APIs. */
    module KeyGeneration {
      /** Gets a back-reference to the keysize argument `arg` that was used to generate a new key-pair. */
      private DataFlow::TypeTrackingNode keysizeBacktracker(
        DataFlow::TypeBackTracker t, DataFlow::Node arg
      ) {
        t.start() and
        arg = any(KeyGeneration::Range r).getKeySizeArg() and
        result = arg.getALocalSource()
        or
        exists(DataFlow::TypeBackTracker t2 | result = keysizeBacktracker(t2, arg).backtrack(t2, t))
      }

      /** Gets a back-reference to the keysize argument `arg` that was used to generate a new key-pair. */
      DataFlow::LocalSourceNode keysizeBacktracker(DataFlow::Node arg) {
        result = keysizeBacktracker(DataFlow::TypeBackTracker::end(), arg)
      }

      /**
       * A data-flow node that generates a new key-pair for use with public-key cryptography.
       *
       * Extend this class to model new APIs. If you want to refine existing API models,
       * extend `KeyGeneration` instead.
       */
      abstract class Range extends DataFlow::Node {
        /** Gets the name of the cryptographic algorithm (for example `"RSA"`). */
        abstract string getName();

        /** Gets the argument that specifies the size of the key in bits, if available. */
        abstract DataFlow::Node getKeySizeArg();

        /**
         * Gets the size of the key generated (in bits), as well as the `origin` that
         * explains how we obtained this specific key size.
         */
        int getKeySizeWithOrigin(DataFlow::Node origin) {
          origin = keysizeBacktracker(this.getKeySizeArg()) and
          result = origin.asExpr().(IntegerLiteral).getValue()
        }

        /** Gets the minimum key size (in bits) for this algorithm to be considered secure. */
        abstract int minimumSecureKeySize();
      }

      /** A data-flow node that generates a new RSA key-pair. */
      abstract class RsaRange extends Range {
        final override string getName() { result = "RSA" }

        final override int minimumSecureKeySize() { result = 2048 }
      }

      /** A data-flow node that generates a new DSA key-pair. */
      abstract class DsaRange extends Range {
        final override string getName() { result = "DSA" }

        final override int minimumSecureKeySize() { result = 2048 }
      }

      /** A data-flow node that generates a new ECC key-pair. */
      abstract class EccRange extends Range {
        final override string getName() { result = "ECC" }

        final override int minimumSecureKeySize() { result = 224 }
      }
    }
  }

  import semmle.python.concepts.CryptoAlgorithms

  /**
   * A data-flow node that is an application of a cryptographic algorithm. For example,
   * encryption, decryption, signature-validation.
   *
   * Extend this class to refine existing API models. If you want to model new APIs,
   * extend `CryptographicOperation::Range` instead.
   */
  class CryptographicOperation extends DataFlow::Node {
    CryptographicOperation::Range range;

    CryptographicOperation() { this = range }

    /** Gets the algorithm used, if it matches a known `CryptographicAlgorithm`. */
    CryptographicAlgorithm getAlgorithm() { result = range.getAlgorithm() }

    /** Gets an input the algorithm is used on, for example the plain text input to be encrypted. */
    DataFlow::Node getAnInput() { result = range.getAnInput() }
  }

  /** Provides classes for modeling new applications of a cryptographic algorithms. */
  module CryptographicOperation {
    /**
     * A data-flow node that is an application of a cryptographic algorithm. For example,
     * encryption, decryption, signature-validation.
     *
     * Extend this class to model new APIs. If you want to refine existing API models,
     * extend `CryptographicOperation` instead.
     */
    abstract class Range extends DataFlow::Node {
      /** Gets the algorithm used, if it matches a known `CryptographicAlgorithm`. */
      abstract CryptographicAlgorithm getAlgorithm();

      /** Gets an input the algorithm is used on, for example the plain text input to be encrypted. */
      abstract DataFlow::Node getAnInput();
    }
  }
}
