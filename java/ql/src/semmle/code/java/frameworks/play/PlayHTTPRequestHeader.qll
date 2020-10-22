import java

/**
<<<<<<< HEAD
 * Play MVC Framework HTTP Request Header Class
=======
 * Play MVC Framework HTTP Request Header
 *
 * @description Member of play.mvc.HTTP. Gets the play.mvc.HTTP$RequestHeader class/interface
>>>>>>> fa523e456f96493dcc08b819ad4bd620cca789b8
 */
class PlayMVCHTTPRequestHeader extends RefType {
  PlayMVCHTTPRequestHeader() { this.hasQualifiedName("play.mvc", "Http$RequestHeader") }
}

/**
<<<<<<< HEAD
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

=======
 * Play Framework HTTP$RequestHeader Methods
 *
 * @description Gets the methods of play.mvc.HTTP$RequestHeader like - headers, getQueryString, getHeader, uri
 * (https://www.playframework.com/documentation/2.6.0/api/java/play/mvc/Http.RequestHeader.html)
 */
class PlayHTTPRequestHeaderMethods extends Method {
  PlayHTTPRequestHeaderMethods() { this.getDeclaringType() instanceof PlayMVCHTTPRequestHeader }
>>>>>>> fa523e456f96493dcc08b819ad4bd620cca789b8
}
