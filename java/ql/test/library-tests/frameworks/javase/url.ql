import java
import semmle.code.java.frameworks.javase.URL

from UrlConstructor c
select c, c.hostArg()