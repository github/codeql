import java
import semmle.code.java.frameworks.play.PlayAsyncResult
import semmle.code.java.frameworks.play.PlayMVCResult

/**
 * Play MVC Framework Controller
 *
 * @description Gets the play.mvc.Controller class
 */
class PlayMVCControllerClass extends Class {
  PlayMVCControllerClass() { this.hasQualifiedName("play.mvc", "Controller") }
}

/**
 * Play Framework Controller which extends/implements
 *
 * @description Gets the classes which extends play.mvc.controller rescursively.
 */
class PlayController extends Class {
  PlayController() {
    exists(Class t | this.extendsOrImplements*(t) and t instanceof PlayMVCControllerClass)
  }
}

/**
 * Play Framework Controller Action Methods
 *
 * @description Gets the controller action methods defined against it.
 * (https://www.playframework.com/documentation/2.8.x/JavaActions)
 * @tip Checking for Public methods usually retrieves direct controller mapped methods defined in routes.
 */
class PlayControllerActionMethod extends Method {
  PlayControllerActionMethod() {
    exists(PlayController controller |
      this = controller.getAMethod() and
      (
        this.getReturnType() instanceof PlayAsyncResultPromise or
        this.getReturnType() instanceof PlayMVCResult or
        this.getReturnType() instanceof PlayAsyncResultCompletionStage
      )
    )
  }
}

/**
 * Play Action-Method parameters, these are essentially part of routes.
 */
class PlayActionQueryParameter extends Parameter {
  PlayActionQueryParameter() {
    exists(PlayControllerActionMethod a |
      a.isPublic() and
      this = a.getAParameter()
    )
  }
}
