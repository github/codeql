import java

/**
 * Play MVC Framework HTTP Request Header Class
 */
class PlayMVCHTTPRequestHeader extends RefType {
  PlayMVCHTTPRequestHeader() { this.hasQualifiedName("play.mvc", "Http$RequestHeader") }
}

/**
 * Play Framework HTTPRequestHeader Methods - `headers`, `getQueryString`, `getHeader`
 *
 * Documentation: https://www.playframework.com/documentation/2.6.0/api/java/play/mvc/Http.RequestHeader.html
 */
class PlayMVCHTTPRequestHeaderMethods extends Method {
  PlayMVCHTTPRequestHeaderMethods() { this.getDeclaringType() instanceof PlayMVCHTTPRequestHeader }

  /**
   * Gets all references to play.mvc.HTTP.RequestHeader `getQueryString` method
   */
  MethodAccess getQueryString() {
    this.hasName("getQueryString") and result = this.getAReference()
  }

}
