import java
import semmle.code.java.security.PathCreation

from PathCreation path
select path, path.getAnInput()
