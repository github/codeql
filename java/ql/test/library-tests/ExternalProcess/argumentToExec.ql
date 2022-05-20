import semmle.code.java.security.ExternalProcess

from ArgumentToExec arg
where arg.getFile().getStem() = "Test"
select arg
