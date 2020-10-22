import java

/**
 * Play MVC Framework Results Class
 *
 * Documentation: https://www.playframework.com/documentation/2.8.x/JavaActions
 */
class PlayMVCResultsClass extends Class {
  PlayMVCResultsClass() { this.hasQualifiedName("play.mvc", "Results") }
}

/**
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
  }
}
