import java
import semmle.code.java.Diagnostics

select any(Diagnostic d | not d.toString().matches("Not rewriting trap file for%"))
