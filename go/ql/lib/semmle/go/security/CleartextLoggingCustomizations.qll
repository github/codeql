/**
 * Provides default sources, sinks, and sanitizers for reasoning about
 * clear-text logging of sensitive information, as well as extension
 * points for adding your own.
 */

import go
private import semmle.go.security.SensitiveActions::HeuristicNames
private import semmle.go.security.SensitiveActions::PasswordHeuristics

/**
 * Provides extension points for customizing the data-flow tracking configuration for reasoning
 * about clear-text logging of sensitive information.
 */
module CleartextLogging {
  /**
   * A data-flow source for clear-text logging of sensitive information.
   */
  abstract class Source extends DataFlow::Node {
    Source() {
      // hard-coded strings are uninteresting
      not exists(this.getStringValue())
    }

    /** Gets a string that describes the type of this data-flow source. */
    abstract string describe();
  }

  /**
   * A data-flow sink for clear-text logging of sensitive information.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A barrier for clear-text logging of sensitive information.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * An argument to a logging mechanism.
   */
  class LoggerSink extends Sink {
    LoggerSink() { this = any(LoggerCall log).getAMessageComponent() }
  }

  /**
   * A data-flow node that does not contain a clear-text password, according to its syntactic name.
   */
  private class NameGuidedNonCleartextPassword extends NonCleartextPassword {
    NameGuidedNonCleartextPassword() {
      exists(string name |
        name.regexpMatch(notSensitive())
        or
        name.regexpMatch("(?i).*err(or)?.*")
      |
        this.asExpr().(Ident).getName() = name
        or
        this.(DataFlow::FieldReadNode).getFieldName() = name
        or
        this.(DataFlow::CallNode).getCalleeName() = name
      )
      or
      // avoid i18n strings
      this.(DataFlow::FieldReadNode)
          .getBase()
          .asExpr()
          .(Ident)
          .getName()
          .regexpMatch("(?is).*(messages|strings).*")
      or
      // avoid dummy passwords
      isDummyPassword(this.getStringValue())
    }
  }

  /**
   * A data-flow node that receives flow that is not a clear-text password.
   */
  private class NonCleartextPasswordFlow extends NonCleartextPassword {
    NonCleartextPasswordFlow() { this = any(NonCleartextPassword other).getASuccessor*() }
  }

  /**
   * A call that might obfuscate a password, for example through hashing.
   */
  private class ObfuscatorCall extends Barrier, DataFlow::CallNode {
    ObfuscatorCall() { this.getCalleeName().regexpMatch(notSensitive()) }
  }

  /**
   * Read of a non-sensitive header, considered as a barrier for clear-text logging.
   */
  private class NonSensitiveHeaderGet extends Barrier {
    NonSensitiveHeaderGet() {
      exists(string headerName |
        exists(DataFlow::MethodCallNode c | c = this |
          c.getTarget().hasQualifiedName("net/http", "Header", "Get") and
          headerName = c.getArgument(0).getStringValue()
        )
        or
        exists(DataFlow::ElementReadNode e | e = this |
          e.getBase().getType().hasQualifiedName("net/http", "Header") and
          headerName = e.getIndex().getStringValue()
        )
      |
        not headerName.toLowerCase() in ["authorization", "cookie"]
      )
    }
  }

  /**
   * A data-flow node that does not contain a clear-text password.
   */
  abstract private class NonCleartextPassword extends DataFlow::Node { }

  /**
   * A value assigned to a struct field that may contain password information.
   *
   * This is a source since `log.Print(obj)` will often show the fields of `obj`.
   */
  private class StructPasswordFieldSource extends DataFlow::Node, Source {
    string name;

    StructPasswordFieldSource() {
      exists(Write write, Field f | write.writesField(_, f, this) |
        name = f.getName() and
        name.regexpMatch(maybePassword()) and
        not name.regexpMatch(notSensitive()) and
        // avoid safe values assigned to presumably unsafe names
        not this instanceof NonCleartextPassword
      )
    }

    override string describe() { result = "an access to " + name }
  }

  /** An access to a variable or property that might contain a password. */
  private class ReadPasswordSource extends DataFlow::Node, Source {
    string name;

    ReadPasswordSource() {
      // avoid safe values assigned to presumably unsafe names
      not this instanceof NonCleartextPassword and
      name.regexpMatch(maybePassword()) and
      (
        this.asExpr().(Ident).getName() = name
        or
        exists(DataFlow::FieldReadNode fn |
          fn = this and
          fn.getFieldName() = name and
          // avoid safe values assigned to presumably unsafe names
          not exists(Write write, NonCleartextPassword ncp |
            write.writesField(fn.getBase().getAPredecessor*(), fn.getField(), ncp)
          )
        )
      )
    }

    override string describe() { result = "an access to " + name }
  }

  /** A call that might return a password. */
  private class CallPasswordSource extends DataFlow::CallNode, Source {
    string name;

    CallPasswordSource() {
      name = this.getCalleeName() and
      name.regexpMatch("(?is)getPassword")
    }

    override string describe() { result = "a call to " + name }
  }

  /** The headers of an HTTP request, considered as a source of sensitive information. */
  private class RequestHeaderSource extends Source {
    RequestHeaderSource() {
      exists(Field hdr |
        hdr.hasQualifiedName("net/http", "Request", "Header") and
        this = hdr.getARead()
      )
    }

    override string describe() { result = "HTTP request headers" }
  }

  private class KubernetesSecretInterfaceSource extends Source, K8sIoClientGo::SecretInterfaceSource
  {
    override string describe() { result = "Kubernetes Secret" }
  }

  /**
   * The first element of a split by ' '  or ':', often sanitizing a username/password pair
   * or the "Method value" syntax used in the HTTP Authorization header.
   */
  private class NonSensitiveAuthorizationElement extends Barrier, DataFlow::ElementReadNode {
    NonSensitiveAuthorizationElement() {
      exists(DataFlow::CallNode splitCall, DataFlow::Node splitAlias |
        splitCall
            .getTarget()
            .hasQualifiedName("strings", ["Split", "SplitN", "SplitAfter", "SplitAfterN"]) and
        splitCall.getArgument(1).getStringValue() = [" ", ":"] and
        DataFlow::localFlow(splitCall.getResult(), splitAlias) and
        this.getBase() = splitAlias
      ) and
      this.getIndex().getIntValue() = 0
    }
  }
}
