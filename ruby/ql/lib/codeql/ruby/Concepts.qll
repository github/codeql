/**
 * Provides abstract classes representing generic concepts such as file system
 * access or system command execution, for which individual framework libraries
 * provide concrete subclasses.
 */

private import codeql.ruby.AST
private import codeql.ruby.CFG
private import codeql.ruby.DataFlow
private import codeql.ruby.Frameworks
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.ApiGraphs
private import codeql.ruby.Regexp as RE

/**
 * A data-flow node that constructs a SQL statement.
 *
 * Often, it is worthy of an alert if a SQL statement is constructed such that
 * executing it would be a security risk.
 *
 * If it is important that the SQL statement is executed, use `SqlExecution`.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `SqlConstruction::Range` instead.
 */
class SqlConstruction extends DataFlow::Node instanceof SqlConstruction::Range {
  /** Gets the argument that specifies the SQL statements to be constructed. */
  DataFlow::Node getSql() { result = super.getSql() }
}

/** Provides a class for modeling new SQL execution APIs. */
module SqlConstruction {
  /**
   * A data-flow node that constructs a SQL statement.
   *
   * Often, it is worthy of an alert if a SQL statement is constructed such that
   * executing it would be a security risk.
   *
   * If it is important that the SQL statement is executed, use `SqlExecution`.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `SqlConstruction` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets the argument that specifies the SQL statements to be constructed. */
    abstract DataFlow::Node getSql();
  }
}

/**
 * A data-flow node that executes SQL statements.
 *
 * If the context of interest is such that merely constructing a SQL statement
 * would be valuable to report, consider using `SqlConstruction`.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `SqlExecution::Range` instead.
 */
class SqlExecution extends DataFlow::Node instanceof SqlExecution::Range {
  /** Gets the argument that specifies the SQL statements to be executed. */
  DataFlow::Node getSql() { result = super.getSql() }
}

/** Provides a class for modeling new SQL execution APIs. */
module SqlExecution {
  /**
   * A data-flow node that executes SQL statements.
   *
   * If the context of interest is such that merely constructing a SQL
   * statement would be valuable to report, consider using `SqlConstruction`.
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
 * A data-flow node that executes a regular expression.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `RegexExecution::Range` instead.
 */
class RegexExecution extends DataFlow::Node instanceof RegexExecution::Range {
  /** Gets the data flow node for the regex being executed by this node. */
  DataFlow::Node getRegex() { result = super.getRegex() }

  /** Gets a dataflow node for the string to be searched or matched against. */
  DataFlow::Node getString() { result = super.getString() }

  /**
   * Gets the name of this regex execution, typically the name of an executing method.
   * This is used for nice alert messages and should include the module if possible.
   */
  string getName() { result = super.getName() }
}

/** Provides classes for modeling new regular-expression execution APIs. */
module RegexExecution {
  /**
   * A data-flow node that executes a regular expression.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `RegexExecution` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets the data flow node for the regex being executed by this node. */
    abstract DataFlow::Node getRegex();

    /** Gets a dataflow node for the string to be searched or matched against. */
    abstract DataFlow::Node getString();

    /**
     * Gets the name of this regex execution, typically the name of an executing method.
     * This is used for nice alert messages and should include the module if possible.
     */
    abstract string getName();
  }
}

/**
 * A data flow node that performs a file system access, including reading and writing data,
 * creating and deleting files and folders, checking and updating permissions, and so on.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `FileSystemAccess::Range` instead.
 */
