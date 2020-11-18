/** A module to reason about request forgery vulnerabilities. */

import java
import semmle.code.java.frameworks.Networking
import semmle.code.java.frameworks.ApacheHttp
import semmle.code.java.frameworks.spring.Spring
import semmle.code.java.frameworks.JaxWS
import semmle.code.java.frameworks.javase.Http
import semmle.code.java.dataflow.DataFlow

/** A module to reason about request forgery vulnerabilities. */
module RequestForgery {
  /** A data flow sink for request forgery vulnerabilities. */
  abstract class Sink extends DataFlow::Node { }

  /**
   * An argument to an url `openConnection` or `openStream` call
   *  taken as a sink for request forgery vulnerabilities.
   */
  private class UrlOpen extends Sink {
    UrlOpen() {
      exists(MethodAccess ma |
        ma.getMethod() instanceof UrlOpenConnectionMethod or
        ma.getMethod() instanceof UrlOpenStreamMethod
      |
        this.asExpr() = ma.getQualifier()
      )
    }
  }

  /**
   * An argument to an Apache `setURI` call taken as a
   *   sink for request forgery vulnerabilities.
   */
  private class ApacheSetUri extends Sink {
    ApacheSetUri() {
      exists(MethodAccess ma |
        ma.getReceiverType() instanceof ApacheHttpRequest and
        ma.getMethod().hasName("setURI")
      |
        this.asExpr() = ma.getArgument(0)
      )
    }
  }

  /**
   * An argument to any Apache Request Instantiation call taken as a
   *   sink for request forgery vulnerabilities.
   */
  private class ApacheHttpRequestInstantiation extends Sink {
    ApacheHttpRequestInstantiation() {
      exists(ClassInstanceExpr c | c.getConstructedType() instanceof ApacheHttpRequest |
        this.asExpr() = c.getArgument(0)
      )
    }
  }

  /**
   * An argument to a Apache RequestBuilder method call taken as a
   *   sink for request forgery vulnerabilities.
   */
  private class ApacheHttpRequestBuilderArgument extends Sink {
    ApacheHttpRequestBuilderArgument() {
      exists(MethodAccess ma |
        ma.getReceiverType() instanceof TypeApacheHttpRequestBuilder and
        ma.getMethod().hasName(["setURI", "get", "post", "put", "optons", "head", "delete"])
      |
        this.asExpr() = ma.getArgument(0)
      )
    }
  }

  /**
   * An argument to any Java.net.http.request Instantiation call taken as a
   *   sink for request forgery vulnerabilities.
   */
  private class HttpRequestNewBuilder extends Sink {
    HttpRequestNewBuilder() {
      exists(MethodAccess call |
        call.getCallee().hasName("newBuilder") and
        call.getMethod().getDeclaringType().getName() = "HttpRequest"
      |
        this.asExpr() = call.getArgument(0)
      )
    }
  }

  /**
   * An argument to an Http Builder `uri` call taken as a
   *   sink for request forgery vulnerabilities.
   */
  private class HttpBuilderUriArgument extends Sink {
    HttpBuilderUriArgument() {
      exists(MethodAccess ma | ma.getMethod() instanceof HttpBuilderUri |
        this.asExpr() = ma.getArgument(0)
      )
    }
  }

  /**
   * An argument to a Spring Rest Template method call taken as a
   *   sink for request forgery vulnerabilities.
   */
  private class SpringRestTemplateArgument extends Sink {
    SpringRestTemplateArgument() {
      exists(MethodAccess ma |
        this.asExpr() = ma.getMethod().(SpringRestTemplateUrlMethods).getUrlArgument(ma)
      )
    }
  }

  /**
   * An argument to `javax.ws.rs.Client`s `target` method call taken as a
   *   sink for request forgery vulnerabilities.
   */
  private class JaxRsClientTarget extends Sink {
    JaxRsClientTarget() {
      exists(MethodAccess ma |
        ma.getMethod().getDeclaringType() instanceof JaxRsClient and
        ma.getMethod().hasName("target")
      |
        this.asExpr() = ma.getArgument(0)
      )
    }
  }

  /**
   * An argument to `org.springframework.http.RequestEntity`s constructor call
   *   which is an URI taken as a sink for request forgery vulnerabilities.
   */
  private class RequestEntityUriArg extends Sink {
    RequestEntityUriArg() {
      exists(ClassInstanceExpr e, Argument a |
        e.getConstructedType() instanceof SpringRequestEntity and
        e.getAnArgument() = a and
        a.getType() instanceof TypeUri and
        this.asExpr() = a
      )
    }
  }
}

/**
 * A class representing all Spring Rest Template methods
 * which take an URL as an argument.
 */
class SpringRestTemplateUrlMethods extends Method {
  SpringRestTemplateUrlMethods() {
    this.getDeclaringType() instanceof SpringRestTemplate and
    this
        .hasName(["doExecute", "postForEntity", "postForLocation", "postForObject", "put",
              "exchange", "execute", "getForEntity", "getForObject", "patchForObject"])
  }

  /**
   * Gets the argument which corresponds to a URL argument
   * passed as a `java.net.URL` object or as a string or the like
   */
  Argument getUrlArgument(MethodAccess ma) {
    // doExecute(URI url, HttpMethod method, RequestCallback requestCallback,
    //  ResponseExtractor<T> responseExtractor)
    result = ma.getArgument(0)
  }
}
