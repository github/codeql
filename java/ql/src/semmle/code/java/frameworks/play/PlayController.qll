import java
import semmle.code.java.frameworks.play.PlayAsyncResult
import semmle.code.java.frameworks.play.PlayMVCResult

/**
 * Play MVC Framework Controller
 */
class PlayMVCControllerClass extends Class {
  PlayMVCControllerClass() { this.hasQualifiedName("play.mvc", "Controller") }
}

/**
 * Play Framework Controllers which extends/implements PlayMVCController recursively - Used to find all Controllers
 */
class PlayController extends Class {
  PlayController() {
    exists(Class t | this.extendsOrImplements*(t) and t instanceof PlayMVCControllerClass)
  }
}

/**
 * Play Framework Controller Action Methods - Mappings to route files
 *
 * Sample Route - `POST  /login  @com.linkedin.Application.login()`
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
    exists(PlayController controller |
      this = controller.getAMethod() and
      (
        this.getReturnType() instanceof PlayAsyncResultPromise or
        this.getReturnType() instanceof PlayMVCResultClass or
        this.getReturnType() instanceof PlayAsyncResultCompletionStage
      )
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