class FileSystemAccess extends DataFlow::Node instanceof FileSystemAccess::Range {
  /** Gets an argument to this file system access that is interpreted as a path. */
  DataFlow::Node getAPathArgument() { result = super.getAPathArgument() }
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
 * A data flow node that reads data from the file system.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `FileSystemReadAccess::Range` instead.
 */
class FileSystemReadAccess extends FileSystemAccess instanceof FileSystemReadAccess::Range {
  /**
   * Gets a node that represents data read from the file system access.
   */
  DataFlow::Node getADataNode() { result = FileSystemReadAccess::Range.super.getADataNode() }
}

/** Provides a class for modeling new file system reads. */
module FileSystemReadAccess {
  /**
   * A data flow node that reads data from the file system.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `FileSystemReadAccess` instead.
   */
  abstract class Range extends FileSystemAccess::Range {
    /**
     * Gets a node that represents data read from the file system.
     */
    abstract DataFlow::Node getADataNode();
  }
}

/**
 * A data flow node that writes data to the file system.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `FileSystemWriteAccess::Range` instead.
 */
class FileSystemWriteAccess extends FileSystemAccess instanceof FileSystemWriteAccess::Range {
  /**
   * Gets a node that represents data written to the file system by this access.
   */
  DataFlow::Node getADataNode() { result = FileSystemWriteAccess::Range.super.getADataNode() }
}

/** Provides a class for modeling new file system writes. */
module FileSystemWriteAccess {
  /**
   * A data flow node that writes data to the file system.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `FileSystemWriteAccess` instead.
   */
  abstract class Range extends FileSystemAccess::Range {
    /**
     * Gets a node that represents data written to the file system by this access.
     */
    abstract DataFlow::Node getADataNode();
  }
}

/**
 * A data flow node that sets the permissions for one or more files.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `FileSystemPermissionModification::Range` instead.
 */
class FileSystemPermissionModification extends DataFlow::Node instanceof FileSystemPermissionModification::Range {
  /**
   * Gets an argument to this permission modification that is interpreted as a
   * set of permissions.
   */
  DataFlow::Node getAPermissionNode() { result = super.getAPermissionNode() }
}

/** Provides a class for modeling new file system permission modifications. */
module FileSystemPermissionModification {
  /**
   * A data-flow node that sets permissions for a one or more files.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `FileSystemPermissionModification` instead.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Gets an argument to this permission modification that is interpreted as a
     * set of permissions.
     */
    abstract DataFlow::Node getAPermissionNode();
  }
}

/**
 * A data flow node that contains a file name or an array of file names from the local file system.
 */
abstract class FileNameSource extends DataFlow::Node { }

/**
 * A data-flow node that escapes meta-characters, which could be used to prevent
 * injection attacks.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `Escaping::Range` instead.
 */
class Escaping extends DataFlow::Node instanceof Escaping::Range {
  Escaping() {
    // escapes that don't have _both_ input/output defined are not valid
    exists(super.getAnInput()) and
    exists(super.getOutput())
  }

  /** Gets an input that will be escaped. */
  DataFlow::Node getAnInput() { result = super.getAnInput() }

  /** Gets the output that contains the escaped data. */
  DataFlow::Node getOutput() { result = super.getOutput() }

  /**
   * Gets the context that this function escapes for, such as `html`, or `url`.
   */
  string getKind() { result = super.getKind() }
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
}

/**
 * An escape of a string so it can be safely included in
 * the body of an HTML element, for example, replacing `{}` in
 * `<p>{}</p>`.
 */
class HtmlEscaping extends Escaping {
  HtmlEscaping() { super.getKind() = Escaping::getHtmlKind() }
}

/** Provides classes for modeling HTTP-related APIs. */
module Http {
  /** Provides classes for modeling HTTP servers. */
  module Server {
    /**
     * A data-flow node that sets up a route on a server.
     *
     * Extend this class to refine existing API models. If you want to model new APIs,
     * extend `RouteSetup::Range` instead.
     */
    class RouteSetup extends DataFlow::Node instanceof RouteSetup::Range {
      /** Gets the URL pattern for this route, if it can be statically determined. */
      string getUrlPattern() { result = super.getUrlPattern() }

      /**
       * Gets a function that will handle incoming requests for this route, if any.
       *
       * NOTE: This will be modified in the near future to have a `RequestHandler` result, instead of a `Method`.
       */
      Method getARequestHandler() { result = super.getARequestHandler() }

