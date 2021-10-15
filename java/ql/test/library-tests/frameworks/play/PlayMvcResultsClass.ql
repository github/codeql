import semmle.code.java.frameworks.play.Play

from PlayMvcResultsClass m
select m.getQualifiedName(), m.getAMethod().getQualifiedName()
