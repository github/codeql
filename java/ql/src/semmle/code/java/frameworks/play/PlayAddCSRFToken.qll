import java

/**
<<<<<<< HEAD
 * Play Framework AddCSRFToken Annotation
 *
 * Documentation: https://www.playframework.com/documentation/2.8.x/JavaCsrf
=======
 * Play Framework AddCSRFToken
 *
 * @description Gets the methods using AddCSRFToken annotation.
 * (https://www.playframework.com/documentation/2.6.x/JavaBodyParsers#Choosing-an-explicit-body-parser)
>>>>>>> fa523e456f96493dcc08b819ad4bd620cca789b8
 */
class PlayAddCSRFTokenAnnotation extends Annotation {
  PlayAddCSRFTokenAnnotation() {
    this.getType().hasQualifiedName("play.filters.csrf", "AddCSRFToken")
  }
}
