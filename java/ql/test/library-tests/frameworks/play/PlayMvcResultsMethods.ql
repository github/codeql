import semmle.code.java.frameworks.play.Play

from PlayMvcResultsMethods m
select m.getAnOkAccess()
