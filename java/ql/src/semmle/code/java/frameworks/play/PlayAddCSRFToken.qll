import java

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
