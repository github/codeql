import java
import semmle.code.java.frameworks.javase.URL

from UrlOpenConnectionMethod m
select m.getAReference()
