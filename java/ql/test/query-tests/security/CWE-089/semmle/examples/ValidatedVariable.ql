import semmle.code.java.security.Validation

from ValidatedVariable var
select var.getLocation(), var
