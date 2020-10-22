import java

/**
<<<<<<< HEAD
 * Play MVC Framework Results Class
 *
 * Documentation: https://www.playframework.com/documentation/2.8.x/JavaActions
=======
 * Play MVC Framework Results
 *
 * @description Gets the play.mvc.Results class - Helper utilities to generate results
 * (https://www.playframework.com/documentation/2.8.x/JavaActions)
>>>>>>> fa523e456f96493dcc08b819ad4bd620cca789b8
 */
class PlayMVCResultsClass extends Class {
  PlayMVCResultsClass() { this.hasQualifiedName("play.mvc", "Results") }
}

/**
<<<<<<< HEAD
 * Play Framework mvc.Results Methods - `ok`, `status`, `redirect`
 *
 * Documentation: https://www.playframework.com/documentation/2.5.8/api/java/play/mvc/Results.html
 */
class PlayMVCResultsMethods extends Method {
  PlayMVCResultsMethods() { this.getDeclaringType() instanceof PlayMVCResultsClass }

  /**
   * Gets all references to play.mvc.Results `ok` method
   */
  MethodAccess getAnOkAccess() {
    this.hasName("ok") and result = this.getAReference()
  }

  /**
   * Gets all references to play.mvc.Results `redirect` method
   */
  MethodAccess getARedirectAccess() {
    this.hasName("redirect") and result = this.getAReference()
=======
 * Play Framework mvc.Results Methods
 *
 * @description Gets the methods of play.mvc.Results like - ok, status, redirect etc.
 * (https://www.playframework.com/documentation/2.5.8/api/java/play/mvc/Results.html)
 */
class PlayHTTPResultsMethods extends Method {
  PlayHTTPResultsMethods() { this.getDeclaringType() instanceof PlayMVCResultsClass }

  /**
   * Gets all references to play.mvc.Results ok method
   */
  MethodAccess ok() {
    exists(MethodAccess ma | ma = this.getAReference() and this.hasName("ok") | result = ma)
  }

  /**
   * Gets all references to play.mvc.Results redirect method
   */
  MethodAccess redirect() {
    exists(MethodAccess ma | ma = this.getAReference() and this.hasName("redirect") | result = ma)
>>>>>>> fa523e456f96493dcc08b819ad4bd620cca789b8
  }
}
