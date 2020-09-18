import java

/**
 * Play Framework Explicit Body Parser
 *
 * @description Gets the methods using the explicit body parser annotation. The methods are usually controller action methods
 * (https://www.playframework.com/documentation/2.8.x/JavaBodyParsers#Choosing-an-explicit-body-parser)
 */
class PlayBodyParserAnnotation extends Annotation {
  PlayBodyParserAnnotation() { this.getType().hasQualifiedName("play.mvc", "BodyParser<>$Of") }
}
