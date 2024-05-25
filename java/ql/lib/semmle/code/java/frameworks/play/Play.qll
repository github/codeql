/**
 * Provides classes and predicates for working with the Play framework.
 */

import java

/**
 * The `play.mvc.Result` class.
 */
class PlayMvcResultClass extends Class {
  PlayMvcResultClass() { this.hasQualifiedName("play.mvc", "Result") }
}

/**
 * The `play.mvc.Results` class.
 */
class PlayMvcResultsClass extends Class {
  PlayMvcResultsClass() { this.hasQualifiedName("play.mvc", "Results") }
}

/**
 * The `play.mvc.Http$RequestHeader` class.
 */
class PlayMvcHttpRequestHeader extends RefType {
  PlayMvcHttpRequestHeader() { this.hasQualifiedName("play.mvc", "Http$RequestHeader") }
}

/**
 * A `play.mvc.BodyParser$Of` annotation.
 */
class PlayBodyParserAnnotation extends Annotation {
  PlayBodyParserAnnotation() { this.getType().hasQualifiedName("play.mvc", "BodyParser$Of") }
}

/**
 * A `play.filters.csrf.AddCSRFToken` annotation.
 */
class PlayAddCsrfTokenAnnotation extends Annotation {
  PlayAddCsrfTokenAnnotation() {
    this.getType().hasQualifiedName("play.filters.csrf", "AddCSRFToken")
  }
}

/**
 * The type `play.libs.F.Promise<Result>`.
 */
class PlayAsyncResultPromise extends MemberType {
  PlayAsyncResultPromise() { this.hasQualifiedName("play.libs", "F$Promise<Result>") }
}

/**
 * The type `java.util.concurrent.CompletionStage<Result>`.
 */
class PlayAsyncResultCompletionStage extends Type {
  PlayAsyncResultCompletionStage() {
    this.hasName("CompletionStage<Result>") and
    this.getCompilationUnit().getPackage().hasName("java.util.concurrent")
  }
}

/**
 * The class `play.mvc.Controller` or a class that transitively extends it.
 */
class PlayController extends Class {
  PlayController() {
    this.extendsOrImplements*(any(Class t | t.hasQualifiedName("play.mvc", "Controller")))
  }
}

/**
 * A Play framework controller action method. These are mappings to route files.
 *
 * Sample Route - `POST  /login  @com.company.Application.login()`.
 *
 * Example - class gets `index` and `login` as valid action methods.
 * ```java
 * public class Application extends Controller {
 *   public Result index(String username, String password) {
 *     return ok("It works!");
 *   }
 *
 *   public Result login() {
 *     return ok("Log me In!");
 *   }
 * }
 * ```
 */
class PlayControllerActionMethod extends Method {
  PlayControllerActionMethod() {
    this = any(PlayController c).getAMethod() and
    (
      this.getReturnType() instanceof PlayAsyncResultPromise or
      this.getReturnType() instanceof PlayMvcResultClass or
      this.getReturnType() instanceof PlayAsyncResultCompletionStage
    )
  }
}

/**
 * A Play framework action method parameter. These are a source of user input.
 *
 * Example - `username` and `password` are action method parameters.
 * ```java
 * public class Application extends Controller {
 *   public Result index(String username, String password) {
 *     return ok("It works!");
 *   }
 * }
 * ```
 */
class PlayActionMethodQueryParameter extends Parameter {
  PlayActionMethodQueryParameter() {
    exists(PlayControllerActionMethod a |
      a.isPublic() and
      this = a.getAParameter()
    )
  }
}

/**
 * A PlayFramework HttpRequestHeader method, some of these are `headers`, `getQueryString`, `getHeader`.
 */
class PlayMvcHttpRequestHeaderMethods extends Method {
  PlayMvcHttpRequestHeaderMethods() { this.getDeclaringType() instanceof PlayMvcHttpRequestHeader }

  /**
   * Gets a reference to the `getQueryString` method.
   */
  MethodCall getAQueryStringAccess() {
    this.hasName("getQueryString") and result = this.getAReference()
  }
}

/**
 * A PlayFramework results method, some of these are `ok`, `status`, `redirect`.
 */
class PlayMvcResultsMethods extends Method {
  PlayMvcResultsMethods() { this.getDeclaringType() instanceof PlayMvcResultsClass }

  /**
   * Gets a reference to the `play.mvc.Results.ok` method.
   */
  MethodCall getAnOkAccess() { this.hasName("ok") and result = this.getAReference() }

  /**
   * Gets a reference to the `play.mvc.Results.redirect` method.
   */
  MethodCall getARedirectAccess() { this.hasName("redirect") and result = this.getAReference() }
}
