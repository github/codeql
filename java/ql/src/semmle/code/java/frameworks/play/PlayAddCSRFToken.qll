import java

/**
 * Play Framework AddCSRFToken
 *
 * @description Gets the methods using AddCSRFToken annotation.
 * (https://www.playframework.com/documentation/2.6.x/JavaBodyParsers#Choosing-an-explicit-body-parser)
 */
class PlayAddCSRFTokenAnnotation extends Annotation {
  PlayAddCSRFTokenAnnotation() {
    this.getType().hasQualifiedName("play.filters.csrf", "AddCSRFToken")
  }
}
