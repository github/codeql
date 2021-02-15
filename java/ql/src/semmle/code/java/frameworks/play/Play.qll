/**
 * Provides classes and predicates for working with the `play` package.
 */

import java

/**
 * A `play.mvc.Result` class.
 */
class PlayMvcResultClass extends Class {
  PlayMvcResultClass() { this.hasQualifiedName("play.mvc", "Result") }
}

/**
 * A `play.mvc.Results` class.
 */
class PlayMvcResultsClass extends Class {
  PlayMvcResultsClass() { this.hasQualifiedName("play.mvc", "Results") }
}

/**
 * A `play.mvc.Http$RequestHeader` class.
 */
class PlayMvcHttpRequestHeader extends RefType {
  PlayMvcHttpRequestHeader() { this.hasQualifiedName("play.mvc", "Http$RequestHeader") }
}

/**
 * A `play.mvc.BodyParser<>$Of"` annotation.
 */
class PlayBodyParserAnnotation extends Annotation {
  PlayBodyParserAnnotation() { this.getType().hasQualifiedName("play.mvc", "BodyParser<>$Of") }
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
 * A member with qualified name `F.Promise<Result>` of package `play.libs.F`.
 */
class PlayAsyncResultPromise extends Member {
  PlayAsyncResultPromise() {
    exists(Class c |
      c.hasQualifiedName("play.libs", "F") and
      this = c.getAMember() and
      this.getQualifiedName() = "F.Promise<Result>"
    )
  }
}

/**
 * A type with qualified name `CompletionStage<Result>` of package `java.util.concurrent`.
 */
class PlayAsyncResultCompletionStage extends Type {
  PlayAsyncResultCompletionStage() {
    this.hasName("CompletionStage<Result>") and
    this.getCompilationUnit().getPackage().hasName("java.util.concurrent")
  }
}

/**
 * A class which extends PlayMvcController recursively to find all controllers.
 */
class PlayController extends Class {
  PlayController() {
    this.extendsOrImplements*(any(Class t | t.hasQualifiedName("play.mvc", "Controller")))
  }
}

/**
 * A method to find PlayFramework controller action methods, these are mapping's to route files.
 *
 * Sample Route - `POST  /login  @com.company.Application.login()`.
 *
 * Example - class get's `index` & `login` as valid action methods.
 * ```
 * public class Application extends Controller {
 *      public Result index(String username, String password) {
 *        return ok("It works!");
 *      }
 *
 *      public Result login() {
 *        return ok("Log me In!");
 *      }
 *    }
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
 * The PlayFramework action method parameters, these are a source of user input.
 *
 * Example - `username` & `password` are marked as valid parameters.
 * ```
 *  public class Application extends Controller {
 *      public Result index(String username, String password) {
 *        return ok("It works!");
 *      }
 *    }
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
   * A reference to the `getQueryString` method.
   */
  MethodAccess getAQueryStringAccess() {
    this.hasName("getQueryString") and result = this.getAReference()
  }
}

/**
 * A PlayFramework results method, some of these are `ok`, `status`, `redirect`.
 */
class PlayMvcResultsMethods extends Method {
  PlayMvcResultsMethods() { this.getDeclaringType() instanceof PlayMvcResultsClass }

  /**
   * A reference to the play.mvc.Results `ok` method.
   */
  MethodAccess getAnOkAccess() { this.hasName("ok") and result = this.getAReference() }

  /**
   * A reference to the play.mvc.Results `redirect` method.
   */
  MethodAccess getARedirectAccess() { this.hasName("redirect") and result = this.getAReference() }
}
