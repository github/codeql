import semmle.code.java.frameworks.play.Play

from PlayMVCResultsMethods m
select m.getAnOkAccess()
