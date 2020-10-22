import java

/**
<<<<<<< HEAD
 * Play Framework Explicit Body Parser Annotation
 *
 * Documentation: https://www.playframework.com/documentation/2.8.x/JavaBodyParsers#Choosing-an-explicit-body-parser
=======
 * Play Framework Explicit Body Parser
 *
 * @description Gets the methods using the explicit body parser annotation. The methods are usually controller action methods
 * (https://www.playframework.com/documentation/2.8.x/JavaBodyParsers#Choosing-an-explicit-body-parser)
>>>>>>> fa523e456f96493dcc08b819ad4bd620cca789b8
 */
class PlayBodyParserAnnotation extends Annotation {
  PlayBodyParserAnnotation() { this.getType().hasQualifiedName("play.mvc", "BodyParser<>$Of") }
}
