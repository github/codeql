/**
 * Provides classes modeling security-relevant aspects of the `bottle` PyPI package.
 * See https://bottlepy.org/docs/dev/.
 */

private import python
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.frameworks.internal.InstanceTaintStepsHelper

/**
 * INTERNAL: Do not use.
 *
 * Provides models for the `bottle` PyPI package.
 * See https://bottlepy.org/docs/dev/.
 */
module Bottle {
  /** Gets a reference to the `bottle` module. */
  API::Node bottle() { result = API::moduleImport("bottle") }

  /** Provides models for the `bottle` module. */
  module BottleModule {
    /** Provides models for the `bottle.response` module */
    module Response {
      /** Gets a reference to the `bottle.response` module. */
      API::Node response() { result = bottle().getMember("response") }

      /**
       * A call to the `bottle.BaseResponse.set_header` or `bottle.BaseResponse.add_header` method.
       *
       * See https://bottlepy.org/docs/dev/api.html#bottle.BaseResponse.set_header
       */
      class BottleResponseHandlerSetHeaderCall extends Http::Server::ResponseHeaderWrite::Range,
        DataFlow::MethodCallNode
      {
        BottleResponseHandlerSetHeaderCall() {
          this = response().getMember(["set_header", "add_header"]).getACall()
        }

        override DataFlow::Node getNameArg() {
          result in [this.getArg(0), this.getArgByName("name")]
        }

        override DataFlow::Node getValueArg() {
          result in [this.getArg(1), this.getArgByName("value")]
        }

        override predicate nameAllowsNewline() { none() }

        override predicate valueAllowsNewline() { none() }
      }

      /** Provides models for the `bottle.request` module */
      module Request {
        /** Gets a reference to the `bottle.request` module. */
        API::Node request() { result = bottle().getMember("request") }

        private class Request extends RemoteFlowSource::Range {
          Request() { this = request().asSource() }

          override string getSourceType() { result = "bottle.request" }
        }

        /**
         * Taint propagation for `bottle.request`.
         *
         * See https://bottlepy.org/docs/dev/api.html#bottle.request
         */
        private class InstanceTaintSteps extends InstanceTaintStepsHelper {
          InstanceTaintSteps() { this = "bottle.request" }

          override DataFlow::Node getInstance() {
            result = request().getAValueReachableFromSource()
          }

          override string getAttributeName() {
            result in ["headers", "query", "forms", "params", "json", "url"]
          }

          override string getMethodName() { none() }

          override string getAsyncMethodName() { none() }
        }
      }

      module Header {
        API::Node instance() { result = bottle().getMember("response").getMember("headers") }

        /** A dict-like write to a response header. */
        class HeaderWriteSubscript extends Http::Server::ResponseHeaderWrite::Range, DataFlow::Node {
          API::Node name;
          API::Node value;

          HeaderWriteSubscript() {
            exists(API::Node holder |
              holder = instance() and
              this = holder.asSource() and
              value = holder.getSubscriptAt(name)
            )
          }

          override DataFlow::Node getNameArg() { result = name.asSink() }

          override DataFlow::Node getValueArg() { result = value.asSink() }

          override predicate nameAllowsNewline() { none() }

          override predicate valueAllowsNewline() { none() }
        }
      }
    }
  }
}
