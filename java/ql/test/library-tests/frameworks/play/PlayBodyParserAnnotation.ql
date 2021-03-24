import semmle.code.java.frameworks.play.Play

from PlayBodyParserAnnotation parser
select parser.getType().getQualifiedName()