      /**
       * Gets a parameter that will receive parts of the url when handling incoming
       * requests for this route, if any. These automatically become a `RemoteFlowSource`.
       */
      Parameter getARoutedParameter() { result = super.getARoutedParameter() }

      /** Gets a string that identifies the framework used for this route setup. */
      string getFramework() { result = super.getFramework() }

      /**
       * Gets the HTTP method name, in lowercase, that this handler will respond to.
       */
      string getHttpMethod() { result = super.getHttpMethod() }
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
          result = this.getUrlPatternArg().getALocalSource().getConstantValue().getStringlikeValue()
        }

        /**
         * Gets a function that will handle incoming requests for this route, if any.
         *
         * NOTE: This will be modified in the near future to have a `RequestHandler` result, instead of a `Method`.
         */
        abstract Method getARequestHandler();

        /**
         * Gets a parameter that will receive parts of the url when handling incoming
         * requests for this route, if any. These automatically become a `RemoteFlowSource`.
         */
        abstract Parameter getARoutedParameter();

        /** Gets a string that identifies the framework used for this route setup. */
        abstract string getFramework();

        /**
         * Gets the HTTP method name, in all caps, that this handler will respond to.
         */
        abstract string getHttpMethod();
      }
    }

    /** A kind of request input. */
    class RequestInputKind extends string {
      RequestInputKind() { this = ["parameter", "header", "body", "url", "cookie"] }
    }

    /** Input from the parameters of a request. */
    RequestInputKind parameterInputKind() { result = "parameter" }

    /** Input from the headers of a request. */
    RequestInputKind headerInputKind() { result = "header" }

    /** Input from the body of a request. */
    RequestInputKind bodyInputKind() { result = "body" }

    /** Input from the URL of a request. */
    RequestInputKind urlInputKind() { result = "url" }

    /** Input from the cookies of a request. */
    RequestInputKind cookieInputKind() { result = "cookie" }

    /**
     * An access to a user-controlled HTTP request input. For example, the URL or body of a request.
     * Instances of this class automatically become `RemoteFlowSource`s.
     *
     * Extend this class to refine existing API models. If you want to model new APIs,
     * extend `RequestInputAccess::Range` instead.
     */
    class RequestInputAccess extends DataFlow::Node instanceof RequestInputAccess::Range {
      /**
       * Gets a string that describes the type of this input.
       *
       * This is typically the name of the method that gives rise to this input.
       */
      string getSourceType() { result = super.getSourceType() }

      /**
       * Gets the kind of the accessed input,
       * Can be one of "parameter", "header", "body", "url", "cookie".
       */
      RequestInputKind getKind() { result = super.getKind() }

      /**
       * Holds if this part of the request may be controlled by a third party,
       * that is, an agent other than the one who sent the request.
       *
       * This is true for the URL, query parameters, and request body.
       * These can be controlled by a malicious third party in the following scenarios:
       *
       * - The user clicks a malicious link or is otherwise redirected to a malicious URL.
       * - The user visits a web site that initiates a form submission or AJAX request on their behalf.
       *
       * In these cases, the request is technically sent from the user's browser, but
       * the user is not in direct control of the URL or POST body.
       *
       * Headers are never considered third-party controllable by this predicate, although the
       * third party does have some control over the the Referer and Origin headers.
       */
      predicate isThirdPartyControllable() {
        this.getKind() = [parameterInputKind(), urlInputKind(), bodyInputKind()]
      }
    }

    /** Provides a class for modeling new HTTP request inputs. */
    module RequestInputAccess {
      /**
       * An access to a user-controlled HTTP request input.
       *
       * Extend this class to model new APIs. If you want to refine existing API models,
       * extend `RequestInputAccess` instead.
       */
      abstract class Range extends DataFlow::Node {
        /**
         * Gets a string that describes the type of this input.
         *
         * This is typically the name of the method that gives rise to this input.
         */
        abstract string getSourceType();

        /**
         * Gets the kind of the accessed input,
         * Can be one of "parameter", "header", "body", "url", "cookie".
         */
        abstract RequestInputKind getKind();
      }
    }

    private class RequestInputAccessAsRemoteFlowSource extends RemoteFlowSource::Range instanceof RequestInputAccess {
      override string getSourceType() { result = this.(RequestInputAccess).getSourceType() }
    }

    /**
     * A function that will handle incoming HTTP requests.
     *
     * Extend this class to refine existing API models. If you want to model new APIs,
     * extend `RequestHandler::Range` instead.
     */
    class RequestHandler extends Method instanceof RequestHandler::Range {
      /**
       * Gets a parameter that could receive parts of the url when handling incoming
       * requests, if any. These automatically become a `RemoteFlowSource`.
       */
      Parameter getARoutedParameter() { result = super.getARoutedParameter() }

      /** Gets a string that identifies the framework used for this route setup. */
      string getFramework() { result = super.getFramework() }

      /**
       * Gets an HTTP method name, in all caps, that this handler will respond to.
       * Handlers can potentially respond to multiple HTTP methods.
       */
      string getAnHttpMethod() { result = super.getAnHttpMethod() }
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
      abstract class Range extends Method {
        /**
         * Gets a parameter that could receive parts of the url when handling incoming
         * requests, if any. These automatically become a `RemoteFlowSource`.
         */
        abstract Parameter getARoutedParameter();

        /** Gets a string that identifies the framework used for this request handler. */
        abstract string getFramework();

        /**
         * Gets an HTTP method name, in all caps, that this handler will respond to.
         * Handlers can potentially respond to multiple HTTP methods.
         */
        abstract string getAnHttpMethod();
      }
    }

    private class RequestHandlerFromRouteSetup extends RequestHandler::Range {
      RouteSetup rs;

      RequestHandlerFromRouteSetup() { this = rs.getARequestHandler() }

      override Parameter getARoutedParameter() {
        result = rs.getARoutedParameter() and
        result = this.getAParameter()
      }

      override string getFramework() { result = rs.getFramework() }

      override string getAnHttpMethod() { result = rs.getHttpMethod() }
    }

    /** A parameter that will receive parts of the url when handling an incoming request. */
    private class RoutedParameter extends RequestInputAccess::Range, DataFlow::ParameterNode {
      RequestHandler handler;

      RoutedParameter() { this.getParameter() = handler.getARoutedParameter() }

      override string getSourceType() { result = handler.getFramework() + " RoutedParameter" }

      override RequestInputKind getKind() { result = parameterInputKind() }
    }

    /**
     * A data flow node that writes data to a header in an HTTP response.
     *
     * Extend this class to refine existing API models. If you want to model new APIs,
     * extend `HeaderWriteAccess::Range` instead.
     */
    class HeaderWriteAccess extends DataFlow::Node instanceof HeaderWriteAccess::Range {
      /** Gets the (lower case) name of the header that is written to. */
      string getName() { result = super.getName().toLowerCase() }

      /** Gets the value that is written to the header. */
      DataFlow::Node getValue() { result = super.getValue() }
    }

    /** Provides a class for modeling new HTTP header writes. */
    module HeaderWriteAccess {
      /**
       * A data flow node that writes data to the header in an HTTP response.
       *
       * Extend this class to model new APIs. If you want to refine existing API models,
       * extend `HeaderWriteAccess` instead.
       */
      abstract class Range extends DataFlow::Node {
        /** Gets the name of the header that is written to. */
        abstract string getName();

        /** Gets the value that is written to the header. */
        abstract DataFlow::Node getValue();
      }
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
    class HttpResponse extends DataFlow::Node instanceof HttpResponse::Range {
      /** Gets the data-flow node that specifies the body of this HTTP response. */
      DataFlow::Node getBody() { result = super.getBody() }

      /** Gets the mimetype of this HTTP response, if it can be statically determined. */
      string getMimetype() { result = super.getMimetype() }
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
          result =
            this.getMimetypeOrContentTypeArg()
                .getALocalSource()
                .getConstantValue()
                .getStringlikeValue()
                .splitAt(";", 0)
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
    class HttpRedirectResponse extends HttpResponse instanceof HttpRedirectResponse::Range {
      /** Gets the data-flow node that specifies the location of this HTTP redirect response. */
      DataFlow::Node getRedirectLocation() { result = super.getRedirectLocation() }
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
      abstract class Range extends Http::Server::HttpResponse::Range {
        /** Gets the data-flow node that specifies the location of this HTTP redirect response. */
        abstract DataFlow::Node getRedirectLocation();
      }
    }
  }

  /** Provides classes for modeling HTTP clients. */
  module Client {
    import codeql.ruby.internal.ConceptsShared::Http::Client as SC

    /**
     * A method call that makes an outgoing HTTP request.
     *
     * Extend this class to refine existing API models. If you want to model new APIs,
     * extend `Request::Range` instead.
     */
    class Request extends SC::Request instanceof Request::Range {
      /** Gets a node which returns the body of the response */
      DataFlow::Node getResponseBody() { result = super.getResponseBody() }

      /**
       * DEPRECATED: Use `getAUrlPart` instead.
       *
       * Gets a node that contributes to the URL of the request.
       * Depending on the framework, a request may have multiple nodes which contribute to the URL.
       */
      deprecated DataFlow::Node getURL() {
        result = super.getURL() or result = Request::Range.super.getAUrlPart()
      }

      /**
       * Holds if this request is made using a mode that disables SSL/TLS
       * certificate validation, where `disablingNode` represents the point at
       * which the validation was disabled.
       */
      deprecated predicate disablesCertificateValidation(DataFlow::Node disablingNode) {
        Request::Range.super.disablesCertificateValidation(disablingNode, _)
        or
        Request::Range.super.disablesCertificateValidation(disablingNode)
      }
    }

    /** Provides a class for modeling new HTTP requests. */
    module Request {
      /**
       * A method call that makes an outgoing HTTP request.
       *
       * Extend this class to model new APIs. If you want to refine existing API models,
       * extend `Request` instead.
       */
      abstract class Range extends SC::Request::Range {
        /** Gets a node which returns the body of the response */
        abstract DataFlow::Node getResponseBody();

        /**
         * DEPRECATED: overwrite `getAUrlPart` instead.
         *
         * Gets a node that contributes to the URL of the request.
         * Depending on the framework, a request may have multiple nodes which contribute to the URL.
         */
        deprecated DataFlow::Node getURL() { none() }

        /**
         * DEPRECATED: override `disablesCertificateValidation/2` instead.
         *
         * Holds if this request is made using a mode that disables SSL/TLS
         * certificate validation, where `disablingNode` represents the point at
         * which the validation was disabled.
         */
        deprecated predicate disablesCertificateValidation(DataFlow::Node disablingNode) { none() }
      }
    }

    /** The response body from an outgoing HTTP request, considered as a remote flow source */
    private class RequestResponseBody extends RemoteFlowSource::Range, DataFlow::Node {
      Request request;

      RequestResponseBody() { this = request.getResponseBody() }

      override string getSourceType() { result = request.getFramework() }
    }
  }
}

