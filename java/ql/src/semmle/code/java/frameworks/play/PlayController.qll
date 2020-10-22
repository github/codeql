import java
import semmle.code.java.frameworks.play.PlayAsyncResult
import semmle.code.java.frameworks.play.PlayMVCResult

/**
 * Play MVC Framework Controller
<<<<<<< HEAD
=======
 *
 * @description Gets the play.mvc.Controller class
>>>>>>> fa523e456f96493dcc08b819ad4bd620cca789b8
 */
class PlayMVCControllerClass extends Class {
  PlayMVCControllerClass() { this.hasQualifiedName("play.mvc", "Controller") }
}

/**
<<<<<<< HEAD
 * Play Framework Controllers which extends/implements PlayMVCController recursively - Used to find all Controllers
=======
 * Play Framework Controller which extends/implements
 *
 * @description Gets the classes which extends play.mvc.controller rescursively.
>>>>>>> fa523e456f96493dcc08b819ad4bd620cca789b8
 */
class PlayController extends Class {
  PlayController() {
    exists(Class t | this.extendsOrImplements*(t) and t instanceof PlayMVCControllerClass)
  }
}

/**
<<<<<<< HEAD
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
=======
 * Play Framework Controller Action Methods
 *
 * @description Gets the controller action methods defined against it.
 * (https://www.playframework.com/documentation/2.8.x/JavaActions)
 * @tip Checking for Public methods usually retrieves direct controller mapped methods defined in routes.
>>>>>>> fa523e456f96493dcc08b819ad4bd620cca789b8
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
<<<<<<< HEAD
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
=======
 * Play Action-Method parameters, these are essentially part of routes.
 */
class PlayActionQueryParameter extends Parameter {
  PlayActionQueryParameter() {
>>>>>>> fa523e456f96493dcc08b819ad4bd620cca789b8
    exists(PlayControllerActionMethod a |
      a.isPublic() and
      this = a.getAParameter()
    )
  }
}
