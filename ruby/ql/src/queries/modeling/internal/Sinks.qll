private import ruby
private import codeql.files.FileSystem
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.security.CodeInjectionCustomizations
private import codeql.ruby.security.CommandInjectionCustomizations
private import codeql.ruby.security.XSS
private import codeql.ruby.security.PathInjectionCustomizations
private import codeql.ruby.security.ServerSideRequestForgeryCustomizations
private import codeql.ruby.security.UnsafeDeserializationCustomizations
private import codeql.ruby.security.UrlRedirectCustomizations
private import codeql.ruby.security.SqlInjectionCustomizations
private import Util as Util

// TODO: there is probably a more sensible central location for this module
module Sinks {
  private module Configs {
    signature class KindSig {
      predicate isSink(DataFlow::Node node);

      predicate isSanitizer(DataFlow::Node node);

      string getKind();
    }

    signature class SinkSig extends DataFlow::Node;

    signature class SanitizerSig extends DataFlow::Node;

    abstract class MCustomization {
  abstract DataFlow::Node getSink();
  abstract DataFlow::Node getSanitizer();
abstract string getKind();
    }

    module SKind<MCustomization Customization> implements KindSig {
      predicate isSink(DataFlow::Node node) { node instanceof Customization::Sink }

      predicate isSanitizer(DataFlow::Node node) { node instanceof Customization::Sanitizer }

      string getKind() { Customization::isKind(result) }
    }

    module MCodeInjection implements MCustomization {
      import CodeInjection

      predicate isKind(string k) { k = "code-injection" }
    }

    module CodeInjectionKind = SKind<MCodeInjection>;

    module MCommandInjection implements MCustomization {
      import CommandInjection

      predicate isKind(string k) { k = "command-injection" }
    }

    module CommandInjectionKind = SKind<MCommandInjection>;

    module MPathInjection implements MCustomization {
      import PathInjection

      predicate isKind(string k) { k = "path-injection" }
    }

    module PathInjectionKind = SKind<MPathInjection>;

    module MSqlInjection implements MCustomization {
      import SqlInjection

      predicate isKind(string k) { k = "sql-injection" }
    }

    module SqlInjectionKind = SKind<MSqlInjection>;

    module HtmlInjection implements MCustomization {
      import ReflectedXss as R
      import StoredXss as S

      class Sanitizer extends DataFlow::Node {
        Sanitizer() { this instanceof R::Sanitizer or this instanceof S::Sanitizer }
      }

      class Sink extends DataFlow::Node {
        Sink() { this instanceof R::Sink or this instanceof S::Sink }
      }

      predicate isKind(string k) { k = "sql-injection" }
    }

    module HtmlInjectionKind = SKind<MSqlInjection>;

    module MRequestForgery implements MCustomization {
      import ServerSideRequestForgery

      predicate isKind(string k) { k = "request-forgery" }
    }

    module RequestForgeryKind = SKind<MRequestForgery>;

    module MUrlRedirection implements MCustomization {
      import UrlRedirect

      predicate isKind(string k) { k = "url-redirection" }
    }

    module UrlRedirectionKind = SKind<MUrlRedirection>;

    module MUnsafeDeserialization implements MCustomization {
      import UnsafeDeserialization

      predicate isKind(string k) { k = "unsafe-deserialization" }
    }

    module UnsafeDeserializationKind = SKind<MUnsafeDeserialization>;
  }

  private DataFlow::Node getTaintSinkOfKind(string kind) {
    result.getLocation().getFile() instanceof Util::RelevantFile and
(
kind = Configs::CodeInjectionKind::getKind()
                                        and

      // kind = SinkKinds::codeInjection() and result instanceof Configs::CodeInjectionKind::Sink
      // or
      // kind = SinkKinds::commandInjection() and result instanceof CommandInjection::Sink
      // or
      // kind = SinkKinds::htmlInjection() and
      // (result instanceof ReflectedXss::Sink or result instanceof StoredXss::Sink)
      // or
      // kind = SinkKinds::pathInjection() and result instanceof PathInjection::Sink
      // or
      // kind = SinkKinds::requestForgery() and result instanceof ServerSideRequestForgery::Sink
      // or
      // kind = SinkKinds::unsafeDeserialization() and result instanceof UnsafeDeserialization::Sink
      // or
      // kind = SinkKinds::urlRedirection() and result instanceof UrlRedirect::Sink
      // or
      // kind = SinkKinds::sqlInjection() and result instanceof SqlInjection::Sink
    ) and
    // the sink is not a string literal
    not exists(Ast::StringLiteral str |
      str = result.asExpr().getExpr() and
      // ensure there is no interpolation, as that is not a literal
      not str.getComponent(_) instanceof Ast::StringInterpolationComponent
    )
  }

  private predicate flowFromParameterToSink(
    DataFlow::ParameterNode param, DataFlow::Node knownSink, SinkKinds::Kind kind
  ) {
    knownSink = getTaintSinkOfKind(kind) and
    param.flowsTo(knownSink) and
    knownSink != param
  }

  predicate sinkModelFlowToKnownSink(string type, string path, string kind) {
    exists(DataFlow::MethodNode methodNode, DataFlow::ParameterNode paramNode |
      paramNode = methodNode.getParameter(_) and
      flowFromParameterToSink(paramNode, _, kind)
    |
      type = Util::getAnAccessPathPrefix(methodNode) and
      path = Util::getMethodParameterPath(methodNode, paramNode)
    )
  }

  predicate parameterIsSuspicious(DataFlow::ParameterNode param, string kind) {
    param.getName() = "sql" and kind = SinkKinds::sqlInjection()
  }

  predicate sinkModelSuspiciousParameterName(string type, string path, string kind) {
    exists(DataFlow::MethodNode methodNode, DataFlow::ParameterNode paramNode |
      paramNode = methodNode.getParameter(_) and
      parameterIsSuspicious(paramNode, kind) and
      methodNode.getLocation().getFile() instanceof Util::RelevantFile
    |
      type = Util::getAnAccessPathPrefix(methodNode) and
      path = "(!!)" + Util::getMethodParameterPath(methodNode, paramNode)
    )
  }

  predicate sinkModel(string type, string path, string kind) {
    sinkModelFlowToKnownSink(type, path, kind) or
    sinkModelSuspiciousParameterName(type, path, kind)
  }
}
