import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import semmle.go.security.RequestForgery
import utils.test.InlineExpectationsTest

module TwirpTest implements TestSig {
  string getARelevantTag() {
    result =
      [
        "handler", "request", "ssrfSink", "message", "serviceInterface", "serviceClient",
        "serviceServer", "clientConstructor", "serverConstructor", "ssrf"
      ]
  }

  additional predicate hasEntityResult(Location location, string element, Entity entity) {
    location = entity.getDeclaration().getLocation() and
    element = entity.toString()
  }

  additional predicate hasTypeResult(Location location, string element, Type goType) {
    exists(TypeEntity typeEntity |
      typeEntity.getType() = goType and
      location = typeEntity.getDeclaration().getLocation() and
      element = goType.toString()
    )
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    value = "" and
    (
      tag = "handler" and
      exists(Twirp::ServiceHandler handler | hasEntityResult(location, element, handler))
      or
      tag = "request" and
      exists(Twirp::Request request |
        location = request.getLocation() and
        element = request.toString()
      )
      or
      tag = "ssrfSink" and
      exists(RequestForgery::Sink sink |
        location = sink.getLocation() and
        element = sink.toString()
      )
      or
      tag = "message" and
      exists(Twirp::ProtobufMessageType message | hasTypeResult(location, element, message))
      or
      tag = "serviceInterface" and
      exists(Twirp::ServiceInterfaceType serviceInterface |
        hasTypeResult(location, element, serviceInterface.getDefinedType())
      )
      or
      tag = "serviceClient" and
      exists(Twirp::ServiceClientType client | hasTypeResult(location, element, client))
      or
      tag = "serviceServer" and
      exists(Twirp::ServiceServerType server | hasTypeResult(location, element, server))
      or
      tag = "clientConstructor" and
      exists(Twirp::ClientConstructor constructor | hasEntityResult(location, element, constructor))
      or
      tag = "serverConstructor" and
      exists(Twirp::ServerConstructor constructor | hasEntityResult(location, element, constructor))
      or
      tag = "ssrf" and
      exists(DataFlow::Node sink |
        RequestForgery::Flow::flowTo(sink) and
        location = sink.getLocation() and
        element = sink.toString()
      )
    )
  }
}

import MakeTest<TwirpTest>
