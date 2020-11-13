import java
import semmle.code.java.frameworks.Networking

from UrlOpenStreamMethod m
select m.getAReference()
