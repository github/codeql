import java
import semmle.code.java.frameworks.javase.URL

from UrlOpenStreamMethod m
select m.getAReference()
