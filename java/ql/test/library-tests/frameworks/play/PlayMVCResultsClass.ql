import semmle.code.java.frameworks.play.Play

from PlayMVCResultsClass m
select m.getQualifiedName(), m.getAMethod().getQualifiedName()
