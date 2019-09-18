import java

/**
 * An annotation in the struts 2 convention plugin.
 */
class StrutsAnnotation extends Annotation {
  StrutsAnnotation() {
    this.getType().getPackage().hasName("org.apache.struts2.convention.annotation")
  }
}

/**
 * A struts annotation that signifies the annotated method should be treated as an action.
 */
class StrutsActionAnnotation extends StrutsAnnotation {
  StrutsActionAnnotation() { this.getType().hasName("Action") }

  Callable getActionCallable() {
    result = getAnnotatedElement()
    or
    exists(StrutsActionsAnnotation actions | this = actions.getAnAction() |
      result = actions.getAnnotatedElement()
    )
  }
}

/**
 * A struts annotation that represents a group of actions for the annotated method.
 */
class StrutsActionsAnnotation extends StrutsAnnotation {
  StrutsActionsAnnotation() { this.getType().hasName("Actions") }

  /**
   * Gets an Action annotation contained in this Actions annotation.
   */
  StrutsActionAnnotation getAnAction() { result = this.getAValue("value") }
}
