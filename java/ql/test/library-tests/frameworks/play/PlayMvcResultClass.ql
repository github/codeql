import semmle.code.java.frameworks.play.Play

from PlayMvcResultClass m
select m.getQualifiedName()
