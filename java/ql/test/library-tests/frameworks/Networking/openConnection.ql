import java
import semmle.code.java.frameworks.Networking

from UrlOpenConnectionMethod m
select m.getAReference()
