import semmle.code.java.frameworks.play.Play

from PlayMvcHttpRequestHeader c
select c.getQualifiedName(), c.getAMethod().getQualifiedName()
