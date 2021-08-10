/**
 * General modelling of ServiceStack framework including separate modules for:
 *  - flow sources
 *  - SQLi sinks
 *  - XSS sinks
 */

import csharp

/** A class representing a Service */
class ServiceClass extends Class {
  ServiceClass() { this.getBaseClass+().getQualifiedName() = "ServiceStack.Service" }

  /** Get a method that handles incoming requests */
  Method getARequestMethod() {
    result = this.getAMethod(["Post", "Get", "Put", "Delete", "Any", "Option", "Head"])
  }
}

/** Top-level Request DTO types */
class RequestDTO extends Class {
  RequestDTO() {
    this.getABaseInterface().getQualifiedName() =
      ["ServiceStack.IReturn", "ServieStack.IReturnVoid"]
  }
}

/** Top-level Response DTO types */
class ResponseDTO extends Class {
  ResponseDTO() {
    exists(RequestDTO req, ConstructedGeneric respInterface |
      req.getABaseInterface() = respInterface and
      respInterface.getUndecoratedName() = "IReturn" and
      respInterface.getATypeArgument() = this
    )
  }
}

/** Flow sources for the ServiceStack framework */
module Sources {
  private import semmle.code.csharp.security.dataflow.flowsources.Remote
  private import semmle.code.csharp.commons.Collections

  /** Types involved in a RequestDTO. Recurse through props and collection types */
  private predicate involvedInRequest(RefType c) {
    c instanceof RequestDTO
    or
    exists(RefType parent, RefType propType | involvedInRequest(parent) |
      (propType = parent.getAProperty().getType() or propType = parent.getAField().getType()) and
      if propType instanceof CollectionType
      then
        c = propType.(ConstructedGeneric).getATypeArgument() or
        c = propType.(ArrayType).getElementType()
      else c = propType
    )
  }

  /**
   *  Remote flow sources for ServiceStack
   *
   *  Assumes all nested fields/properties on request DTOs are tainted, which is
   *  an overapproximation and may lead to FPs depending on how Service Stack app
   *  is configured.
   */
  class ServiceStackSource extends RemoteFlowSource {
    ServiceStackSource() {
      // Parameters are sources. In practice only interesting when they are string/primitive typed.
      exists(ServiceClass service |
        service.getARequestMethod().getAParameter() = this.asParameter()
      )
      or
      // Field/property accesses on RequestDTOs and request involved types
      // involved types aren't necessarily only from requests so may lead to FPs...
      exists(RefType reqType | involvedInRequest(reqType) |
        reqType.getAProperty().getAnAccess() = this.asExpr() or
        reqType.getAField().getAnAccess() = this.asExpr()
      )
    }

    override string getSourceType() { result = "ServiceStack request DTO field" }
  }
}

/** Flow Sinks for the ServiceStack framework */
module Sinks {
  private import semmle.code.csharp.security.dataflow.flowsinks.ExternalLocationSink

  /** RemoteFlow sinks for service stack */
  class ServiceStackRemoteRequestParameter extends ExternalLocationSink {
    ServiceStackRemoteRequestParameter() {
      exists(MethodCall mc |
        mc.getTarget().getQualifiedName() in [
            "ServiceStack.IRestClient.Get", "ServiceStack.IRestClient.Put",
            "ServiceStack.IRestClient.Post", "ServiceStack.IRestClient.Delete",
            "ServiceStack.IRestClient.Patch", "ServiceStack.IRestClient.Send",
            "ServiceStack.IRestClientAsync.GetAsync", "ServiceStack.IRestClientAsync.DeleteAsync",
            "ServiceStack.IRestClientAsync.PutAsync", "ServiceStack.IRestClientAsync.PostAsync",
            "ServiceStack.IRestClientAsync.PatchAsync",
            "ServiceStack.IRestClientAsync.CustomMethodAsync"
          ] and
        this.asExpr() = mc.getAnArgument()
      )
    }
  }
}

/** SQLi support for the ServiceStack framework */
module SQL {
  private import semmle.code.csharp.security.dataflow.SqlInjectionQuery

  /** SQLi sinks for ServiceStack */
  class ServiceStackSink extends Sink {
    ServiceStackSink() {
      exists(MethodCall mc, Method m, int p |
        (mc.getTarget() = m.getAnOverrider*() or mc.getTarget() = m.getAnImplementor*()) and
        sqlSinkParam(m, p) and
        mc.getArgument(p) = this.asExpr()
      )
    }
  }

  private predicate sqlSinkParam(Method m, int p) {
    exists(RefType cls | cls = m.getDeclaringType() |
      // if using the typed query builder api, only need to worry about Unsafe variants
      cls.getQualifiedName() =
        ["ServiceStack.OrmLite.SqlExpression", "ServiceStack.OrmLite.IUntypedSqlExpression"] and
      m.getName().matches("Unsafe%") and
      p = 0
      or
      // Read api - all string typed 1st params are potential sql sinks. They should be templates, not directly user controlled.
      cls.getQualifiedName() =
        [
          "ServiceStack.OrmLite.OrmLiteReadApi", "ServiceStack.OrmLite.OrmLiteReadExpressionsApi",
          "ServiceStack.OrmLite.OrmLiteReadApiAsync",
          "ServiceStack.OrmLite.OrmLiteReadExpressionsApiAsync"
        ] and
      m.getParameter(p).getType() instanceof StringType and
      p = 1
      or
      // Write API - only 2 methods that take string
      cls.getQualifiedName() =
        ["ServiceStack.OrmLite.OrmLiteWriteApi", "ServiceStack.OrmLite.OrmLiteWriteApiAsync"] and
      m.getName() = ["ExecuteSql", "ExecuteSqlAsync"] and
      p = 1
      or
      // NoSQL sinks in redis client. TODO should these be separate query?
      cls.getQualifiedName() = "ServiceStack.Redis.IRedisClient" and
      (
        m.getName() = ["Custom", "LoadLuaScript"]
        or
        m.getName().matches("%Lua%") and not m.getName().matches("%Sha%")
      ) and
      p = 0
      // TODO
      // ServiceStack.OrmLite.OrmLiteUtils.SqlColumn - what about other similar classes?
      // couldn't find CustomSelect
      // need to handle "PreCreateTable", "PostCreateTable", "PreDropTable", "PostDropTable"
    )
  }
}

/** XSS support for ServiceStack framework */
module XSS {
  private import semmle.code.csharp.security.dataflow.XSSSinks

  /** XSS sinks for ServiceStack */
  class XssSink extends Sink {
    XssSink() {
      exists(ServiceClass service, ReturnStmt r |
        this.asExpr() = r.getExpr() and
        r.getEnclosingCallable() = service.getARequestMethod()
      )
      or
      exists(ObjectCreation oc |
        oc.getType().hasQualifiedName("ServiceStack.HttpResult") and
        this.asExpr() = oc.getArgument(0)
      )
    }
  }
}
