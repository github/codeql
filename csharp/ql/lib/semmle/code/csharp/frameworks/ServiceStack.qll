/**
 * General modeling of ServiceStack framework including separate modules for:
 *  - flow sources
 *  - SQLi sinks
 *  - XSS sinks
 */

import csharp

/** A class representing a Service */
private class ServiceClass extends Class {
  ServiceClass() {
    this.getBaseClass+().hasFullyQualifiedName("ServiceStack", "Service") or
    this.getABaseType*().getABaseInterface().hasFullyQualifiedName("ServiceStack", "IService")
  }

  /** Get a method that handles incoming requests */
  Method getARequestMethod() {
    exists(string name |
      result = this.getAMethod(name) and
      name.regexpMatch("(Get|Post|Put|Delete|Any|Option|Head|Patch)(Async|Json|Xml|Jsv|Csv|Html|Protobuf|Msgpack|Wire)?")
    )
  }
}

/** Flow sources for the ServiceStack framework */
module Sources {
  private import semmle.code.csharp.security.dataflow.flowsources.Remote

  /**
   *  Remote flow sources for ServiceStack. Parameters of well-known `request` methods.
   */
  private class ServiceStackSource extends RemoteFlowSource {
    ServiceStackSource() {
      exists(ServiceClass service |
        service.getARequestMethod().getAParameter() = this.asParameter()
      )
    }

    override string getSourceType() { result = "ServiceStack request parameter" }
  }
}

/** XSS support for ServiceStack framework */
module XSS {
  private import semmle.code.csharp.security.dataflow.XSSSinks

  /** XSS sinks for ServiceStack */
  class XssSink extends Sink {
    XssSink() {
      exists(ServiceClass service, Method m, Expr e |
        service.getARequestMethod() = m and
        this.asExpr() = e and
        m.canReturn(e) and
        (
          e.getType() instanceof StringType or
          e.getType().hasFullyQualifiedName("ServiceStack", "HttpResult")
        )
      )
    }
  }
}
