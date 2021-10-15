import semmle.code.java.frameworks.play.Play

from PlayControllerActionMethod m
select m.getQualifiedName()
