import java
import semmle.code.java.Diagnostics

select any(Diagnostic d | not d.toString().startsWith("Not rewriting trap file for"))
