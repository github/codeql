import java
import semmle.code.java.frameworks.Networking

from UrlConstructor c
select c, c.getHostArg()