/** DEPRECATED: Alias for Http */
deprecated module HTTP = Http;

/**
 * A data flow node that executes an operating system command,
 * for instance by spawning a new process.
 */
class SystemCommandExecution extends DataFlow::Node instanceof SystemCommandExecution::Range {
  /** Holds if a shell interprets `arg`. */
  predicate isShellInterpreted(DataFlow::Node arg) { super.isShellInterpreted(arg) }

  /** Gets an argument to this execution that specifies the command or an argument to it. */
  DataFlow::Node getAnArgument() { result = super.getAnArgument() }
}

/** Provides a class for modeling new operating system command APIs. */
module SystemCommandExecution {
  /**
   * A data flow node that executes an operating system command, for instance by spawning a new
   * process.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `SystemCommandExecution` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets an argument to this execution that specifies the command or an argument to it. */
    abstract DataFlow::Node getAnArgument();

    /** Holds if a shell interprets `arg`. */
    predicate isShellInterpreted(DataFlow::Node arg) { none() }
  }
}

/**
 * A data-flow node that dynamically executes Ruby code.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `CodeExecution::Range` instead.
 */
class CodeExecution extends DataFlow::Node instanceof CodeExecution::Range {
  /** Gets the argument that specifies the code to be executed. */
  DataFlow::Node getCode() { result = super.getCode() }

