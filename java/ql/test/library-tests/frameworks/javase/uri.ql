import java
import semmle.code.java.frameworks.javase.URI

from UriCreation c
select c, c.hostArg()