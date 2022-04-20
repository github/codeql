import java
import semmle.code.java.deadcode.DeadCode
import semmle.code.java.frameworks.struts.StrutsActions

/**
 * Entry point for apache struts 1.x actions. All methods declared in
 * `org.apache.struts.action.Action` + the default constructor are assumed
 * to be live. If this is a `DispatchAction` then all public methods are
 * live.
 */
class Struts1ActionEntryPoint extends EntryPoint, Class {
  Struts1ActionEntryPoint() {
    this.getAnAncestor().hasQualifiedName("org.apache.struts.action", "Action")
  }

  override Callable getALiveCallable() {
    result = this.getACallable() and
    (
      exists(Method methodFromAction |
        methodFromAction.getDeclaringType().hasQualifiedName("org.apache.struts.action", "Action")
      |
        result.(Method).overrides+(methodFromAction)
      )
      or
      this.getAnAncestor().hasQualifiedName("org.apache.struts.actions", "DispatchAction") and
      result.(Method).isPublic()
      or
      result.(Constructor).getNumberOfParameters() = 0
    )
  }
}

/**
 * A struts 2 action class that is reflectively constructed.
 */
class Struts2ReflectivelyConstructedAction extends ReflectivelyConstructedClass {
  Struts2ReflectivelyConstructedAction() { this instanceof Struts2ActionClass }
}

/**
 * A method called on a struts 2 action class when the action is activated.
 */
class Struts2ActionMethodEntryPoint extends CallableEntryPoint {
  Struts2ActionMethodEntryPoint() { this instanceof Struts2ActionMethod }
}

/**
 * A method called on a struts 2 action class before an action is activated.
 */
class Struts2PrepareMethodEntryPoint extends CallableEntryPoint {
  Struts2PrepareMethodEntryPoint() { this instanceof Struts2PrepareMethod }
}

/**
 * A class which is accessible - directly or indirectly - from a struts action.
 */
class ActionAccessibleClass extends Class {
  ActionAccessibleClass() {
    // A struts action class is directly accessible.
    this instanceof Struts2ActionClass or
    this instanceof Struts1ActionEntryPoint or
    // Any class returned by a struts action is accessible within the JSP.
    exists(ActionAccessibleClass actionAccessibleClass |
      usesType(actionAccessibleClass.getAGetter().getReturnType(), this)
    )
  }

  Method getAGetter() {
    result = this.getAMethod() and
    result.getName().matches("get%")
  }

  Method getASetter() {
    result = this.getAMethod() and
    result.getName().matches("set%")
  }
}

/**
 * A Struts getter or setter method is considered to be live, because it can be accessed within
 * JSP files, for which we have no information.
 */
class StrutsGetterSetter extends CallableEntryPoint {
  StrutsGetterSetter() {
    exists(ActionAccessibleClass actionAccessibleClass |
      this = actionAccessibleClass.getAGetter() or
      this = actionAccessibleClass.getASetter()
    )
  }
}