  /** Holds if this execution runs arbitrary code, as opposed to some restricted subset. E.g. `Object.send` will only run any method on an object. */
  predicate runsArbitraryCode() { super.runsArbitraryCode() }
}

/** Provides a class for modeling new dynamic code execution APIs. */
module CodeExecution {
  /**
   * A data-flow node that dynamically executes Ruby code.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `CodeExecution` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets the argument that specifies the code to be executed. */
    abstract DataFlow::Node getCode();

    /** Holds if this execution runs arbitrary code, as opposed to some restricted subset. E.g. `Object.send` will only run any method on an object. */
    predicate runsArbitraryCode() { any() }
  }
}

/**
 * A data-flow node that parses XML content.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `XmlParserCall::Range` instead.
 */
class XmlParserCall extends DataFlow::Node instanceof XmlParserCall::Range {
  /** Gets the argument that specifies the XML content to be parsed. */
  DataFlow::Node getInput() { result = super.getInput() }

  /** Holds if this XML parser call is configured to process external entities */
  predicate externalEntitiesEnabled() { super.externalEntitiesEnabled() }
}

/** Provides a class for modeling new XML parsing APIs. */
module XmlParserCall {
  /**
   * A data-flow node that parses XML content.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `class XmlParserCall` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets the argument that specifies the XML content to be parsed. */
    abstract DataFlow::Node getInput();

