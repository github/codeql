import semmle.code.java.frameworks.play.Play

from PlayController c
select c.getQualifiedName()
