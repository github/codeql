import semmle.code.java.frameworks.play.Play

from PlayMVCResultClass m
select m.getQualifiedName()