    /** Holds if this XML parser call is configured to process external entities */
    abstract predicate externalEntitiesEnabled();
  }
}

/**
 * A data-flow node that may represent a database object in an ORM system.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `OrmInstantiation::Range` instead.
 */
class OrmInstantiation extends DataFlow::Node instanceof OrmInstantiation::Range {
  /** Holds if a call to `methodName` on this instance may return a field of this ORM object. */
  bindingset[methodName]
  predicate methodCallMayAccessField(string methodName) {
    super.methodCallMayAccessField(methodName)
  }
}

/** Provides a class for modeling new ORM object instantiation APIs. */
module OrmInstantiation {
  /**
   * A data-flow node that may represent a database object in an ORM system.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `OrmInstantiation` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Holds if a call to `methodName` on this instance may return a field of this ORM object. */
    bindingset[methodName]
    abstract predicate methodCallMayAccessField(string methodName);
  }
}

/**
 * A data flow node that writes persistent data.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `PersistentWriteAccess::Range` instead.
 */
class PersistentWriteAccess extends DataFlow::Node instanceof PersistentWriteAccess::Range {
  /**
   * Gets the data flow node corresponding to the written value.
   */
  DataFlow::Node getValue() { result = super.getValue() }
}

/** Provides a class for modeling new persistent write access APIs. */
module PersistentWriteAccess {
  /**
   * A data flow node that writes persistent data.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `PersistentWriteAccess` instead.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Gets the data flow node corresponding to the written value.
     */
    abstract DataFlow::Node getValue();
  }
}

/**
 * A data-flow node that may set or unset Cross-site request forgery protection.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `CSRFProtectionSetting::Range` instead.
 */
class CsrfProtectionSetting extends DataFlow::Node instanceof CsrfProtectionSetting::Range {
  /**
   * Gets the boolean value corresponding to if CSRF protection is enabled
   * (`true`) or disabled (`false`) by this node.
   */
  boolean getVerificationSetting() { result = super.getVerificationSetting() }
}

/** DEPRECATED: Alias for CsrfProtectionSetting */
deprecated class CSRFProtectionSetting = CsrfProtectionSetting;

