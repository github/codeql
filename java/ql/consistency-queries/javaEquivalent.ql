import java
import semmle.code.java.Diagnostics

from Diagnostic d
where exists(d.getMessage().indexOf("Couldn't find a Java equivalent function to "))
select d
