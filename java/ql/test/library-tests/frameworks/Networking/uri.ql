import java
import semmle.code.java.frameworks.Networking

from UriCreation c
select c, c.getHostArg()