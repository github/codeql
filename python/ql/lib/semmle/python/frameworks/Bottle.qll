/**
 * Provides classes modeling security-relevant aspects of the `bottle` PyPI package.
 * See https://www.tornadoweb.org/en/stable/.
 */

private import python
private import semmle.python.Concepts
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.ApiGraphs
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.frameworks.internal.InstanceTaintStepsHelper

/**
 * INTERNAL: Do not use.
 *
 * Provides models for the `bottle` PyPI package.
 * See https://www.tornadoweb.org/en/stable/.
 */
module Bottle {
  module BottleModule {
    API::Node bottle() { result = API::moduleImport("bottle") }

    module Response {
      API::Node response() {
        result = bottle().getMember("response")
        //or
        //result = ModelOutput::getATypeNode("tornado.web.RequestHandler~Subclass").getASubclass*()
      }

      /**
       * A call to the `bottle.web.RequestHandler.set_header` method.
       *
       * See https://www.tornadoweb.org/en/stable/web.html#tornado.web.RequestHandler.set_header
       */
      class BottleRequestHandlerSetHeaderCall extends Http::Server::ResponseHeaderWrite::Range,
        DataFlow::MethodCallNode
      {
        BottleRequestHandlerSetHeaderCall() {
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

      module Request {
        API::Node request() { result = bottle().getMember("request") }

        private class Request extends RemoteFlowSource::Range {
          Request() { this = request().asSource() }

          //or
          //result = ModelOutput::getATypeNode("tornado.web.RequestHandler~Subclass").getASubclass*()
          override string getSourceType() { result = "bottle.request" }
        }

        /**
         * Taint propagation for `bottle.request`.
         *
         * See https://flask.palletsprojects.com/en/1.1.x/api/#flask.Request
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
        API::Node instance() {
          result = bottle().getMember("response").getMember("headers")
          //or
          //result = ModelOutput::getATypeNode("tornado.web.RequestHandler~Subclass").getASubclass*()
        }

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

          //name = instance().getASubscript().getIndex().asSink()
          override DataFlow::Node getNameArg() { result = name.asSink() }

          override DataFlow::Node getValueArg() { result = value.asSink() }

          // TODO: These checks perhaps could be made more precise.
          override predicate nameAllowsNewline() { none() }

          override predicate valueAllowsNewline() { none() }
        }
      }
    }
  }
}
