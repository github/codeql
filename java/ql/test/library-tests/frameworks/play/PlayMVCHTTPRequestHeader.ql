import semmle.code.java.frameworks.play.Play

from PlayMVCHTTPRequestHeader c
select c.getQualifiedName(), c.getAMethod().getQualifiedName()