/** Provides a class for modeling new CSRF protection setting APIs. */
module CsrfProtectionSetting {
  /**
   * A data-flow node that may set or unset Cross-site request forgery protection.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `CSRFProtectionSetting` instead.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Gets the boolean value corresponding to if CSRF protection is enabled
     * (`true`) or disabled (`false`) by this node.
     */
    abstract boolean getVerificationSetting();
  }
}

/** DEPRECATED: Alias for CsrfProtectionSetting */
deprecated module CSRFProtectionSetting = CsrfProtectionSetting;

/** Provides classes for modeling path-related APIs. */
module Path {
  /**
   * A data-flow node that performs path sanitization. This is often needed in order
   * to safely access paths.
   */
  class PathSanitization extends DataFlow::Node instanceof PathSanitization::Range { }

  /** Provides a class for modeling new path sanitization APIs. */
  module PathSanitization {
    /**
     * A data-flow node that performs path sanitization. This is often needed in order
     * to safely access paths.
     */
    abstract class Range extends DataFlow::Node { }
  }
}

/**
 * A data-flow node that may configure behavior relating to cookie security.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `CookieSecurityConfigurationSetting::Range` instead.
 */
class CookieSecurityConfigurationSetting extends DataFlow::Node instanceof CookieSecurityConfigurationSetting::Range {
  /**
   * Gets a description of how this cookie setting may weaken application security.
   * This predicate has no results if the setting is considered to be safe.
   */
  string getSecurityWarningMessage() { result = super.getSecurityWarningMessage() }
}

/** Provides a class for modeling new cookie security setting APIs. */
module CookieSecurityConfigurationSetting {
  /**
   * A data-flow node that may configure behavior relating to cookie security.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `CookieSecurityConfigurationSetting` instead.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Gets a description of how this cookie setting may weaken application security.
     * This predicate has no results if the setting is considered to be safe.
     */
    abstract string getSecurityWarningMessage();
  }
}

/**
 * A data-flow node that logs data.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `Logging::Range` instead.
 */
class Logging extends DataFlow::Node instanceof Logging::Range {
  /** Gets an input that is logged. */
  DataFlow::Node getAnInput() { result = super.getAnInput() }
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
 * Provides models for cryptographic concepts.
 *
 * Note: The `CryptographicAlgorithm` class currently doesn't take weak keys into
 * consideration for the `isWeak` member predicate. So RSA is always considered
 * secure, although using a low number of bits will actually make it insecure. We plan
 * to improve our libraries in the future to more precisely capture this aspect.
 */
module Cryptography {
  // Since we still rely on `isWeak` predicate on `CryptographicOperation` in Ruby, we
  // modify that part of the shared concept... which means we have to explicitly
  // re-export everything else.
  // Using SC shorthand for "Shared Cryptography"
  import codeql.ruby.internal.ConceptsShared::Cryptography as SC

  class CryptographicAlgorithm = SC::CryptographicAlgorithm;

  class EncryptionAlgorithm = SC::EncryptionAlgorithm;

  class HashingAlgorithm = SC::HashingAlgorithm;

  class PasswordHashingAlgorithm = SC::PasswordHashingAlgorithm;

  /**
   * A data-flow node that is an application of a cryptographic algorithm. For example,
   * encryption, decryption, signature-validation.
   *
   * Extend this class to refine existing API models. If you want to model new APIs,
   * extend `CryptographicOperation::Range` instead.
   */
  class CryptographicOperation extends SC::CryptographicOperation instanceof CryptographicOperation::Range {
    /** DEPRECATED: Use `getAlgorithm().isWeak() or getBlockMode().isWeak()` instead */
    deprecated predicate isWeak() { super.isWeak() }
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
    abstract class Range extends SC::CryptographicOperation::Range {
      /** DEPRECATED: Use `getAlgorithm().isWeak() or getBlockMode().isWeak()` instead */
      deprecated predicate isWeak() { this.getAlgorithm().isWeak() or this.getBlockMode().isWeak() }
    }
  }

  class BlockMode = SC::BlockMode;
}
