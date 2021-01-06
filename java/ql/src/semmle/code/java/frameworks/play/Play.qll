import java

/**
 * Play MVC Framework Result Class
 */
class PlayMVCResultClass extends Class {
  PlayMVCResultClass() { this.hasQualifiedName("play.mvc", "Result") }
}

/**
 * Play MVC Framework Results Class
 *
 * Documentation: https://www.playframework.com/documentation/2.8.x/JavaActions
 */
class PlayMVCResultsClass extends Class {
  PlayMVCResultsClass() { this.hasQualifiedName("play.mvc", "Results") }
}

/**
 * Play MVC Framework HTTP Request Header Class
 */
class PlayMVCHTTPRequestHeader extends RefType {
  PlayMVCHTTPRequestHeader() { this.hasQualifiedName("play.mvc", "Http$RequestHeader") }
}

/**
 * Play Framework Explicit Body Parser Annotation
 *
 * Documentation: https://www.playframework.com/documentation/2.8.x/JavaBodyParsers#Choosing-an-explicit-body-parser
 */
class PlayBodyParserAnnotation extends Annotation {
  PlayBodyParserAnnotation() { this.getType().hasQualifiedName("play.mvc", "BodyParser<>$Of") }
}

/**
 * Play Framework AddCSRFToken Annotation
 *
 * Documentation: https://www.playframework.com/documentation/2.8.x/JavaCsrf
 */
class PlayAddCSRFTokenAnnotation extends Annotation {
  PlayAddCSRFTokenAnnotation() {
    this.getType().hasQualifiedName("play.filters.csrf", "AddCSRFToken")
  }
}

/**
 * Play Framework Async Promise - Gets the Promise<Result> Generic Member/Type of (play.libs.F)
 *
 * Documentation: https://www.playframework.com/documentation/2.5.1/api/java/play/libs/F.Promise.html
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
 * Play Framework Async Generic Result - Gets the CompletionStage<Result> Generic Type of (java.util.concurrent)
 *
 * Documentation: https://www.playframework.com/documentation/2.6.x/JavaAsync
 */
class PlayAsyncResultCompletionStage extends Type {
  PlayAsyncResultCompletionStage() {
    this.hasName("CompletionStage<Result>") and
    this.getCompilationUnit().getPackage().hasName("java.util.concurrent")
  }
}

/**
 * Play Framework Controllers which extends PlayMVCController recursively - Used to find all Controllers
 */
class PlayController extends Class {
  PlayController() {
    this.extendsOrImplements*(any(Class t | t.hasQualifiedName("play.mvc", "Controller")))
  }
}

/**
 * Play Framework Controller Action Methods - Mappings to route files
 *
 * Sample Route - `POST  /login  @com.company.Application.login()`
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
 *
 * Documentation: https://www.playframework.com/documentation/2.8.x/JavaActions
 */
class PlayControllerActionMethod extends Method {
  PlayControllerActionMethod() {
    this = any(PlayController c).getAMethod() and
    (
      this.getReturnType() instanceof PlayAsyncResultPromise or
      this.getReturnType() instanceof PlayMVCResultClass or
      this.getReturnType() instanceof PlayAsyncResultCompletionStage
    )
  }
}

/**
 * Play Action-Method parameters. These are a source of user input
 *
 * Example - Class get's `username` & `password` as valid parameters
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
 * Play Framework HTTPRequestHeader Methods - `headers`, `getQueryString`, `getHeader`
 *
 * Documentation: https://www.playframework.com/documentation/2.6.0/api/java/play/mvc/Http.RequestHeader.html
 */
class PlayMVCHTTPRequestHeaderMethods extends Method {
  PlayMVCHTTPRequestHeaderMethods() { this.getDeclaringType() instanceof PlayMVCHTTPRequestHeader }

  /**
   * Gets all references to play.mvc.HTTP.RequestHeader `getQueryString` method
   */
  MethodAccess getAQueryStringAccess() {
    this.hasName("getQueryString") and result = this.getAReference()
  }
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
  MethodAccess getAnOkAccess() { this.hasName("ok") and result = this.getAReference() }

  /**
   * Gets all references to play.mvc.Results `redirect` method
   */
  MethodAccess getARedirectAccess() { this.hasName("redirect") and result = this.getAReference() }
}
