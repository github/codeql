/** Modeling for `ActionDispatch::Request`. */

private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.ApiGraphs
private import codeql.ruby.frameworks.ActionController

/** Modeling for `ActionDispatch::Request`. */
module Request {
  /**
   * A method call against an `ActionDispatch::Request` instance.
   */
  private class RequestMethodCall extends DataFlow::CallNode {
    RequestMethodCall() {
      any(ActionControllerClass cls)
          .getSelf()
          .getAMethodCall("request")
          .(DataFlow::LocalSourceNode)
          .flowsTo(this.getReceiver()) or
      this =
        API::getTopLevelMember("ActionDispatch")
            .getMember("Request")
            .getInstance()
            .getAMethodCall(_)
    }
  }

  abstract private class RequestInputAccess extends RequestMethodCall,
    Http::Server::RequestInputAccess::Range
  {
    override string getSourceType() { result = "ActionDispatch::Request#" + this.getMethodName() }
  }

  /**
   * A method call on `request` which returns request parameters.
   */
  private class ParametersCall extends RequestInputAccess {
    ParametersCall() {
      this.getMethodName() =
        [
          "parameters", "params", "[]", "GET", "POST", "query_parameters", "request_parameters",
          "filtered_parameters", "query_string"
        ]
    }

    override Http::Server::RequestInputKind getKind() {
      result = Http::Server::parameterInputKind()
    }
  }

  /** A method call on `request` which returns part or all of the request path. */
  private class PathCall extends RequestInputAccess {
    PathCall() {
      this.getMethodName() =
        ["path", "filtered_path", "fullpath", "original_fullpath", "original_url", "url"]
    }

    override Http::Server::RequestInputKind getKind() { result = Http::Server::urlInputKind() }
  }

  /** A method call on `request` which returns a specific request header. */
  private class HeadersCall extends RequestInputAccess {
    HeadersCall() {
      this.getMethodName() =
        [
          "authorization", "script_name", "path_info", "user_agent", "referer", "referrer",
          "headers", "cookies", "cookie_jar", "content_type", "accept", "accept_encoding",
          "accept_language", "if_none_match", "if_none_match_etags", "content_mime_type"
        ]
      or
      // Request headers are prefixed with `HTTP_` to distinguish them from
      // "headers" supplied by Rack middleware.
      this.getMethodName() = ["get_header", "fetch_header"] and
      this.getArgument(0).getConstantValue().getString().regexpMatch("^HTTP_.+")
    }

    override Http::Server::RequestInputKind getKind() { result = Http::Server::headerInputKind() }
  }

  // TODO: each_header
  /**
   * A method call on `request` which returns part or all of the host.
   * This can be influenced by headers such as Host and X-Forwarded-Host.
   */
  private class HostCall extends RequestInputAccess {
    HostCall() {
      this.getMethodName() =
        [
          "authority", "host", "host_authority", "host_with_port", "raw_host_with_port", "hostname",
          "forwarded_for", "forwarded_host", "port", "forwarded_port", "port_string", "domain",
          "subdomain", "subdomains"
        ]
    }

    override Http::Server::RequestInputKind getKind() { result = Http::Server::headerInputKind() }
  }

  /**
   * A method call on `request` which is influenced by one or more request
   * headers.
   */
  private class HeaderTaintedCall extends RequestInputAccess {
    HeaderTaintedCall() {
      this.getMethodName() = ["media_type", "media_type_params", "content_charset", "base_url"]
    }

    override Http::Server::RequestInputKind getKind() { result = Http::Server::headerInputKind() }
  }

  /** A method call on `request` which returns the request body. */
  private class BodyCall extends RequestInputAccess {
    BodyCall() { this.getMethodName() = ["body", "raw_post", "body_stream"] }

    override Http::Server::RequestInputKind getKind() { result = Http::Server::bodyInputKind() }
  }

  private module Env {
    abstract private class Env extends DataFlow::LocalSourceNode { }

    /**
     * A method call on `request` which returns the rack env.
     * This is a hash containing all the information about the request. Values
     * under keys starting with `HTTP_` are user-controlled.
     */
    private class RequestEnvCall extends DataFlow::CallNode, Env {
      RequestEnvCall() { this.getMethodName() = ["env", "filtered_env"] }
    }

    private import codeql.ruby.frameworks.Rack

    private class RackEnv extends Env {
      RackEnv() { this = any(Rack::App::RequestHandler handler).getEnv().getALocalUse() }
    }

    /**
     * A read of a user-controlled parameter from the request env.
     */
    private class EnvHttpAccess extends DataFlow::CallNode, Http::Server::RequestInputAccess::Range {
      EnvHttpAccess() {
        this = any(Env c).getAMethodCall("[]") and
        exists(string key | key = this.getArgument(0).getConstantValue().getString() |
          key.regexpMatch("^HTTP_.+") or key = "PATH_INFO"
        )
      }

      override Http::Server::RequestInputKind getKind() { result = Http::Server::headerInputKind() }

      override string getSourceType() { result = "ActionDispatch::Request#env[]" }
    }
  }
}
